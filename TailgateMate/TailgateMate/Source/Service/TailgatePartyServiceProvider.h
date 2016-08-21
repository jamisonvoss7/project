//
//  TailgatePartyServiceProvider.h
//  TailgateMate
//
//  Created by Jamison Voss on 4/16/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FireBaseServiceProvider.h"

@interface TailgatePartyServiceProvider : FireBaseServiceProvider

// Getters

- (void)getAllLiteTailgateParties:(void (^)(NSArray *parties, NSError *error))handler;

- (void)getTailgatePartiesInvitedTo:(void (^)(NSArray *parties, NSError *error))handler;

- (void)getUserTailgateParties:(void (^)(NSArray *array, NSError *error))handler;

- (void)getTailgatePartiesFromIds:(NSArray *)ids
                     withComplete:(void (^)(NSArray *parties, NSError *error))handler;

- (void)getTailgatePartyFullForId:(NSString *)tailgateId
                     withComplete:(void (^)(TailgateParty *party, NSError *error))handler;

- (void)getPublicTailgateParties:(void (^)(NSArray *parties, NSError *error))handler;

- (void)getGuestsForTailgate:(NSString *)tailgateId
                withComplete:(void (^)(NSArray *guests, NSError *error))handler;

- (void)getTimeLineForTailgate:(NSString *)tailgateId
                  withComplete:(void (^)(NSArray *timeline, NSError *error))handler;

//- (void)getSuppliesForTailgate:(NSString *)tailgateId
//                  withComplete:(void (^)(NSArray *supplies, NSError *error))handler;
//
//- (void)getNeedsForTailgate:(NSString *)tailgateId
//               withComplete:(void (^)(NSArray *needs, NSError *error))handler;

// Add
- (void)addTailgateParty:(TailgateParty *)party
            withComplete:(void (^)(BOOL succcess, NSError *error))handler;


// Updater
- (void)updateLiteTailgateParty:(TailgateParty *)party
                   withComplete:(void (^)(BOOL success, NSError *error))handler;

- (void)updateTailgatePartyFull:(TailgateParty *)party
                   withComplete:(void (^)(BOOL success, NSError *error))handler;

- (void)updateTailgateParty:(NSString *)tailgateId
                 withGuests:(NSArray *)guests
               withComplete:(void (^)(BOOL success, NSError *error))handler;

- (void)updateTimeLineForParty:(NSString *)tailgateId
                  withTimeLine:(NSArray *)timeLine
                  withComplete:(void (^)(BOOL success, NSError *error))handler;

//- (void)updateTailgateParty:(NSString *)tailgateId
//               withSupplies:(NSArray *)supplies
//               withComplete:(void (^)(BOOL success, NSError *error))handler;
//
//- (void)updateTailgateParty:(NSString *)tailgateId
//                  withNeeds:(NSArray *)needs
//               withComplete:(void (^)(BOOL success, NSError *error))handler;

@end
