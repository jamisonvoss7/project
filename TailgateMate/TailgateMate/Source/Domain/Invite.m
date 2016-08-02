//
//  Invite.m
//  TailgateMate
//
//  Created by Jamison Voss on 7/31/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "Invite.h"

@implementation Invite
+ (instancetype)instanceFromDate:(FIRDataSnapshot *)data {
    Invite *instance = [[Invite alloc] init];
    
    instance.tailgateId = data.value[@"tailgateId"];
    
    return instance;
}

+ (instancetype)instacneFromDictionary:(NSDictionary *)dictionary {
    Invite *instance = [[Invite alloc] init];
    
    instance.tailgateId = dictionary[@"tailgateId"];
    
    return instance;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (self.tailgateId.length > 0) {
        dict[@"tailgateId"]= self.tailgateId;
    }

    return dict;
}
@end
