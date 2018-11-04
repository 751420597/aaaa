//
//  ForgetViewController.m
//  OA
//
//  Created by 翟凤禄 on 2018/10/31.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import "ForgetViewController.h"
#import "UIButton+WebCache.h"
#import "GetPassWordController.h"
@interface ForgetViewController ()<UITextFieldDelegate>
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
@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    
    self.view.backgroundColor = kThemeColor;
    
     [self _initMainView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self changeImage];
}
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
    _verCodeBtn.layer.cornerRadius = [AdaptInterface convertWidthWithWidth:5];
    [_verCodeBtn addTarget:self action:@selector(changeImage) forControlEvents:UIControlEventTouchUpInside];
    //设置显示模式为永远显示(默认不显示)
    _verCodeTF.rightViewMode = UITextFieldViewModeAlways;
    _verCodeTF.rightView = _verCodeBtn;
   
    
    //注册按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(CGRectGetMinX(_phoneTF.frame), CGRectGetMaxY(_verCodeTF.frame) + [AdaptInterface convertHeightWithHeight:24], [AdaptInterface convertWidthWithWidth:300], [AdaptInterface convertHeightWithHeight:40]);
    registerBtn.backgroundColor = [UIColor redColor];
    [registerBtn setTitle:@"下一步" forState:UIControlStateNormal];
    registerBtn.titleLabel.textColor = [UIColor whiteColor];
    registerBtn.titleLabel.font = kSystemFontOfSize(16);
    registerBtn.layer.cornerRadius = [AdaptInterface convertWidthWithWidth:3];
    [registerBtn addTarget:self action:@selector(registerBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    
}
-(void)registerBtn:(UIButton*)btn{
    
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
        NSDictionary *params = @{@"username":_phoneTF.text,@"verify_code":_verCodeTF.text};
        [HttpManager requestDataWithURL2:@"mobile/user/forget_pwd" hasHttpHeaders:YES params:params withController:self httpMethod:@"POST" completion:^(id result) {
            
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
-(void)changeImage{
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    //缓存web清除
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    int x = arc4random() % 100000;
    NSString *url = [NSString stringWithFormat:@"https://www.diyoupin.com/Mobile/User/verify/rand/%d.html?type=forget",x];
    [HttpManager downloadFromUrl:url success:^(id result) {
        [_verCodeBtn sd_setBackgroundImageWithURL:result forState:0];
    } faile:^(id result) {
        
    }];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
