//
//  Account.h
//  TailgateMate
//
//  Created by Jamison Voss on 2/9/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FirebaseObject.h"
#import "UserCredentials.h"
#import "AccountType.h"

@interface Account : FirebaseObject

@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *emailAddress;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *photoId;
@property (nonatomic, copy) NSString *photoUrl;

@property (nonatomic) AccountType *type;

@property (nonatomic) NSArray /* Contacts */ *contacts;
@property (nonatomic) NSArray /* TailgateParty */ *pastParties;
@property (nonatomic) NSArray /* TailgateParty */ *upcomingOrCurrentParties;

@end
