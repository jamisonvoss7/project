//
//  NSDate+Additions.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/12/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "NSDate+Additions.h"

static NSDateFormatter *formatter = nil;
static NSCalendar *calendar = nil;
static NSInteger ThreeDays = 259200;
static NSInteger OneDay = 86400;

NSString *const UTCFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZ";
NSString *const NOTimeZoneFormat = @"yyyy-MM-dd'T'HH:mm:ss";

NSString * const DateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZ";

@implementation NSDate (Additions)

+ (NSString *)formattedStringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:DateFormat];
    return [formatter stringFromDate:date];
}

+ (NSDate *)dateFromFormattedString:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:DateFormat];
    return [formatter dateFromString:dateString];
}

+ (NSCalendar *)sharedCalendar {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [NSCalendar currentCalendar];
    });
    return calendar;
}

+ (NSDateFormatter *)formatter {
    if ([NSThread currentThread] != [NSThread mainThread]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"Can only use this category on the main thread. (NSDateFormatter is not thread safe."]
                                     userInfo:nil];
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    return formatter;
}

+ (NSUInteger)currentDayOfMonth {
    NSDateComponents *components = [[NSDate date] componentsWithFlags:NSCalendarUnitDay];
    return [components day];
}

+ (NSDate *)firstDayOfCurrentMonth {
    NSDateComponents *components = [[NSDate date] componentsWithFlags:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear];
    [components setDay:1];
    return [[NSDate sharedCalendar] dateFromComponents:components];
}

+ (NSDate *)dateWithComponents:(NSDateComponents *)components {
    return [[NSDate sharedCalendar] dateFromComponents:components];
}

+ (NSString *)UTCStringFromDate:(NSDate *)date encodeZOffset:(BOOL)encode;{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:UTCFormat];
    
    NSString *utcString = [formatter stringFromDate:date];
    if (encode) {
        utcString = [utcString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    }
    return utcString;
}

+ (NSDate *)dateFromUTCString:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:UTCFormat];
    return [formatter dateFromString:dateString];
}

+ (NSDate *)dateWithNoTimeZone:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:UTCFormat];
    NSDate *date = [formatter dateFromString:dateString];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter1 setDateFormat:@"MM/dd/yyyy"];
    
    NSString *string = [formatter1 stringFromDate:date];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"MM/dd/yyyy"];
    NSDate *returnDate = [formatter2 dateFromString:string];
    return returnDate;
}

// --------------------------------------------------------------------------------
#pragma mark -
#pragma mark Instance Methods
// --------------------------------------------------------------------------------
- (NSInteger)yearsFromDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:self];
    
    if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
        (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day]))) {
        return [dateComponentsNow year] - [dateComponentsBirth year] - 1;
    }
    return [dateComponentsNow year] - [dateComponentsBirth year];
}

- (NSUInteger)numberOfDaysInMonth {
    NSRange range = [[NSDate sharedCalendar] rangeOfUnit:NSCalendarUnitDay
                                                  inUnit:NSCalendarUnitMonth
                                                 forDate:self];
    return range.length;
}

- (BOOL)isCurrentDayOfMonth {
    NSDateComponents *components = [[NSDate date] componentsWithFlags:NSCalendarUnitDay
                                    | NSCalendarUnitMonth
                                    | NSCalendarUnitYear];
    
    NSDateComponents *currentComponents = [self componentsWithFlags:NSCalendarUnitDay
                                           | NSCalendarUnitMonth
                                           | NSCalendarUnitYear];
    
    if (components.day == currentComponents.day
        && components.month == currentComponents.month
        && components.year == currentComponents.year) {
        return YES;
    }
    return NO;
}

- (NSDate *)addMonths:(int)months {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [[NSDate sharedCalendar] dateByAddingComponents:components toDate:self options:0];
}

- (NSDateComponents *)monthDayYearComponents {
    return [self componentsWithFlags:NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay
            | NSCalendarUnitWeekday];
}

- (NSDateComponents *)componentsWithFlags:(NSCalendarUnit)flags {
    return [[NSDate sharedCalendar] components:flags fromDate:self];
}

- (BOOL)isMonthInPast {
    NSDateComponents *currentComponents =
    [[NSDate date] componentsWithFlags:NSCalendarUnitYear | NSCalendarUnitMonth];
    NSDateComponents *components = [self componentsWithFlags:NSCalendarUnitYear | NSCalendarUnitMonth];
    if (components.year <= currentComponents.year && components.month < currentComponents.month) {
        return YES;
    }
    return NO;
}

