//
//  AddTailgateMapView.m
//  TailgateMate
//
//  Created by Jamison Voss on 4/13/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AddTailgateMapView.h"
#import "PinProvider.h"

@interface AddTailgateMapView ()
@property (nonatomic) CLLocation *initialLocationToUse;
@end

@implementation AddTailgateMapView

+ (instancetype)instanceFromDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"AddTailgateMapView" bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mapview.delegate = self;
    
    self.pinView.image = [UIImage imageNamed:@"RedFullPin"];
    
    // If the user turned off location services, don't ask.
    if ([LocationManager isLocationServicesEnabled]
        && [LocationManager isLocationServicesAuthorized]){
        
        [[AppManager sharedInstance].locationManager updateLocationWithComplete:^(CLLocation *location) {
            self.initialLocationToUse = location;
        }];
    } else {
        self.initialLocationToUse = [self checkForBackUpLocation];
    }
}

- (void)setInitialLocationToUse:(CLLocation *)initialLocationToUse {
    _initialLocationToUse = initialLocationToUse;
    [self.mapview setCenterCoordinate:initialLocationToUse.coordinate];
}

- (CLLocation *)checkForBackUpLocation {
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:42.014382613289001 longitude:-93.635700716097716];
    return loc;
}


@end
