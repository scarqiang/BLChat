//
//  BLDateFormatter.m
//  beiliao
//
//  Created by beiliao on 16/3/28.
//  Copyright © 2016年 ibeiliao.com. All rights reserved.
//

#import "BLDateFormatter.h"

@interface BLDateFormatter ()

@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) NSCalendar *calendar;

@end

@implementation BLDateFormatter

+ (BLDateFormatter *)sharedInstance {
    static dispatch_once_t token;
    static BLDateFormatter *instance;
    dispatch_once(&token, ^{
        instance = [[BLDateFormatter alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-Hans"]];
        [_dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];

        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }

    return self;
}


- (NSString *)formatTimeWith:(NSTimeInterval)time format:(NSString *)format {
    self.dateFormatter.dateFormat = format;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    return [self.dateFormatter stringFromDate:date];
}

/**
 *  已回复的时间t， 显示时间的字符串s
 t< 5分钟， s=“刚刚”
 t< 60分钟，s=“分钟前”，例如“27分钟前”
 t< 1天，s=“hh:mm”，例如“17:21”
 t< 2天，s=“昨天 hh:mm” 例如“昨天 17:21”
 t< 3天，s=“前天 hh:mm” 例如“前天 17:21”
 t< 1年，s=“MM-dd HH:mm” 例如“01-28 17:45”
 t>=1年，s=“yyyy-MM-dd” 例如“2015-03-17”
 *
 *  @param date
 */

- (NSString *)formatTime:(NSTimeInterval)time {
    NSDate *targetDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    // timeInterval 发布时间跟现在的一个时间差，单位：秒
    NSTimeInterval  timeInterval = targetDate.timeIntervalSinceNow;
    timeInterval = -timeInterval;
    
    NSString *result;

    enum NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *targetDateComponents = [self.calendar components:unitFlags fromDate:targetDate];
    NSDateComponents *nowDateComponents = [self.calendar components:unitFlags fromDate:[NSDate date]];

    BOOL (^isToday)() = ^BOOL() {
        return [self isDateComponents:targetDateComponents inSameDayWithDateComponets:nowDateComponents];
    };

    BOOL (^isYesterday)() = ^BOOL () {
        NSDateComponents *diffComponent = [NSDateComponents new];
        diffComponent.day = -1;
        NSDate *yesterdayDate = [self.calendar dateByAddingComponents:diffComponent toDate:[NSDate date] options:0];
        NSDateComponents *yesterdayDateComponents = [self.calendar components:unitFlags fromDate:yesterdayDate];
        return [self isDateComponents:yesterdayDateComponents inSameDayWithDateComponets:targetDateComponents];
    };

    BOOL (^isDayBeforeYesterday)() = ^BOOL () {
        NSDateComponents *diffComponent = [NSDateComponents new];
        diffComponent.day = -2;
        NSDate *dayBeforeYesterdayDate = [self.calendar dateByAddingComponents:diffComponent toDate:[NSDate date] options:0];
        NSDateComponents *dayBeforeYesterdayDateComponents = [self.calendar components:unitFlags fromDate:dayBeforeYesterdayDate];
        return [self isDateComponents:dayBeforeYesterdayDateComponents inSameDayWithDateComponets:targetDateComponents];
    };

    if (targetDateComponents.year < nowDateComponents.year) { // 不是今年发的,要带上年份
        self.dateFormatter.dateFormat = @"yyyy-MM-dd";
        result = [self.dateFormatter stringFromDate:targetDate];
    }
    else if (isToday()) { // 今天

        if (timeInterval < 60 * 5) {
            result = [NSString stringWithFormat:@"刚刚"];
        }
        else if (timeInterval < 3600) {
            result = [NSString stringWithFormat:@"%i分钟前", (int)floor(timeInterval / 60)];
        }
        else {
            self.dateFormatter.dateFormat = @"HH:mm";
            result = [self.dateFormatter stringFromDate:targetDate];
        }
    }
    else if (isYesterday()) { // 昨天
        self.dateFormatter.dateFormat = @"HH:mm";
        result = [NSString stringWithFormat:@"昨天 %@", [self.dateFormatter stringFromDate:targetDate]];
    }
    else if (isDayBeforeYesterday()) { // 前天
        self.dateFormatter.dateFormat = @"HH:mm";
        result = [NSString stringWithFormat:@"前天 %@", [self.dateFormatter stringFromDate:targetDate]];
    }
    else {
        self.dateFormatter.dateFormat = @"MM-dd HH:mm";
        result = [self.dateFormatter stringFromDate:targetDate];
    }
    
    return  result;
}

/**
 * 返回聊天中的时间格式
 * @param time
 * @return 时间
 */
- (nullable NSString *)formattedChatTime:(NSTimeInterval)time {
    NSDate *targetDate = [NSDate dateWithTimeIntervalSince1970:time];
    if (!targetDate) {
        return nil;
    }
    NSDateFormatter *formatter = self.dateFormatter;
    [formatter setDateFormat:@"YYYYMMdd"];
    NSString *dateNow = [formatter stringFromDate:[NSDate date]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:[[dateNow substringWithRange:NSMakeRange(6,2)] intValue]];
    [components setMonth:[[dateNow substringWithRange:NSMakeRange(4,2)] intValue]];
    [components setYear:[[dateNow substringWithRange:NSMakeRange(0,4)] intValue]];

    //今天 0点时间
    NSDate *startDateOfToday = [self.calendar dateFromComponents:components];

    NSTimeInterval timeDiffInSecond = [targetDate timeIntervalSinceDate:startDateOfToday];
    NSInteger timeDiffInHour = (NSInteger) (timeDiffInSecond / (60 * 60));
    NSString *dateFormat = nil;
    NSString *result = nil;

    if (timeDiffInHour >= 0 && timeDiffInHour <= 6) {
        dateFormat = @"凌晨hh:mm";
    } else if (timeDiffInHour > 6 && timeDiffInHour <= 11 ) {
        dateFormat = @"上午hh:mm";
    } else if (timeDiffInHour > 11 && timeDiffInHour <= 17) {
        dateFormat = @"下午hh:mm";
    } else if (timeDiffInHour > 17 && timeDiffInHour <= 24) {
        dateFormat = @"晚上hh:mm";
    } else if (timeDiffInHour < 0 && timeDiffInHour >= -24){
        dateFormat = @"昨天HH:mm";
    } else {
        dateFormat = @"YYYY-MM-dd hh:mm";
    }

    result = [self formatTimeWith:time format:dateFormat];
    return result;
}

/**
 * 判断两个 NSDateComponents 是否在同一天
 * @param dateComponents1
 * @param dateComponents2
 * @return 判断结果
 */
- (BOOL)isDateComponents:(NSDateComponents *)dateComponents1 inSameDayWithDateComponets:(NSDateComponents *)dateComponents2 {
    return dateComponents1.year == dateComponents2.year &&
        dateComponents1.month == dateComponents2.month &&
        dateComponents1.day == dateComponents2.day;
}

- (NSInteger)daysBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime {
    if (!fromDateTime || !toDateTime) {
        return 0;
    }
    
    NSDate *fromDate;
    NSDate *toDate;

    [self.calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:nil forDate:fromDateTime];
    [self.calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:nil forDate:toDateTime];
    
    NSDateComponents *difference = [self.calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

- (nullable NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format {
    self.dateFormatter.dateFormat = format;
    return [self.dateFormatter dateFromString:dateString];
}
@end
