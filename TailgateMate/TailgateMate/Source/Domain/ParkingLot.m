//
//  ParkingLot.m
//  TailgateMate
//
//  Created by Jamison Voss on 3/29/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "ParkingLot.h"

@implementation ParkingLot

+ (instancetype)instanceFromDate:(FIRDataSnapshot *)data {
    ParkingLot *parkingLot = [[ParkingLot alloc] init];
    
    parkingLot.lotName = data.value[@"lotName"];
    parkingLot.location = [Location instacneFromDictionary:data.value[@"location"]];
    
    return parkingLot;
}

+ (instancetype)instacneFromDictionary:(NSDictionary *)dictionary {
    ParkingLot *parkingLot = [[ParkingLot alloc] init];
    
    parkingLot.lotName = dictionary[@"lotName"];
    parkingLot.location = [Location instacneFromDictionary:dictionary[@"location"]];
    
    return parkingLot;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    if (self.lotName.length > 0) {
        dictionary[@"lotName"] = self.lotName;
    }
    
    if (self.location) {
        dictionary[@"location"] = [self.location dictionaryRepresentation];
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
