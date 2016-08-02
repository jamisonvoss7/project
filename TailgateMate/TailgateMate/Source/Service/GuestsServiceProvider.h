//
//  GuestsServiceProvider.h
//  TailgateMate
//
//  Created by Jamison Voss on 7/31/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FireBaseServiceProvider.h"

@interface GuestsServiceProvider : FireBaseServiceProvider

- (void)inviteGuests:(NSArray *)guests
     toTailgateParty:(TailgateParty *)party
        withComplete:(void (^)(BOOL success, NSError *error))handler;

@end
