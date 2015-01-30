//
//  ProgreeView.m


#import "ProgreeView.h"


@implementation ProgreeView
@synthesize visible;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [darkView.layer setMasksToBounds:YES];
    [darkView.layer setCornerRadius:10.0];
    [darkView.layer setBorderWidth:1.0];
    [darkView.layer setBorderColor:[[UIColor clearColor] CGColor]];
    
    self.view.backgroundColor = [UIColor clearColor];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}



@end
