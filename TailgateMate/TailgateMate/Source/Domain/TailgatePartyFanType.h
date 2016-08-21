//
//  TailgatePartyFanType.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/18/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FirebaseEnum.h"

#define TAILGATEPARTYFANTYPE_HOME [TailgatePartyFanType _HOME]
#define TAILGATEPARTYFANTYPE_AWAY [TailgatePartyFanType _AWAY]
#define TAILGATEPARTYFANTYPE_BOTH [TailgatePartyFanType _BOTH]

@interface TailgatePartyFanType : FirebaseEnum

+ (TailgatePartyFanType *)_HOME;
+ (TailgatePartyFanType *)_AWAY;
+ (TailgatePartyFanType *)_BOTH;

@end
