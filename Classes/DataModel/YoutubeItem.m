//
//  YoutubeItem.m
//  youtube
//
//  Created by Tulakshana on 30/1/15.
//  Copyright (c) 2015 Tulakshana. All rights reserved.
//

#import "YoutubeItem.h"

#import "NSString+HTML.h"

@implementation YoutubeItem


- (NSString *)getVideoId{
    NSString *videoId = [self.link stringByReplacingOccurrencesOfString:@"http://www.youtube.com/watch?v=" withString:@""];
    videoId = [videoId stringByReplacingOccurrencesOfString:@"&amp;feature=youtube_gdata" withString:@""];
    
    return videoId;
}

- (NSString *)getHTML{
    NSString *htmlString = self.desc;
    NSData *stringData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]};
    NSAttributedString *decodedString;
    decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                     options:options
                                          documentAttributes:NULL
                                                       error:NULL];
    
    return [decodedString string];
}

-(NSString *) descByStrippingHTML {
    
//    NSRange r;
    NSString *s = [self getHTML];
//    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
//        s = [s stringByReplacingCharactersInRange:r withString:@""];
//    NSLog(@"%@",s);
    
    return [s stringByConvertingHTMLToPlainText];
}

- (NSURL *)getThumbURL{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",[self getVideoId]]];
}

- (NSString *)getTitle{
    return [self.title stringByConvertingHTMLToPlainText];
}
@end
