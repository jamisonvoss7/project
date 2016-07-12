//
//  Stadium.m
//  TailgateMate
//
//  Created by Jamison Voss on 10/5/15.
//  Copyright © 2015 Jamison Voss. All rights reserved.
//

#import "Stadium.h"

@implementation Stadium

+ (instancetype)instanceFromDate:(FIRDataSnapshot *)data {
    Stadium *instance = [[Stadium alloc] init];
    
    instance.name = data.value[@"name"];
    instance.location = [Location instanceFromDate:data.value[@"location"]];
    
    return instance;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    if (self.name.length > 0) {
        dictionary[@"name"] = self.name;
    }
    
    if (self.location) {
        dictionary[@"location"] = [self.location dictionaryRepresentation];
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
