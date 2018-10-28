//
//  OderItemView.m
//  OA
//
//  Created by 翟凤禄 on 2018/10/25.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import "OderItemView.h"
#import "UIButton+WebCache.h"
@implementation OderItemView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor =[UIColor whiteColor];
        [self creatView:frame];
    }
    return self;
}
-(void)creatView:(CGRect)frame{
    self.imgView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imgView.frame =CGRectMake(0, [AdaptInterface convertHeightWithHeight:10], frame.size.width, frame.size.height-[AdaptInterface convertHeightWithHeight:25]);
    [self.imgView setImageEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, 0)];
    [self addSubview:self.imgView];
    
    self.textLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imgView.frame)-[AdaptInterface convertHeightWithHeight:10], CGRectGetWidth(self.imgView.frame), [AdaptInterface convertHeightWithHeight:15])];
    self.textLB.font = [UIFont systemFontOfSize:13.f];
    self.textLB.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.textLB];
    
    self.redLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:25], [AdaptInterface convertWidthWithWidth:25])];
    self.redLB.center = CGPointMake(CGRectGetMaxX(self.imgView.frame) - [AdaptInterface convertWidthWithWidth:18], CGRectGetMinY(self.imgView.frame)+[AdaptInterface convertHeightWithHeight:2]);
    self.redLB.textColor =[UIColor whiteColor];
    self.redLB.backgroundColor =[UIColor redColor];
    self.redLB.font = [UIFont systemFontOfSize:11.f];
    self.redLB.layer.cornerRadius = self.redLB.frame.size.width/2;
    self.redLB.layer.masksToBounds = YES;
    self.redLB.hidden = YES;
    self.redLB.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.redLB];
}
-(void)changeStatus:(BOOL)isActive{
    self.redLB.hidden = isActive;
}
@end
