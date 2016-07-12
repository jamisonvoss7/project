//
//  FireBaseServiceProvider.m
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FireBaseServiceProvider.h"
#import "Account.h"

@implementation FireBaseServiceProvider

- (void)setData:(id)data forPath:(NSString *)path withCompletion:(void (^)(NSError *error, FIRDatabaseReference *ref))handler {
    FIRDatabaseReference *baseRef = [AppManager sharedInstance].firedatabasebaseRef;
    
    baseRef = [baseRef child:path];
    [baseRef setValue:[data dictionaryRepresentation] withCompletionBlock:handler];
}

- (void)updateData:(id)data forPath:(NSString *)path withCompletion:(void (^)(NSError *error, FIRDatabaseReference *ref))handler {
    FIRDatabaseReference *baseRef = [AppManager sharedInstance].firedatabasebaseRef;
    
    baseRef = [baseRef child:path];
    [baseRef updateChildValues:[data dictionaryRepresentation] withCompletionBlock:handler];
}

- (void)observeDateAtPath:(NSString *)path withCompletion:(void (^)(FIRDataSnapshot *))handler {
    FIRDatabaseReference *baseRef = [AppManager sharedInstance].firedatabasebaseRef;
    
    baseRef = [baseRef child:path];
    [baseRef observeSingleEventOfType:FIRDataEventTypeValue
                            withBlock:handler];
}
@end
