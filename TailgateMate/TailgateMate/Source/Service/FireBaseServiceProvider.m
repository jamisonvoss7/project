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

- (void)setArrayData:(id)data
             forPath:(NSString *)path
      withCompletion:(void (^)(NSError *, FIRDatabaseReference *))handler {
    FIRDatabaseReference *baseRef = [AppManager sharedInstance].firedatabasebaseRef;
    
    baseRef = [baseRef child:path];
    [baseRef setValue:data withCompletionBlock:handler];
}

- (void)updateData:(id)data forPath:(NSString *)path withCompletion:(void (^)(NSError *error, FIRDatabaseReference *ref))handler {
    FIRDatabaseReference *baseRef = [AppManager sharedInstance].firedatabasebaseRef;
    
    baseRef = [baseRef child:path];
    [baseRef updateChildValues:[data dictionaryRepresentation] withCompletionBlock:handler];
}

- (void)updateArrayData:(id)data forPath:(NSString *)path withCompletion:(void (^)(NSError *, FIRDatabaseReference *))handler {
    FIRDatabaseReference *baseRef = [AppManager sharedInstance].firedatabasebaseRef;
    
    baseRef = [baseRef child:path];
    [baseRef updateChildValues:data withCompletionBlock:handler];
}

- (void)observeDataAtPath:(NSString *)path withCompletion:(void (^)(FIRDataSnapshot *))handler {
    FIRDatabaseReference *baseRef = [AppManager sharedInstance].firedatabasebaseRef;
    
    baseRef = [baseRef child:path];
    [baseRef observeSingleEventOfType:FIRDataEventTypeValue
                            withBlock:handler];
}

- (void)observeDataAtPath:(NSString *)path andParams:(NSDictionary *)dict withCompletion:(void (^)(FIRDataSnapshot *))handler {
    FIRDatabaseReference *baseRef = [AppManager sharedInstance].firedatabasebaseRef;
    
    baseRef = [baseRef child:path];
  
    NSString *value = [[dict allValues] firstObject];
    NSString *key = [[dict allKeys] firstObject];
    
    [[[baseRef queryOrderedByChild:key] queryEqualToValue:value] observeSingleEventOfType:FIRDataEventTypeValue
                                                                                withBlock:handler];
    
}
@end
