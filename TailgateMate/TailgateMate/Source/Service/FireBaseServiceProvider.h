//
//  FireBaseServiceProvider.h
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FireBaseServiceProvider : NSObject

// Post
- (void)setData:(id)data forPath:(NSString *)path withCompletion:(void (^)(NSError *error, FIRDatabaseReference *ref))handler;
- (void)setArrayData:(id)data forPath:(NSString *)path withCompletion:(void (^)(NSError *error, FIRDatabaseReference *ref))handler;

// Put
- (void)updateData:(id)data forPath:(NSString *)path withCompletion:(void (^)(NSError *error, FIRDatabaseReference *ref))handler;
- (void)updateArrayData:(id)data forPath:(NSString *)path withCompletion:(void (^)(NSError *error, FIRDatabaseReference *ref))handler;

// Get
- (void)observeDataAtPath:(NSString *)path withCompletion:(void (^)(FIRDataSnapshot *data))handler;

// Get with params
- (void)observeDataAtPath:(NSString *)path
                andParams:(NSDictionary *)dict
           withCompletion:(void (^)(FIRDataSnapshot *data))handler;
@end
