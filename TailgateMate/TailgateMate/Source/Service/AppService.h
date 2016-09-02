//
//  AppService.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/26/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FireBaseServiceProvider.h"

@interface AppService : FireBaseServiceProvider

- (void)getAppStoreLineWithCompletion:(void (^)(NSString *link, NSError *error))handler;

@end
