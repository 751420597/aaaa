//
//  LoginView.m
//  OA
//
//  Created by 翟凤禄 on 2018/10/29.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self creatView:frame];
    }
    return self;
}
-(void)creatView:(CGRect)frame{
    CGFloat height = frame.size.height;
    CGFloat width = frame.size.width;
    self.imgView = [[UIImageView alloc]init];
    self.imgView.frame = CGRectMake(0, 0, height,  height);
    [self addSubview:self.imgView];
    
    self.keyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.keyBtn.frame = CGRectMake(CGRectGetMaxX(self.imgView.frame),0, width-height,  height);
    [self.keyBtn setTitleColor:[UIColor blackColor] forState:0];
    [self addSubview:self.keyBtn];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
