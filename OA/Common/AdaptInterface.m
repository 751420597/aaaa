//
//  AdaptInterface.m
//  PartimeJobInfo
//
//  Created by mac on 15/3/26.
//  Copyright (c) 2015年 ___HuiMing Xu___. All rights reserved.
//

#import "AdaptInterface.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation AdaptInterface


#pragma mark 按比例缩放图片
+(UIImage *) imageWithImage:(UIImage*) image scaledToSize:(CGSize) newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}
#pragma mark 颜色值转图片
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
+(BOOL)isTelephoneNumber:(NSString *)iphonenumber{
    if ([iphonenumber length]!=11) {
        
        return false;
    }else{
        /**
         * 手机号码
         * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         * 联通：130,131,132,152,155,156,185,186
         * 电信：133,1349,153,180,189
         */
       // NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
        /**
         10         * 中国移动：China Mobile
         11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         12         */
        //NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
        /**
         15         * 中国联通：China Unicom
         16         * 130,131,132,152,155,156,185,186
         17         */
       // NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
        /**
         20         * 中国电信：China Telecom
         21         * 133,1349,153,180,189
         22         */
        NSString * CT = @"^1[3|4|5|7|8][0-9]{9}$";
        /**
         25         * 大陆地区固话及小灵通
         26         * 区号：010,020,021,022,023,024,025,027,028,029
         27         * 号码：七位或八位
         28         */
        // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
        
       // NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
       // NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
        //NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
        NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
        
        if (([regextestct evaluateWithObject:iphonenumber] == YES))
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}
+(BOOL)isEmailAdress:(NSString *)string{
    
    NSString *numberRegex=@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberTest evaluateWithObject:string];
}
/**
 * @brief 判断当前时间是否在fromHour和toHour之间。如，fromHour=9，toHour=15时，即为判断当前时间是否在9:00-15:00之间
 */
+ (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now = [NSDate date];;
    NSDateComponents *comps = nil;
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    comps = [calendar components:unitFlags fromDate:now];
    NSInteger week = [comps weekday];
    if(week==1 || week == 7) //1表示周日，7表示周六
    {
        return NO;
    }
    
    NSDate *date9 = [AdaptInterface getCustomDateWithHour:fromHour];
    NSDate *date15 = [AdaptInterface getCustomDateWithHour:toHour];
    
    NSDate *currentDate = [NSDate date];
    
    if ([currentDate compare:date9]==NSOrderedDescending && [currentDate compare:date15]==NSOrderedAscending)
    {
        NSLog(@"该时间在 %ld:00-%ld:00 之间！", (long)fromHour, (long)toHour);
        return YES;
    }
    return NO;
}
/**
 * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 * @param hour 如hour为“8”，就是上午8:00（本地时间）
 */
+ (NSDate *)getCustomDateWithHour:(NSInteger)hour
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentComps = nil;
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [resultCalendar dateFromComponents:resultComps];
}

/**
 * @brief 计算某两个时间差（得出秒数）
 */
+ (long)numberOfDaysFromTodayByTime:(NSString *)time
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *senddate=[NSDate date];
    //结束时间
    NSDate *endDate = [dateFormatter dateFromString:time];
    //当前时间
    NSDate *senderDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:senddate]];
    //得到相差秒数
    NSTimeInterval differTime= (long)[endDate timeIntervalSinceDate:senderDate];
    
    return differTime;
}

#pragma mark 根据字符串得到日期
+(NSDate *)getDateByDateString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

/**
 * @brief 计算某两个时间差（得出秒数）
 */
+ (long)numberOfSecondToTime:(NSString *)time2 FromTime:(NSString *)time1
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //规定为东八区时区
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8 * 3600];
    //结束时间
    NSDate *fromDate = [dateFormatter dateFromString:time1];
    //当前时间
    NSDate *ToDate = [dateFormatter dateFromString:time2];
    //得到相差秒数
    NSTimeInterval differTime= (long)[ToDate timeIntervalSinceDate:fromDate];
    
    return differTime;
}

//5到20位字母加数字加下划线（用户名）
+(BOOL)isMatchUserName:(NSString *)letterNumber
{
    NSString *numberRegex=@"[0-9A-Za-z_]{5,20}$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    
    return [numberTest evaluateWithObject:letterNumber];
}

//6到18位字母加数字下划线（用户名或密码）
+(BOOL)isMatchUserNameOrPassword:(NSString *)letterNumber
{
    NSString *numberRegex=@"[0-9A-Za-z_]{6,18}$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    
    return [numberTest evaluateWithObject:letterNumber];
}

