//
//  Dock.m
//  Test
//
//  Created by user on 14-7-31.
//  Copyright (c) 2014年 user. All rights reserved.
//
#define KDockItemCount 5
#import "Dock.h"
#import "DockItem.h"

@interface Dock()
{
    DockItem *currentItem;
    DockItem *button;
    
    UIButton *_redMessage;
//    UIButton *_redMessage2;
    int _noReadCount;
    int _noReadCount2;
}
@end

@implementation Dock

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        

        [self addDockItemWithIcon:@"1(2)" withSelect:@"2(2)" withTitle:@"首页" withMark:1];
        [self addDockItemWithIcon:@"3(2)" withSelect:@"4(2)" withTitle:@"分类" withMark:2];
        [self addDockItemWithIcon:@"5(2)" withSelect:@"6" withTitle:@"小店" withMark:3];
        [self addDockItemWithIcon:@"7" withSelect:@"8" withTitle:@"购物车" withMark:4];
        [self addDockItemWithIcon:@"9" withSelect:@"10" withTitle:@"我的" withMark:5];
    }
    return self;
}

-(void) addDockItemWithIcon:(NSString *)icon withSelect:(NSString *)selectedIcon withTitle:(NSString *)title withMark:(int)mark
{
    // 1.创建按钮，同时调用DockItem中对图片和文本重写的方法
    button= [DockItem buttonWithType:UIButtonTypeCustom];
    button.tag = mark -1;
    // 添加到dockView中
    [self addSubview:button];
    // 2.设置边框
    //[self adjustDockItemFrame];

    int dockItemWidth = self.frame.size.width /KDockItemCount;
    int dockItemHeight = self.frame.size.height;
    button.frame = CGRectMake((mark-1) * dockItemWidth, 0, dockItemWidth, dockItemHeight);
    
    // 3.设置图片和文字的一般状态和高亮状态
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedIcon] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchDown];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:colorWithHexString(@"#666666") forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
    
}

-(void) itemClick:(DockItem *)item
{
    
    // 5.通知控制器
    if (_dockItemClick) {
        _dockItemClick((int)item.tag);
    }
    
    
}
#pragma mark 重写设置选中索引的方法
- (void)setSelectedIndex:(int)selectedIndex
{
    // 1.条件过滤
    if (selectedIndex < 0 || selectedIndex >= self.subviews.count) return;
    
    // 2.赋值给成员变量
    _selectedIndex = selectedIndex;
    
    // 3.对应的item
    DockItem *item = self.subviews[selectedIndex];
    
    // 4.相当于点击了这个item
    [self itemClick:item];
    
    
}
-(void)adjustDockItemFrame
{
    // 1.获得dock里的所有Item数量
    int dockItemCount = (int)self.subviews.count;
    int dockItemWidth = self.frame.size.width /dockItemCount;
    int dockItemHeight = self.frame.size.height;
    for (int i=0; i < dockItemCount; i++) {
        
        DockItem *dockItem = self.subviews[i];
        //设置边框
        dockItem.frame = CGRectMake(i * dockItemWidth, 0, dockItemWidth, dockItemHeight);
        
        //设置按钮的Tag
        dockItem.tag = i;
    }
}


@end
