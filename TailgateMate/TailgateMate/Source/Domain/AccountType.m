//
//  AccountType.m
//  TailgateMate
//
//  Created by Jamison Voss on 6/25/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AccountType.h"

static AccountType *accounttype_basic;
static AccountType *accounttype_email;
static AccountType *accounttype_facebook;
static AccountType *accounttype_twitter;
static AccountType *accounttype_none;


@implementation AccountType

+ (AccountType *)findByString:(NSString *)enumString {
    if ([enumString isEqualToString:@"BASIC"]) {
        return [self _BASIC];
    }
    
    if ([enumString isEqualToString:@"EMAIL"]) {
        return [self _EMAIL];
    }
    
    if ([enumString isEqualToString:@"FACEBOOK"]) {
        return [self _FACEBOOK];
    }
    
    if ([enumString isEqualToString:@"TWITTER"]) {
        return [self _TWITTER];
    }
    
    if ([enumString isEqualToString:@"NONE"]) {
        return [self _NONE];
    }
    
    return nil;
}

+ (AccountType *)_BASIC {
    if (!accounttype_basic) {
        accounttype_basic = [[super alloc] initWithString:@"BASIC"];
    }
    return accounttype_basic;
}

+ (AccountType *)_EMAIL {
    if (!accounttype_email) {
        accounttype_email = [[super alloc] initWithString:@"EMAIL"];
    }
    return accounttype_email;
}

+ (AccountType *)_FACEBOOK {
    if (!accounttype_facebook) {
        accounttype_facebook = [[super alloc] initWithString:@"FACEBOOK"];
    }
    return accounttype_facebook;
}

+ (AccountType *)_TWITTER {
    if (!accounttype_twitter) {
        accounttype_twitter = [[super alloc] initWithString:@"TWITTER"];
    }
    return accounttype_twitter;
}

+ (AccountType *)_NONE {
    if (!accounttype_none) {
        accounttype_none = [[super alloc] initWithString:@"NONE"];
    }
    return accounttype_none;
}


@end
