//
//  SortModel.h
//  OA
//
//  Created by 翟凤禄 on 2018/11/4.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SortModel : NSObject

@property(nonatomic , copy)NSString *name;
@property(nonatomic , strong)NSArray *tmenu;
-(SortModel *)initSortModelWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
