//
//  TopItemView.m
//  OA
//
//  Created by 翟凤禄 on 2018/10/24.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import "TopItemView.h"

@implementation TopItemView

-(instancetype)initWithFrame:(CGRect)frame{
    if([super initWithFrame:frame]){
        [self createView:frame];
    }
    return self;
}
-(void)createView:(CGRect)frame{
    CGFloat height = frame.size.height;
    CGFloat width = frame.size.width;
    self.numberLB =[[UILabel alloc]initWithFrame:CGRectMake(0, [AdaptInterface convertHeightWithHeight:3], width, height/2)];
    self.numberLB.font = [UIFont systemFontOfSize:13.5f];
    self.numberLB.textAlignment = NSTextAlignmentCenter;
    self.numberLB.textColor =[UIColor whiteColor];
    [self addSubview:self.numberLB];
    
    self.textLB =[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.numberLB.frame)-[AdaptInterface convertHeightWithHeight:3], width, height/2)];
    self.textLB.font = [UIFont systemFontOfSize:13.5f];
    self.textLB.textAlignment = NSTextAlignmentCenter;
    self.textLB.textColor =[UIColor whiteColor];
    [self addSubview:self.textLB];
    
    
}

@end
