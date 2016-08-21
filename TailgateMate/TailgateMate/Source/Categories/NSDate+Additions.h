//
//  NSDate+Additions.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/12/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

+ (NSString *)formattedStringFromDate:(NSDate *)date;
+ (NSDate *)dateFromFormattedString:(NSString *)dateString;

+ (NSCalendar *)sharedCalendar;
+ (NSDate *)firstDayOfCurrentMonth;
+ (NSDate *)dateWithComponents:(NSDateComponents *)components;
+ (NSUInteger)currentDayOfMonth;
+ (NSString *)UTCStringFromDate:(NSDate *)date encodeZOffset:(BOOL)encode;
+ (NSDate *)dateFromUTCString:(NSString *)dateString;
+ (NSDate *)dateWithNoTimeZone:(NSString *)dateString;

- (NSDateComponents *)monthDayYearComponents;
- (NSDateComponents *)componentsWithFlags:(NSCalendarUnit)flags;
- (NSInteger)yearsFromDate;
- (NSDate *)addMonths:(int)months;
- (BOOL)isCurrentDayOfMonth;
- (BOOL)isMonthInPast;
- (BOOL)isDateInPast;
- (BOOL)isDateTimeInPast;
- (NSUInteger)numberOfDaysInMonth;
- (BOOL)isToday;
- (BOOL)isFutureDate;
- (BOOL)withinThreeDays;
- (BOOL)isInMonth:(NSDate *)date;

- (BOOL)withinThirtyDays;
- (BOOL)within24hours;
- (NSInteger)numberOfYearsAgo;
- (BOOL) withinOneMinute;
- (BOOL) withinOneHour;
- (BOOL)isCurrentYear;
- (BOOL)isSameDayAsDate:(NSDate*)date;
- (NSInteger)minutesAgo;

@end
