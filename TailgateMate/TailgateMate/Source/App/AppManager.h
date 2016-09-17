//
//  AppManager.h
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FireBaseServiceProvider.h"
#import "AccountManager.h"
#import "LocationManager.h"
#import "AppStoreVersion.h"

@interface AppManager : NSObject

@property (nonatomic, readonly) FIRDatabaseReference *firedatabasebaseRef;
@property (nonatomic, readonly) FIRStorageReference *firebaseStorageRef;
@property (nonatomic, readonly) AccountManager *accountManager;
@property (nonatomic, readonly) LocationManager *locationManager;
@property (nonatomic, readonly) AppStoreVersion *appStoreVersion;

+ (AppManager *)sharedInstance;
- (void)initAppWIthComplete:(void (^)(BOOL success, NSError *error))handler;

@end
