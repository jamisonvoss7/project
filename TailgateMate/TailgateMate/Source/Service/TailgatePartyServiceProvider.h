//
//  TailgatePartyServiceProvider.h
//  TailgateMate
//
//  Created by Jamison Voss on 4/16/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FireBaseServiceProvider.h"

@interface TailgatePartyServiceProvider : FireBaseServiceProvider

- (void)getAllTailgateParties:(void (^)(NSArray *parties, NSError *error))handler;
- (void)addTailgateParty:(TailgateParty *)party withComplete:(void (^)(BOOL succcess, NSError *error))handler;
- (void)updateTailgateParty:(TailgateParty *)party withComplete:(void (^)(BOOL success, NSError *error))handler;

@end
