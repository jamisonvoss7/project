//
//  Account.h
//  TailgateMate
//
//  Created by Jamison Voss on 2/9/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FirebaseObject.h"
#import "UserCredentials.h"

typedef enum AccountType {
    AccountTypeBasic,
    AccountTypeEmail,
    AccountTypeFacebook,
    AccountTypeTwitter,
    AccountTypeNone
} AccountType;

@interface Account : FirebaseObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *emailAddress;
@property (nonatomic, assign) AccountType type;
@property (nonatomic) UserCredentials *credentials;

@end
