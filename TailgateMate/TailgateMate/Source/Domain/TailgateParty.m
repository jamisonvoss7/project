//
//  TailgateParty.m
//  TailgateMate
//
//  Created by Jamison Voss on 10/5/15.
//  Copyright © 2015 Jamison Voss. All rights reserved.
//

#import "TailgateParty.h"

@implementation TailgateParty

+ (instancetype)instanceFromDate:(FIRDataSnapshot *)data; {
    TailgateParty *instance = [[TailgateParty alloc] init];
 
    instance.name = data.value[@"name"];
    instance.details = data.value[@"details"];
    instance.personCount = data.value[@"personCount"];
    instance.parkingLot = [ParkingLot instacneFromDictionary:data.value[@"parkingLot"]];
    instance.uid = data.value[@"uid"];
//    instance.supplies = [TailgateSupply arrayFromData:data.value[@"supplies"]];
//    instance.needs = [TailgateSupply arrayFromData:data.value[@"needs"]];
    instance.guests = [Contact arrayFromData:data.value[@"guests"]];
    instance.fanType = [TailgatePartyFanType findByString:data.value[@"fanType"]];
    instance.type = [TailgatePartyType findByString:data.value[@"type"]];
    instance.hostUserName = data.value[@"hostUserName"];
    instance.startDate = [FirebaseObject dateFromDateString:data.value[@"startDate"]];
    instance.endDate = [FirebaseObject dateFromDateString:data.value[@"endDate"]];
    
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
//        _supplies = [[NSArray alloc] init];
//        _needs = [[NSArray alloc] init];
    }
    return self;
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
//    if (self.supplies.count > 0) {
//        dictionary[@"supplies"] = [TailgateSupply dictionaryFromArray:self.supplies];
//    }
//    if (self.needs.count > 0) {
//        dictionary[@"needs"] = [TailgateSupply dictionaryFromArray:self.needs];
//    }
    if (self.guests.count > 0) {
        dictionary[@"guests"] = [Contact dictionaryFromArray:self.guests];
    }
    if (self.type) {
        dictionary[@"type"] = [self.type description];
    }
    if (self.hostUserName) {
        dictionary[@"hostUserName"] = self.hostUserName;
    }
    if (self.startDate) {
        dictionary[@"startDate"] = [FirebaseObject dateToDateString:self.startDate];
    }
    if (self.endDate) {
        dictionary[@"endDate"] = [FirebaseObject dateToDateString:self.endDate];
    }

    dictionary[@"fanType"] = [self.fanType description];
    
    return dictionary;
}

@end
