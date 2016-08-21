//
//  FirebaseObject.h
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FirebaseObject : NSObject

@property (nonatomic, copy) NSString *uid;

+ (instancetype)instanceFromDate:(FIRDataSnapshot *)data;
+ (instancetype)instacneFromDictionary:(NSDictionary *)dictionary;
+ (NSArray *)arrayFromData:(FIRDataSnapshot *)data;
+ (NSArray *)arrayFromArray:(NSArray *)arrayData;
+ (NSDictionary *)dictionaryFromArray:(NSArray *)array;

- (NSDictionary *)dictionaryRepresentation;

+ (NSString *)dateToDateString:(NSDate *)date;
+ (NSDate *)dateFromDateString:(NSString *)dateString;

@end
