//
//  MoreViewController.m
//  OA
//
//  Created by llc on 16/4/13.
//  Copyright (c) 2016年 xinpingTech. All rights reserved.
//

#import "SettingViewController.h"
#import "MyCell.h"
#import "TopItemView.h"
#import "OderItemView.h"
#import "MoneyItemView.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    UIImageView *topGroundView;//最顶部背景图
    
    UIImageView *heardImgView;
    
    UILabel *nameLB;
    
    UIImageView *topGroundView_2;
    
    TopItemView *myCollectionBT;
    TopItemView *myNotifitionBT;
    TopItemView *signBT;
    
    OderItemView *btn0;
    OderItemView *btn1;
    OderItemView *btn2;
    OderItemView *btn3;
    
    
    MoneyItemView *moneyV0;
    MoneyItemView *moneyV1;
    MoneyItemView *moneyV2;
    
    UIView *backView;
    UIView *backView2;
    
    UILabel *balanceLB;
    UILabel *couponLB;
    UILabel *integralLB;
    
    UITableView *_tableView;
}


@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kThemeColor;
    
    [self creatTopView];
    [self createTradView];
    [self createMyWalletView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.view.userInteractionEnabled = NO;
    [self loadData];
}

-(void)creatTopView{
    topGroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, currentViewWidth, [AdaptInterface convertHeightWithHeight:155])];
    topGroundView.image = [UIImage imageNamed:@"我的"];
    topGroundView.userInteractionEnabled = YES;
    [self.view addSubview:topGroundView];
    
    heardImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:60], [AdaptInterface convertWidthWithWidth:60])];
    heardImgView.center = CGPointMake([AdaptInterface convertWidthWithWidth:60], topGroundView.frame.size.height/2);
    heardImgView.layer.cornerRadius = heardImgView.frame.size.width/2;
    heardImgView.layer.masksToBounds = YES;
    heardImgView.image = [UIImage imageNamed:@"user"];
    [topGroundView addSubview:heardImgView];
    
    nameLB = [[UILabel alloc]init];
    nameLB.text = @"未登录";
    nameLB.font =[UIFont systemFontOfSize:17.5f];
    nameLB.textColor =[UIColor whiteColor];
    [topGroundView addSubview:nameLB];
    [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(heardImgView.mas_right).mas_offset(10);
        
        make.centerY.mas_equalTo(heardImgView);
    }];
    
    topGroundView_2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topGroundView.frame)-[AdaptInterface convertHeightWithHeight:45], currentViewWidth, [AdaptInterface convertHeightWithHeight:45])];
    topGroundView_2.userInteractionEnabled = YES;
    [topGroundView addSubview:topGroundView_2];
    
    myCollectionBT =[[TopItemView alloc] initWithFrame:CGRectMake(0, 0,currentViewWidth/3, CGRectGetHeight(topGroundView_2.frame))];
    myCollectionBT.textLB.text=@"我的收藏";
    myCollectionBT.numberLB.text = @"0";
    [topGroundView_2 addSubview:myCollectionBT];
    
    UIButton *collectionBt = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionBt.frame = myCollectionBT.frame;
    collectionBt.tag = 1;
    [collectionBt addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [topGroundView_2 addSubview:collectionBt];
    
    
    
    myNotifitionBT =[[TopItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(myCollectionBT.frame),0 ,currentViewWidth/3, CGRectGetHeight(topGroundView_2.frame))];
    myNotifitionBT.textLB.text=@"消息通知";
    myNotifitionBT.numberLB.text = @"0";
    [topGroundView_2 addSubview:myNotifitionBT];
    
    UIButton *notifitionBt = [UIButton buttonWithType:UIButtonTypeCustom];
    notifitionBt.frame = myNotifitionBT.frame;
    notifitionBt.tag = 2;
    [notifitionBt addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [topGroundView_2 addSubview:notifitionBt];
    
    signBT = [[TopItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(myNotifitionBT.frame),0 ,currentViewWidth/3, CGRectGetHeight(topGroundView_2.frame))];
    signBT.textLB.text=@"签    到";
    signBT.numberLB.text = @"0";
    [topGroundView_2 addSubview:signBT];
    
    UIButton *sign = [UIButton buttonWithType:UIButtonTypeCustom];
    sign.frame = signBT.frame;
    sign.tag = 3;
    [sign addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [topGroundView_2 addSubview:sign];
    
}

-(void)createTradView{
    backView =[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topGroundView_2.frame)+[AdaptInterface convertHeightWithHeight:10], currentViewWidth, [AdaptInterface convertHeightWithHeight:110])];
    backView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:backView];
    
    UIImageView *imagView =[[UIImageView alloc]initWithFrame:CGRectMake([AdaptInterface convertWidthWithWidth:10], [AdaptInterface convertHeightWithHeight:5], [AdaptInterface convertWidthWithWidth:25], [AdaptInterface convertWidthWithWidth:25])];
    imagView.contentMode = UIViewContentModeScaleAspectFit;
    imagView.image  =[UIImage imageNamed:@"我的订单"];
    [backView addSubview:imagView];
    
    UILabel *tradLbB =[UILabel new];
    tradLbB.text =@"我的订单";
    tradLbB.font = [UIFont systemFontOfSize:15.5f];
    [backView addSubview:tradLbB];
    [tradLbB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imagView.mas_right).mas_offset(3);
        make.top.mas_equalTo(imagView.mas_top);
        make.height.mas_equalTo(imagView.mas_height);
    }];
    
    UILabel *allTradLbB =[UILabel new];
    allTradLbB.text =@"全部订单  >";
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    allTradLbB.userInteractionEnabled = YES;
    [allTradLbB addGestureRecognizer:tapGesturRecognizer];
    allTradLbB.font = kTextFornt;
    [backView addSubview:allTradLbB];
    [allTradLbB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(backView.mas_right).mas_offset(-38);
        make.top.mas_equalTo(imagView.mas_top);
        make.height.mas_equalTo(imagView.mas_height);
    }];
    
    UILabel *line = [UILabel new];
    line.backgroundColor = kThemeColor;
    [backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.top.mas_equalTo(allTradLbB.mas_bottom).mas_offset(5);
        make.width.mas_offset(currentViewWidth);
        make.height.mas_offset(1);
    }];
    
    btn0 =[[OderItemView alloc]initWithFrame:CGRectMake([AdaptInterface convertWidthWithWidth:15], CGRectGetMaxY(imagView.frame)+[AdaptInterface convertHeightWithHeight:11], (currentViewWidth-75)/4, (currentViewWidth-100)/4)];
    [btn0.imgView setImage:[UIImage imageNamed:@"待付款"] forState:0];
    btn0.imgView.tag = 4;
    [btn0.imgView addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    btn0.textLB.text = @"待付款";
    [backView addSubview:btn0];
    
    btn1 =[[OderItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn0.frame)+[AdaptInterface convertWidthWithWidth:15], CGRectGetMinY(btn0.frame), CGRectGetWidth(btn0.frame), CGRectGetHeight(btn0.frame))];
    [btn1.imgView setImage:[UIImage imageNamed:@"待收货"] forState:0];
    btn1.textLB.text = @"待收货";
    btn1.imgView.tag = 5;
    [btn1.imgView addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn1];
   
    
    btn2 =[[OderItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn1.frame)+[AdaptInterface convertWidthWithWidth:15], CGRectGetMinY(btn0.frame), CGRectGetWidth(btn0.frame), CGRectGetHeight(btn0.frame))];
    [btn2.imgView setImage:[UIImage imageNamed:@"待评价"] forState:0];
    btn2.textLB.text = @"待评价";
    btn2.imgView.tag = 6;
    [btn2.imgView addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn2];
    
    
    btn3 =[[OderItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn2.frame)+[AdaptInterface convertWidthWithWidth:15], CGRectGetMinY(btn0.frame), CGRectGetWidth(btn0.frame), CGRectGetHeight(btn0.frame))];
    [btn3.imgView setImage:[UIImage imageNamed:@"退款退货"] forState:0];
    btn3.textLB.text = @"退款/退货";
    btn3.imgView.tag = 7;
    [btn3.imgView addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn3];
    
    
}
-(void)createMyWalletView{
    backView2 =[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(backView.frame)+[AdaptInterface convertHeightWithHeight:10], currentViewWidth, [AdaptInterface convertHeightWithHeight:110])];
    backView2.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:backView2];
    
    UIImageView *imagView =[[UIImageView alloc]initWithFrame:CGRectMake([AdaptInterface convertWidthWithWidth:10], [AdaptInterface convertHeightWithHeight:5], [AdaptInterface convertWidthWithWidth:25], [AdaptInterface convertWidthWithWidth:25])];
    imagView.contentMode = UIViewContentModeScaleAspectFit;
    imagView.image  =[UIImage imageNamed:@"我的钱包"];
    [backView2 addSubview:imagView];
    
    UILabel *tradLbB =[UILabel new];
    tradLbB.text =@"我的钱包";
    tradLbB.font = [UIFont systemFontOfSize:15.5f];
    [backView2 addSubview:tradLbB];
    [tradLbB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imagView.mas_right).mas_offset(3);
        make.top.mas_equalTo(imagView.mas_top);
        make.height.mas_equalTo(imagView.mas_height);
    }];
    
    UILabel *allTradLbB =[UILabel new];
    allTradLbB.text =@"资金管理  >";
    allTradLbB.font = kTextFornt;
    allTradLbB.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction2:)];
    [allTradLbB addGestureRecognizer:tapGesturRecognizer];
    [backView2 addSubview:allTradLbB];
    [allTradLbB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(backView.mas_right).mas_offset(-38);
        make.top.mas_equalTo(imagView.mas_top);
        make.height.mas_equalTo(imagView.mas_height);
    }];
    
    UILabel *line = [UILabel new];
    line.backgroundColor = kThemeColor;
    [backView2 addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.top.mas_equalTo(allTradLbB.mas_bottom).mas_offset(5);
        make.width.mas_offset(currentViewWidth);
        make.height.mas_offset(1);
    }];
    
    moneyV0 =[[MoneyItemView alloc]initWithFrame:CGRectMake([AdaptInterface convertWidthWithWidth:15], CGRectGetMaxY(imagView.frame)+[AdaptInterface convertHeightWithHeight:11], (currentViewWidth-30)/3, [AdaptInterface convertHeightWithHeight:75])];
    [moneyV0.numBT  setTitle:@"00.00" forState:0];
    moneyV0.numBT.tag = 8;
    [moneyV0.numBT addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    moneyV0.textLB.text = @"余额";
    
    [backView2 addSubview:moneyV0];
    
    moneyV1 =[[MoneyItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(moneyV0.frame), CGRectGetMinY(btn0.frame), CGRectGetWidth(moneyV0.frame), CGRectGetHeight(moneyV0.frame))];
    [moneyV1.numBT  setTitle:@"00.00" forState:0] ;
    moneyV1.numBT.tag = 9;
    [moneyV1.numBT addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    moneyV1.textLB.text = @"优惠券";
    [backView2 addSubview:moneyV1];
    
    
    moneyV2 =[[MoneyItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(moneyV1.frame), CGRectGetMinY(btn0.frame), CGRectGetWidth(moneyV0.frame), CGRectGetHeight(moneyV0.frame))];
    [moneyV2.numBT  setTitle:@"00.00" forState:0];
    moneyV2.numBT.tag = 8;
    [moneyV2.numBT addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    moneyV2.textLB.text = @"积分";
    [backView2 addSubview:moneyV2];
    
    _tableView =[[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, CGRectGetMaxY(backView2.frame)+[AdaptInterface convertHeightWithHeight:10], currentViewWidth, [AdaptInterface convertHeightWithHeight:200]);
    _tableView.backgroundColor =[UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView =[UIView new];
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AdaptInterface convertHeightWithHeight:40];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ident = @"cell";
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if(!cell){
        cell = [[MyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    switch (indexPath.row) {
        case 0:
            cell.textLB.text = @"会员升级";
            cell.imgView.image = [UIImage imageNamed:@"会员升级"];
            break;
        case 1:
            cell.textLB.text = @"我的评价";
            cell.imgView.image = [UIImage imageNamed:@"我的评价"];
            break;
        case 2:
            cell.textLB.text = @"领券中心";
            cell.imgView.image = [UIImage imageNamed:@"领券中心"];
            break;
        case 3:
            cell.textLB.text = @"浏览历史";
            cell.imgView.image = [UIImage imageNamed:@"浏览历史"];
            break;
        case 4:
            cell.textLB.text = @"地址管理";
            cell.imgView.image = [UIImage imageNamed:@"地址管理"];
            break;
            
        default:
            break;
    }
    return cell;
}
//全部订单
-(void)tapAction:(id)tap{
    HelpCenterViewController *helpVC =[[HelpCenterViewController alloc]init];
    helpVC.urlstring =  @"Mobile/User/order_list";
    [self.navigationController pushViewController:helpVC animated:YES];
}
-(void)tapAction2:(id)tap{
    HelpCenterViewController *helpVC =[[HelpCenterViewController alloc]init];
    helpVC.urlstring =  @"Mobile/User/account";
    [self.navigationController pushViewController:helpVC animated:YES];
}
-(void)buttonAction:(UIButton *)btn{
    switch (btn.tag) {
        case 1:
        {
            HelpCenterViewController *helpVC =[[HelpCenterViewController alloc]init];
            helpVC.urlstring =  @"Mobile/User/collect_list";
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
        case 2:
        {
            HelpCenterViewController *helpVC =[[HelpCenterViewController alloc]init];
            helpVC.urlstring =  @"mobile/User/message";
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
        case 3:
        {
            //            HelpCenterViewController *helpVC =[[HelpCenterViewController alloc]init];
            //            helpVC.urlstring =  @"";
            //            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
        case 4:
        {
            HelpCenterViewController *helpVC =[[HelpCenterViewController alloc]init];
            helpVC.urlstring =  @"Mobile/User/order_list/type/WAITPAY";
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
        case 5:
        {
            HelpCenterViewController *helpVC =[[HelpCenterViewController alloc]init];
            helpVC.urlstring =  @"Mobile/User/wait_receive/type/WAITRECEIVE";
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
        case 6:
        {
            HelpCenterViewController *helpVC =[[HelpCenterViewController alloc]init];
            helpVC.urlstring =  @"Mobile/User/comment/status/0";
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
        case 7:
        {
            HelpCenterViewController *helpVC =[[HelpCenterViewController alloc]init];
            helpVC.urlstring =  @"Mobile/User/return_goods_list/type/1";
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
        case 8:
        {
            HelpCenterViewController *helpVC =[[HelpCenterViewController alloc]init];
            helpVC.urlstring =  @"Mobile/User/account";
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
        case 9:
        {
            HelpCenterViewController *helpVC =[[HelpCenterViewController alloc]init];
            helpVC.urlstring =  @"Mobile/User/coupon";
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
        case 10:
        {
            HelpCenterViewController *helpVC =[[HelpCenterViewController alloc]init];
            helpVC.urlstring =  @"Mobile/Shop/intDetails/name/user";
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            HelpCenterViewController *helpVC =[[HelpCenterViewController alloc]init];
            helpVC.urlstring =  @"Mobile/User/level_add";
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
        case 1:
        {
            HelpCenterViewController *helpVC =[[HelpCenterViewController alloc]init];
            helpVC.urlstring =  @"Mobile/User/comment/status/1";
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
        case 2:
        {
            HelpCenterViewController *helpVC =[[HelpCenterViewController alloc]init];
            helpVC.urlstring =  @"Mobile/Activity/coupon_list";
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
        case 3:
        {
            HelpCenterViewController *helpVC =[[HelpCenterViewController alloc]init];
            helpVC.urlstring =  @"Mobile/User/visit_log";
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
        case 4:
        {
            HelpCenterViewController *helpVC =[[HelpCenterViewController alloc]init];
            helpVC.urlstring =  @"Mobile/User/address_list";
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}
-(void)loadData{
    [HttpManager requestDataWithURL2:@"mobile/user/index" hasHttpHeaders:YES params:nil withController:self httpMethod:@"POST" completion:^(id result) {
        
        self.view.userInteractionEnabled = YES;
        NSString *sign =  result[@"data"][@"sign"];
        NSDictionary *userDic = result[@"data"][@"user"];
        nameLB.text = userDic[@"nickname"];
        myCollectionBT.numberLB.text =[NSString stringWithFormat:@"%@",userDic[@"collect_count"]] ;
        btn2.redLB.text =[NSString stringWithFormat:@"%@",userDic[@"waitComment"]]; //待评论
        btn0.redLB.text =[NSString stringWithFormat:@"%@",userDic[@"waitPay"]]; //待支付
        btn3.redLB.text =[NSString stringWithFormat:@"%@",userDic[@"waitReceive"]];//退货
        btn1.redLB.text = [NSString stringWithFormat:@"%@",userDic[@"waitSend"]];//待发货
        if([userDic[@"waitComment"] intValue]!=0){
            [btn2 changeStatus:NO];
        }else{
            [btn2 changeStatus:YES];
        }
        
        if([userDic[@"waitPay"] intValue]!=0){
            [btn0 changeStatus:NO];
        }else{
            [btn0 changeStatus:YES];
        }
        
        if([userDic[@"waitReceive"] intValue]!=0){
            [btn3 changeStatus:NO];
        }else{
            [btn3 changeStatus:YES];
        }
        
        if([userDic[@"waitSend"] intValue]!=0){
            [btn1 changeStatus:NO];
        }else{
            [btn1 changeStatus:YES];
        }
        
        [moneyV0.numBT  setTitle:[NSString stringWithFormat:@"%@",userDic[@"user_money"]] forState:0];//余额
        [moneyV1.numBT  setTitle:[NSString stringWithFormat:@"%@",userDic[@"coupon_count"]] forState:0] ;//优惠券数
        [moneyV2.numBT  setTitle:[NSString stringWithFormat:@"%@",userDic[@"points"]] forState:0];//h积分
    } error:^(id result) {
        
    } failure:^(id result) {
        
    }];
}
@end
