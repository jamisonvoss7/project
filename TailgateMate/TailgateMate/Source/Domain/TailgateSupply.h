//
//  TailgateSupply.h
//  TailgateMate
//
//  Created by Jamison Voss on 10/5/15.
//  Copyright © 2015 Jamison Voss. All rights reserved.
//

#import "FirebaseObject.h"

@interface TailgateSupply : FirebaseObject
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *details;
@property (nonatomic) SupplyType *type;
@end
