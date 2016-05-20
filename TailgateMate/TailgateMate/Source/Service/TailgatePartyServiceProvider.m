//
//  TailgatePartyServiceProvider.m
//  TailgateMate
//
//  Created by Jamison Voss on 4/16/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TailgatePartyServiceProvider.h"

@implementation TailgatePartyServiceProvider

- (void)getAllTailgateParties:(void (^)(NSArray *, NSError *))handler {
    NSString *route = [NSString stringWithFormat:@"tailgateParties"];

    [self observeDateAtPath:route withCompletion:^(FDataSnapshot *data) {
        NSArray *array = [TailgateParty arrayFromData:data];
        if (array) {
            handler(array, nil);
        } else {
            handler(nil, nil);
        }
    }];
}

- (void)addTailgateParty:(TailgateParty *)party withComplete:(void (^)(BOOL, NSError *))handler {
    NSString *route = [NSString stringWithFormat:@"tailgateParties/%@", party.uid];
    
    [self setData:party
          forPath:route
   withCompletion:^(NSError *error, Firebase *ref) {
       if (ref && !error) {
           handler(YES, nil);
       } else {
           handler(NO, error);
       }
   }];
}

- (void)updateTailgateParty:(TailgateParty *)party withComplete:(void (^)(BOOL, NSError *))handler {
    NSString *route = [NSString stringWithFormat:@"tailgateParties/%@", party.uid];
    
    [self updateData:party
             forPath:route
      withCompletion:^(NSError *error, Firebase *ref) {
          if (ref && !error) {
              handler(YES, nil);
          } else {
              handler(NO, error);
          }
    }];
}
@end
