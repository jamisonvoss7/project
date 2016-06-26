//
//  TailgatePartyType.m
//  TailgateMate
//
//  Created by Jamison Voss on 6/25/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TailgatePartyType.h"

static TailgatePartyType *tailgatepartytype_public;
static TailgatePartyType *tailgatepartytype_private;
static TailgatePartyType *tailgatepartytype_promoted;

@implementation TailgatePartyType

+ (TailgatePartyType *)findByString:(NSString *)enumString {
    
    if ([enumString isEqualToString:@"PUBLIC"]) {
        return [self _PUBLIC];
    }

    if ([enumString isEqualToString:@"PRIVATE"]) {
        return [self _PRIVATE];
    }

    if ([enumString isEqualToString:@"PROMOTED"]) {
        return [self _PROMOTED];
    }
   
    return nil;
}

+ (TailgatePartyType *)_PUBLIC {
    if (!tailgatepartytype_public) {
        tailgatepartytype_public = [[super alloc] initWithString:@"PUBLIC"];
    }
    return tailgatepartytype_public;
}

+ (TailgatePartyType *)_PRIVATE {
    if (!tailgatepartytype_private) {
        tailgatepartytype_private = [[super alloc] initWithString:@"PRIVATE"];
    }
    return tailgatepartytype_private;
}

+ (TailgatePartyType *)_PROMOTED {
    if (!tailgatepartytype_promoted) {
        tailgatepartytype_promoted = [[super alloc] initWithString:@"PROMOTED"];
    }
    return tailgatepartytype_promoted;
}

@end
