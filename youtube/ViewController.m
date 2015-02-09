//
//  ViewController.m
//  youtube
//
//  Created by Tulakshana on 30/1/15.
//  Copyright (c) 2015 Tulakshana. All rights reserved.
//

#import "ViewController.h"

#import "TBXML.h"
#import "TBXML+HTTP.h"
#import "YoutubeCell.h"
#import "YoutubeDetailVC.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *table;
}
@property (nonatomic,strong)NSMutableArray *items;
@property (nonatomic,strong)NSString *currentFeed;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.items = [[NSMutableArray alloc]init];
    
    [self readRSS];
    [self addRefreshControl];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"detailSegue" sender:nil];
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.items count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *hotItemCellIdentifier = @"hotItemCellIdentity";
    YoutubeCell *cell = (YoutubeCell *)[tableView dequeueReusableCellWithIdentifier:hotItemCellIdentifier];
    if (cell == nil) {
        cell = [[YoutubeCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:hotItemCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.numberOfLines = 4;
    }
    YoutubeItem *item = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = [item getTitle];
    
    cell.detailTextLabel.text = item.pubDate;
    [cell loadImage:[item getThumbURL] item:item];
    return cell;
}

#pragma mark -

- (void)addRefreshControl{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [table addSubview:refreshControl];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self loadURL:self.currentFeed];
    [refreshControl endRefreshing];
}

#pragma mark - RSS

- (void)readRSS{
    
//    NSString *urlString = @"https://gdata.youtube.com/feeds/api/users/ozharvest/uploads?v=2";
    NSString *urlString = @"http://gdata.youtube.com/feeds/base/users/ozharvest/uploads?alt=rss&amp;v=2&amp;orderby=published&amp;client=ytapi-youtube-profile";
    [self loadURL:urlString];
    
    
}

- (void)loadURL:(NSString *)url {
    __weak typeof(self)weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Create a success block to be called when the asyn request completes
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
//        NSLog(@"PROCESSING ASYNC CALLBACK");
        
        // If TBXML found a root node, process element and iterate all children
        if (tbxmlDocument.rootXMLElement)
            [self traverseElement:tbxmlDocument.rootXMLElement];
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
    };
    
    // Create a failure block that gets called if something goes wrong
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    };
    
    
    self.currentFeed = url;
    // Initialize TBXML with the URL of an XML doc. TBXML asynchronously loads and parses the file.
    TBXML *tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:url]
                                      success:successBlock
                                      failure:failureBlock];
}

- (void) traverseElement:(TBXMLElement *)element {
    TBXMLElement *channel = (element->firstChild);
    TBXMLElement *title = (channel->firstChild);
    
    TBXMLElement *sibling = (title->nextSibling);
    [self.items removeAllObjects];
    while (sibling) {
        if ([[TBXML elementName:sibling] isEqualToString:@"item"]) {
            YoutubeItem *item = [[YoutubeItem alloc]init];
            TBXMLElement *child = (sibling->firstChild);
            while (child) {
                if ([[TBXML elementName:child] isEqualToString:@"title"]) {
                    item.title = [TBXML textForElement:child];
                }else if ([[TBXML elementName:child] isEqualToString:@"description"]) {
                    item.desc = [TBXML textForElement:child];
                }else if ([[TBXML elementName:child] isEqualToString:@"link"]) {
                    item.link = [TBXML textForElement:child];
                }
//                else if ([[TBXML elementName:child] isEqualToString:@"media:content"]) {
//                    item.mediaLink = [TBXML attributeValue:(child->firstAttribute)];
//                    item.mediaType = [TBXML attributeValue:((child->firstAttribute)->next)];
//                }
                else if ([[TBXML elementName:child] isEqualToString:@"pubDate"]) {
                    item.pubDate = [TBXML textForElement:child];
                }
                child = (child->nextSibling);
            }
            [self.items addObject:item];
        }
        sibling = (sibling->nextSibling);
    }
    [self performSelectorOnMainThread:@selector(reloadList) withObject:nil waitUntilDone:TRUE];
    
}



- (void)reloadList{
    [table reloadData];
    
}

#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"detailSegue"])
    {
        YoutubeDetailVC *vc = (YoutubeDetailVC *)[segue destinationViewController];
        YoutubeItem *item = [self.items objectAtIndex:[table indexPathForSelectedRow].row];
        vc.item = item;
        [table deselectRowAtIndexPath:[table indexPathForSelectedRow] animated:TRUE];
    }
    
    
}

@end