//是否是非法字符（用户名或昵称）
+(BOOL)isIllegalCharacter:(NSString *)string
{
    NSString *numberRegex=@"^([`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？])$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberTest evaluateWithObject:string];
}
//判断是否含汉字
+(BOOL)isPassWord:(NSString *)password
{
    NSString *phs = @"^[^\u4e00-\u9fa5]{0,}$";
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phs];
    if (([regextestphs evaluateWithObject:password] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//银行卡号校验
+(BOOL)isValidCardNumber:(NSString *)cardNumber {
    int sum = 0;
    int len = [cardNumber length];
    int i = 0;
    
    while (i < len) {
        NSString *tmpString = [cardNumber substringWithRange:NSMakeRange(len - 1 - i, 1)];
        int tmpVal = [tmpString intValue];
        if (i % 2 != 0) {
            tmpVal *= 2;
            if(tmpVal>=10) {
                tmpVal -= 9;
            }
        }
        sum += tmpVal;
        i++;
    }
    
    if((sum % 10) == 0)
        return YES;
    else
        return NO;
}
#pragma mark 身份证号位数校验
+(BOOL)checkNumCard:(NSString *)numCard
{
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    
    if ([identityCardPredicate evaluateWithObject:numCard]) {
        return YES;
        
    }else{
        return NO;
    }
    
}

#pragma mark 身份证号校验
+ (BOOL)validateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, value.length)];
            

            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return false;
    }
}
//验证输入的是否是数字
+(BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
//只能输入字母或数字
+ (BOOL) validateNumCard:(NSString *)numCard
{
    NSString *numCardRegex = @"^[A-Za-z0-9]+$";
    NSPredicate *numCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numCardRegex];
    return [numCardPredicate evaluateWithObject:numCard];
}
#pragma mark 获取UUID
+(NSString*) getUUID
{
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:@"UUID"]) {
        return [userDefault objectForKey:@"UUID"];
    }
    else{
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        [userDefault setObject:result forKey:@"UUID"];
        [userDefault synchronize];
        return result;
    }
    
}
//判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
+ (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}
#pragma mark 根据时间戳转换日期
+(NSString *)getDataByTimeStamp:(NSString *)timestamp withFormatter:(NSString *)formatter
{
    if ([timestamp isKindOfClass:[NSNull class]]) {
        return @"";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];//格式化
    
    //规定为东八区时区
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8 * 3600];

    
    [df setDateFormat:formatter];
    
    return [df stringFromDate:date];
}
+(int)getDayByYear
{
    int year;
    //获取当前日期
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    NSString *endString = [locationString substringToIndex:4];
    NSInteger currentYear = [endString integerValue];
    //判断平年和闰年
    if((currentYear%4==0&&currentYear%100!=0)||(currentYear%100==0&&currentYear%400==0))
    {
        year = 366;
    }
    else
    {
        year = 365;
    }
    return year;
}
#pragma mark MD5（32位）加密
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH *2];
    for(int i =0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}
#pragma mark MD5（16位）加密
+ (NSString *)md5:(NSString *)str
{
    
    const char *cStr = [str UTF8String];
    
    unsigned char result[16];
    
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    
    return [NSString stringWithFormat:
            
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            
            ];
    
}
+ (UIColor *) colorWithHexString1: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
#pragma mark - 获取控件在设备上的绝对frame
+(CGRect)convertFrameWithOriginX:(CGFloat)x andOriginY:(CGFloat)y andWidth:(CGFloat)width andHeight:(CGFloat)height
{
    CGFloat deviceHeight = 0.f;
    if (iPhone4)
    {
        deviceHeight=568.f;
    }
    else
    {
        deviceHeight=currentViewHeight;
    }
    CGRect newFrame;
    CGFloat newX = currentViewWidth*x/iphone6Width;
    CGFloat newY = deviceHeight*y/iphone6Height;
    CGFloat newWidth = currentViewWidth*width/iphone6Width;
    CGFloat newHeight = deviceHeight*height/iphone6Height;
    newFrame = CGRectMake(newX, newY, newWidth, newHeight);
    return newFrame;
}

#pragma mark - 获取某个长度在不同设备上的绝对长度
+(CGFloat)convertWidthWithWidth:(CGFloat)width
{
    CGFloat newWidth = currentViewWidth*width/iphone6Width;
    return newWidth;
}

