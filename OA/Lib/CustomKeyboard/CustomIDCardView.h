//
//  CustomIDCardView.h
//  CustomKeyBoard
//
//  Created by xinping-imac-1 on 16/1/4.
//  Copyright (c) 2016年 libaozi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFieldDelegate<NSObject>
- (BOOL)changeTField:(UITextField *)textfield withString:(id)string;
@end

@interface CustomIDCardView : UIView
@property (nonatomic,strong) UIToolbar *toolBar;
@property (nonatomic,strong) UIButton *btnItem;//toolbar上的按钮
@property (nonatomic,strong) UIBarButtonItem *space,*space1,*space2,* doneBtn;//toolbar上面的图标，左边标题，右边标题，确定按钮
@property (nonatomic,strong) UITextField *TField;
@property (nonatomic,strong) NSMutableString *temString;//可变字符串用来接收输入的数字
@property (nonatomic, weak) id<TFieldDelegate> delegate;

//-(void)setToolBarWithCenterImage:(UIImage *)image withLeftTitle:(NSString *)leftTitle withLeftTitleColor:(UIColor *)lColor withRightTitle:(NSString *)rightTitle withRightTitleColor:(UIColor *)rColor WithTitle:(NSString *)title  target:(id)target action:(SEL)action withTitleColor:(UIColor *)doneBtnColor;//修改键盘toolbar ，设置toolbar的图片，标题，和完成按钮的标题，颜色，事件；
-(void)setToolBarWithTarget:(id)target action:(SEL)action withTitleColor:(UIColor *)doneBtnColor;//修改键盘toolbar
-(void)limitWordCount:(int)count1 ;//限制字数方法
@property(nonatomic,assign)int count1;// 限制的字数
@end
