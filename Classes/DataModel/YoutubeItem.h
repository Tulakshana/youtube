//
//  YoutubeItem.h
//  youtube
//
//  Created by Tulakshana on 30/1/15.
//  Copyright (c) 2015 Tulakshana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YoutubeItem : NSObject

@property (nonatomic,strong) NSString *pubDate;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSString *link;



@property (nonatomic,strong) UIImage *thumb;

- (NSString *)getVideoId;
- (NSString *)descByStrippingHTML;
- (NSURL *)getThumbURL;
@end
