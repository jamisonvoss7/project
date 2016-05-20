//
//  FireBaseEnum.m
//  TailgateMate
//
//  Created by Jamison Voss on 4/11/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FirebaseEnum.h"

@interface FirebaseEnum ()
@property (nonatomic, copy) NSString *enumString;
@end

@implementation FirebaseEnum

- (id)initWithString:(NSString *)enumString {
    self = [super init];
    if (self) {
        _enumString = enumString;
    }
    return self;
}

- (NSString *)description {
    return _enumString;
}

+ (id)findByString:(NSString *)enumString {
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end

