//
//  YoutubeItem.m
//  youtube
//
//  Created by Tulakshana on 30/1/15.
//  Copyright (c) 2015 Tulakshana. All rights reserved.
//

#import "YoutubeItem.h"

@implementation YoutubeItem


- (NSString *)getVideoId{
    NSString *videoId = [self.link stringByReplacingOccurrencesOfString:@"http://www.youtube.com/watch?v=" withString:@""];
    videoId = [videoId stringByReplacingOccurrencesOfString:@"&amp;feature=youtube_gdata" withString:@""];
    
    return videoId;
}
@end
