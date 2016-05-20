//
//  LocationManager.m
//  TailgateMate
//
//  Created by Jamison Voss on 4/13/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager () <CLLocationManagerDelegate>

@property (nonatomic, readwrite) CLLocation *lastKnownLocation;
@property (nonatomic) CLLocationManager *clLocationManager;
@property (nonatomic) NSMutableArray *delegates;
@property (nonatomic) NSMutableArray *updateLocationBlockHandlers;
@property (nonatomic) NSMutableArray *requestAuthorizationBlockHandlers;
@property (nonatomic) dispatch_queue_t dispatchQueue;
@property (nonatomic) BOOL requestingForAuthorization;
@property (nonatomic) BOOL waitingForAuthorizationConfirmation;
@property (nonatomic) BOOL waitingForUpdatingLocation;

@end

// --------------------------------------------------------------------------------
#pragma mark -
#pragma mark Class Definition
// --------------------------------------------------------------------------------

@implementation LocationManager

// --------------------------------------------------------------------------------
#pragma mark -
#pragma mark Instance Methods
// --------------------------------------------------------------------------------

- (instancetype)init {
    return [self initWithDesiredAccuracy:kCLLocationAccuracyBest andDistanceFilter:5];
}

- (instancetype)initWithDesiredAccuracy:(CLLocationAccuracy)accuracy
                      andDistanceFilter:(CLLocationDistance)distance {
    self = [super init];
    if (self) {
        _clLocationManager = [[CLLocationManager alloc] init];
        _clLocationManager.delegate = self;
        _clLocationManager.desiredAccuracy = accuracy;
        _clLocationManager.distanceFilter = distance;
        _delegates = [NSMutableArray array];
        _updateLocationBlockHandlers = [NSMutableArray array];
        _requestAuthorizationBlockHandlers = [NSMutableArray array];
        _requestingForAuthorization = NO;
        _waitingForAuthorizationConfirmation = NO;
        _waitingForUpdatingLocation = NO;
        _lastKnownLocation = _clLocationManager.location;
        _dispatchQueue = dispatch_queue_create("com.sportinginnovations.LocationManager", nil);
    }
    return self;
}

+ (BOOL)isLocationServicesEnabled {
    return [CLLocationManager locationServicesEnabled];
}

+ (BOOL)isLocationServicesAuthorized {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return [LocationManager isAuthorizationStatusAuthorized:status];
}

+ (BOOL)isLocationServicesAuthorizationNotDetermined {
    return ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined);
}

+ (CLAuthorizationStatus)authorizationStatus {
    return [CLLocationManager authorizationStatus];
}

+ (BOOL)isAuthorizationStatusAuthorized:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways
        || status == kCLAuthorizationStatusAuthorizedWhenInUse
        ) {
        return YES;
    }
    return NO;
}

- (void)requestEnableLocationServices {
    // Start requesting update location and this will
    // show the Settings dialog option.
    [self.clLocationManager startUpdatingLocation];
}

- (void)requestAuthorization {
    self.requestingForAuthorization = YES;
    [self.clLocationManager requestWhenInUseAuthorization];
}

- (void)requestAuthorizationWithComplete:(void (^)(BOOL isAuthorized))handler {
    __weak LocationManager *this = self;
    dispatch_async(self.dispatchQueue, ^{
        if (![this.requestAuthorizationBlockHandlers containsObject:handler]) {
            [this.requestAuthorizationBlockHandlers addObject:handler];
        }
        if (!this.requestingForAuthorization) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [this requestAuthorization];
            });
        }
    });
}

- (void)addDelegate:(id<CLLocationManagerDelegate>)delegate {
    __weak LocationManager *this = self;
    dispatch_sync(self.dispatchQueue, ^{
        if (![this.delegates containsObject:delegate]) {
            [this.delegates addObject:delegate];
        }
    });
}

- (void)removeDelegate:(id<CLLocationManagerDelegate>)delegate {
    __weak LocationManager *this = self;
    dispatch_sync(self.dispatchQueue, ^{
        if ([this.delegates containsObject:delegate]) {
            [this.delegates removeObject:delegate];
        }
        if (this.delegates.count == 0) {
            [this stopUpdatingLocation];
        }
    });
}

