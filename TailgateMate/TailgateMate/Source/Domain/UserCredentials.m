//
//  UserCredentials.m
//  TailgateMate
//
//  Created by Jamison Voss on 3/7/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "UserCredentials.h"

@implementation UserCredentials

+ (instancetype)instanceFromDate:(FDataSnapshot *)data {
    UserCredentials *userCredentials = [[UserCredentials alloc] init];
    userCredentials.userName = data.value[@"userName"];
    userCredentials.password = data.value[@"password"];
    return userCredentials;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
  
    if (self.userName.length > 0) {
        dictionary[@"userName"] = self.userName;
    }
    
    if (self.password.length > 0) {
        dictionary[@"password"] = self.password;
    }
    
    return [[NSDictionary alloc] initWithDictionary:dictionary];
}

@end
