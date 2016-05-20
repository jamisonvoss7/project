//
//  FireBaseServiceProvider.h
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FireBaseServiceProvider : NSObject

// Post
- (void)setData:(id)data forPath:(NSString *)path withCompletion:(void (^)(NSError *error, Firebase *ref))handler;

// Put
- (void)updateData:(id)data forPath:(NSString *)path withCompletion:(void (^)(NSError *error, Firebase *ref))handler;

// Get
- (void)observeDateAtPath:(NSString *)paht withCompletion:(void (^)(FDataSnapshot *data))handler;

@end
