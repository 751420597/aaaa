//
//  DockItem.m
//  Test
//
//  Created by user on 14-7-31.
//  Copyright (c) 2014年 user. All rights reserved.
//
#define KImageBili 0.6

#import "DockItem.h"

@interface DockItem ()
{
    UIButton *_redMessage1;
    UIButton *_redMessage2;
    int _noReadCount;
    int _noReadCount2;
}
@end
@implementation DockItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 当加载dockItem时改变字体大小，位置等信息
//        self.titleLabel.font = [UIFont systemFontOfSize:12];
//        self.tintColor =[UIColor grayColor];
//        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 设置图片为自适应
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.adjustsImageWhenHighlighted = NO;

    }
    
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH =contentRect.size.height ;
    return CGRectMake(0, 1, imageW, imageH);
}

//-(CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    CGFloat titleW = contentRect.size.width;
//    CGFloat titleY = contentRect.size.height *0.6;
//    CGFloat titleH = contentRect.size.height - titleY;
//    return  CGRectMake(0, titleY + 1, titleW, titleH);
//}

//重写Highlighted方法，使长按时已选中
-(void)setHighlighted:(BOOL)highlighted{
   
}

////重写设置图片边框
//-(CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//
//    if (self.tag ==2) {
//        return CGRectMake(0, 1, contentRect.size.width, contentRect.size.height -5);
//    }
//    return CGRectMake(0, 3, contentRect.size.width, contentRect.size.height * KImageBili);
//}
//
////重写设置文本边框
//-(CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    CGFloat titleY=contentRect.size.height * KImageBili -7;
//    CGFloat titleHeight = contentRect.size.height - titleY;
//    return CGRectMake(0, titleY, contentRect.size.width, titleHeight + 8);
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
