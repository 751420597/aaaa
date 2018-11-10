//
//  PrefectureVie.m
//  OA
//
//  Created by 翟凤禄 on 2018/10/28.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import "PrefectureVie.h"

@implementation PrefectureVie

-(instancetype)initWithFrame:(CGRect)frame{
    self =  [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createView:frame];
    }
    
    return self;
}
-(void)createView:(CGRect)frame{
    CGFloat height = frame.size.height;
    CGFloat width = frame.size.width;
    self.titleLB =[[UILabel alloc]initWithFrame:CGRectMake([AdaptInterface convertWidthWithWidth:20], 0, width, [AdaptInterface convertHeightWithHeight:30])];
    self.titleLB.font = [UIFont systemFontOfSize:17.5f];
    self.titleLB.text = @"精确严选专区";
    [self addSubview:self.titleLB];
    
    self.contentLB =[[UILabel alloc]initWithFrame:CGRectMake([AdaptInterface convertWidthWithWidth:20], CGRectGetMaxY(self.titleLB.frame), width, [AdaptInterface convertHeightWithHeight:20])];
    self.contentLB.font = [UIFont systemFontOfSize:13.5f];
    self.contentLB.text = @"魅力狂欢.无限嗨购";
    self.contentLB.textColor = [UIColor grayColor];
    [self addSubview:self.contentLB];
    
    self.imgViewBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    self.imgViewBtn.frame =CGRectMake(0, CGRectGetMaxY(self.contentLB.frame), width, height-CGRectGetMaxY(self.contentLB.frame));
    [self addSubview:self.imgViewBtn];
   
}
@end
