//
//  FireBaseServiceProvider.h
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FireBaseServiceProvider : NSObject

// Post
- (void)setData:(id)data forPath:(NSString *)path withCompletion:(void (^)(NSError *error, FIRDatabaseReference *ref))handler;

// Put
- (void)updateData:(id)data forPath:(NSString *)path withCompletion:(void (^)(NSError *error, FIRDatabaseReference *ref))handler;

// Get
- (void)observeDateAtPath:(NSString *)path withCompletion:(void (^)(FIRDataSnapshot *data))handler;

@end
