//
//  Thing.h
//  TailgateMate
//
//  Created by Jamison Voss on 4/10/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FirebaseObject.h"

@interface Thing : FirebaseObject

@property (nonnull, copy) NSString *part1;
@property (nonnull, copy) NSString *part2;
@property (nonnull, copy) NSString *name;

@end
