//
//  TailgatePartyType.h
//  TailgateMate
//
//  Created by Jamison Voss on 6/25/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FirebaseEnum.h"

#define TAILGATEPARTYTYPE_PUBLIC [TailgatePartyType _PUBLIC];
#define TAILGATEPARTYTYPE_PRIVATE [TailgatePartyType _PRIVATE];
#define TAILGATEPARTYTYPE_PROMOTED [TailgatePartyType _PROMOTED];

@interface TailgatePartyType : FirebaseEnum

+ (TailgatePartyType *)_PUBLIC;
+ (TailgatePartyType *)_PRIVATE;
+ (TailgatePartyType *)_PROMOTED;

@end
