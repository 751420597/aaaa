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
    topGroundView.backgroundColor = [UIColor redColor];
    [self.view addSubview:topGroundView];
    
    heardImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:60], [AdaptInterface convertWidthWithWidth:60])];
    heardImgView.center = CGPointMake([AdaptInterface convertWidthWithWidth:60], topGroundView.center.y+10);
    heardImgView.layer.cornerRadius = heardImgView.frame.size.width/2;
    heardImgView.layer.masksToBounds = YES;
    heardImgView.image =[UIImage imageNamed:@"user"];
    [topGroundView addSubview:heardImgView];
    
    nameLB = [[UILabel alloc]init];
    nameLB.text = @"371273793724";
    nameLB.font =[UIFont systemFontOfSize:17.5f];
    nameLB.textColor =[UIColor whiteColor];
    [topGroundView addSubview:nameLB];
    [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(heardImgView.mas_right).mas_offset(10);
        
        make.centerY.mas_equalTo(heardImgView);
    }];
    
    timeLB = [UILabel new];
    timeLB.textColor = [UIColor orangeColor];
    timeLB.text = @"注册时间:2018-10-22";
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
    allTradBT.titleLabel.font = kTextFornt;
    [allTradBT setTitleColor:[UIColor redColor] forState:0];
    [backView addSubview:allTradBT];
    [allTradBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(backView.mas_right).mas_offset(-38);
        make.top.mas_equalTo(tradLbB.mas_top);
        make.height.mas_equalTo(tradLbB.mas_height);
    }];
    
    moneyItemV0 =[[MoneyItemView alloc]initWithFrame:CGRectMake([AdaptInterface convertWidthWithWidth:15],35+ [AdaptInterface convertHeightWithHeight:15], (currentViewWidth-75)/3, [AdaptInterface convertHeightWithHeight:75])];
    moneyItemV0.textLB.text = @"本周期订单(笔)";
    [moneyItemV0.numBT setTitle:@"22" forState:0];
    moneyItemV0.numBT.titleLabel.font =[UIFont systemFontOfSize:23.f];
    [backView addSubview:moneyItemV0];

    
    moneyItemV1 =[[MoneyItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(moneyItemV0.frame)+[AdaptInterface convertWidthWithWidth:15], CGRectGetMinY(moneyItemV0.frame), CGRectGetWidth(moneyItemV0.frame), CGRectGetHeight(moneyItemV0.frame))];
    moneyItemV1.textLB.text = @"待入账(元)";
    [moneyItemV1.numBT setTitle:@"22" forState:0];
    moneyItemV1.numBT.titleLabel.font =[UIFont systemFontOfSize:23.f];
    [backView addSubview:moneyItemV1];
    
    
    moneyItemV2 =[[MoneyItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(moneyItemV1.frame)+[AdaptInterface convertWidthWithWidth:15], CGRectGetMinY(moneyItemV0.frame), CGRectGetWidth(moneyItemV0.frame), CGRectGetHeight(moneyItemV0.frame))];
    moneyItemV2.textLB.text = @"收入(元)";
    [moneyItemV2.numBT setTitle:@"22" forState:0];
    moneyItemV2.numBT.titleLabel.font =[UIFont systemFontOfSize:20.f];
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
    allTradBT.titleLabel.font = kTextFornt;
    [allTradBT setTitleColor:[UIColor redColor] forState:0];
    [backView2 addSubview:allTradBT];
    [allTradBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(backView.mas_right).mas_offset(-38);
        make.top.mas_equalTo(tradLbB.mas_top);
        make.height.mas_equalTo(tradLbB.mas_height);
    }];
    
    
    btn0 =[[OderItemView alloc]initWithFrame:CGRectMake([AdaptInterface convertWidthWithWidth:15], 35 +[AdaptInterface convertHeightWithHeight:15], (currentViewWidth-75)/4, backView2.frame.size.height-35-[AdaptInterface convertHeightWithHeight:15])];
    [btn0.imgView setImage:[UIImage imageNamed:@"邀请创客"] forState:0];
    btn0.textLB.text = @"邀请创客";
    [backView2 addSubview:btn0];
    
    btn1 =[[OderItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn0.frame)+[AdaptInterface convertWidthWithWidth:15], CGRectGetMinY(btn0.frame), CGRectGetWidth(btn0.frame), CGRectGetHeight(btn0.frame))];
    [btn1.imgView setImage:[UIImage imageNamed:@"邀请云店"] forState:0];
    btn1.textLB.text = @"邀请云店";
    [backView2 addSubview:btn1];
    
    
    btn2 =[[OderItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn1.frame)+[AdaptInterface convertWidthWithWidth:15], CGRectGetMinY(btn0.frame), CGRectGetWidth(btn0.frame), CGRectGetHeight(btn0.frame))];
    [btn2.imgView setImage:[UIImage imageNamed:@"推广海报"] forState:0];
    btn2.textLB.text = @"推广海报";
    [backView2 addSubview:btn2];
    
    
    btn3 =[[OderItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn2.frame)+[AdaptInterface convertWidthWithWidth:15], CGRectGetMinY(btn0.frame), CGRectGetWidth(btn0.frame), CGRectGetHeight(btn0.frame))];
    [btn3.imgView setImage:[UIImage imageNamed:@"商城物料"] forState:0];
    btn3.textLB.text = @"商城物料";
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
-(void)loadData{
    [HttpManager requestDataWithURL2:@"mobile/user/index" hasHttpHeaders:YES params:nil withController:self httpMethod:@"POST" completion:^(id result) {
        
    } error:^(id result) {
        
    } failure:^(id result) {
        
    }];
}
@end
