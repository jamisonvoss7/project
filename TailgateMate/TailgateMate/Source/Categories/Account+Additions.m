//
//  Account+Additions.m
//  TailgateMate
//
//  Created by Jamison Voss on 7/31/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "Account+Additions.h"

@implementation Account (Additions)

- (NSString *)encodeEmailAddress {
    NSString *email = self.emailAddress;
    email = [email stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
    return email;
}

@end
