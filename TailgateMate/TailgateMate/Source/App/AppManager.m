//
//  AppManager.m
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AppManager.h"
#import "FireBaseServiceProvider.h"
#import "Thing.h"
#import "Batch.h"
#import "AppService.h"

@interface AppManager ()
@property (nonatomic, readwrite) FIRDatabaseReference *firedatabasebaseRef;
@property (nonatomic, readwrite) FIRStorageReference *firebaseStorageRef;
@property (nonatomic, readwrite) AccountManager *accountManager;
@property (nonatomic, readwrite) LocationManager *locationManager;
@property (nonatomic, readwrite) NSString *appStoreLink;
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
        self.firebaseStorageRef = [[FIRStorage storage] referenceForURL:@"gs://pregame-c4f13.appspot.com"];
    }
    return self;
}

- (void)initAppWIthComplete:(void (^)(BOOL, NSError *))handler {
    Batch *batch = [Batch create];
   
    [batch addBatchBlock:^(Batch *batch) {
        [self.accountManager loadCurrentAccuntWithComplete:^(BOOL success, NSError *error) {
            [batch complete:error];
        }];
    }];
    
    [batch addBatchBlock:^(Batch *batch) {
        AppService *service = [[AppService alloc] init];
        [service getAppStoreLineWithCompletion:^(NSString *link, NSError *error) {
            self.appStoreLink = link;
            [batch complete:error];
        }];
    }];
    
    [batch executeWithComplete:^(NSError *error) {
        handler(!error, error);
    }];
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
