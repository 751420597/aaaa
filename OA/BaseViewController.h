//
//  BaseViewController.h
//  mdffx
//
//  Created by 吴朋 on 2017/7/11.
//  Copyright © 2017年 xinpingTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic,strong) UIButton * rigntBtn;
/*!
 @method
 @abstract   创建导航条返回按钮
 */
-(void)createBackItemWithTarget:(id)target;

/*!
 @method
 @abstract   创建导航条左按钮
 @param 	imageName 	按钮图片
 @param 	highlightedImageName 	按钮高亮的图片
 @param 	target 	按钮点击事件响应对象
 @param 	selector 	按钮点击事件响应方法
 */
- (void)createLeftItemWithImage:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)selector;

/*!
 @method
 @abstract   返回事件
 */
-(void)pop;


/*!
 @method
 @abstract   创建导航条右边按钮
 @param 	target 	按钮点击事件响应对象
 @param 	selector 	按钮点击事件响应方法
 title_  按钮的名字
 */
- (void)createRightItemWithTitle:(NSString*)title withImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName action:(SEL)selector target:(id)target;


/**
 创建导航条上的选项

 @param titles 需要显示的items
 @param clickItem 点击item的回调
 @param selectedIndex 选择下标
 */
- (void)createCenterSegementWithTitles:(NSArray *)titles clickItemsWithIndex:(void(^)(NSInteger index))clickItem selectedItemIndex:(NSInteger)selectedIndex;

#pragma mark 去掉多余的分割线
-(void)setExtraCellLineHidden: (UITableView *)tableView;

@end
