//
//  PinProvider.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/13/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "PinProvider.h"

@implementation PinProvider

+ (UIImage *)imageForTailgateParty:(TailgateParty *)party {
    if (party.fanType == TAILGATEPARTYFANTYPE_HOME) {
        if (party.type == TAILGATEPARTYTYPE_PUBLIC) {
            return [UIImage imageNamed:@"RedEmptyPin"];
        } else if (party.type == TAILGATEPARTYTYPE_PRIVATE) {
            return [UIImage imageNamed:@"RedFullPin"];
        }
    } else if (party.fanType == TAILGATEPARTYFANTYPE_AWAY) {
        if (party.type == TAILGATEPARTYTYPE_PUBLIC) {
            return [UIImage imageNamed:@"PurpleEmptyPin"];
        } else if (party.type == TAILGATEPARTYTYPE_PRIVATE) {
            return [UIImage imageNamed:@"PurpleFullPin"];
        }
    } else if (party.fanType == TAILGATEPARTYFANTYPE_BOTH) {
        if (party.type == TAILGATEPARTYTYPE_PUBLIC) {
            return [UIImage imageNamed:@"BlackEmptyPin"];
        } else if (party.type == TAILGATEPARTYTYPE_PRIVATE) {
            return [UIImage imageNamed:@"BlackFullPin"];
        }
    }
    
    return [UIImage imageNamed:@"BlackFullPin"];
}

+ (NSString *)nameForPinForTailgateParty:(TailgateParty *)party {
    if (party.fanType == TAILGATEPARTYFANTYPE_HOME) {
        if (party.type == TAILGATEPARTYTYPE_PUBLIC) {
            return @"RedEmptyPin";
        } else if (party.type == TAILGATEPARTYTYPE_PRIVATE) {
            return @"RedFullPin";
        }
    } else if (party.fanType == TAILGATEPARTYFANTYPE_AWAY) {
        if (party.type == TAILGATEPARTYTYPE_PUBLIC) {
            return @"PurpleEmptyPin";
        } else if (party.type == TAILGATEPARTYTYPE_PRIVATE) {
            return @"PurpleFullPin";
        }
    } else if (party.fanType == TAILGATEPARTYFANTYPE_BOTH) {
        if (party.type == TAILGATEPARTYTYPE_PUBLIC) {
            return @"BlackEmptyPin";
        } else if (party.type == TAILGATEPARTYTYPE_PRIVATE) {
            return @"BlackFullPin";
        }
    }
    
    return @"BlackFullPin";
}

@end
