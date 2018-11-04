//
//  RegisterViewController.m
//  Enjoylove
//
//  Created by snowflake1993922 on 2017/12/15.
//  Copyright © 2017年 yxh. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
@interface RegisterViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    dispatch_source_t _timer;//发送验证码倒计时
    
}
/**
 姓名
 */
@property(nonatomic,strong) UITextField *passWordTF;

@property(nonatomic,strong) UITextField *comitPassWordTF;
@property(nonatomic,strong) UITextField *peopleTF;

/**
 手机号
 */
@property(nonatomic,strong) UITextField *phoneTF;

/**
 验证码
 */
@property(nonatomic,strong) UITextField *verCodeTF;

/**
 发送验证码button
 */
@property(nonatomic,strong) UIButton *verCodeBtn;

/**
 倒计时
 */
@property(nonatomic,strong)NSString *downTime;


@property(nonatomic,strong)NSString *countDown;//倒计时

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    
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
    }else if ([_verCodeTF isFirstResponder])
    {
        [_verCodeTF resignFirstResponder];
    }else if ([_comitPassWordTF isFirstResponder]){
        [_comitPassWordTF resignFirstResponder];
    }else if ([_peopleTF isFirstResponder]){
        [_peopleTF resignFirstResponder];
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
    _phoneTF.placeholder = @"请输入手机号码";
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
    
    //推荐人
    _peopleTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_phoneTF.frame), CGRectGetMaxY(_comitPassWordTF.frame)+[AdaptInterface convertHeightWithHeight:30], [AdaptInterface convertWidthWithWidth:300], [AdaptInterface convertHeightWithHeight:45])];
    _peopleTF.layer.cornerRadius = [AdaptInterface convertWidthWithWidth:5];
    _peopleTF.backgroundColor =[UIColor whiteColor];
    _peopleTF.returnKeyType = UIReturnKeyDone;
    //_passWordTF.keyboardType = UIKeyboardTypeNumberPad;
    _peopleTF.delegate = self;
    _peopleTF.font = [UIFont fontWithName:@"Helvetica" size:16.f];
    //UITextField设置placeholder颜色
    _peopleTF.placeholder = @"推荐人id";
    _peopleTF.textAlignment = NSTextAlignmentLeft;
    _peopleTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:15], 0)];
    //设置显示模式为永远显示(默认不显示)
    _peopleTF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_peopleTF];
    
    
    //验证码
    _verCodeTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_phoneTF.frame), CGRectGetMaxY(_peopleTF.frame) + [AdaptInterface convertHeightWithHeight:30], [AdaptInterface convertWidthWithWidth:300], [AdaptInterface convertHeightWithHeight:45])];
    _verCodeTF.layer.cornerRadius = [AdaptInterface convertWidthWithWidth:5];
    _verCodeTF.backgroundColor =[UIColor whiteColor];
    _verCodeTF.returnKeyType = UIReturnKeyDone;
    //    passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    _verCodeTF.delegate = self;
    _verCodeTF.font = [UIFont fontWithName:@"Helvetica" size:16.f];
    //UITextField设置placeholder颜色
    _verCodeTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: colorWithHexString(@"c4c8cd")}];
    _verCodeTF.textAlignment = NSTextAlignmentLeft;
    //_verCodeTF.secureTextEntry = YES;
    _verCodeTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:15], 0)];
    //设置显示模式为永远显示(默认不显示)
    _verCodeTF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_verCodeTF];
    
    _verCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _verCodeBtn.frame = CGRectMake(0,[AdaptInterface convertHeightWithHeight:5],[AdaptInterface convertWidthWithWidth:120], [AdaptInterface convertHeightWithHeight:45]);
    _verCodeBtn.backgroundColor = [UIColor redColor];
    _verCodeBtn.layer.cornerRadius = [AdaptInterface convertWidthWithWidth:5];
    [_verCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _verCodeBtn.titleLabel.font = kSystemFontOfSize(14.f);
    _verCodeBtn.titleLabel.textColor = colorWithHexString(@"#ffffff");
    [_verCodeBtn addTarget:self action:@selector(sendVerifyBtn:) forControlEvents:UIControlEventTouchUpInside];
    //设置显示模式为永远显示(默认不显示)
    _verCodeTF.rightViewMode = UITextFieldViewModeAlways;
    _verCodeTF.rightView = _verCodeBtn;
    
    //注册按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(CGRectGetMinX(_phoneTF.frame), CGRectGetMaxY(_verCodeTF.frame) + [AdaptInterface convertHeightWithHeight:24], [AdaptInterface convertWidthWithWidth:300], [AdaptInterface convertHeightWithHeight:40]);
    registerBtn.backgroundColor = [UIColor redColor];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.textColor = [UIColor whiteColor];
    registerBtn.titleLabel.font = kSystemFontOfSize(16);
    registerBtn.layer.cornerRadius = [AdaptInterface convertWidthWithWidth:3];
    [registerBtn addTarget:self action:@selector(registerBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
   
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (_passWordTF == textField)  //判断是否时我们想要限定的那个输入框
    {
        //姓名不超过10位
        if ([toBeString length] >= 10) { //如果输入框内容大于10则不允许输入
            textField.text = [toBeString substringToIndex:10];
            return NO;
        }
    }
    else if (_phoneTF == textField)
    {
        //手机号不超过11位
        if ([toBeString length] >= 11) { //如果输入框内容大于11则不允许输入
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
    }
    return YES;
}


#pragma mark - 发送验证码
- (void)sendVerifyBtn:(UIButton *)btn
{
    NSLog(@"+++++发送验证码======");
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    if (!IS_NOT_EMPTY(_phoneTF.text))
    {
        [AdaptInterface tipMessageTitle:@"请输入手机号/邮箱" view:self.view];
        return;
    }
    if (!IS_NOT_EMPTY(_passWordTF.text))
    {
        [AdaptInterface tipMessageTitle:@"请输入密码" view:self.view];
        return;
    }
    
    if ( ![_comitPassWordTF.text isEqualToString:_passWordTF.text])
    {
        [AdaptInterface tipMessageTitle:@"请确认密码" view:self.view];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([AdaptInterface isConnected])
    {
        
        [params setObject:@"mobile" forKey:@"type"];
        [params setObject:@(1) forKey:@"scene"];
        [params setObject:_phoneTF.text forKey:@"mobile"];
       
        [HttpManager requestDataWithURL2:@"Home/Api/send_validate_code" hasHttpHeaders:YES params:params withController:self httpMethod:@"POST" completion:^(id result) {
            int success = [result[@"status"] intValue];
            if (success == 1)
            {
                [AdaptInterface tipMessageTitle:result[@"msg"] view:self.view];
                //                 [AdaptInterface tipMessageTitle:verifyCode view:self.view];
                __block int timeout=120; //倒计时时间
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                dispatch_source_set_event_handler(_timer, ^
                                                  {
                                                      if(timeout<=0)
                                                      { //倒计时结束，关闭
                                                          dispatch_source_cancel(_timer);
                                                          dispatch_async(dispatch_get_main_queue(), ^
                                                                         {
                                                                             //设置界面的按钮显示 根据自己需求设置
                                                                             [btn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
                                                                             btn.backgroundColor = [UIColor redColor];
                                                                             btn.userInteractionEnabled = YES;
                                                                         });
                                                      }else{
                                                          int seconds = timeout % 120;
                                                          if (seconds == 0)
                                                          {
                                                              seconds = 120;
                                                          }
                                                          _countDown = [NSString stringWithFormat:@"%.2d", seconds];
                                                          dispatch_async(dispatch_get_main_queue(), ^
                                                                         {
                                                                             //设置界面的按钮显示 根据自己需求设置
                                                                             [btn setTitle: [NSString stringWithFormat:@"%@%@",_countDown, @"秒后重新发送"] forState:UIControlStateNormal];
                                                                             btn.backgroundColor = [UIColor lightGrayColor];
                                                                             btn.userInteractionEnabled = NO;
                                                                             
                                                                         });
                                                          timeout--;
                                                      }
                                                  });
                dispatch_resume(_timer);
                btn.userInteractionEnabled = YES;
                btn.backgroundColor = [UIColor redColor];
                
            }else
            {
                [AdaptInterface tipMessageTitle:result[@"msg"] view:self.view];
                btn.userInteractionEnabled = YES;
                btn.backgroundColor = [UIColor redColor];
            }
        } error:^(id result) {
            btn.userInteractionEnabled = YES;
            btn.backgroundColor = [UIColor redColor];
        } failure:^(id result) {
            btn.userInteractionEnabled = YES;
            btn.backgroundColor = [UIColor redColor];
        }];
        

    }
    else
    {
        [AdaptInterface tipMessageTitle:@"无网络连接" view:self.view];
        return;
    }
}


#pragma mark - 注册提交信息
- (void)registerBtn:(UIButton *)btn
{
    
    NSLog(@"+++++注册提交信息======");
    if (!IS_NOT_EMPTY(_passWordTF.text))
    {
        [AdaptInterface tipMessageTitle:@"密码不能为空" view:self.view];
        return;
    }
    if (!IS_NOT_EMPTY(_phoneTF.text))
    {
        [AdaptInterface tipMessageTitle:@"账号不能为空" view:self.view];
        return;
    }
    if (!IS_NOT_EMPTY(_verCodeTF.text))
    {
        [AdaptInterface tipMessageTitle:@"验证码不能为空" view:self.view];
        return;
    }
    
    if ([AdaptInterface isConnected])
    {
        NSDictionary *params = @{@"username":_phoneTF.text,@"password":_passWordTF.text,@"password2":_comitPassWordTF.text,@"invitationId":_peopleTF.text,@"mobile_code":_verCodeTF.text,@"scene":@(1)};
        [HttpManager requestDataWithURL2:@"mobile/user/reg" hasHttpHeaders:YES params:params withController:self httpMethod:@"POST" completion:^(id result) {
            
            [self.navigationController popViewControllerAnimated:YES];
        } error:^(id result) {
            
        } failure:^(id result) {
            
        }];
    }else
    {
        [AdaptInterface tipMessageTitle:@"无网络连接" view:self.view];
        return;
    }
    
    

}


@end
