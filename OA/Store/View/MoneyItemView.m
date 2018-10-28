//
//  MoneyItemView.m
//  OA
//
//  Created by 翟凤禄 on 2018/10/25.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import "MoneyItemView.h"

@implementation MoneyItemView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self creatView:frame];
    }
    return self;
}
-(void)creatView:(CGRect)frame{
    self.numBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.numBT.frame =CGRectMake(0, [AdaptInterface convertHeightWithHeight:10], frame.size.width, frame.size.height-[AdaptInterface convertHeightWithHeight:25]);
    [self.numBT setTitleColor:[UIColor blackColor] forState:0];
    self.numBT.titleLabel.font = [UIFont systemFontOfSize:17.1f];
    [self.numBT setTitleEdgeInsets:UIEdgeInsetsMake(-25, 0, 0, 0)];
    self.numBT.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.numBT];
    
    self.textLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.numBT.frame)-[AdaptInterface convertHeightWithHeight:15], CGRectGetWidth(self.numBT.frame), [AdaptInterface convertHeightWithHeight:15])];
    self.textLB.font = [UIFont systemFontOfSize:13.f];
    self.textLB.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.textLB];
    
    
}
@end
