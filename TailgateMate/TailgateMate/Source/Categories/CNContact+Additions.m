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
            return number.stringValue;
        }
    }
    
    CNLabeledValue *val = [self.phoneNumbers firstObject];
    CNPhoneNumber *number = val.value;
    return number.stringValue;
}

@end
