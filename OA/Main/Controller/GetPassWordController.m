//
//  GetPassWordController.m
//  OA
//
//  Created by 翟凤禄 on 2018/11/4.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import "GetPassWordController.h"
#import "LoginViewController.h"
@interface GetPassWordController ()

@property(nonatomic,strong) UITextField *passWordTF;

@property(nonatomic,strong) UITextField *comitPassWordTF;
@end

@implementation GetPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    [self createBackItemWithTarget:self];
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
    }else if ([_comitPassWordTF isFirstResponder]){
        [_comitPassWordTF resignFirstResponder];
    }
}

/**
 初始化视图
 */
- (void)_initMainView
{
    
    //姓名
    _passWordTF = [[UITextField alloc] initWithFrame:CGRectMake((currentViewWidth-[AdaptInterface convertWidthWithWidth:300])/2,  [AdaptInterface convertHeightWithHeight:50], [AdaptInterface convertWidthWithWidth:300], [AdaptInterface convertHeightWithHeight:45])];
    _passWordTF.layer.cornerRadius = [AdaptInterface convertWidthWithWidth:5];
    _passWordTF.backgroundColor =[UIColor whiteColor];
    _passWordTF.returnKeyType = UIReturnKeyDone;
    //_passWordTF.keyboardType = UIKeyboardTypeNumberPad;
    _passWordTF.delegate = self;
    _passWordTF.font = [UIFont fontWithName:@"Helvetica" size:16.f];
    //UITextField设置placeholder颜色
    _passWordTF.placeholder = @"新密码";
    _passWordTF.textAlignment = NSTextAlignmentLeft;
    _passWordTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:15], 0)];
    //设置显示模式为永远显示(默认不显示)
    _passWordTF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_passWordTF];
    
    //确认密码
    _comitPassWordTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_passWordTF.frame), CGRectGetMaxY(_passWordTF.frame)+[AdaptInterface convertHeightWithHeight:30], [AdaptInterface convertWidthWithWidth:300], [AdaptInterface convertHeightWithHeight:45])];
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
    registerBtn.frame = CGRectMake(CGRectGetMinX(_passWordTF.frame), CGRectGetMaxY(_comitPassWordTF.frame) + [AdaptInterface convertHeightWithHeight:24], [AdaptInterface convertWidthWithWidth:300], [AdaptInterface convertHeightWithHeight:40]);
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
        NSDictionary *param = @{@"password":_passWordTF.text,@"password2":_comitPassWordTF.text,@"is_set":@"1"};
        [HttpManager requestDataWithURL2:@"mobile/user/set_pwd" hasHttpHeaders:YES params:param withController:self httpMethod:@"POST" completion:^(id result) {
            [AdaptInterface tipMessageTitle:@"修改成功" view: self.view];
            [self clearCookie];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UINavigationController *naviVc = self.navigationController;//self.navigationController表示本界面
                NSMutableArray *viewControllers = [[NSMutableArray alloc] init];//初始化一个vc的数组,用于存放跳转本界面以来的所有vc
                for (UIViewController *vc in [naviVc viewControllers]) {//遍历一路跳转到本界面以来的所有界面
                    [viewControllers addObject:vc];//将遍历出来的界面存放入数组
                    
                    //判断要回退的指定界面是否与遍历的界面相同,ZYYSeconedViewController也可以替换为ZYYThirdViewController
                    if ([vc isKindOfClass:[LoginViewController class]]) {
                        [self.navigationController popToViewController:vc animated:YES];//执行回退动作
                    }
                }
            });
            
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
-(void)clearCookie{
    if (@available(iOS 19.0, *)) {
        NSSet *websiteDataTypes = [NSSet setWithObject:WKWebsiteDataTypeCookies];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        }];
    }
    
    //删除NSHTTPCookieStorage中的cookies
    NSHTTPCookieStorage *NSCookiesStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [NSCookiesStore removeCookiesSinceDate:[NSDate dateWithTimeIntervalSince1970:0]];
    
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: @[]];
    [[NSUserDefaults standardUserDefaults] setObject:cookiesData forKey:PAWKCookiesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
