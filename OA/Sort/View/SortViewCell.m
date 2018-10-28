//
//  SortViewCell.m
//  OA
//
//  Created by 翟凤禄 on 2018/10/28.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import "SortViewCell.h"

@implementation SortViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor =[UIColor whiteColor];
        [self creatView:frame];

    }
    return self;
}
-(void)creatView:(CGRect)frame{
    self.imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-[AdaptInterface convertHeightWithHeight:25])];
    self.imgV.backgroundColor =[UIColor blueColor];
    [self.contentView addSubview:self.imgV];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imgV.frame), frame.size.width, [AdaptInterface convertHeightWithHeight:25])];
    self.titleLB.text = @"英国";
    self.titleLB.font = [UIFont systemFontOfSize:13.5f];
    self.titleLB.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLB];
}
@end
