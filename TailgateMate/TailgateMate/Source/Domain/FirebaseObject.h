//
//  FirebaseObject.h
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FirebaseObject : NSObject

@property (nonatomic, copy) NSString *uid;

+ (instancetype)instanceFromDate:(FDataSnapshot *)data;
+ (instancetype)instacneFromDictionary:(NSDictionary *)dictionary;
+ (NSArray *)arrayFromData:(FDataSnapshot *)data;
+ (NSDictionary *)dictionaryFromArray:(NSArray *)array;

- (NSDictionary *)dictionaryRepresentation;


@end