- (BOOL)isDateInPast {
    NSDateComponents *currentComponents = [[NSDate date] componentsWithFlags:NSCalendarUnitYear
                                           | NSCalendarUnitMonth
                                           | NSCalendarUnitDay
                                           | NSCalendarUnitHour];
    
    NSDateComponents *components = [self componentsWithFlags:NSCalendarUnitYear
                                    | NSCalendarUnitMonth
                                    | NSCalendarUnitDay
                                    | NSCalendarUnitHour];
    if (components.year > currentComponents.year) {
        return NO;
    }
    if (components.year < currentComponents.year) {
        return YES;
    }
    if (components.month < currentComponents.month) {
        return YES;
    }
    if (components.day < currentComponents.day && components.month == currentComponents.month) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isDateTimeInPast {
    NSDate *currentDate = [NSDate date];
    if ([self compare:currentDate] == NSOrderedDescending) {
        // self is later than currentDate
        return NO;
    } else if ([self compare:currentDate] == NSOrderedAscending) {
        // self is earlier than currentDate
        return YES;
    } else {
        // dates are the same
        return NO;
    }
}

- (BOOL)isToday {
    NSDateComponents *currentComponents = [[NSDate date] componentsWithFlags:NSCalendarUnitYear
                                           | NSCalendarUnitMonth
                                           | NSCalendarUnitDay];
    
    NSDateComponents *components = [self componentsWithFlags:NSCalendarUnitYear
                                    | NSCalendarUnitMonth
                                    | NSCalendarUnitDay];
    
    if (currentComponents.year == components.year) {
        if (currentComponents.month == components.month) {
            if (currentComponents.day == components.day) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)isFutureDate {
    if ([self timeIntervalSince1970] > [[NSDate date] timeIntervalSince1970]) {
        return YES;
    }
    return NO;
}

- (BOOL)withinThreeDays {
    if ([self timeIntervalSinceNow] < ThreeDays) {
        return YES;
    }
    return NO;
}

- (BOOL)isInMonth:(NSDate *)date  {
    NSDateComponents *selfComponents = [self componentsWithFlags:NSCalendarUnitMonth];
    NSDateComponents *dateComponents = [date componentsWithFlags:NSCalendarUnitMonth];
    return (selfComponents.month == dateComponents.month);
}

- (BOOL)withinThirtyDays {
    if ([[NSDate date] timeIntervalSinceDate:self] <= OneDay * 30.0f) {
        return YES;
    }
    return NO;
}

- (BOOL)within24hours {
    if ([[NSDate date] timeIntervalSinceDate:self] <= OneDay) {
        return YES;
    }
    return NO;
}

- (NSInteger )numberOfYearsAgo {
    NSInteger seconds = [self timeIntervalSinceNow];
    if (seconds > OneDay * 365) {
        NSInteger years = seconds / OneDay *365;
        
        NSDateComponents *selfComponents = [self componentsWithFlags:NSCalendarUnitMonth];
        NSDateComponents *dateComponents = [[NSDate date] componentsWithFlags:NSCalendarUnitMonth];
        
        if (selfComponents.day > dateComponents.day) {
            return years - 1;
        } else {
            return years;
        }
    } else {
        return 0;
    }
}

- (BOOL)withinOneMinute {
    if ([[NSDate date] timeIntervalSinceDate:self] <= 60) {
        return YES;
    }
    return NO;
}

- (BOOL)withinOneHour {
    if ([[NSDate date] timeIntervalSinceDate:self] <= 3600) {
        return YES;
    }
    return NO;
}

- (BOOL)isCurrentYear {
    NSDateComponents *components = [[NSDate date] componentsWithFlags:NSCalendarUnitDay
                                    | NSCalendarUnitMonth
                                    | NSCalendarUnitYear];
    
    NSDateComponents *currentComponents = [self componentsWithFlags:NSCalendarUnitDay
                                           | NSCalendarUnitMonth
                                           | NSCalendarUnitYear];
    
    if (components.year == currentComponents.year) {
        return YES;
    }
    return NO;
}

- (BOOL)isSameDayAsDate:(NSDate*)otherDate {
    NSDateComponents* dateComps = [[NSDate sharedCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    NSDateComponents* otherComps = [[NSDate sharedCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:otherDate];
    return dateComps.year == otherComps.year && dateComps.month == otherComps.month && dateComps.day == otherComps.day;
}

- (NSInteger)minutesAgo {
    NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:self];
    return seconds / 60;
}
@end
