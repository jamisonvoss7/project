//
//  Stadium.h
//  TailgateMate
//
//  Created by Jamison Voss on 10/5/15.
//  Copyright © 2015 Jamison Voss. All rights reserved.
//

#import "FirebaseObject.h"

@interface Stadium : FirebaseObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic) Location *location;
@property (nonatomic) NSArray *parkingLots;

@end
