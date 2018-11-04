//
//  ShoppingViewController.m
//  OA
//
//  Created by 翟凤禄 on 2018/10/15.
//  Copyright © 2018年 xinpingTech. All rights reserved.
//

#import "ShoppingViewController.h"

@interface ShoppingViewController ()

@end

@implementation ShoppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购物车";
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self loadData];
}
-(void)loadData{
    [HttpManager requestDataWithURL2:@"mobile/user/index" hasHttpHeaders:YES params:nil withController:self httpMethod:@"POST" completion:^(id result) {
        
    } error:^(id result) {
        
    } failure:^(id result) {
        
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
