//
//  UserCredentials.h
//  TailgateMate
//
//  Created by Jamison Voss on 3/7/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FirebaseObject.h"

@interface UserCredentials : FirebaseObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;

@end
