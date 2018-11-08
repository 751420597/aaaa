//
//  SubSortModel.m
//  OA
//
//  Created by 翟凤禄 on 2018/11/4.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import "SubSortModel.h"

@implementation SubSortModel
-(SubSortModel *)initSubSortModelWithDic:(NSDictionary *)dic{
    if (dic) {
        self.name = dic[@"name"];
        self.subMenu = dic[@"sub_menu"];
        self.id = dic[@"id"];
        self.imgeUrl = [NSString stringWithFormat:@"%@%@",kRequestIP,dic[@"image"]];
    }
    return self;
}
@end
