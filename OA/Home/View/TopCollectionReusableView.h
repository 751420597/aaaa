//
//  TopCollectionReusableView.h
//  OA
//
//  Created by 翟凤禄 on 2018/10/28.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "OderItemView.h"
#import "HRAdView.h"
#import "UIButton+WebCache.h"
#import "PrefectureVie.h"
NS_ASSUME_NONNULL_BEGIN

@interface TopCollectionReusableView : UIView<SDCycleScrollViewDelegate>

@property(nonatomic,strong) HRAdView * hRAdview;// 滚动字幕
@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;
@property(nonatomic,strong)UIButton *activeBtn0;
@property(nonatomic,strong)UIButton *activeBtn1;
@property(nonatomic,strong)UIButton *activeBtn2;

@property(nonatomic,strong)UIButton *nameItem0;
@property(nonatomic,strong)UIButton *nameItem1;
@property(nonatomic,strong)UIButton *nameItem2;
@property(nonatomic,strong)UIButton *nameItem3;
@property(nonatomic,strong)UIButton *nameItem4;
@property(nonatomic,strong)UIButton *nameItem5;
@property(nonatomic,strong)UIButton *nameItem6;
@property(nonatomic,strong)UIButton *nameItem7;

@property(nonatomic,strong)PrefectureVie *pView0;
@property(nonatomic,strong)PrefectureVie *pView1;
@property(nonatomic,strong)PrefectureVie *pView2;

@property(nonatomic,strong)NSArray *yanxuanArr;

-(CGFloat)getHeight;

@end

NS_ASSUME_NONNULL_END