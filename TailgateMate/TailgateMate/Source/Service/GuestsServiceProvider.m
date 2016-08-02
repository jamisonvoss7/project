//
//  GuestsServiceProvider.m
//  TailgateMate
//
//  Created by Jamison Voss on 7/31/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "GuestsServiceProvider.h"
#import "Batch.h"

@implementation GuestsServiceProvider

- (void)inviteGuests:(NSArray *)guests
     toTailgateParty:(TailgateParty *)party
        withComplete:(void (^)(BOOL, NSError *))handler {
    Batch *batch = [Batch create];

    Invite *newInvite = [[Invite alloc] init];
    newInvite.tailgateId = party.uid;
    
    for (Contact *contact in guests) {
        [batch addBatchBlock:^(Batch *batch) {
            NSString *path = [NSString stringWithFormat:@"invites/%@", contact.userName];
            
            [super observeDataAtPath:path
                      withCompletion:^(FIRDataSnapshot *data) {
                          if (data.exists) {
                              NSMutableArray *invites = [NSMutableArray arrayWithArray:[Invite arrayFromData:data]];
                              [invites addObject:newInvite];
                              
                              [super updateArrayData:[Invite dictionaryFromArray:invites]
                                        forPath:path
                                 withCompletion:^(NSError *error, FIRDatabaseReference *ref) {
                                     [batch complete:error];
                                 }];
                          } else {
                              NSMutableArray *invites = [[NSMutableArray alloc] initWithObjects:newInvite, nil];
                           
                              [super setArrayData:[Invite dictionaryFromArray:invites]
                                          forPath:path
                                   withCompletion:^(NSError *error, FIRDatabaseReference *ref) {
                                       [batch complete:error];
                                   }];
                          }
                      }];
        }];
        
    }
    
    [batch executeWithComplete:^(NSError *error) {
        handler(!error, error);
    }];
    
}

@end
