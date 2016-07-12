//
//  Location.m
//  TailgateMate
//
//  Created by Jamison Voss on 10/5/15.
//  Copyright © 2015 Jamison Voss. All rights reserved.
//

#import "Location.h"

@implementation Location

+ (instancetype) instanceFromDate:(FIRDataSnapshot *)data {
    Location *location = [[Location alloc] init];
    
    location.lat = data.value[@"lat"];
    location.lon = data.value[@"lon"];
    location.radius = data.value[@"radius"];
    
    return location;
}

+ (instancetype)instacneFromDictionary:(NSDictionary *)dictionary {
    Location *location = [[Location alloc] init];
    
    location.lat = dictionary[@"lat"];
    location.lon = dictionary[@"lon"];
    location.radius = dictionary[@"radius"];
    
    return location;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    if (self.lat) {
        dictionary[@"lat"] = self.lat;
    }
    
    if (self.lon) {
        dictionary[@"lon"] = self.lon;
    }
    
    if (self.radius) {
        dictionary[@"radius"] = self.radius;
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
