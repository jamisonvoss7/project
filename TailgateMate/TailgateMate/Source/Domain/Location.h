//
//  Location.h
//  TailgateMate
//
//  Created by Jamison Voss on 10/5/15.
//  Copyright © 2015 Jamison Voss. All rights reserved.
//

#import "FirebaseObject.h"
#import <CoreGraphics/CoreGraphics.h>

@interface Location : FirebaseObject

@property (nonatomic) NSNumber *lat;
@property (nonatomic) NSNumber *lon;
@property (nonatomic) NSNumber *radius;

@end
