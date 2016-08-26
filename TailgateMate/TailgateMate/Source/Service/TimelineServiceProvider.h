//
//  TimelineServiceProvder.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/16/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FireBaseServiceProvider.h"

@interface TimelineServiceProvider : FireBaseServiceProvider

- (void)addTimelineItem:(TimelineItem *)item
        toTailgateParty:(TailgateParty *)party
           withComplete:(void (^)(BOOL success, NSError *error))handler;

- (void)saveImage:(UIImage *)image
             atId:(NSString *)imageId
 forPartyTimeline:(NSString *)partyId
   withCompletion:(void (^)(BOOL success, NSError *error))handler;

- (void)getImageFromImageId:(NSString *)imageId
                 andPartyId:(NSString *)party
             withCompletion:(void (^)(UIImage *image, NSError *error))handler;
@end
