//
//  Contact.h
//  TailgateMate
//
//  Created by Jamison Voss on 7/3/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FirebaseObject.h"

@interface Contact : FirebaseObject

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *emailAddress;
@property (nonatomic, copy) NSString *userName;

@property (nonatomic) ContactType *contactType;

@end
