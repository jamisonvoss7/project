//
//  SupplyType.m
//  TailgateMate
//
//  Created by Jamison Voss on 4/11/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "SupplyType.h"

static SupplyType *supplytype_drink;
static SupplyType *supplytype_alcoholic_drink;
static SupplyType *supplytype_food;
static SupplyType *supplytype_utensile;
static SupplyType *supplytype_snack;
static SupplyType *supplytype_appliance;
static SupplyType *supplytype_furniture;
static SupplyType *supplytype_game;
static SupplyType *supplytype_miscellaneous;

@implementation SupplyType

+ (SupplyType *)findByString:(NSString *)enumString {
  
    if ([enumString isEqualToString:@"DRINK"]) {
        return [self _DRINK];
    }
    if ([enumString isEqualToString:@"ALCOHOLIC_DRINK"]) {
        return [self _ALCOHOLIC_DRINK];
    }
    if ([enumString isEqualToString:@"FOOD"]) {
        return [self _FOOD];
    }
    if ([enumString isEqualToString:@"UTENSILE"]) {
        return [self _UTENSILE];
    }
    if ([enumString isEqualToString:@"SNACK"]) {
        return [self _SNACK];
    }
    if ([enumString isEqualToString:@"APPLIANCE"]) {
        return [self _APPLIANCE];
    }
    if ([enumString isEqualToString:@"FURNITURE"]) {
        return [self _FURNITURE];
    }
    if ([enumString isEqualToString:@"GAME"]) {
        return [self _GAME];
    }
    if ([enumString isEqualToString:@"MISCELLANEOUS"]) {
        return [self _MISCELLANEOUS];
    }

    return nil;
}

+ (SupplyType *)_DRINK {
    if (!supplytype_drink) {
        supplytype_drink = [[super alloc] initWithString:@"DRINK"];
    }
    return supplytype_drink;
}

+ (SupplyType *)_ALCOHOLIC_DRINK {
    if (!supplytype_alcoholic_drink) {
        supplytype_alcoholic_drink = [[super alloc] initWithString:@"ALCOHOLIC_DRINK"];
    }
    return supplytype_alcoholic_drink;
}

+ (SupplyType *)_FOOD {
    if (!supplytype_food) {
        supplytype_food = [[super alloc] initWithString:@"FOOD"];
    }
    return supplytype_food;
}

+ (SupplyType *)_UTENSILE {
    if (!supplytype_utensile) {
        supplytype_utensile = [[super alloc] initWithString:@"UTENSILE"];
    }
    return supplytype_utensile;
}

+ (SupplyType *)_SNACK {
    if (!supplytype_snack) {
        supplytype_snack = [[super alloc] initWithString:@"SNACK"];
    }
    return supplytype_snack;
}

+ (SupplyType *)_APPLIANCE {
    if (!supplytype_appliance) {
        supplytype_appliance = [[super alloc] initWithString:@"APPLIANCE"];
    }
    return supplytype_appliance;
}

+ (SupplyType *)_FURNITURE {
    if (!supplytype_furniture) {
        supplytype_furniture = [[super alloc] initWithString:@"FURNITURE"];
    }
    return supplytype_furniture;
}

+ (SupplyType *)_GAME {
    if (!supplytype_game) {
        supplytype_game = [[super alloc] initWithString:@"GAME"];
    }
    return supplytype_game;
}

+ (SupplyType *)_MISCELLANEOUS {
    if (!supplytype_miscellaneous) {
        supplytype_miscellaneous = [[super alloc] initWithString:@"MISCELLANEOUS"];
    }
    return supplytype_miscellaneous;
}
@end
