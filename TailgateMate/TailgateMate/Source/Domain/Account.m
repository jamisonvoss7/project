//
//  Account.m
//  TailgateMate
//
//  Created by Jamison Voss on 2/9/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "Account.h"

@implementation Account

+ (instancetype)instanceFromDate:(FIRDataSnapshot *)data {
    Account *account = [[Account alloc] init];
        
    account.displayName = data.value[@"displayName"];
    account.emailAddress = data.value[@"emailAddress"];
    account.phoneNumber = data.value[@"phoneNumber"];
    account.userName = data.value[@"userName"];
    account.photoId = data.value[@"photoId"];
    account.photoUrl = data.value[@"photoUrl"];
    account.type = [[AccountType alloc] initWithString:data.value[@"type"]];
    account.uid = data.value[@"uid"];
    
    if (data.value[@"contacts"]) {
        account.contacts = [Contact arrayFromArray:data.value[@"contacts"]];
    }
    
    if (data.value[@"pastParties"]) {
        account.pastParties = [TailgateParty arrayFromData:data.value[@"pastParties"]];
    }
    
    if (data.value[@"upcomingOrCurrentParties"]) {
        account.upcomingOrCurrentParties = [TailgateParty arrayFromData:data.value[@"upcomingOrCurrentParties"]];
    }
    
    return account;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    if (self.displayName.length > 0) {
        dictionary[@"displayName"] = self.displayName;
    }
    if (self.emailAddress.length > 0) {
        dictionary[@"emailAddress"] = self.emailAddress;
    }
    if (self.uid.length > 0) {
        dictionary[@"uid"] = self.uid;
    }
    if (self.type) {
        dictionary[@"type"] = [self.type description];
    }
    if (self.contacts.count > 0) {
        dictionary[@"contacts"] = [Contact dictionaryFromArray:self.contacts];
    }
    if (self.pastParties.count > 0) {
        dictionary[@"pastParties"] = [TailgateParty dictionaryFromArray:self.pastParties];
    }
    if (self.upcomingOrCurrentParties.count > 0) {
        dictionary[@"upcomingOrCurrentParties"] = [TailgateParty dictionaryFromArray:self.upcomingOrCurrentParties];
    }
    if (self.photoUrl.length > 0) {
        dictionary[@"photoUrl"] = self.photoUrl;
    }
    if (self.photoId.length > 0) {
        dictionary[@"photoId"] = self.photoId;
    }
    if (self.userName.length > 0) {
        dictionary[@"userName"] = self.userName;
    }
    
    return dictionary;
}

@end
