//
//  Thing.m
//  TailgateMate
//
//  Created by Jamison Voss on 4/10/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "Thing.h"

@implementation Thing

+ (instancetype)instanceFromDate:(FDataSnapshot *)data {
    Thing *instance = [[Thing alloc] init];

    instance.name = data.value[@"name"];
    instance.part1 = data.value[@"part1"];
    instance.part2 = data.value[@"part2"];
    
    return instance;
}

+ (NSDictionary *)dictionaryFromArray:(NSArray *)array {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:array.count];
    
    for (Thing *thing in array) {
        if (thing.name.length > 0) {
            dict[thing.name] = [thing dictionaryRepresentation];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:dict];
}


- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (self.name.length > 0) {
        dict[@"name"] = self.name;
    }
    
    if (self.part1.length > 0) {
        dict[@"part1"] = self.part1;
    }
    
    if (self.part2.length > 0) {
        dict[@"part2"] = self.part2;
    }
    
    return [NSDictionary dictionaryWithDictionary:dict];
}



@end
