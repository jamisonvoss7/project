//
//  ContactType.h
//  TailgateMate
//
//  Created by Jamison Voss on 7/31/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FirebaseEnum.h"

#define CONTACTTYPE_PHONE [ContactType _PHONE]
#define CONTACTTYPE_EMAIL [ContactType _EMAIL]
#define CONTACTTYPE_SOCIAL [ContactType _SOCIAL]

@interface ContactType : FirebaseEnum

+ (ContactType *)_PHONE;
+ (ContactType *)_EMAIL;
+ (ContactType *)_SOCIAL;

@end
