//
//  TimelineItem.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/11/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TimelineItem.h"

@implementation TimelineItem

+ (instancetype)instanceFromDate:(FIRDataSnapshot *)data {
    TimelineItem *instance = [[TimelineItem alloc] init];
    
    instance.userDisplayName = data.value[@"userDisplayName"];
    instance.photoId = data.value[@"photoId"];
    instance.message = data.value[@"message"];
    instance.tiemStamp = [FirebaseObject dateFromDateString:data.value[@"timeStamp"]];
    instance.type = [TimelineItemType findByString:data.value[@"type"]];
    
    return instance;
}

+ (instancetype)instacneFromDictionary:(NSDictionary *)dictionary {
    TimelineItem *instance = [[TimelineItem alloc] init];
    
    instance.userDisplayName = dictionary[@"userDisplayName"];
    instance.photoId = dictionary[@"photoId"];
    instance.message = dictionary[@"message"];
    instance.tiemStamp = [FirebaseObject dateFromDateString:dictionary[@"timeStamp"]];
    instance.type = [TimelineItemType findByString:dictionary[@"type"]];
    
    return instance;

}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:4];
    
    if (self.userDisplayName.length > 0) {
        dictionary[@"userDisplayName"] = self.userDisplayName;
    }
    
    if (self.photoId.length > 0) {
        dictionary[@"photoId"] = self.photoId;
    }
    
    if (self.message.length > 0) {
        dictionary[@"message"] = self.message;
    }
    
    if (self.tiemStamp) {
        dictionary[@"timeStamp"] = [FirebaseObject dateToDateString:self.tiemStamp];
    }
    
    if (self.type) {
        dictionary[@"type"] = [self.type description];
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
