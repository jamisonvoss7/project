//
//  TailgatePartyFanType.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/18/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TailgatePartyFanType.h"

static TailgatePartyFanType *tailgatepartyfantype_home;
static TailgatePartyFanType *tailgatepartyfantype_away;
static TailgatePartyFanType *tailgatepartyfantype_both;

@implementation TailgatePartyFanType

+ (TailgatePartyFanType *)findByString:(NSString *)enumString {
    if ([enumString isEqualToString:@"HOME"]) {
        return [self _HOME];
    }
    
    if ([enumString isEqualToString:@"AWAY"]) {
        return [self _AWAY];
    }
    
    if ([enumString isEqualToString:@"BOTH"]) {
        return [self _BOTH];
    }
    return nil;
}

+ (TailgatePartyFanType *)_AWAY {
    if (!tailgatepartyfantype_away) {
        tailgatepartyfantype_away = [[super alloc] initWithString:@"AWAY"];
    }
    return tailgatepartyfantype_away;
}

+ (TailgatePartyFanType *)_HOME {
    if (!tailgatepartyfantype_home) {
        tailgatepartyfantype_home = [[super alloc] initWithString:@"HOME"];
    }
    return tailgatepartyfantype_home;
}

+ (TailgatePartyFanType *)_BOTH {
    if (!tailgatepartyfantype_both) {
        tailgatepartyfantype_both = [[super alloc] initWithString:@"BOTH"];
    }
    return tailgatepartyfantype_both;

}

@end
