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

- (void)flagTimelineItem:(TimelineItem *)item toTailgateParty:(TailgateParty *)party withComplete:(void (^)(BOOL, NSError *))handler {
    NSString *path = [NSString stringWithFormat:@"timeline/%@", party.uid];
    
    NSInteger count = item.flagCount.integerValue;
    count++;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:party.timeline];
  
    item.flagCount = [NSNumber numberWithInteger:count];
    NSInteger index = [self indexOfItem:item inArray:array];

    if (count >= 5) {
        [array removeObjectAtIndex:index];
    } else {
        if (index >= 0) {
            [array replaceObjectAtIndex:index withObject:item];
        } else {
            handler(NO, nil);
        }
    }
    
    [self setArrayData:[FirebaseObject dictionaryFromArray:array]
               forPath:path
        withCompletion:^(NSError *error, FIRDatabaseReference *ref) {
            handler(!error, error);
        }];
}

- (NSInteger)indexOfItem:(TimelineItem *)item inArray:(NSArray *)array {
    NSInteger cur = 0;
    for (TimelineItem *timelineItem in array) {
        if ([timelineItem isEqual:item]) {
            return cur;
        }
        cur++;
    }
    return -1;
}
@end
