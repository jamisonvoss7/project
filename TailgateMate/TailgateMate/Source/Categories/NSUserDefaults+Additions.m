//
//  NSUserDefaults+Additions.m
//  TailgateMate
//
//  Created by Jamison Voss on 4/6/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "NSUserDefaults+Additions.h"

static NSString * const kDEFAULTS_ACCOUNT_ID_KEY = @"accountUID";

@implementation NSUserDefaults (Additions)

- (NSString *)accountUID {
    NSData *data = [self objectForKey:kDEFAULTS_ACCOUNT_ID_KEY];
    return [[NSString alloc] initWithData:data encoding:NSUTF32StringEncoding];
}

- (void)setAccountUID:(NSString *)accountUID {
    if (accountUID.length > 0) {
        NSData *data = [accountUID dataUsingEncoding:NSUTF32StringEncoding];
        [self setObject:data forKey:kDEFAULTS_ACCOUNT_ID_KEY];
        [self synchronize];
    }
}

@end
