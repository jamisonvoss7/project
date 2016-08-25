//
//  TailgatePartyServiceProvider.m
//  TailgateMate
//
//  Created by Jamison Voss on 4/16/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TailgatePartyServiceProvider.h"
#import "Batch.h"
#import "GuestsServiceProvider.h"
#import "Account+Additions.h"

@implementation TailgatePartyServiceProvider

- (void)getAllLiteTailgateParties:(void (^)(NSArray *, NSError *))handler {
    NSString *path = [NSString stringWithFormat:@"tailgateParties"];

    [self observeDataAtPath:path withCompletion:^(FIRDataSnapshot *data) {
        NSArray *array = [TailgateParty arrayFromData:data];
        if (array) {
            handler(array, nil);
        } else {
            handler(nil, nil);
        }
    }];
}

- (void)getTailgatePartiesInvitedTo:(void (^)(NSArray *, NSError *))handler {
    NSString *path = [NSString stringWithFormat:@"invites/%@", [AppManager sharedInstance].accountManager.profileAccount.userName];
    
    [super observeDataAtPath:path
              withCompletion:^(FIRDataSnapshot *data) {
                  if (data.exists) {
                      NSArray *array = [Invite arrayFromData:data];
                      if (array.count > 0) {
                          [self getTailgatePartiesFromIds:[self parseInvitesId:array]
                                             withComplete:handler];
                      } else {
                          handler(nil, nil);
                      }
                  } else {
                      handler(nil, nil);
                  }
    }];
}

- (void)getUserTailgateParties:(void (^)(NSArray *, NSError *))handler {
    NSString *path = [NSString stringWithFormat:@"tailgateParties"];
    NSDictionary *dict = @{@"hostUserName": [AppManager sharedInstance].accountManager.profileAccount.userName};
    
    [super observeDataAtPath:path
                   andParams:dict
              withCompletion:^(FIRDataSnapshot *data) {
                  if (data.exists) {
                      NSArray *parties = [TailgateParty arrayFromData:data];
                      Batch *batch = [Batch create];
                      NSMutableArray *allParties = [[NSMutableArray alloc] initWithCapacity:parties.count];
                      
                      for (TailgateParty *party in parties) {
                          [batch addBatchBlock:^(Batch *batch) {
                              [self getTailgatePartyFullForId:party.uid
                                                 withComplete:^(TailgateParty *party, NSError *error) {
                                                     if (party && !error) {
                                                         [allParties addObject:party];
                                                     }
                                                     [batch complete:error];
                                                 }];
                          }];
                      }
                      
                      [batch executeWithComplete:^(NSError *error) {
                          handler(allParties, error);
                      }];
                  } else {
                      handler(nil, nil);
                  }
              }];
}

- (void)getTailgatePartiesFromIds:(NSArray *)ids
                     withComplete:(void (^)(NSArray *, NSError *))handler {
    Batch *batch = [Batch create];
    NSMutableArray *parties = [[NSMutableArray alloc] initWithCapacity:ids.count];
    
    for (NSString *partyId in ids) {
        [batch addBatchBlock:^(Batch *batch) {
            [self getTailgatePartyFullForId:partyId withComplete:^(TailgateParty *party, NSError *error) {
                if (party && !error) {
                    [parties addObject:party];
                }
                [batch complete:error];
            }];
        }];
    }
    
    [batch executeWithComplete:^(NSError *error) {
        handler([NSArray arrayWithArray:parties], error);
    }];
}

- (void)getTailgatePartyFullForId:(NSString *)tailgateId withComplete:(void (^)(TailgateParty *, NSError *))handler {
    NSString *partyPath = [NSString stringWithFormat:@"tailgateParties/%@", tailgateId];
   
    [super observeDataAtPath:partyPath
              withCompletion:^(FIRDataSnapshot *data) {
                  if (data.exists) {
                      TailgateParty *party = [TailgateParty instanceFromDate:data];
                      [self batchRequestForFullTailgate:party withComplete:handler];
                  } else {
                      handler(nil, nil);
                  }
              }];
    
}

