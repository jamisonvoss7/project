//
//  TimelineItemType.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/11/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TimelineItemType.h"

static TimelineItemType *timelineitemtype_message;
static TimelineItemType *timelineitemtype_image;
static TimelineItemType *timelineitemtype_creation;

@implementation TimelineItemType

+ (TimelineItemType *)findByString:(NSString *)enumString {
    if ([enumString isEqualToString:@"MESSAGE"]) {
        return [self _MESSAGE];
    }
    
    if ([enumString isEqualToString:@"IMAGE"]) {
        return [self _IMAGE];
    }
    
    if ([enumString isEqualToString:@"CREATION"]) {
        return [self _CREATION];
    }
    return nil;
}


+ (TimelineItemType *)_MESSAGE {
    if (!timelineitemtype_message) {
        timelineitemtype_message = [[super alloc] initWithString:@"MESSAGE"];
    }
    return timelineitemtype_message;
}

+ (TimelineItemType *)_IMAGE {
    if (!timelineitemtype_image) {
        timelineitemtype_image = [[super alloc] initWithString:@"IMAGE"];
    }
    return timelineitemtype_image;
}

+ (TimelineItemType *)_CREATION {
    if (!timelineitemtype_creation) {
        timelineitemtype_creation = [[super alloc] initWithString:@"CREATION"];
    }
    return timelineitemtype_creation;
}

@end
