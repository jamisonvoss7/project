//
//  AppService.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/26/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AppService.h"

@implementation AppService

- (void)getAppStoreLineWithCompletion:(void (^)(NSString *, NSError *))handler {
    NSString *path = @"appStoreLink";
    
    [super observeDataAtPath:path
              withCompletion:^(FIRDataSnapshot *data) {
                  if (data.exists) {
                      handler(data.value , nil);
                  } else {
                      handler(nil, nil);
                  }
              }];
}

@end
