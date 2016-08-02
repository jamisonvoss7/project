//
//  Contact.m
//  TailgateMate
//
//  Created by Jamison Voss on 7/3/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "Contact.h"

@implementation Contact

+ (instancetype)instanceFromDate:(FIRDataSnapshot *)data {
    Contact *instance = [[Contact alloc] init];

    instance.displayName = data.value[@"displayName"];
    instance.emailAddress = data.value[@"emailAddress"];
    instance.phoneNumber = data.value[@"phoneNumber"];
    instance.contactType = [[ContactType alloc] initWithString:data.value[@"contactType"]];
    instance.userName = data.value[@"userName"];
    
    return instance;
}

+ (instancetype)instacneFromDictionary:(NSDictionary *)dictionary {
    Contact *instance = [[Contact alloc] init];
    
    instance.displayName = dictionary[@"displayName"];
    instance.emailAddress = dictionary[@"emailAddress"];
    instance.phoneNumber = dictionary[@"phoneNumber"];
    instance.contactType = [[ContactType alloc] initWithString:dictionary[@"contactType"]];
    instance.userName = dictionary[@"userName"];

    return instance;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (self.displayName.length > 0) {
        dict[@"displayName"] = self.displayName;
    }
    
    if (self.emailAddress.length > 0) {
        dict[@"emailAddress"] = self.emailAddress;
    }
    
    if (self.phoneNumber.length > 0) {
        dict[@"phoneNumber"] = self.phoneNumber;
    }
    
    if (self.contactType) {
        dict[@"contactType"] = [self.contactType description];
    }
    
    if (self.userName.length > 0) {
        dict[@"userName"] = self.userName;
    }
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

@end
