//
//  Batch.m
//
//  Copyright (c) 2013 Sporting Innovations LLC. All rights reserved.
//

#import "Batch.h"

// --------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Properties
// --------------------------------------------------------------------------------

@interface Batch()

@property (nonatomic, copy) void(^completeBlock)(NSError *error);
@property (nonatomic) NSMutableArray *blocks;
@property (nonatomic) NSError *error;
@property (nonatomic, assign) NSUInteger completionCounter;
@property (nonatomic) dispatch_queue_t dispatchQueue;

@end

// --------------------------------------------------------------------------------
#pragma mark -
#pragma mark Class Definition
// --------------------------------------------------------------------------------

@implementation Batch

- (id)init {
    self = [super init];
    if (self) {
        self.blocks = [[NSMutableArray alloc] init];
        self.dispatchQueue = dispatch_queue_create("com.sportinginnovations.Batch", nil);
    }
    return self;
}

+ (Batch *)create:(void(^)(Batch *batch))blocks, ... {
	Batch *batch = [[Batch alloc] init];

	va_list args;
	va_start(args, blocks);

	for (void(^arg)(Batch *batch) = blocks; arg != nil; arg = va_arg(args, void(^)(Batch *batch))) {
		[batch addBatchBlock:arg];
    }

	va_end(args);
	return batch;
}

+ (Batch *)create {
	return [[Batch alloc] init];
}

- (void)complete:(NSError *)error {
    dispatch_sync(self.dispatchQueue, ^{
        if (!self.error) {
            self.error = error;
        }
        self.completionCounter++;
        if (self.completionCounter >= self.blocks.count) {
            if (self.completeBlock != nil) {
                self.completeBlock(self.error);
                self.completeBlock = nil;
            }
        }
    });
}

- (void)addBatchBlock:(void(^)(Batch *batch))block {
	[self.blocks addObject:block];
}

- (void)addBatchBlocks:(NSArray *)blocks {
    [self.blocks addObjectsFromArray:blocks];
}

- (void)executeWithComplete:(void(^)(NSError *error))handler {
	if (self.blocks.count == 0) {
		handler(nil);
		return;
	}
    self.completionCounter = 0;
    self.error = nil;

	self.completeBlock = handler;
	[self.blocks enumerateObjectsUsingBlock:^(void(^block)(Batch *batch), NSUInteger idx, BOOL *stop) {
		block(self);
	}];
}

@end
