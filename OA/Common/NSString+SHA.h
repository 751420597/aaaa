//
//  NSString+SHA.h
//  HYKDProject
//
//  Created by mac on 15/5/8.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSString (SHA)

-(NSString *) sha1;
-(NSString *) sha224;
-(NSString *) sha256;
-(NSString *) sha384;
-(NSString *) sha512;

@end