- (void)startUpdatingLocation {
    [self.clLocationManager startUpdatingLocation];
    
    // Depends on the location services settings, sometime the didUpdateLocation
    // never called. We check for this status after 3 seconds, and if it's still
    // not updated yet, we would use the last known location if it's fresh.
    __weak LocationManager *this = self;
    dispatch_async(self.dispatchQueue, ^{
        if (this.waitingForAuthorizationConfirmation) {
            return;
        }
        this.waitingForUpdatingLocation = YES;
        
        int64_t delay = 3.0; // in seconds
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
        dispatch_after(time, self.dispatchQueue, ^(void){
            if (this.waitingForUpdatingLocation) {
                this.waitingForUpdatingLocation = NO;
                
                CLLocation *location = nil;
                if ([LocationManager isLocationFresh:this.lastKnownLocation]) {
                    location = this.lastKnownLocation;
                }
                [this invokeUpdateLocationBlockHandlersForLocation:location];
            }
        });
    });
}

- (void)stopUpdatingLocation {
    [self.clLocationManager stopUpdatingLocation];
}

+ (BOOL)isLocationFresh:(CLLocation *)location {
    if (!location.timestamp) {
        return NO;
    }
    return ([[NSDate date] timeIntervalSinceDate:location.timestamp] < 60);
}

- (void)updateLocationWithComplete:(void(^)(CLLocation *location))handler {
    // The last known location is fresh, so use it.
    if ([LocationManager isLocationFresh:self.lastKnownLocation]) {
        handler(self.lastKnownLocation);
        return;
    }
    __weak LocationManager *this = self;
    dispatch_async(self.dispatchQueue, ^{
        if (![this.updateLocationBlockHandlers containsObject:handler]) {
            [this.updateLocationBlockHandlers addObject:handler];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [this startUpdatingLocation];
        });
    });
}

// --------------------------------------------------------------------------------
#pragma mark -
#pragma mark Location Manager Delegate Methods
// --------------------------------------------------------------------------------

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    self.lastKnownLocation = newLocation;
    
    __weak LocationManager *this = self;
    dispatch_async(self.dispatchQueue, ^{
        for (id<CLLocationManagerDelegate> delegate in this.delegates) {
            if ([delegate respondsToSelector:@selector(locationManager:didUpdateToLocation:fromLocation:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [delegate locationManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
                });
            }
        }
        this.waitingForUpdatingLocation = NO;
        [this invokeUpdateLocationBlockHandlersForLocation:newLocation];
    });
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    __weak LocationManager *this = self;
    dispatch_async(self.dispatchQueue, ^{
        for (id<CLLocationManagerDelegate> delegate in this.delegates) {
            if ([delegate respondsToSelector:@selector(locationManager:didChangeAuthorizationStatus:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [delegate locationManager:manager didChangeAuthorizationStatus:status];
                });
            }
        }
        
        if (this.requestAuthorizationBlockHandlers.count > 0) {
            if (this.requestingForAuthorization && !this.waitingForAuthorizationConfirmation) {
                this.waitingForAuthorizationConfirmation = YES;
            } else if (this.requestingForAuthorization && this.waitingForAuthorizationConfirmation) {
                this.requestingForAuthorization = NO;
                this.waitingForAuthorizationConfirmation = NO;
                
                for (void(^requestAuthorizationHandler)(BOOL authorized) in this.requestAuthorizationBlockHandlers) {
                    BOOL isAuthorized = [LocationManager isAuthorizationStatusAuthorized:status];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        requestAuthorizationHandler(isAuthorized);
                    });
                }
                dispatch_async(this.dispatchQueue, ^{
                    [this.requestAuthorizationBlockHandlers removeAllObjects];
                });
            }
        }
    });
}

// --------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods
// --------------------------------------------------------------------------------

- (void)invokeUpdateLocationBlockHandlersForLocation:(CLLocation *)location {
    if (self.updateLocationBlockHandlers.count > 0) {
        for (void(^updateLocationHandler)(CLLocation *location) in self.updateLocationBlockHandlers) {
            dispatch_async(dispatch_get_main_queue(), ^{
                updateLocationHandler(location);
            });
        }
        dispatch_async(self.dispatchQueue, ^{
            [self.updateLocationBlockHandlers removeAllObjects];
        });
        if (self.delegates.count == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopUpdatingLocation];
            });
        }
    }
}

@end
