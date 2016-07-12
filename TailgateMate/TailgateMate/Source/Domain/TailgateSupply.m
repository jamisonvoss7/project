//
//  TailgateSupply.m
//  TailgateMate
//
//  Created by Jamison Voss on 10/5/15.
//  Copyright © 2015 Jamison Voss. All rights reserved.
//

#import "TailgateSupply.h"

@implementation TailgateSupply

+ (instancetype)instanceFromDate:(FIRDataSnapshot *)data {
    TailgateSupply *supply = [[TailgateSupply alloc] init];
    
    supply.name = data.value[@"name"];
    supply.details = data.value[@"details"];
    supply.type = [[SupplyType alloc] initWithString:data.value[@"type"]];
    
    return supply;
}

+ (instancetype)instacneFromDictionary:(NSDictionary *)dictionary {
    TailgateSupply *supply = [[TailgateSupply alloc] init];
    
    supply.name = dictionary[@"name"];
    supply.details = dictionary[@"details"];
    supply.type = [[SupplyType alloc] initWithString:dictionary[@"type"]];
    
    return supply;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (self.name.length > 0) {
        dict[@"name"] = self.name;
    }
    if (self.details.length > 0) {
        dict[@"details"] = self.details;
    }
    if (self.type) {
        dict[@"type"] = [self.type description];
    }
    
    return [NSDictionary dictionaryWithDictionary:dict];
}


@end
