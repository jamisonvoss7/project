//
//  AccountType.h
//  TailgateMate
//
//  Created by Jamison Voss on 6/25/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FirebaseEnum.h"

#define ACCOUNTTYPE_BASIC [AccountType _BASIC]
#define ACCOUNTTYPE_EMAIL [AccountType _EMAIL]
#define ACCOUNTTYPE_FACEBOOK [AccountType _FACEBOOK]
#define ACCOUNTTYPE_TWITTER [AccountType _TWITTER]
#define ACCOUNTTYPE_NONE [AccountType _NONE]

@interface AccountType : FirebaseEnum

+ (AccountType *)_BASIC;
+ (AccountType *)_EMAIL;
+ (AccountType *)_FACEBOOK;
+ (AccountType *)_TWITTER;
+ (AccountType *)_NONE;

@end

