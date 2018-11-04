//
//  LoginViewController.m
//  Enjoylove
//
//  Created by snowflake1993922 on 2017/12/14.
//  Copyright © 2017年 yxh. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "MainViewController.h"
#import "LoginCell.h"
#import "LoginView.h"
#import "UIButton+WebCache.h"
#import "ForgetViewController.h"

@interface LoginViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *_tableView;

}


/**
 注册按钮
 */
@property(nonatomic,strong)UIButton *registerBtn;
@property(nonatomic,strong)UIButton *loginBtn;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [[IQKeyboardManager sharedManager] setEnable:YES];
    UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reclaimKeyboard)];
    tapGesture.delegate= self;
    [self.view addGestureRecognizer:tapGesture];
    
    [self _initMainView];
}

/**
 初始化视图
 */
- (void)_initMainView
{
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((currentViewWidth-[AdaptInterface convertWidthWithWidth:336/2])/2, [AdaptInterface convertHeightWithHeight:107], [AdaptInterface convertWidthWithWidth:336/2], [AdaptInterface convertHeightWithHeight:108/2])];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    iconImageView.image = [UIImage imageNamed:@"login_logo"];
    [self.view addSubview:iconImageView];
    
    _tableView =[[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, CGRectGetMaxY(iconImageView.frame), currentViewWidth, [AdaptInterface convertHeightWithHeight:180]);
    _tableView.backgroundColor =[UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView =[UIView new];
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.frame = CGRectMake([AdaptInterface convertWidthWithWidth:30], CGRectGetMaxY(_tableView.frame)+[AdaptInterface convertHeightWithHeight:40], currentViewWidth-[AdaptInterface convertWidthWithWidth:60], [AdaptInterface convertHeightWithHeight:60]);
    self.loginBtn.backgroundColor =[UIColor redColor];
    self.loginBtn.layer.cornerRadius = 4;
    [self.loginBtn setTitle:@"登录" forState:0];
    [self.loginBtn addTarget:self action:@selector(LoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
    
    
    LoginView *autoLoginView =[[LoginView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.loginBtn.frame), CGRectGetMaxY(self.loginBtn.frame)+[AdaptInterface convertHeightWithHeight:40], [AdaptInterface convertWidthWithWidth:120], [AdaptInterface convertHeightWithHeight:30])];
    autoLoginView.imgView.image = [UIImage imageNamed:@""];
    [autoLoginView.keyBtn setTitle:@"自动登录" forState:0];
    [self.view addSubview:autoLoginView];
    
    LoginView *resignView =[[LoginView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.loginBtn.frame), CGRectGetMaxY(autoLoginView.frame)+[AdaptInterface convertHeightWithHeight:40], [AdaptInterface convertWidthWithWidth:120], [AdaptInterface convertHeightWithHeight:30])];
    resignView.imgView.image = [UIImage imageNamed:@""];
    [resignView.keyBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [resignView.keyBtn setTitle:@"快速注册" forState:0];
    [self.view addSubview:resignView];
    
    LoginView *forgetView =[[LoginView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.loginBtn.frame)-[AdaptInterface convertWidthWithWidth:130], CGRectGetMaxY(autoLoginView.frame)+[AdaptInterface convertHeightWithHeight:40], [AdaptInterface convertWidthWithWidth:120], [AdaptInterface convertHeightWithHeight:30])];
    forgetView.imgView.image = [UIImage imageNamed:@""];
    [forgetView.keyBtn setTitle:@"忘记密码" forState:0];
    [forgetView.keyBtn addTarget:self action:@selector(forgetAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AdaptInterface convertHeightWithHeight:60];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ident = @"cell";
    LoginCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if(!cell){
        cell = [[LoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    switch (indexPath.row) {
        case 0:
            cell.keyLB.text = @"账号";
            cell.valueTF.placeholder = @"请输入邮箱/手机号";
            cell.btn.hidden = YES;
            break;
            
        case 1:
            cell.keyLB.text = @"密码";
            cell.valueTF.placeholder = @"请输入密码";
            cell.btn.hidden = YES;
            break;
            
        case 2:
        {
            cell.keyLB.text = @"验证码";
            cell.valueTF.placeholder = @"请输入邮箱/手机号";
            cell.btn.hidden = NO;
            
            int x = arc4random() % 100000;
            NSString *url = [NSString stringWithFormat:@"https://www.diyoupin.com/Mobile/User/verify/rand/%d.html",x];
            [HttpManager downloadFromUrl:url success:^(id result) {
                [cell.btn sd_setBackgroundImageWithURL:result forState:0];
            } faile:^(id result) {
                
            }];
        }
            break;
            
        default:
            break;
    }
    return cell;
    
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}


- (void)LoginBtn:(UIButton *)sender
{
    NSLog(@"登录");
    LoginCell *cell0 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    LoginCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    LoginCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    NSString *phone = cell0.valueTF.text;
    NSString *passWord = cell1.valueTF.text;
    NSString *code = cell2.valueTF.text;
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    if ([AdaptInterface isConnected])
    {
        NSDictionary *param = @{@"username":phone,@"password":passWord,@"verify_code":code};
        [HttpManager requestDataWithURL2:@"mobile/user/do_login" hasHttpHeaders:YES params:param withController:self httpMethod:@"POST" completion:^(id result) {
            NSDictionary *data = result[@"result"];
            NSString *token =data[@"token"];
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [UIApplication sharedApplication].delegate.window.rootViewController = [[MainViewController alloc] init];
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

#pragma mark - 无账号，快速注册
- (void)registerAction
{
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    
    [self.navigationController pushViewController:registerVC animated:YES];
}
-(void)forgetAction{
    ForgetViewController *registerVC = [[ForgetViewController alloc] init];
    
    [self.navigationController pushViewController:registerVC animated:YES];
}
-(void)reclaimKeyboard{
    LoginCell *cell0 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    LoginCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    LoginCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    [cell0.valueTF resignFirstResponder];
    [cell1.valueTF resignFirstResponder];
    [cell2.valueTF resignFirstResponder];
}
@end