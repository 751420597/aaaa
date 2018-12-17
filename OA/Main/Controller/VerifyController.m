//
//  VerifyController.m
//  OA
//
//  Created by 翟凤禄 on 2018/12/3.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import "VerifyController.h"
#import "GetPassWordController.h"
@interface VerifyController ()<UITextFieldDelegate>
{
    dispatch_source_t _timer;//发送验证码倒计时
    
}
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

@implementation VerifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    
    self.view.backgroundColor = kThemeColor;
    [self createBackItemWithTarget:self];
    [self _initMainView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)_initMainView
{
    //手机号
    _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake((currentViewWidth-[AdaptInterface convertWidthWithWidth:300])/2,  [AdaptInterface convertHeightWithHeight:50], [AdaptInterface convertWidthWithWidth:300], [AdaptInterface convertHeightWithHeight:45])];
    _phoneTF.font = [UIFont fontWithName:@"Helvetica" size:16.f];
    _phoneTF.textAlignment = NSTextAlignmentLeft;
    _phoneTF.text =[NSString stringWithFormat:@"手机号:  %@",_phone];
    _phoneTF.userInteractionEnabled = NO;
    [self.view addSubview:_phoneTF];
    
    //验证码
    _verCodeTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_phoneTF.frame), CGRectGetMaxY(_phoneTF.frame) + [AdaptInterface convertHeightWithHeight:30], [AdaptInterface convertWidthWithWidth:300], [AdaptInterface convertHeightWithHeight:45])];
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
    [registerBtn setTitle:@"提交" forState:UIControlStateNormal];
    registerBtn.titleLabel.textColor = [UIColor whiteColor];
    registerBtn.titleLabel.font = kSystemFontOfSize(16);
    registerBtn.layer.cornerRadius = [AdaptInterface convertWidthWithWidth:3];
    [registerBtn addTarget:self action:@selector(registerBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    
}
-(void)registerBtn:(UIButton*)btn{
    
    if (!IS_NOT_EMPTY(_verCodeTF.text))
    {
        [AdaptInterface tipMessageTitle:@"验证码不能为空" view:self.view];
        return;
    }
    
    if ([AdaptInterface isConnected])
    {
        NSDictionary *params = @{@"code":_verCodeTF.text,@"mobile":_phone,@"type":@"mobile",@"scene":@(2)};
        [HttpManager requestDataWithURL2:@"Home/api/check_validate_code" hasHttpHeaders:YES params:params withController:self httpMethod:@"POST" completion:^(id result) {
            
            GetPassWordController *vc =[GetPassWordController new];
            [self.navigationController pushViewController:vc animated:YES];
        } error:^(id result) {
            
        } failure:^(id result) {
            
        }];
    }else
    {
        [AdaptInterface tipMessageTitle:@"无网络连接" view:self.view];
        return;
    }
}
#pragma mark - 发送验证码
- (void)sendVerifyBtn:(UIButton *)btn
{
    NSLog(@"+++++发送验证码======");
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([AdaptInterface isConnected])
    {
        
        [params setObject:@"mobile" forKey:@"type"];
        [params setObject:@(2) forKey:@"scene"];
        [params setObject:self.phone forKey:@"mobile"];
        
        [HttpManager requestDataWithURL2:@"Home/Api/send_validate_code" hasHttpHeaders:YES params:params withController:self httpMethod:@"POST" completion:^(id result) {
            int success = [result[@"status"] intValue];
            if (success == 1)
            {
                [AdaptInterface tipMessageTitle:result[@"msg"] view:self.view];
                //                 [AdaptInterface tipMessageTitle:verifyCode view:self.view];
                __block int timeout=1200; //倒计时时间
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
                                                          _countDown = [NSString stringWithFormat:@"%.2d", timeout];
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
@end
