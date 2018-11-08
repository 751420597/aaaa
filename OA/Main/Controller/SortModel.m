//
//  SortModel.m
//  OA
//
//  Created by 翟凤禄 on 2018/11/4.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import "SortModel.h"

@implementation SortModel
-(SortModel *)initSortModelWithDic:(NSDictionary *)dic{
    if (dic) {
        self.name = dic[@"name"];
        self.tmenu = dic[@"tmenu"];
    }
    return self;
}
@end