- (void)getPublicTailgateParties:(void (^)(NSArray *, NSError *))handler {
    NSString *path = [NSString stringWithFormat:@"tailgateParties"];
    NSDictionary *dict = @{@"type": [TAILGATEPARTYTYPE_PUBLIC description]};
    
    [super observeDataAtPath:path
                   andParams:dict
              withCompletion:^(FIRDataSnapshot *data) {
                  if (data.exists) {
                      NSArray *parties = [TailgateParty arrayFromData:data];
                      Batch *batch = [Batch create];
                      NSMutableArray *allParties = [[NSMutableArray alloc] initWithCapacity:parties.count];
                      
                      for (TailgateParty *party in parties) {
                          [batch addBatchBlock:^(Batch *batch) {
                              [self getTailgatePartyFullForId:party.uid
                                                 withComplete:^(TailgateParty *party, NSError *error) {
                                                     if (party && !error) {
                                                         [allParties addObject:party];
                                                     }
                                                     [batch complete:error];
                                                 }];
                          }];
                      }
                      
                      [batch executeWithComplete:^(NSError *error) {
                          handler(allParties, error);
                      }];
                  } else {
                      handler(nil, nil);
                  }
              }];
}

- (void)getGuestsForTailgate:(NSString *)tailgateId
                withComplete:(void (^)(NSArray *guests, NSError *error))handler {
    NSString *guestPath = [NSString stringWithFormat:@"guests/%@", tailgateId];
  
    [super observeDataAtPath:guestPath
              withCompletion:^(FIRDataSnapshot *data) {
                  if (data) {
                      NSArray *guests = [Contact arrayFromData:data];
                      handler(guests, nil);
                  } else {
                      handler(nil, nil);
                  }
              }];
}

- (void)getTimeLineForTailgate:(NSString *)tailgateId
                  withComplete:(void (^)(NSArray *, NSError *))handler {
    NSString *path = [NSString stringWithFormat:@"timeline/%@", tailgateId];
    
    [super observeDataAtPath:path
              withCompletion:^(FIRDataSnapshot *data) {
                  if (data) {
                      NSArray *timeline = [TimelineItem arrayFromData:data];
                      handler(timeline, nil);
                  } else {
                      handler(nil, nil);
                  }
              }];
}

//- (void)getSuppliesForTailgate:(NSString *)tailgateId
//                  withComplete:(void (^)(NSArray *supplies, NSError *error))handler {
//    NSString *path = [NSString stringWithFormat:@"supplies/%@", tailgateId];
//    
//    [super observeDataAtPath:path
//              withCompletion:^(FIRDataSnapshot *data) {
//                  if (data) {
//                      NSArray *supplies = [TailgateSupply arrayFromData:data];
//                      handler(supplies, nil);
//                  } else {
//                      handler(nil, nil);
//                  }
//              }];
//}
//
//- (void)getNeedsForTailgate:(NSString *)tailgateId
//               withComplete:(void (^)(NSArray *needs, NSError *error))handler {
//    NSString *path = [NSString stringWithFormat:@"needs/%@", tailgateId];
//    
//    [super observeDataAtPath:path
//              withCompletion:^(FIRDataSnapshot *data) {
//                  if (data) {
//                      NSArray *needs = [TailgateSupply arrayFromData:data];
//                      handler(needs, nil);
//                  } else {
//                      handler(nil, nil);
//                  }
//              }];
//}

