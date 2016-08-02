//
//  Batch.h
//
//  Copyright (c) 2013 Sporting Innovations LLC. All rights reserved.
//

@interface Batch : NSObject

+ (Batch *)create:(void(^)(Batch *batch))blocks, ... NS_REQUIRES_NIL_TERMINATION;
+ (Batch *)create;

- (void)complete:(NSError *)error;
- (void)addBatchBlock:(void(^)(Batch *batch))block;
- (void)addBatchBlocks:(NSArray *)blocks;
- (void)executeWithComplete:(void(^)(NSError *error))handler;

@end
