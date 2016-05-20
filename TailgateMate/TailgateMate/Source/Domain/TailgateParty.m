//
//  TailgateParty.m
//  TailgateMate
//
//  Created by Jamison Voss on 10/5/15.
//  Copyright © 2015 Jamison Voss. All rights reserved.
//

#import "TailgateParty.h"

@implementation TailgateParty

+ (instancetype)instanceFromDate:(FDataSnapshot *)data; {
    TailgateParty *instance = [[TailgateParty alloc] init];
 
    instance.name = data.value[@"name"];
    instance.details = data.value[@"details"];
    instance.personCount = data.value[@"personCount"];
    instance.parkingLot = [ParkingLot instacneFromDictionary:data.value[@"parkingLot"]];
    instance.uid = data.value[@"uid"];
    instance.supplies = [TailgateSupply arrayFromData:data.value[@"supplies"]];
    instance.needs = [TailgateSupply arrayFromData:data.value[@"supplies"]];
    
    return instance;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    if (self.name.length > 0) {
        dictionary[@"name"] = self.name;
    }
    if (self.details.length > 0) {
        dictionary[@"details"] = self.details;
    }
    if (self.personCount > 0) {
        dictionary[@"personCount"] = self.personCount;
    }
    if (self.uid.length > 0) {
        dictionary[@"uid"] = self.uid;
    }
    if (self.parkingLot) {
        dictionary[@"parkingLot"] = [self.parkingLot dictionaryRepresentation];
    }
    if (self.supplies.count > 0) {
        dictionary[@"supplies"] = [TailgateSupply dictionaryFromArray:self.supplies];
    }
    if (self.needs.count > 0) {
        dictionary[@"needs"] = [TailgateSupply dictionaryFromArray:self.needs];
    }
    
    return dictionary;
}

@end
