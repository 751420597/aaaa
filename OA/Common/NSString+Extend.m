//
//  NSString+Extend.m
//  mes-client-iphone2
//
//  Created by  mac on 10-12-13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSString+Extend.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (Extend)
-(NSString *)filterHtml{
    
    NSString *content=[self stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    content=[content stringByReplacingOccurrencesOfString:@"<span>" withString:@""];
    content=[content stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
    content=[content stringByReplacingOccurrencesOfString:@"<SPAN>" withString:@""];
    content=[content stringByReplacingOccurrencesOfString:@"</SPAN>" withString:@""];
    content=[content stringByReplacingOccurrencesOfString:@"　　" withString:@""];
    content=[content stringByReplacingOccurrencesOfString:@"<table" withString:@"<div style=\"solid;width:700px; overflow-x: scroll;overflow-y : hidden;\"><table"];
    content=[content stringByReplacingOccurrencesOfString:@"</table>" withString:@"</table></div>"];
    content=[content stringByReplacingOccurrencesOfString:@"<TABLE" withString:@"<div style=\"solid;width:700px; overflow-x: scroll;overflow-y : hidden;\"><table"];
    content=[content stringByReplacingOccurrencesOfString:@"</TABLE>" withString:@"</table></div>"];
    content=[content stringByReplacingOccurrencesOfString:@"<br />" withString:@"<br/><p>"];
    content=[content stringByReplacingOccurrencesOfString:@"<br/>" withString:@"<br/><p>"];
    
    content=[content stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
    content=[content stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
    //    content=[content stringByReplacingOccurrencesOfString:@"<P>" withString:@""];
    //    content=[content stringByReplacingOccurrencesOfString:@"</P>" withString:@""];
    return content;
}

//unicode编码以\u开头
+ (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}
- (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
//    unsigned char result[CC_MD5_DIGEST_LENGTH];
    unsigned char result[32];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];}
- (NSUInteger) indexOf:(char) searchChar
{
	
	NSRange result = [self rangeOfString:[[NSString alloc] initWithFormat:@"%c",searchChar]];
	
	return result.location;
}

- (NSUInteger) lastIndexOf:(char) searchChar
{
	
	NSRange result = [self rangeOfString:[[NSString alloc] initWithFormat:@"%c",searchChar] options:NSBackwardsSearch];
    
	return result.location;
}
- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString *outputStr = (__bridge NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (__bridge CFStringRef)input,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
    return outputStr;
}

- (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
} - (NSString *) stringByURLEncoding{
//    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
     return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#.[]_{}%^•¥£€<>~|-", kCFStringEncodingUTF8);
}

- (NSString *) stringByURLDecoding{
    
    NSString *result = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return result;
}
-(NSString*)dateToString:(NSDate*)_date format:(NSString*)_format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [formatter setTimeZone:timeZone];
    
    [formatter setDateFormat :_format];
    
    
    return [formatter stringFromDate:_date];
}
-(NSDate*)stringToDate:(NSString*)_format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:_format];
    NSDate *destDate= [dateFormatter dateFromString:self];
    //    [dateFormatter release];
    return destDate;
}
+ (NSString*) stringWithUUID {
	CFUUIDRef	uuidObj = CFUUIDCreate(nil);//create a new UUID
	//get the string representation of the UUID
    CFStringRef uuidString = CFUUIDCreateString(nil, uuidObj);
	NSString	*result = (__bridge NSString*)CFStringCreateCopy(NULL, uuidString);
	CFRelease(uuidObj);
    CFRelease(uuidString);
	return result;
}
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize textSize;
    if (CGSizeEqualToSize(size, CGSizeZero))
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        textSize = [self sizeWithAttributes:attributes];
    }
    else
    {
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        //NSStringDrawingTruncatesLastVisibleLine如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。 如果指定了NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略 NSStringDrawingUsesFontLeading计算行高时使用行间距。（字体大小+行间距=行高）
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGRect rect = [self boundingRectWithSize:size
                                         options:option
                                      attributes:attributes
                                         context:nil];
        
        textSize = rect.size;
    }
    return textSize;
}

- (BOOL)containsString:(NSString *)aString
{
    if (!IS_NOT_EMPTY(aString)) {
        return NO;
    }
    if ([self rangeOfString:aString].location != NSNotFound) {
        return YES;
    }
    return NO;
}
@end
