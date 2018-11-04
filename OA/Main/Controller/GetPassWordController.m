//
//  GetPassWordController.m
//  OA
//
//  Created by 翟凤禄 on 2018/11/4.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import "GetPassWordController.h"

@interface GetPassWordController ()

/**
旧密码
 */
@property(nonatomic,strong) UITextField *phoneTF;

@property(nonatomic,strong) UITextField *passWordTF;

@property(nonatomic,strong) UITextField *comitPassWordTF;
@end

@implementation GetPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    
    self.view.backgroundColor = kThemeColor;
    
    UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reclaimKeyboard)];
    tapGesture.delegate= self;
    [self.view addGestureRecognizer:tapGesture];
    
    [self _initMainView];
}
/**
 *  点击空白处回收键盘
 */
-(void)reclaimKeyboard
{
    if ([_passWordTF isFirstResponder])
    {
        [_passWordTF resignFirstResponder];
    }else if ([_phoneTF isFirstResponder])
    {
        [_phoneTF resignFirstResponder];
    }else if ([_comitPassWordTF isFirstResponder]){
        [_comitPassWordTF resignFirstResponder];
    }
}

/**
 初始化视图
 */
- (void)_initMainView
{
    //手机号
    _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake((currentViewWidth-[AdaptInterface convertWidthWithWidth:300])/2,  [AdaptInterface convertHeightWithHeight:50]+65, [AdaptInterface convertWidthWithWidth:300], [AdaptInterface convertHeightWithHeight:45])];
    _phoneTF.layer.cornerRadius = [AdaptInterface convertWidthWithWidth:5];
    _phoneTF.backgroundColor =[UIColor whiteColor];
    _phoneTF.returnKeyType = UIReturnKeyDone;
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTF.delegate = self;
    _phoneTF.font = [UIFont fontWithName:@"Helvetica" size:16.f];
    //UITextField设置placeholder颜色
    _phoneTF.placeholder = @"请输入原密码";
    _phoneTF.textAlignment = NSTextAlignmentLeft;
    _phoneTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:15], 0)];
    //设置显示模式为永远显示(默认不显示)
    _phoneTF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_phoneTF];
    
    //姓名
    _passWordTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_phoneTF.frame), CGRectGetMaxY(_phoneTF.frame)+[AdaptInterface convertHeightWithHeight:30], [AdaptInterface convertWidthWithWidth:300], [AdaptInterface convertHeightWithHeight:45])];
    _passWordTF.layer.cornerRadius = [AdaptInterface convertWidthWithWidth:5];
    _passWordTF.backgroundColor =[UIColor whiteColor];
    _passWordTF.returnKeyType = UIReturnKeyDone;
    //_passWordTF.keyboardType = UIKeyboardTypeNumberPad;
    _passWordTF.delegate = self;
    _passWordTF.font = [UIFont fontWithName:@"Helvetica" size:16.f];
    //UITextField设置placeholder颜色
    _passWordTF.placeholder = @"请设置6-20位登录密码";
    _passWordTF.textAlignment = NSTextAlignmentLeft;
    _passWordTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:15], 0)];
    //设置显示模式为永远显示(默认不显示)
    _passWordTF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_passWordTF];
    
    //确认密码
    _comitPassWordTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_phoneTF.frame), CGRectGetMaxY(_passWordTF.frame)+[AdaptInterface convertHeightWithHeight:30], [AdaptInterface convertWidthWithWidth:300], [AdaptInterface convertHeightWithHeight:45])];
    _comitPassWordTF.layer.cornerRadius = [AdaptInterface convertWidthWithWidth:5];
    _comitPassWordTF.backgroundColor =[UIColor whiteColor];
    _comitPassWordTF.returnKeyType = UIReturnKeyDone;
    //_passWordTF.keyboardType = UIKeyboardTypeNumberPad;
    _comitPassWordTF.delegate = self;
    _comitPassWordTF.font = [UIFont fontWithName:@"Helvetica" size:16.f];
    //UITextField设置placeholder颜色
    _comitPassWordTF.placeholder = @"确认密码";
    _comitPassWordTF.textAlignment = NSTextAlignmentLeft;
    _comitPassWordTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:15], 0)];
    //设置显示模式为永远显示(默认不显示)
    _comitPassWordTF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_comitPassWordTF];
    
    //注册按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(CGRectGetMinX(_phoneTF.frame), CGRectGetMaxY(_comitPassWordTF.frame) + [AdaptInterface convertHeightWithHeight:24], [AdaptInterface convertWidthWithWidth:300], [AdaptInterface convertHeightWithHeight:40]);
    registerBtn.backgroundColor = [UIColor redColor];
    [registerBtn setTitle:@"确认" forState:UIControlStateNormal];
    registerBtn.titleLabel.textColor = [UIColor whiteColor];
    registerBtn.titleLabel.font = kSystemFontOfSize(16);
    registerBtn.layer.cornerRadius = [AdaptInterface convertWidthWithWidth:3];
    [registerBtn addTarget:self action:@selector(getPassWord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    
}

-(void)getPassWord{
    if ([AdaptInterface isConnected])
    {
        NSDictionary *param = @{@"old_password":_phoneTF.text,@"new_password":_passWordTF.text,@"confirm_password":_comitPassWordTF.text};
        [HttpManager requestDataWithURL2:@"mobile/user/password" hasHttpHeaders:YES params:param withController:self httpMethod:@"POST" completion:^(id result) {
            [AdaptInterface tipMessageTitle:@"修改成功" view: self.view];
        } error:^(id result) {
            
        } failure:^(id result) {
            
        }];
    }
    else
    {
        [AdaptInterface tipMessageTitle:@"无网络连接" view:self.view];
        return;
    }
}

@end
