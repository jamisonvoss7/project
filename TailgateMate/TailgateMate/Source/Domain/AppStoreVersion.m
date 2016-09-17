//
//  AppStoreVersion.m
//  TailgateMate
//
//  Created by Jamison Voss on 9/13/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AppStoreVersion.h"

@implementation AppStoreVersion

+ (instancetype)instanceFromDate:(FIRDataSnapshot *)data {
    AppStoreVersion *instance = [[AppStoreVersion alloc] init];
    
    instance.minVersion = data.value[@"minVersion"];
    
    return instance;
}

@end
