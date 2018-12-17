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
#import "CBAutoScrollLabel.h"

typedef  void (^Block)(NSString *link,NSInteger index);
typedef  void (^BlockLink)(NSString *link,NSInteger index);
typedef  void (^BlockSudokuLink)(NSString *link,NSInteger index);
typedef  void (^BlockADLink)(NSString *link,NSInteger index);
typedef  void (^BlockTap)(NSString *link,NSInteger index);
@interface TopCollectionReusableView : UIView<SDCycleScrollViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)CBAutoScrollLabel * scrollLable;// 滚动字幕
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
@property(nonatomic,strong)NSArray *adArr;
@property(nonatomic,strong)NSMutableArray *adImageArr;
@property(nonatomic,strong)NSArray *iconeArr;
@property(nonatomic,copy)Block block;
@property(nonatomic,copy)BlockLink blockLink;
@property(nonatomic,copy)BlockSudokuLink blockSudokuLink;
@property(nonatomic,copy)NSString *info;
@property(nonatomic,copy)BlockADLink blockAdLink;
@property(nonatomic,copy)BlockTap blockTap;
@property(nonatomic,strong)NSDictionary *dicYX1;
@property(nonatomic,strong)NSDictionary *dicYX2;
@property(nonatomic,strong)NSDictionary *dicYX3;

@property(nonatomic,strong)NSArray *threeAdArr;

@property(nonatomic,strong)UILabel *addressLB;
@property(nonatomic,strong)UILabel *messageLB;

-(CGFloat)getHeight;

@end


