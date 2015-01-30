//
//  YoutubeCell.h
//  youtube
//
//  Created by Tulakshana on 30/1/15.
//  Copyright (c) 2015 Tulakshana. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YoutubeItem.h"

@interface YoutubeCell : UITableViewCell


- (void)loadImage:(NSURL *)url item:(YoutubeItem *)item;

@end
