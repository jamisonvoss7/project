//
//  SupplyType.h
//  TailgateMate
//
//  Created by Jamison Voss on 4/11/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FirebaseEnum.h"

#define SUPPLYTYPE_DRINK [SupplyType _DRINK]
#define SUPPLYTYPE_ALCOHOLIC_DRINK [SupplyType _ALCOHOLIC_DRINK]
#define SUPPLYTYPE_FOOD [SupplyType _FOOD]
#define SUPPLYTYPE_UTENSILE [SupplyType _UTENSILE]
#define SUPPLYTYPE_SNACK [SupplyType _SNACK]
#define SUPPLYTYPE_APPLIANCE [SupplyType _APPLIANCE]
#define SUPPLYTYPE_FURNITURE [SupplyType _FURNITURE]
#define SUPPLYTYPE_GAME [SupplyType _GAME]
#define SUPPLYTYPE_MISCELLANEOUS [SupplyType _MISCELLANEOUS]

@interface SupplyType : FirebaseEnum

+ (SupplyType *)_DRINK;
+ (SupplyType *)_ALCOHOLIC_DRINK;
+ (SupplyType *)_FOOD;
+ (SupplyType *)_UTENSILE;
+ (SupplyType *)_SNACK;
+ (SupplyType *)_APPLIANCE;
+ (SupplyType *)_FURNITURE;
+ (SupplyType *)_GAME;
+ (SupplyType *)_MISCELLANEOUS;

@end
