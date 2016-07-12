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

    instance.firstName = data.value[@"firstName"];
    instance.lastName = data.value[@"lastName"];
    instance.userName = data.value[@"userName"];
    instance.phoneNumber = data.value[@"phoneNumber"];
    
    return instance;
}

+ (instancetype)instacneFromDictionary:(NSDictionary *)dictionary {
    Contact *instance = [[Contact alloc] init];
    
    instance.firstName = dictionary[@"firstName"];
    instance.lastName = dictionary[@"lastName"];
    instance.userName = dictionary[@"userName"];
    instance.phoneNumber = dictionary[@"phoneNumber"];
    
    return instance;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (self.firstName.length > 0) {
        dict[@"firstName"] = self.firstName;
    }
    
    if (self.lastName.length > 0) {
        dict[@"lastName"] = self.lastName;
    }
    
    if (self.userName.length > 0) {
        dict[@"userName"] = self.userName;
    }
    
    if (self.phoneNumber.length > 0) {
        dict[@"phoneNumber"] = self.phoneNumber;
    }
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

@end