- (void)batchRequestForFullTailgate:(TailgateParty *)party
                       withComplete:(void (^)(TailgateParty *tailgate, NSError *))handler {
    Batch *batch = [Batch create];
    
    [batch addBatchBlock:^(Batch *batch) {
        [self getGuestsForTailgate:party.uid
                      withComplete:^(NSArray *guests, NSError *error) {
                          if (guests.count > 0) {
                              party.guests = guests;
                          }
                          [batch complete:error];
                      }];
    }];
    
    [batch addBatchBlock:^(Batch *batch) {
       [self getTimeLineForTailgate:party.uid
                       withComplete:^(NSArray *timeline, NSError *error) {
                           if (timeline.count > 0) {
                               party.timeline = timeline;
                           }
                           [batch complete:error];
                       }];
    }];
    
//    [batch addBatchBlock:^(Batch *batch) {
//        [self getSuppliesForTailgate:party.uid
//                        withComplete:^(NSArray *supplies, NSError *error) {
//                            if (supplies.count > 0) {
//                                party.supplies = supplies;
//                            }
//                            [batch complete:error];
//                        }];
//    }];
//    
//    [batch addBatchBlock:^(Batch *batch) {
//        [self getNeedsForTailgate:party.uid
//                     withComplete:^(NSArray *needs, NSError *error) {
//                         if (needs.count > 0) {
//                             party.needs = needs;
//                         }
//                         [batch complete:error];
//                     }];
//    }];
    
    [batch executeWithComplete:^(NSError *error) {
        handler(party, error);
    }];
}

- (void)addTailgateParty:(TailgateParty *)party withComplete:(void (^)(BOOL, NSError *))handler {
    [self batchAddTailgateParty:party
                   withComplete:handler];
}

- (void)updateLiteTailgateParty:(TailgateParty *)party
                   withComplete:(void (^)(BOOL, NSError *))handler {
    NSString *path = [NSString stringWithFormat:@"tailgateParties/%@", party.uid];
    
    [self updateData:party
             forPath:path
      withCompletion:^(NSError *error, FIRDatabaseReference *ref) {
          if (ref && !error) {
              handler(YES, nil);
          } else {
              handler(NO, error);
          }
    }];
}

- (void)updateTailgatePartyFull:(TailgateParty *)party withComplete:(void (^)(BOOL, NSError *))handler {
    NSString *path = [NSString stringWithFormat:@"tailgateParties/%@", party.uid];
    
    [super updateData:party
              forPath:path
       withCompletion:^(NSError *error, FIRDatabaseReference *ref) {
           if (ref && !error) {
               [self batchUpdateTailgateParty:party withComplete:handler];
           }
       }];
}

- (void)updateTailgateParty:(NSString *)tailgateId
                 withGuests:(NSArray *)guests
               withComplete:(void (^)(BOOL success, NSError *error))handler {
    NSString  *path = [NSString stringWithFormat:@"guest/%@", tailgateId];
    
    [super updateArrayData:[Contact dictionaryFromArray:guests]
                   forPath:path
            withCompletion:^(NSError *error, FIRDatabaseReference *ref) {
                if (ref && !error) {
                    handler(YES, nil);
                } else {
                    handler(NO, error);
                }
            }];
}


//- (void)updateTailgateParty:(NSString *)tailgateId
//               withSupplies:(NSArray *)supplies
//               withComplete:(void (^)(BOOL success, NSError *))handler {
//    NSString *path = [NSString stringWithFormat:@"supplies/%@", tailgateId];
//    
//    [super updateData:[TailgateSupply dictionaryFromArray:supplies]
//              forPath:path
//       withCompletion:^(NSError *error, FIRDatabaseReference *ref) {
//           if (ref && !error) {
//               handler(YES, nil);
//           } else {
//               handler(NO, error);
//           }
//       }];
//}

//- (void)updateTailgateParty:(NSString *)tailgateId
//                  withNeeds:(NSArray *)needs
//               withComplete:(void (^)(BOOL success, NSError *))handler {
//    NSString *path = [NSString stringWithFormat:@"needs/%@", tailgateId];
//    
//    [super updateData:[TailgateSupply dictionaryFromArray:needs]
//              forPath:path
//       withCompletion:^(NSError *error, FIRDatabaseReference *ref) {
//           if (ref && !error) {
//               handler(YES, nil);
//           } else {
//               handler(NO, error);
//           }
//       }];
//}

