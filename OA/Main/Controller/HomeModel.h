//
//  HomeModel.h
//  OA
//
//  Created by 翟凤禄 on 2018/11/3.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeModel : NSObject
@property(nonatomic,copy) NSString *comment;
@property(nonatomic,copy) NSString *url;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *imageUrl;
@property(nonatomic,copy) NSString *idStr;
-(HomeModel *)initHomeModelWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
