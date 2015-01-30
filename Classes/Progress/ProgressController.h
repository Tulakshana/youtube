//
//  ProgressController.h


#import <Foundation/Foundation.h>
#import "ProgreeView.h"

@interface ProgressController : NSObject{
    ProgreeView *progress;
    int referenceCount;
}
@property (nonatomic, strong) ProgreeView *progress;

+(ProgressController*)getSharedInstance;

-(void)startProgress;

-(void)endProgressIfVisible;
-(void)forcedEndProgressIfVisible;

@end
