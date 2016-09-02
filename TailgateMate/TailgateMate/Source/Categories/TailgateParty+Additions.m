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
        return @"Home fans";
    } else if (self.fanType == TAILGATEPARTYFANTYPE_AWAY) {
        return @"Away fans";
    } else {
        return @"All fans";
    }
}

- (BOOL)isDifferentThanParty:(TailgateParty *)party {
    if (party.parkingLot.location.lat != self.parkingLot.location.lat) {
        return YES;
    }
    
    if (party.parkingLot.location.lon != self.parkingLot.location.lon) {
        return YES;
    }
    
    if (party.fanType != self.fanType) {
        return YES;
    }
    
    if (party.type != self.type) {
        return YES;
    }
    
    return NO;
}
@end
