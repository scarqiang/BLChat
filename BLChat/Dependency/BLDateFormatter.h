//
//  BLDateFormatter.h
//  beiliao
//
//  Created by beiliao on 16/3/28.
//  Copyright © 2016年 ibeiliao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLDateFormatter : NSObject
NS_ASSUME_NONNULL_BEGIN
+ (BLDateFormatter *)sharedInstance;
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

- (NSString *)formatTime:(NSTimeInterval)time;

- (NSString *)formatTimeWith:(NSTimeInterval)time format:(NSString *)format;
/**
 * 用于聊天的格式化时间
 * @param time
 * @return
 */
- (nullable NSString *)formattedChatTime:(NSTimeInterval)time;

- (BOOL)isDateComponents:(NSDateComponents *)dateComponents1 inSameDayWithDateComponets:(NSDateComponents *)dateComponents2;

/**
 *  计算两个日期相差的日历天数，非简单的间隔天数
 *
 *  @param fromDateTime 较早的日期
 *  @param toDateTime   较晚的日期
 *
 *  @return 相差的天数
 */
- (NSInteger)daysBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime;

/**
 *  从日期字符串获取日期
 *
 *  @param dateString 日期字符串
 *  @param format     日期格式
 *
 *  @return 日期，当解析错误时为nil
 */
- (nullable NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format;

- (BOOL)isDateComponents:(NSDateComponents *)dateComponents1 inSameDayWithDateComponets:(NSDateComponents *)dateComponents2;

NS_ASSUME_NONNULL_END
@end
