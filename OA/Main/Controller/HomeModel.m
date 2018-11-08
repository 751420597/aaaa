//
//  HomeModel.m
//  OA
//
//  Created by 翟凤禄 on 2018/11/3.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel
-(HomeModel *)initHomeModelWithDic:(NSDictionary *)dic{
    if (dic) {
        self.comment = dic[@"goods_name"];
        self.imageUrl = dic[@"original_img"];
        self.price = dic[@"shop_price"];
        self.idStr = dic[@"extend_cat_id"];
    }
    return self;
}
@end
