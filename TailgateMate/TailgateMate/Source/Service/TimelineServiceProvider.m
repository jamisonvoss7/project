//
//  TimelineServiceProvder.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/16/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TimelineServiceProvider.h"
#import "ImageServiceProvider.h"

@implementation TimelineServiceProvider
- (void)saveImage:(UIImage *)image
             atId:(NSString *)imageId
 forPartyTimeline:(NSString *)partyId
   withCompletion:(void (^)(BOOL, NSError *))handler {
    
    NSString *path = [NSString stringWithFormat:@"timelines/%@/images/%@", partyId, imageId];
    
    ImageServiceProvider *imageService = [[ImageServiceProvider alloc] init];
    [imageService saveImage:image atPath:path withCompletion:handler];
}

- (void)addTimelineItem:(TimelineItem *)item
        toTailgateParty:(TailgateParty *)party
           withComplete:(void (^)(BOOL success, NSError *error))handler {
    NSString *path = [NSString stringWithFormat:@"timeline/%@", party.uid];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:party.timeline];
    [array addObject:item];
    
    [super updateArrayData:[FirebaseObject dictionaryFromArray:array]
                   forPath:path
            withCompletion:^(NSError *error, FIRDatabaseReference *ref) {
                handler(!error, error);
            }];
}

- (void)getImageFromImageId:(NSString *)imageId
                 andPartyId:(NSString *)partyId
             withCompletion:(void (^)(UIImage *, NSError *))handler {
    NSString *path = [NSString stringWithFormat:@"timelines/%@/images/%@", partyId, imageId];
    
    ImageServiceProvider *imageService = [[ImageServiceProvider alloc] init];
    [imageService getImageFromPath:path
                    withCompletion:handler];
}
@end
