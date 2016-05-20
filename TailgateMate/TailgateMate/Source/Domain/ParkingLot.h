//
//  ParkingLot.h
//  TailgateMate
//
//  Created by Jamison Voss on 3/29/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FirebaseObject.h"

@interface ParkingLot : FirebaseObject

@property (nonatomic, copy) NSString *lotName;
@property (nonatomic) Location *location;

@end
