//
//  CustomView.h
//  CustomKeyBoard
//
//  Created by xinping-imac-1 on 15/11/11.
//  Copyright (c) 2015年 libaozi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyBoardDelegate<NSObject>
- (BOOL)changeTField:(UITextField *)textfield withString:(id)string;
@end

@interface CustomView : UIView

//toolbar上的按钮
@property (nonatomic,strong)  UIButton *btnItem;

//toolbar属性
@property (nonatomic,strong) UIToolbar *toolBar;

//toolbar上面的图标，左边标题，右边标题，确定按钮
@property (nonatomic,strong) UIBarButtonItem *space,*space1,*space2,* doneBtn;

//textField属性
//@property (nonatomic,strong) UITextField *TField;

//可变字符串用来接收输入的数字
//@property (nonatomic,strong) NSMutableString *temString;//临时可变字符串用来跟最大值做对比

//double类型的两个值，用来转换输入的字符串，并和+100，+1000，+10000 数字想加
@property (nonatomic,assign)  double num1,num2;

//警告框
@property (nonatomic,strong)  UIAlertView *alertView;

@property (nonatomic,assign) double maxNumber,decimalNumber;//最大值，小数点位数

@property (nonatomic,assign) BOOL pointFlag;

//@property (nonatomic,assign) double max

//修改键盘toolbar ，设置toolbar的图片，标题，和完成按钮的标题，颜色，事件；
-(void)setToolBarWithTarget:(id)target action:(SEL)action withTitleColor:(UIColor *)doneBtnColor;

//限制字数方法
-(void)limitWordCount:(int)count1 ;
@property(nonatomic,assign)int count1;// 限制的字数

@property (nonatomic, weak) id<KeyBoardDelegate> delegate;

//@property (nonatomic,copy) void (^pointFlagBlock)(BOOL pointFlag);
//-(BOOL)pointFlag:(BOOL)point;
-(void)keyboardPointView;
@end
@interface CustomView ()<UIKeyInput>
@property (nonatomic, weak) UITextField<UITextInput> *textInput;

@end
