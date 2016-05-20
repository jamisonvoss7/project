//
//  Account.m
//  TailgateMate
//
//  Created by Jamison Voss on 2/9/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "Account.h"

@implementation Account


+ (instancetype)instanceFromDate:(FDataSnapshot *)data {
    Account *account = [[Account alloc] init];
    
    NSLog(@"%@", data.value);
    
    account.firstName = data.value[@"firstName"];
    account.lastName = data.value[@"lastName"];
    account.emailAddress = data.value[@"emailAddress"];
    account.uid = data.value[@"uid"];
    if (data.value[@"userCredentials"]) {
        account.credentials = [UserCredentials instacneFromDictionary:data.value[@"userCredentials"]];
    }
    
    return account;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    if (self.firstName.length > 0) {
        dictionary[@"firstName"] = self.firstName;
    }
    if (self.lastName.length > 0) {
        dictionary[@"lastName"] = self.lastName;
    }
    if (self.emailAddress.length > 0) {
        dictionary[@"emailAddress"] = self.emailAddress;
    }
    if (self.uid.length > 0) {
        dictionary[@"uid"] = self.uid;
    }
    if (self.credentials) {
        dictionary[@"userCredentials"] = [self.credentials dictionaryRepresentation];
    }
    
    return dictionary;
}

@end
