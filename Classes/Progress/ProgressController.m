//
//  ProgressController.m


#import "ProgressController.h"

#import "AppDelegate.h"

static ProgressController *sharedInstance;

@interface ProgressController(){
    NSTimer *progressTimer;
    

    BOOL showProgressBar;
}
@property (nonatomic, strong) NSTimer *progressTimer;

@end

@implementation ProgressController
@synthesize progress;
@synthesize progressTimer;

+(ProgressController*)getSharedInstance{
    @synchronized(self){
        if (sharedInstance==NULL) {
            sharedInstance = [[ProgressController alloc] init];
        }
    }
    return sharedInstance;
}

-(id)init{
    self = [super init];
    
    self.progress = [[ProgreeView alloc] initWithNibName:@"ProgreeView" bundle:nil];
    
    return self;
}

-(void)startProgress{
    [self performSelectorOnMainThread:@selector(showProgress) withObject:nil waitUntilDone:NO];
}




-(void)showProgress{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    referenceCount++;
    if(progress != nil && !progress.visible){
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        progress.view.frame = [UIScreen mainScreen].bounds;
        

        
        [appDelegate.window  addSubview:progress.view];
        progress.visible = YES;

    }

        [self startTimer];

}




-(void)startTimer{
    [self disableTimer];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(forcedEndTimeoutProgressIfVisible) userInfo:nil repeats:NO];
}



-(void)disableTimer{
    if (self.progressTimer != nil && [self.progressTimer isValid]) {
        [self.progressTimer invalidate];
        self.progressTimer = nil;
    }
}

-(void)endProgressIfVisible{
    [self performSelectorOnMainThread:@selector(endProgress) withObject:nil waitUntilDone:NO];
}

-(void)endProgress{
    referenceCount--;
    if(referenceCount<=0){
        [self disableTimer];
        if(progress && progress.visible){
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            progress.visible = NO;
            [progress.view removeFromSuperview];
        }
    } else if (referenceCount<0){
        referenceCount = 0;
    }
}

-(void)forcedEndTimeoutProgressIfVisible{
    NSLog(@"Progress Timeout");
    referenceCount = 0;
    [self endProgressIfVisible];
}

-(void)forcedEndProgressIfVisible{
    referenceCount = 0;
    [self endProgressIfVisible];
}


@end
