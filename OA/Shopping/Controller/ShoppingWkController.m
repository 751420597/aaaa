//
//  ShoppingViewController.m
//  OA
//
//  Created by 翟凤禄 on 2018/10/15.
//  Copyright © 2018年 xinpingTech. All rights reserved.
//

#import "ShoppingWkController.h"

@interface ShoppingWkController ()
{
    UIWebView *_webViews;
    WKWebView *_wkWebView;
    
    UIProgressView *progressView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    UIImageView *imageView ;
    UIButton *button;
    UIView *backView;
}
@property (nonatomic,strong)NSArray *cookiesArr;
@end

@implementation ShoppingWkController
-(void)loadData{
    NSDictionary *param = @{@"goods_num":@[@1],@"cart_select":@[@1]};
    [HttpManager requestDataWithURL2:@"mobile/cart/ajaxCartList" hasHttpHeaders:YES params:param withController:self httpMethod:@"POST" completion:^(id result) {
        NSDictionary *userDic = result[@"data"][@"user"];
        if(userDic==nil){
            //未登录
             UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc] init]];
            [self presentViewController:navc animated:YES completion:nil];
            return ;
        }else{
            NSArray *cartList =result[@"data"][@"cartList"];
            if(cartList.count>0){
                self.urlstring = @"mobile/cart/cart";
                [self loadRequset:self.urlstring];
                
                UIView *view  = [self.view viewWithTag:200];
                view.hidden = YES;
            }else{
                UIView *view  = [self.view viewWithTag:200];
                view.hidden = NO;
                [self.view bringSubviewToFront:view];
                
            }
            
        }
        
    } error:^(id result) {
        
    } failure:^(id result) {
        
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = YES;
    [self loadData];
//    [SVProgressHUD showWithStatus:@"请稍后"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShopping = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createNativeView];
    
}
-(void)createNativeView{
    backView = [UIView new];
    backView.frame = self.view.bounds;
    backView.tag = 200;
    backView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:backView];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
    imageView.image = [UIImage imageNamed:@"nothing"];
    imageView.center = CGPointMake(self.view.center.x, self.view.center.y-80) ;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backView addSubview:imageView];
    
    UILabel *titleLb =[UILabel new];
    titleLb.text = @"购物车暂无商品";
    titleLb.frame =CGRectMake(CGRectGetMinX(imageView.frame)- 25, CGRectGetMaxY(imageView.frame), CGRectGetWidth(imageView.frame)+50, 35);
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = [UIColor lightGrayColor];
    [backView addSubview:titleLb];
    
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(CGRectGetMinX(imageView.frame), CGRectGetMaxY(titleLb.frame), CGRectGetWidth(imageView.frame), 35);
    [button setTitle:@"去逛逛" forState:0];
    [button setTitleColor:[UIColor blackColor] forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [button addTarget:self action:@selector(goShipping) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:button];
}
-(void)goShipping{
    [[NSNotificationCenter defaultCenter] postNotificationName:kGotoHome object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [super tapAction];
}

@end
