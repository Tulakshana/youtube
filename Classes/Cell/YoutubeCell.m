//
//  YoutubeCell.m
//  youtube
//
//  Created by Tulakshana on 30/1/15.
//  Copyright (c) 2015 Tulakshana. All rights reserved.
//

#import "YoutubeCell.h"



@implementation YoutubeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadImage:(NSURL *)url item:(YoutubeItem *)item{
    
    if (item.thumb) {
        self.imageView.image = item.thumb;
        [self setNeedsLayout];
        return;
    }
    NSURLRequest *imageRequest =
    [NSURLRequest requestWithURL:url];
    
    // send the async request (note that the completion block will be called on the main thread)
    //
    // note: using the block-based "sendAsynchronousRequest" is preferred, and useful for
    // small data transfers that are likely to succeed. If you doing large data transfers,
    // consider using the NSURLConnectionDelegate-based APIs.
    //
    [NSURLConnection sendAsynchronousRequest:imageRequest
     // the NSOperationQueue upon which the handler block will be dispatched:
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               // back on the main thread, check for errors, if no errors start the parsing
                               //
                               
                               
                               // here we check for any returned NSError from the server, "and" we also check for any http response errors
                               if (error != nil) {
                                   NSLog(@"%@",[error debugDescription]);
                               }
                               else {
                                   // check for any response errors
                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                   if (([httpResponse statusCode]/100) == 2) {
                                       
                                       // Update the UI and start parsing the data,
                                       // Spawn an NSOperation to parse the earthquake data so that the UI is not
                                       // blocked while the application parses the XML data.
                                       //
                                       item.thumb = [UIImage imageWithData:data];
                                       self.imageView.image = item.thumb;
                                       [self setNeedsLayout];
                                   }
                                   else {
                                       NSLog(@"HTTP Error, Code: %d",(int)[httpResponse statusCode]);
                                   }
                               }
                           }];
    
}

@end
