//
//  AppManager.m
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AppManager.h"
#import "FireBaseServiceProvider.h"
#import "Thing.h"

@interface AppManager ()
@property (nonatomic, readwrite) FIRDatabaseReference *firedatabasebaseRef;
@property (nonatomic, readwrite) FIRStorageReference *firebaseStorageRef;
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
        self.firedatabasebaseRef = [[FIRDatabase database] reference];
        self.firebaseStorageRef = [[FIRStorage storage] referenceForURL:@"gs://firebase-tailgatemate.appspot.com"];
    }
    return self;
}

- (void)initAppWIthComplete:(void (^)(BOOL, NSError *))handler {
   [self.accountManager loadCurrentAccuntWithComplete:handler];
}

- (AccountManager *)accountManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _accountManager = [[AccountManager alloc] init];
    });
    return _accountManager;
}

- (LocationManager *)locationManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _locationManager = [[LocationManager alloc] init];
    });
    return _locationManager;
}

@end
