//
//  VersionUpdateView.m
//  MFB
//
//  Created by llc on 15/10/12.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import "VersionUpdateView.h"
#import "HarpyConstants.h"

@interface VersionUpdateView ()
{
    UITextField *moneyTF;
    CGRect orginBgViewFrame;
}
@end

@implementation VersionUpdateView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        //背景图片
        self.image = [UIImage imageNamed:@"coverLayer"];
        // 加载控件
        [self createControl];
        
    }
    return self;
}
-(void) createControl
{
    bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    
    bgView.center = CGPointMake(currentViewWidth*0.5, currentViewHeight*0.4);
    bgView.bounds = CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:600/2], [AdaptInterface convertHeightWithHeight:290/2]);
    
    [self addSubview:bgView];
    
    
    //CGFloat leftMargin =[AdaptInterface convertWidthWithWidth:15];
    CGFloat bgViewWidth = bgView.frame.size.width;
    
    //余额
    UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgViewWidth, [AdaptInterface convertHeightWithHeight:88/2])];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"版本更新";
    [bgView addSubview:titleLabel];
    
    
    
    //余额
    _contentLabel =[[UILabel alloc] init];
    _contentLabel.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame), bgViewWidth, [AdaptInterface convertHeightWithHeight:88/2]);
    _contentLabel.font = [UIFont systemFontOfSize:16];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.numberOfLines =0;
    [bgView addSubview:_contentLabel];
    
    
    
    
    // 灰色分割线
    UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentLabel.frame) + [AdaptInterface convertHeightWithHeight:22/2], bgViewWidth, 0.5)];
    lineView.backgroundColor = colorWithHexString(@"#cccccc");
    [bgView addSubview:lineView];
    
    
    //确认
    UIButton *_confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.frame = CGRectMake(0, CGRectGetMaxY(lineView.frame) , [AdaptInterface convertWidthWithWidth:600/2], [AdaptInterface convertHeightWithHeight:90/2]);
    
    [_confirmBtn setTitle:@"立即更新" forState:UIControlStateNormal];
    [_confirmBtn setBackgroundColor:colorWithHexString(@"#f1f5f8")];
    [_confirmBtn setTitleColor:colorWithHexString(@"#0066cc") forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_confirmBtn];
 
}

//确认
- (void)confirmAction:(UIButton *)button
{
    NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kHarpyAppID];
    NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
    [[UIApplication sharedApplication] openURL:iTunesURL];
}
@end