- (void)batchUpdateTailgateParty:(TailgateParty *)party
                    withComplete:(void (^)(BOOL success, NSError *error))handler {
    Batch *batch = [Batch create];
    
    [batch addBatchBlock:^(Batch *batch) {
        [self updateTailgateParty:party.uid
                       withGuests:party.guests
                     withComplete:^(BOOL success, NSError *error) {
                         [batch complete:error];
                     }];
    }];
    
    [batch addBatchBlock:^(Batch *batch) {
        GuestsServiceProvider *provider = [[GuestsServiceProvider alloc] init];
        [provider inviteGuests:party.guests
               toTailgateParty:party
                  withComplete:^(BOOL success, NSError *error) {
                      [batch complete:error];
                  }];
    }];

    
//    [batch addBatchBlock:^(Batch *batch) {
//        [self updateTailgateParty:party.uid
//                     withSupplies:party.supplies
//                     withComplete:^(BOOL success, NSError *error) {
//                         [batch complete:error];
//                     }];
//    }];
//    
//    [batch addBatchBlock:^(Batch *batch) {
//        [self updateTailgateParty:party.uid
//                        withNeeds:party.needs
//                     withComplete:^(BOOL success, NSError *error) {
//                         [batch complete:error];
//                     }];
//    }];
    
    [batch executeWithComplete:^(NSError *error) {
        handler(!error, error);
    }];
}

- (void)batchAddTailgateParty:(TailgateParty *)party
                 withComplete:(void (^)(BOOL success, NSError *errro))handler {
    Batch *batch = [Batch create];
    
    // guests
    [batch addBatchBlock:^(Batch *batch) {
        NSString *guestsPath = [NSString stringWithFormat:@"guests/%@", party.uid];
        [super setArrayData:[Contact dictionaryFromArray:party.guests]
                    forPath:guestsPath
             withCompletion:^(NSError *error, FIRDatabaseReference *ref) {
                 [batch complete:error];
             }];
    }];
    
    [batch addBatchBlock:^(Batch *batch) {
        NSString *timelinePath = [NSString stringWithFormat:@"timeline/%@", party.uid];
        [super setArrayData:[TimelineItem dictionaryFromArray:party.timeline]
                    forPath:timelinePath
             withCompletion:^(NSError *error, FIRDatabaseReference *ref) {
                 [batch complete:error];
             }];
    }];
    
    // supplies
//    [batch addBatchBlock:^(Batch *batch) {
//        NSString *suppliesPath = [NSString stringWithFormat:@"supplies/%@", party.uid];
//        [super setArrayData:[TailgateSupply dictionaryFromArray:party.supplies]
//               forPath:suppliesPath
//        withCompletion:^(NSError *error, FIRDatabaseReference *ref) {
//            [batch complete:error];
//        }];
//    }];
//    
//    // needs
//    [batch addBatchBlock:^(Batch *batch) {
//        NSString *needsPath = [NSString stringWithFormat:@"needs/%@", party.uid];
//        [super setArrayData:[TailgateSupply dictionaryFromArray:party.needs]
//                    forPath:needsPath
//             withCompletion:^(NSError *error, FIRDatabaseReference *ref) {
//                 [batch complete:error];
//             }];
//    }];
    
    // Invites
    [batch addBatchBlock:^(Batch *batch) {
        GuestsServiceProvider *provider = [[GuestsServiceProvider alloc] init];
        [provider inviteGuests:party.guests
               toTailgateParty:party
                  withComplete:^(BOOL success, NSError *error) {
                      [batch complete:error];
                  }];
    }];

    [batch executeWithComplete:^(NSError *error) {
        party.guests = nil;
        party.timeline = nil;
//        party.supplies = nil;
//        party.needs = nil;
        
        NSString *path = [NSString stringWithFormat:@"tailgateParties/%@", party.uid];
        [super setData:party forPath:path withCompletion:^(NSError *error, FIRDatabaseReference *ref) {
            handler(!error, error);
        }];
    }];
}

- (NSArray *)parseInvitesId:(NSArray *)array {
    NSMutableArray *ids = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (Invite *invite in array) {
        [ids addObject:invite.tailgateId];
    }
    
    return [NSArray arrayWithArray:ids];
}

@end
