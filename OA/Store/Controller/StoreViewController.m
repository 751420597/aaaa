//
//  StoreViewController.m
//  OA
//
//  Created by 翟凤禄 on 2018/10/15.
//  Copyright © 2018年 xinpingTech. All rights reserved.
//

#import "StoreViewController.h"
#import "StoreCell.h"
#import "MoneyItemView.h"
#import "OderItemView.h"
@interface StoreViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation StoreViewController
{
    UIImageView *topGroundView;//最顶部背景图
    
    UIImageView *heardImgView;
    
    UILabel *nameLB;
    
    UILabel *timeLB;
    
    UIButton *myCollectionBT;
    UIButton *myNotifitionBT;
    UIButton *signBT;
    
    OderItemView *btn0;
    OderItemView *btn1;
    OderItemView *btn2;
    OderItemView *btn3;
    
    MoneyItemView *moneyItemV0;
    MoneyItemView *moneyItemV1;
    MoneyItemView *moneyItemV2;
    
    UIView *backView;
    UIView *backView2;
    
    UILabel *balanceLB;
    UILabel *couponLB;
    UILabel *integralLB;
    
    UITableView *_tableView;
    UIButton *chuangKeBTn ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kThemeColor;
    self.title =@"小店";
    
    [self creatTopView];
    [self createTradView];
    [self createMyWalletView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self loadData];
}
-(void)creatTopView{
    topGroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, currentViewWidth, [AdaptInterface convertHeightWithHeight:130])];
    topGroundView.backgroundColor = colorWithHexString(@"#f94f50");
    topGroundView.userInteractionEnabled = YES;
    [self.view addSubview:topGroundView];
    
    chuangKeBTn =[UIButton buttonWithType:UIButtonTypeCustom];
    chuangKeBTn.frame =CGRectMake(currentViewWidth-[AdaptInterface convertWidthWithWidth:100], [AdaptInterface convertHeightWithHeight:28], [AdaptInterface convertWidthWithWidth:100], [AdaptInterface convertWidthWithWidth:28]);
    chuangKeBTn.backgroundColor = colorWithHexString(@"#f94f50");
    chuangKeBTn.layer.cornerRadius =CGRectGetHeight(chuangKeBTn.frame)/2;
    chuangKeBTn.layer.masksToBounds=YES;
    [chuangKeBTn setTitle:@"创客" forState:0];
    chuangKeBTn.titleLabel.font = [UIFont systemFontOfSize:13.5];
    chuangKeBTn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    [chuangKeBTn setImage:[UIImage imageNamed:@"chuangke"] forState:0];
    chuangKeBTn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    chuangKeBTn.tag = 102;
    [chuangKeBTn addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    [topGroundView addSubview:chuangKeBTn];
    
    
    heardImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:60], [AdaptInterface convertWidthWithWidth:60])];
    heardImgView.center = CGPointMake([AdaptInterface convertWidthWithWidth:60], topGroundView.center.y+10);
    heardImgView.layer.cornerRadius = heardImgView.frame.size.width/2;
    heardImgView.layer.masksToBounds = YES;
    heardImgView.image =[UIImage imageNamed:@"user"];
    [topGroundView addSubview:heardImgView];
    
    nameLB = [[UILabel alloc]init];
    nameLB.text = @"未开通";
    nameLB.font =[UIFont systemFontOfSize:17.5f];
    nameLB.textColor =[UIColor whiteColor];
    [topGroundView addSubview:nameLB];
    [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(heardImgView.mas_right).mas_offset(10);
        
        make.centerY.mas_equalTo(heardImgView);
    }];
    
    timeLB = [UILabel new];
    timeLB.textColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
    timeLB.text = @"注册时间:";
    timeLB.font = [UIFont systemFontOfSize:16.5f];
    [topGroundView addSubview:timeLB];
    [timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(topGroundView.mas_right).mas_offset(-15);
        make.bottom.mas_equalTo(topGroundView.mas_bottom).mas_offset(-10);
    }];
    
}
-(void)createTradView{
    backView =[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topGroundView.frame), currentViewWidth, [AdaptInterface convertHeightWithHeight:130])];
    backView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:backView];
    
    UILabel *tradLbB =[UILabel new];
    tradLbB.text =@"我的收入";
    tradLbB.font = [UIFont systemFontOfSize:18.5f];
    [backView addSubview:tradLbB];
    [tradLbB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.top.mas_offset(15);
        make.height.mas_offset(30);
    }];
    
    UIButton *allTradBT =[UIButton buttonWithType:UIButtonTypeCustom];
    [allTradBT setTitle:@"更多 >"forState:0];
    allTradBT.tag = 101;
    allTradBT.titleLabel.font = kTextFornt;
    [allTradBT addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    [allTradBT setTitleColor:[UIColor redColor] forState:0];
    [backView addSubview:allTradBT];
    [allTradBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(backView.mas_right).mas_offset(-38);
        make.top.mas_equalTo(tradLbB.mas_top);
        make.height.mas_equalTo(tradLbB.mas_height);
    }];
    
    moneyItemV0 =[[MoneyItemView alloc]initWithFrame:CGRectMake([AdaptInterface convertWidthWithWidth:15],35+ [AdaptInterface convertHeightWithHeight:15], (currentViewWidth-75)/3, [AdaptInterface convertHeightWithHeight:75])];
    moneyItemV0.textLB.text = @"本周期订单(笔)";
    [moneyItemV0.numBT setTitle:@"0" forState:0];
    moneyItemV0.numBT.tag = 5;
    [moneyItemV0.numBT addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    moneyItemV0.numBT.titleLabel.font =[UIFont systemFontOfSize:17.f];
    [backView addSubview:moneyItemV0];

    
    moneyItemV1 =[[MoneyItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(moneyItemV0.frame)+[AdaptInterface convertWidthWithWidth:15], CGRectGetMinY(moneyItemV0.frame), CGRectGetWidth(moneyItemV0.frame), CGRectGetHeight(moneyItemV0.frame))];
    moneyItemV1.textLB.text = @"待入账(元)";
    [moneyItemV1.numBT setTitle:@"0" forState:0];
    moneyItemV1.numBT.tag = 6;
    [moneyItemV1.numBT addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    moneyItemV1.numBT.titleLabel.font =[UIFont systemFontOfSize:17.f];
    [backView addSubview:moneyItemV1];
    
    
    moneyItemV2 =[[MoneyItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(moneyItemV1.frame)+[AdaptInterface convertWidthWithWidth:15], CGRectGetMinY(moneyItemV0.frame), CGRectGetWidth(moneyItemV0.frame), CGRectGetHeight(moneyItemV0.frame))];
    moneyItemV2.textLB.text = @"收入(元)";
    [moneyItemV2.numBT setTitle:@"0" forState:0];
    moneyItemV2.numBT.tag = 7;
    [moneyItemV2.numBT addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    moneyItemV2.numBT.titleLabel.font =[UIFont systemFontOfSize:17.f];
    [backView addSubview:moneyItemV2];
    
}
-(void)createMyWalletView{
    backView2 =[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(backView.frame)+[AdaptInterface convertHeightWithHeight:10], currentViewWidth, [AdaptInterface convertHeightWithHeight:130])];
    backView2.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:backView2];
    
    UILabel *tradLbB =[UILabel new];
    tradLbB.text =@"我的推广";
    tradLbB.font = [UIFont systemFontOfSize:18.5f];
    [backView2 addSubview:tradLbB];
    [tradLbB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.top.mas_offset(15);
        make.height.mas_offset(30);
    }];
    
    UIButton *allTradBT =[UIButton buttonWithType:UIButtonTypeCustom];
    [allTradBT setTitle:@"更多 >"forState:0];
    allTradBT.tag = 100;
    allTradBT.titleLabel.font = kTextFornt;
    [allTradBT setTitleColor:[UIColor redColor] forState:0];
    [allTradBT addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView2 addSubview:allTradBT];
    [allTradBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(backView.mas_right).mas_offset(-38);
        make.top.mas_equalTo(tradLbB.mas_top);
        make.height.mas_equalTo(tradLbB.mas_height);
    }];
    
    
    btn0 =[[OderItemView alloc]initWithFrame:CGRectMake([AdaptInterface convertWidthWithWidth:15], 35 +[AdaptInterface convertHeightWithHeight:15], (currentViewWidth-75)/4, backView2.frame.size.height-35-[AdaptInterface convertHeightWithHeight:15])];
    [btn0.imgView setImage:[UIImage imageNamed:@"邀请创客"] forState:0];
    btn0.imgView.tag = 1;
    [btn0.imgView addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    btn0.textLB.text = @"邀请创客";
    [backView2 addSubview:btn0];
    
    btn1 =[[OderItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn0.frame)+[AdaptInterface convertWidthWithWidth:15], CGRectGetMinY(btn0.frame), CGRectGetWidth(btn0.frame), CGRectGetHeight(btn0.frame))];
    [btn1.imgView setImage:[UIImage imageNamed:@"邀请云店"] forState:0];
    btn1.textLB.text = @"邀请云店";
    btn1.imgView.tag = 2;
    [btn1.imgView addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView2 addSubview:btn1];
    
    
    btn2 =[[OderItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn1.frame)+[AdaptInterface convertWidthWithWidth:15], CGRectGetMinY(btn0.frame), CGRectGetWidth(btn0.frame), CGRectGetHeight(btn0.frame))];
    [btn2.imgView setImage:[UIImage imageNamed:@"推广海报"] forState:0];
    btn2.imgView.tag = 3;
    [btn2.imgView addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    btn2.textLB.text = @"推广海报";
    [backView2 addSubview:btn2];
    
    
    btn3 =[[OderItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn2.frame)+[AdaptInterface convertWidthWithWidth:15], CGRectGetMinY(btn0.frame), CGRectGetWidth(btn0.frame), CGRectGetHeight(btn0.frame))];
    [btn3.imgView setImage:[UIImage imageNamed:@"商城物料"] forState:0];
    btn3.textLB.text = @"商城物料";
    btn3.imgView.tag = 4;
    [btn3.imgView addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView2 addSubview:btn3];
    
    _tableView =[[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, CGRectGetMaxY(backView2.frame), currentViewWidth, [AdaptInterface convertHeightWithHeight:180]);
    _tableView.backgroundColor =[UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView =[UIView new];
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
}
-(void)pushAction:(UIButton *)btn{
    NSString *url = @"";
    switch (btn.tag) {
        case 1:
            url =@"mobile/Shop/share/id/1";
            break;
        case 2:
            url =@"mobile/Shop/share/id/2";
            break;
        case 3:
            url =@"mobile/Shop/share/id/3";
            break;
        case 4:
            url =@"mobile/Goods/goodsList/id/12";
            break;
        case 5:
            url =@"mobile/Shop/ordIncome";
            break;
        case 6:
            url =@"mobile/Shop/ordIncome";
            break;
        case 7:
            url =@"mobile/Shop/incDetails";
            break;
        case 100:
            url =@"mobile/shop/promotion";
            break;
        case 101:
            url =@"mobile/Shop/inCome";
            break;
        case 102:
            url =@"mobile/User/level_add";
            break;
            
        default:
            break;
    }
    if (@available(iOS 14.0, *)) {
        PAWebView *helpVC =[[PAWebView alloc]init];
        helpVC.urlstring = url;
        [self.navigationController pushViewController:helpVC animated:YES];
    }else{
        HelpCenterViewController *helpVC = [[HelpCenterViewController alloc]init];
        helpVC.urlstring = url;
        [self.navigationController pushViewController:helpVC animated:YES];
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AdaptInterface convertHeightWithHeight:60];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ident = @"cell";
    StoreCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if(!cell){
        cell = [[StoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    switch (indexPath.row) {
        case 0:
            cell.textLB.text = @"我的分店";
            cell.numLB.text = @"1";
            break;
        case 1:
            cell.textLB.text = @"我的积分";
            cell.numLB.text = @"173";
            break;
        case 2:
            cell.textLB.text = @"小迪学院";
            cell.imgView.image =[UIImage imageNamed:@"小迪学院"];
            break;
            
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *url = @"";
    switch (indexPath.row) {
        case 0:
                url = @"mobile/shop/branch";
            break;
        case 1:
                url=@"mobile/shop/integral";
            break;
        case 2:
                url = @"mobile/Distribut/must_see";
            break;
            
        default:
            break;
    }
    
    if (@available(iOS 14.0, *)) {
        PAWebView *helpVC =[[PAWebView alloc]init];
        helpVC.urlstring = url;
        [self.navigationController pushViewController:helpVC animated:YES];
    }else{
        HelpCenterViewController *helpVC = [[HelpCenterViewController alloc]init];
        helpVC.urlstring = url;
        [self.navigationController pushViewController:helpVC animated:YES];
    }
}
-(void)loadData{
    [HttpManager requestDataWithURL2:@"mobile/distribut/index" hasHttpHeaders:YES params:nil withController:self httpMethod:@"POST" completion:^(id result) {
        NSDictionary *userdDic = result[@"data"][@"user"];
        if(userdDic==nil){
            //未登录
            UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc] init]];
            [self presentViewController:navc animated:YES completion:nil];
            return ;
        }
        NSString *level_name =result[@"data"][@"level_name"];
        NSString *time =[NSString stringWithFormat:@"%@",userdDic[@"reg_time"]] ;
        NSString *totalOrderNum =[NSString stringWithFormat:@"%@",result[@"data"][@"total"]] ;
        
        if ([totalOrderNum isEqualToString:@"(null)"]) {
            if (@available(iOS 14.0, *)) {
                PAWebView *vc = [[PAWebView alloc]init];
                vc.urlstring = @"Mobile/User/level_add";
                vc.tag = @"store";
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                HelpCenterViewController *vc = [[HelpCenterViewController alloc]init];
                vc.urlstring = @"Mobile/User/level_add";
                vc.tag = @"store";
                [self.navigationController pushViewController:vc animated:YES];
            }
            return;
        }
        if([totalOrderNum isEqualToString:@"<null>"]){
            totalOrderNum = @"0";
        }
        NSString *run_money = [NSString stringWithFormat:@"%@",result[@"data"][@"run_money"]] ;
        NSString *money = [NSString stringWithFormat:@"%@",result[@"data"][@"money"][@"achieve_money"]] ;
        if([money isEqualToString:@"<null>"]){
            money = @"0";
        }
        if([run_money isEqualToString:@"<null>"]){
            run_money = @"0";
        }
        
        money = [NSString stringWithFormat:@"%.2f",money.floatValue];
        run_money = [NSString stringWithFormat:@"%.2f",run_money.floatValue];
        
        NSString *total_shop = [NSString stringWithFormat:@"%@",result[@"data"][@"total_shop"]] ;
        NSString *jiFen = [NSString stringWithFormat:@"%@",result[@"data"][@"int"]] ;
        [heardImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kRequestIP,userdDic[@"head_pic"]]] placeholderImage:[UIImage imageNamed:@"user"]];
        
        [chuangKeBTn setTitle:level_name forState:0];
        nameLB.text =[NSString stringWithFormat:@"%@ - %@",userdDic[@"nickname"],level_name] ;
        timeLB.text =[NSString stringWithFormat:@"注册时间:%@",[AdaptInterface getDataByTimeStamp:time withFormatter:@"yyyy-MM-dd"]];
        [moneyItemV0.numBT setTitle:totalOrderNum forState:0];
        [moneyItemV1.numBT setTitle:run_money forState:0];
        [moneyItemV2.numBT setTitle:money forState:0];
        
        StoreCell *cell0 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        StoreCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        
        cell0.numLB.text =total_shop;
        cell1.numLB.text =jiFen;
    } error:^(id result) {
        
    } failure:^(id result) {
        
    }];
}
@end