#pragma mark - 获取某个长度在不同设备上的绝对长度
+(CGFloat)convertHeightWithHeight:(CGFloat)height
{
    CGFloat deviceHeight = 0.f;
    if (iPhone4)
    {
        deviceHeight=568.f;
    }
    else
    {
        deviceHeight=currentViewHeight;
    }
    CGFloat newHeight = deviceHeight*height/iphone6Height;
    return newHeight;
}

//判断网络是否连接
+(BOOL)isConnected
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    BOOL isReachable=YES;
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            //NSLog(@"没有网络");
            isReachable=NO;
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            NSLog(@"正在使用3G网络");
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            break;
    }
    return isReachable;
}
+(void)tipMessageTitle:(NSString *)title view:(UIView *)view{
    if ([view viewWithTag:192021]) {
        [[view viewWithTag:192021]removeFromSuperview];
    }
    CGSize size=[title sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(300, 50)];
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake((view.frame.size.width-size.width-40)/2, 200, size.width+40, 50)];
    if (iPhone4) {
        bgView=[[UIView alloc]initWithFrame:CGRectMake((view.frame.size.width-size.width-40)/2, 120, size.width+40, 50)];
    }
    bgView.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.7];
    bgView.layer.masksToBounds=YES;
    bgView.layer.cornerRadius=10.0;
    bgView.tag=192021;
    [view addSubview:bgView];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, bgView.frame.size.width-40, bgView.frame.size.height-10)];
    label.font=[UIFont boldSystemFontOfSize:14];
    label.textColor=[UIColor whiteColor];
    label.text=title;
    label.numberOfLines =0;
    label.backgroundColor=[UIColor clearColor];
    
    CGSize descriptionsSize = [label.text textSizeWithFont:label.font constrainedToSize:CGSizeMake(bgView.frame.size.width-40, MAXFLOAT)];
    label.frame =(CGRect){{20,10},descriptionsSize};
    bgView.frame =CGRectMake((view.frame.size.width-size.width-40)/2, 200, size.width+40, descriptionsSize.height+20);
    if (iPhone4) {
        bgView.frame=CGRectMake((view.frame.size.width-size.width-40)/2, 120, size.width+40, descriptionsSize.height+20);
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=6.0)
    {
        label.textAlignment=NSTextAlignmentCenter;
    }
    [bgView addSubview:label];
    [bgView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
}

//格式话小数 四舍五入类型
+ (NSString *)decimalwithFormat:(NSString *)format floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

+ (BOOL)is_iPhone_4
{
    if ([UIScreen mainScreen].bounds.size.height == 480.0f) {
        return YES;
    }else{
        return NO;
    }
}
+(BOOL)isChinese:(NSString *)string{
    
    NSString *numberRegex=@"^[\u4e00-\u9fcb,\u00b7,\\.]{0,}$";//限制可输入点·号 .号
    //NSString *numberRegex=@"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberTest evaluateWithObject:string];
}
//金额处理
+ (NSString *)getMoney:(float)money
{
    NSString *backText;
    if (money < 10000)
    {
        backText = [NSString stringWithFormat:@"%.2f元",money];
        
    }
    else
    {
        if (money >= 100000000)
        {
            double amount = money;
            double largeMoney = (amount*0.00000001);
            double smallMoney = (amount*0.0001);
            if ((int)money % 1000000 == 0)
            {
                backText = [NSString stringWithFormat:@"%.2f亿元",largeMoney];
            }
            else
            {
                if ((int)money % 100 == 0)
                {
                    backText = [NSString stringWithFormat:@"%.2f万元",smallMoney];
                }
                else
                {
                    backText = [NSString stringWithFormat:@"%.2f元",amount];
                }
            }
            
        }
        else if (money >= 1000000)
        {
            double amount = money;
            double smallMoney = (amount*0.0001);
            
            if ((int)money % 100 == 0)
            {
                backText = [NSString stringWithFormat:@"%.2f万",smallMoney];
            }
            else
            {
                backText = [NSString stringWithFormat:@"%.2f元",amount];
            }
            
            
        }
        else
        {
            double amount = money;
            double smallMoney = (amount*0.0001);
            if ((int)money % 100 == 0)
            {
                backText = [NSString stringWithFormat:@"%.2f万元",smallMoney];
            }
            else
            {
                backText = [NSString stringWithFormat:@"%.2f元",amount];
            }
            
        }
    }
    
    return backText;

}

@end
