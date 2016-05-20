//
//  AppManager.m
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AppManager.h"
#import "FireBaseServiceProvider.h"
#import "Thing.h"

@interface AppManager ()
@property (nonatomic, readwrite) AccountManager *accountManager;
@property (nonatomic, readwrite) LocationManager *locationManager;
@end

@implementation AppManager

+ (AppManager *)sharedInstance {
    static AppManager *appManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appManager = [[self alloc] init];
    });
    return appManager;
}

- (id)init {
    if (self = [super init]) {
        _firebaseRef = [[Firebase alloc] initWithUrl:@"https://tailgatemate.firebaseIO.com"];
    }
    return self;
}

- (void)initAppWIthComplete:(void (^)(BOOL, NSError *))handler {
    if (!self.accountManager) {
        self.accountManager = [[AccountManager alloc] init];
    }

    if (!self.locationManager) {
        self.locationManager = [[LocationManager alloc] init];
    }
    
    [self.accountManager loadCurrentAccuntWithComplete:handler];
}

- (LocationManager *)locationManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _locationManager = [[LocationManager alloc] init];
    });
    return _locationManager;
}


@end
