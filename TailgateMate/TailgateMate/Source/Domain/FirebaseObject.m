//
//  FirebaseObject.m
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FirebaseObject.h"

@implementation FirebaseObject

+ (instancetype)instanceFromDate:(FDataSnapshot *)data {
    return [[FirebaseObject alloc] init];
}

+ (instancetype)instacneFromDictionary:(NSDictionary *)dictionary {
    return [[FirebaseObject alloc] init];
}

+ (NSArray *)arrayFromData:(FDataSnapshot *)data {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:data.childrenCount];
    
    for (FDataSnapshot *snap in data.children) {
        [array addObject:[self instanceFromDate:snap]];
    }

    return [NSArray arrayWithArray:array];
}

+ (NSArray *)arrayFromArray:(NSArray *)arrayData {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:arrayData.count];
    
    for (NSDictionary *snap in arrayData) {
        [array addObject:[self instacneFromDictionary:snap]];
    }
    
    return [NSArray arrayWithArray:array];
}

+ (NSDictionary *)dictionaryFromArray:(NSArray *)array {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:array.count];
    
    int i = 0;
    
    for (FirebaseObject *object in array) {
        if (object.uid.length > 0) {
            dict[object.uid] = [object dictionaryRepresentation];
        } else {
            dict[[[NSNumber numberWithInteger:i] stringValue]] = [object dictionaryRepresentation];
        }
        i++;
    }
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (NSDictionary *)dictionaryRepresentation {
    return [[NSDictionary alloc] init];
}


@end
