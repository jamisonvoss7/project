//
//  TailgateParty.h
//  TailgateMate
//
//  Created by Jamison Voss on 10/5/15.
//  Copyright © 2015 Jamison Voss. All rights reserved.
//

#import "Location.h"
#import "FirebaseObject.h"

@interface TailgateParty : FirebaseObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *details;
@property (nonatomic) NSNumber *personCount;
@property (nonatomic) ParkingLot *parkingLot;
@property (nonatomic) NSArray *supplies;
@property (nonatomic) NSArray *needs;

@end
