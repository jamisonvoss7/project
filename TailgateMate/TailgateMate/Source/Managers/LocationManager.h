//
//  LocationManager.h
//  TailgateMate
//
//  Created by Jamison Voss on 4/13/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

/**
 * LocationManager is a simple wrapper around CLLocationManager to
 * provide convenience methods, and additional business logic for Uphoria.
 *
 * By default, the LocationManager has a desired accuracy of hundred meters and
 * a 5 meters distance filter.
 */
@interface LocationManager : NSObject

@property (nonatomic, readonly) CLLocation *lastKnownLocation;

- (instancetype)initWithDesiredAccuracy:(CLLocationAccuracy)accuracy
                      andDistanceFilter:(CLLocationDistance)distance;

/**
 * Determines if the Location Services is enabled.
 */
+ (BOOL)isLocationServicesEnabled;

/**
 * Determines if the app is authorized by the user for accessing Location Services.
 */
+ (BOOL)isLocationServicesAuthorized;

/**
 * Determines if the app authorization status in not determined.
 */
+ (BOOL)isLocationServicesAuthorizationNotDetermined;

/**
 * Wrapper for [CLLocationManager authorizationStatus]
 */
+ (CLAuthorizationStatus)authorizationStatus;

/**
 * Determines if the given authorization status is authorized.
 */
+ (BOOL)isAuthorizationStatusAuthorized:(CLAuthorizationStatus)status;

/**
 * Requests the user to enable Location Services.
 */
- (void)requestEnableLocationServices;

/**
 * Requests the user for access to Location Services.
 */
- (void)requestAuthorization;

/**
 * Requests the user for access to Location Services and callback with the status.
 */
- (void)requestAuthorizationWithComplete:(void (^)(BOOL isAuthorized))handler;

/**
 * Add a delegate to the LocationManager. The CLLocationManagerDelegate
 * is used here because it simply forwards the messages from CLLocationManager.
 * Multiple delegates can be added so a single instance of LocationManager
 * can be shared. Remember to remove the delegate when no it's longer in use.
 */
- (void)addDelegate:(id<CLLocationManagerDelegate>)delegate;

/**
 * Remove the given delegate. When the last delegate is removed, the manager
 * will invoke stopUpdatingLocation to conserve the resources.
 */
- (void)removeDelegate:(id<CLLocationManagerDelegate>)delegate;

/**
 * Wrapper for [CLLocationManager startUpdatingLocation].
 * If there is no delegate added to the LocationManager prior to this call.
 * It simply ignores the request and return. Since an instance of the manager
 * can be shared, we want to conserve the resources when not in use.
 */
- (void)startUpdatingLocation;

/**
 * Wrapper for [CLLocationManager stopUpdatingLocation].
 */
- (void)stopUpdatingLocation;

/**
 * Determines if the location is fresh (timestamp is less than a minute)
 */
+ (BOOL)isLocationFresh:(CLLocation *)location;

/**
 * Updates for location.
 */
- (void)updateLocationWithComplete:(void (^)(CLLocation *location))handler;

@end

