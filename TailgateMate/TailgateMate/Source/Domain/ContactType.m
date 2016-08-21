//
//  ContactType.m
//  TailgateMate
//
//  Created by Jamison Voss on 7/31/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "ContactType.h"

static ContactType *contacttype_phone;
static ContactType *contacttype_email;
static ContactType *contacttype_social;

@implementation ContactType

+ (ContactType *)findByString:(NSString *)enumString {
    if ([enumString isEqualToString:@"PHONE"]) {
        return [self _PHONE];
    }
    
    if ([enumString isEqualToString:@"EMAIL"]) {
        return [self _EMAIL];
    }
    
    if ([enumString isEqualToString:@"SOCIAL"]) {
        return [self _SOCIAL];
    }
    
    return nil;
}

+ (ContactType *)_PHONE {
    if (!contacttype_phone) {
        contacttype_phone = [[super alloc] initWithString:@"PHONE"];
    }
    return contacttype_phone;
}

+ (ContactType *)_EMAIL {
    if (!contacttype_email) {
        contacttype_email = [[super alloc] initWithString:@"EMAIL"];
    }
    return contacttype_email;
}

+ (ContactType *)_SOCIAL {
    if (!contacttype_social) {
        contacttype_social = [[super alloc] initWithString:@"SOCIAL"];
    }
    return contacttype_social;
}

@end
