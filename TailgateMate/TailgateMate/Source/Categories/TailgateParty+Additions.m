//
//  TailgateParty+Additions.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/18/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TailgateParty+Additions.h"

@implementation TailgateParty (Additions)

- (NSString *)stringForFanType {
    if (self.fanType == TAILGATEPARTYFANTYPE_HOME) {
        return @"Home";
    } else if (self.fanType == TAILGATEPARTYFANTYPE_AWAY) {
        return @"Away";
    } else {
        return @"All fans";
    }
}

@end
