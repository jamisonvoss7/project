//
//  CNContact+Additions.m
//  TailgateMate
//
//  Created by Jamison Voss on 7/16/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "CNContact+Additions.h"

@implementation CNContact (Additions)

- (NSString *)phoneNumberString {
     for (CNLabeledValue *val in self.phoneNumbers) {
        if ([val.label containsString:@"Mobile"]) {
            CNPhoneNumber *number = val.value;
            return [self doctorString:number.stringValue];
        }
    }
    
    CNLabeledValue *val = [self.phoneNumbers firstObject];
    CNPhoneNumber *number = val.value;
    return [self doctorString:number.stringValue];
}

- (NSString *)doctorString:(NSString *)number {
    number = [number stringByReplacingOccurrencesOfString:@"+" withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@"(" withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@")" withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@"\\s"
                                               withString:@""
                                                  options:NSRegularExpressionSearch
                                                    range:NSMakeRange(0, number.length)];
    
    //myNewString will be @"thisisatest"

    return number;
}

@end
