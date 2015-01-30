//
//  YoutubeDetailVC.m
//  youtube
//
//  Created by Tulakshana on 30/1/15.
//  Copyright (c) 2015 Tulakshana. All rights reserved.
//

#import "YoutubeDetailVC.h"

#import "UIWebView+YouTube.h"

@interface YoutubeDetailVC ()<UIWebViewDelegate>{
    IBOutlet UIWebView *wView;
}

@end

@implementation YoutubeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [wView loadYouTubeVideoID:self.videoId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [[ProgressController getSharedInstance]startProgress];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [[ProgressController getSharedInstance]endProgressIfVisible];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[ProgressController getSharedInstance]endProgressIfVisible];
}

@end
