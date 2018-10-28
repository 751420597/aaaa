//
//  NSString+Extend.h
//  mes-client-iphone2
//
//  Created by  mac on 10-12-13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString(Extend)

-(NSString *)filterHtml;
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;
- (unsigned int) indexOf:(char) searchChar;
- (unsigned int) lastIndexOf:(char) searchChar;
- (NSString *)md5:(NSString *)str;
- (NSString *) stringByURLEncoding;
-(NSString*)dateToString:(NSDate*)_date format:(NSString*)_format;
- (NSString *) stringByURLDecoding;
- (NSString *)encodeToPercentEscapeString: (NSString *) input;
+ (NSString*) stringWithUUID;
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

- (NSDate*)stringToDate:(NSString*)_format;

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

- (BOOL)containsString:(NSString *)aString;
@end
