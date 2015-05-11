//
//  NSDate+LCW.m
//  MyHospital
//
//  Created by XYQS on 15/3/31.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "NSDate+LCW.h"

@implementation NSDate (LCW)

/**
 *  是否为今天
 */
- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

/**
 *  是否为昨天
 */
- (BOOL)isYesterday
{
    // 2014-05-01
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    
    // 2014-04-30
    NSDate *selfDate = [self dateWithYMD];
    
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

/**
 *  是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year;
}

- (NSDateComponents *)deltaWithNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}

//获得日期的周几
//+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate
//{
//    
//    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
//    [calendar setTimeZone: timeZone];
//    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
//    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
//    return [weekdays objectAtIndex:theComponents.weekday];
//}

//-(NSString *)getDate:(NSDate *)date
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *string1 = [formatter stringFromDate:date];
//    NSArray *strArr1 = [string1 componentsSeparatedByString:@" "];
//    NSString *string2 = [strArr1 firstObject];
//    return string2;
//}
//
//-(NSString *)getMonAndDay:(NSString *)str
//{
//    NSArray *strArr = [str componentsSeparatedByString:@"-"];
//    NSString *str1 = [strArr[1] stringByAppendingString:@"月"];
//    str1 = [str1 stringByAppendingString:strArr[2]];
//    str1 = [str1 stringByAppendingString:@"日"];
//    return str1;
//}


@end
