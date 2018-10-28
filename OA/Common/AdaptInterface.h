//
//  AdaptInterface.h
//  PartimeJobInfo
//
//  Created by mac on 15/3/26.
//  Copyright (c) 2015年 ___HuiMing Xu___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "NSString+Extend.h"
#import "JSONKit.h"
#import "NSString+SHA.h"

@interface AdaptInterface : NSObject
{
    NSMutableData* returnData;
    NSURLConnection* urlCon;
    SEL finishSelector;
    SEL failSelector;
    id target;
}

#pragma mark 按比例缩放图片
+(UIImage *) imageWithImage:(UIImage*) image scaledToSize:(CGSize) newSize;

#pragma mark 颜色值转图片
+ (UIImage *)createImageWithColor:(UIColor *)color;

//判断手机号是否正确
+(BOOL)isTelephoneNumber:(NSString *)iphonenumber;

//判断邮箱格式是否正确
+(BOOL)isEmailAdress:(NSString *)string;
/**
 * @brief 判断当前时间是否在fromHour和toHour之间。如，fromHour=9，toHour=15时，即为判断当前时间是否在9:00-15:00之间
 */
+ (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour;

/**
 * @brief 计算某两个时间差（得出秒数）
 */
+ (long)numberOfDaysFromTodayByTime:(NSString *)time;

#pragma mark 根据字符串得到日期
+(NSDate *)getDateByDateString:(NSString *)dateString;

/**
 * @brief 计算某两个时间差（得出秒数）
 */
+ (long)numberOfSecondToTime:(NSString *)time2 FromTime:(NSString *)time1;

//5到20位字母加数字加下划线（用户名）
+(BOOL)isMatchUserName:(NSString *)letterNumber;

//6到18位字母加数字下划线（用户名或密码）
+(BOOL)isMatchUserNameOrPassword:(NSString *)letterNumber;

//是否是非法字符（用户名或昵称）
+(BOOL)isIllegalCharacter:(NSString *)string;
//是否含汉字
+(BOOL)isPassWord:(NSString *)password;
//银行卡号校验
+(BOOL)isValidCardNumber:(NSString *)cardNumber;

#pragma mark 身份证号校验

+(BOOL)checkNumCard:(NSString *)numCard;
+ (BOOL)validateIDCardNumber:(NSString *)value;

//验证输入的是否是数字
+(BOOL)validateNumber:(NSString*)number;

//只能输入字母或数字
+ (BOOL) validateNumCard:(NSString *)numCard;

#pragma mark 获取UUID
+(NSString*) getUUID;

#pragma mark 整形
+ (BOOL)isPureInt:(NSString*)string;

#pragma mark 浮点型：
+ (BOOL)isPureFloat:(NSString*)string;

#pragma mark 根据时间戳转换日期
+(NSString *)getDataByTimeStamp:(NSString *)timestamp withFormatter:(NSString *)formatter;

#pragma mark 判断闰年或者平年
+(int)getDayByYear;

// 提示框
+(void)tipMessageTitle:(NSString *)title view:(UIView *)view;

//判断网络是否连接
+(BOOL)isConnected;

//得到用户id
+ (NSString *)getUserId;

#pragma mark 判断是否有借款权限
+(BOOL)hasLoanPermission;

//URLDEcode
+(NSString *)decodeString:(NSString*)encodedString;

#pragma mark MD5（32位）加密
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString;

#pragma mark MD5（16位）加密
+ (NSString *)md5:(NSString *)str;

#pragma mark 颜色转换
+ (UIColor *) colorWithHexString1: (NSString *)color;

#pragma mark - 获取控件在设备上的绝对frame
+(CGRect)convertFrameWithOriginX:(CGFloat)x andOriginY:(CGFloat)y andWidth:(CGFloat)width andHeight:(CGFloat)height;

#pragma mark - 获取某个长度在不同设备上的绝对长度
+(CGFloat)convertWidthWithWidth:(CGFloat)width;

#pragma mark - 获取某个长度在不同设备上的绝对长度
+(CGFloat)convertHeightWithHeight:(CGFloat)height;

//格式话小数 四舍五入类型
+ (NSString *)decimalwithFormat:(NSString *)format floatV:(float)floatV;

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;

/*是否是iPhone4*/
+ (BOOL)is_iPhone_4;
//是否是中文(可加 .和中文·)
+(BOOL)isChinese:(NSString *)string;
//金额处理
+ (NSString *)getMoney:(float)money;

@end
