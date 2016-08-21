//
//  TailgateParty.h
//  TailgateMate
//
//  Created by Jamison Voss on 10/5/15.
//  Copyright © 2015 Jamison Voss. All rights reserved.
//

#import "FirebaseObject.h"
#import "TailgatePartyFanType.h"

@interface TailgateParty : FirebaseObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *details;
@property (nonatomic) NSNumber *personCount;
@property (nonatomic) ParkingLot *parkingLot;

// @property (nonatomic) NSArray *supplies;
// @property (nonatomic) NSArray *needs;

@property (nonatomic) NSArray *guests;
@property (nonatomic) TailgatePartyFanType *fanType;
@property (nonatomic) TailgatePartyType *type;
@property (nonatomic, copy) NSString *hostUserName;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) NSArray *timeline;

@end
