//
//  FMDBHandle.h
//  DouBier
//
//  Created by lanou3g on 15-5-8.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface FMDBHandle : NSObject

+(FMDBHandle *)shareHandle;

//插入或修改数据
-(void)insertNumAccount:(NSString*)account HPassWord:(NSString*)handlePassWord IsHand:(NSString *)isHand IsTouch:(NSString *)isTouch;

//根据用户名读取手势密码
-(NSMutableArray *)selectHandlePassWordWithAccount:(NSString*)account;

//根据用户名读取手势设置状态
-(NSMutableArray *)selectIsHandWithAccount:(NSString*)account;

//根据用户名读取指纹设置状态
-(NSMutableArray *)selectIsTouchWithAccount:(NSString*)account;

//根据用户名删除手势密码
-(BOOL) deleteHandlePassWordWithAccount:(NSString *)account;
//---------------------------------产品表---------------------------------

#pragma mark 添加产品缓存数据
-(BOOL)addProduct:(NSString *)content withProductType:(NSString *)productType;

#pragma mark 得到产品缓存数据
-(NSString *)getProductCacheData:(NSString *)productType;

#pragma mark 删除数据
-(BOOL) deleteProduct:(NSString *)productType;

//---------------------------------我的投资---------------------------------

#pragma mark 添加缓存数据
-(BOOL)addMyInvestWithContent:(NSString *)content withUser:(NSString *)user  withStatus:(NSString *)status;

#pragma mark 得到缓存数据
-(NSString *)getMyInvestWithUser:(NSString *)user  withStatus:(NSString *)status;

#pragma mark 删除数据
-(BOOL) deleteMyInvestWithUser:(NSString *)user  withStatus:(NSString *)status;

@end
