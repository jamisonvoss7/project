//
//  TailgateParty+Additions.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/18/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TailgateParty.h"

@interface TailgateParty (Additions)

- (NSString *)stringForFanType;
- (BOOL)isDifferentThanParty:(TailgateParty *)party;

@end
