//
//  OderItemView.h
//  OA
//
//  Created by 翟凤禄 on 2018/10/25.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OderItemView : UIView
@property (nonatomic , strong) UILabel *textLB;
@property (nonatomic , strong) UILabel *redLB;
@property (nonatomic , strong) UIButton *imgView;

-(void)changeStatus:(BOOL)isActive;
@end

NS_ASSUME_NONNULL_END
