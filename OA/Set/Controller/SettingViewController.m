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
    self.navigationController.navigationBar.hidden = YES;
    self.title =@"更多";
    
    [self creatTopView];
    [self createTradView];
    [self createMyWalletView];
}

-(void)creatTopView{
    topGroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, currentViewWidth, [AdaptInterface convertHeightWithHeight:155])];
    topGroundView.image = [UIImage imageNamed:@"我的"];
    [self.view addSubview:topGroundView];
    
    heardImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:60], [AdaptInterface convertWidthWithWidth:60])];
    heardImgView.center = CGPointMake([AdaptInterface convertWidthWithWidth:60], topGroundView.frame.size.height/2);
    heardImgView.layer.cornerRadius = heardImgView.frame.size.width/2;
    heardImgView.layer.masksToBounds = YES;
    heardImgView.image = [UIImage imageNamed:@"user"];
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
    
    topGroundView_2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topGroundView.frame)-[AdaptInterface convertHeightWithHeight:45], currentViewWidth, [AdaptInterface convertHeightWithHeight:45])];
    topGroundView_2.userInteractionEnabled = YES;
    [topGroundView addSubview:topGroundView_2];
    
    myCollectionBT =[[TopItemView alloc] initWithFrame:CGRectMake(0, 0,currentViewWidth/3, CGRectGetHeight(topGroundView_2.frame))];
    myCollectionBT.textLB.text=@"我的收藏";
    myCollectionBT.numberLB.text = @"0";
    [topGroundView_2 addSubview:myCollectionBT];
    
    UIButton *collectionBt = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionBt.frame = myCollectionBT.frame;
    [collectionBt addTarget:self action:@selector(myCollection) forControlEvents:UIControlEventTouchUpInside];
    [topGroundView_2 addSubview:collectionBt];
    
    
    
    myNotifitionBT =[[TopItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(myCollectionBT.frame),0 ,currentViewWidth/3, CGRectGetHeight(topGroundView_2.frame))];
    myNotifitionBT.textLB.text=@"消息通知";
    myNotifitionBT.numberLB.text = @"0";
    [topGroundView_2 addSubview:myNotifitionBT];
    
    UIButton *notifitionBt = [UIButton buttonWithType:UIButtonTypeCustom];
    notifitionBt.frame = myNotifitionBT.frame;
    [notifitionBt addTarget:self action:@selector(myNotifitionBt) forControlEvents:UIControlEventTouchUpInside];
    [topGroundView_2 addSubview:notifitionBt];
    
    signBT = [[TopItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(myNotifitionBT.frame),0 ,currentViewWidth/3, CGRectGetHeight(topGroundView_2.frame))];
    signBT.textLB.text=@"签    到";
    signBT.numberLB.text = @"0";
    [topGroundView_2 addSubview:signBT];
    
    UIButton *sign = [UIButton buttonWithType:UIButtonTypeCustom];
    sign.frame = signBT.frame;
    [sign addTarget:self action:@selector(sign) forControlEvents:UIControlEventTouchUpInside];
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
    btn0.textLB.text = @"待付款";
    btn0.redLB.text = @"100";
    [btn0 changeStatus:NO];
    [backView addSubview:btn0];
    
    btn1 =[[OderItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn0.frame)+[AdaptInterface convertWidthWithWidth:15], CGRectGetMinY(btn0.frame), CGRectGetWidth(btn0.frame), CGRectGetHeight(btn0.frame))];
    [btn1.imgView setImage:[UIImage imageNamed:@"待收货"] forState:0];
    btn1.textLB.text = @"待收货";
    btn1.redLB.text = @"100";
    [btn1 changeStatus:NO];
    [backView addSubview:btn1];
   
    
    btn2 =[[OderItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn1.frame)+[AdaptInterface convertWidthWithWidth:15], CGRectGetMinY(btn0.frame), CGRectGetWidth(btn0.frame), CGRectGetHeight(btn0.frame))];
    [btn2.imgView setImage:[UIImage imageNamed:@"待评价"] forState:0];
    btn2.textLB.text = @"待评价";
    btn2.redLB.text = @"100";
    [backView addSubview:btn2];
    
    
    btn3 =[[OderItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn2.frame)+[AdaptInterface convertWidthWithWidth:15], CGRectGetMinY(btn0.frame), CGRectGetWidth(btn0.frame), CGRectGetHeight(btn0.frame))];
    [btn3.imgView setImage:[UIImage imageNamed:@"退款退货"] forState:0];
    btn3.textLB.text = @"退款/退货";
    btn3.redLB.text = @"100";
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
    allTradLbB.font = kTextFornt;;
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
    [moneyV0.numBT  setTitle:@"2000.00" forState:0];
    moneyV0.textLB.text = @"余额";
    
    [backView2 addSubview:moneyV0];
    
    moneyV1 =[[MoneyItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(moneyV0.frame), CGRectGetMinY(btn0.frame), CGRectGetWidth(moneyV0.frame), CGRectGetHeight(moneyV0.frame))];
    [moneyV1.numBT  setTitle:@"2000.00" forState:0] ;
    moneyV1.textLB.text = @"优惠券";
    [backView2 addSubview:moneyV1];
    
    
    moneyV2 =[[MoneyItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(moneyV1.frame), CGRectGetMinY(btn0.frame), CGRectGetWidth(moneyV0.frame), CGRectGetHeight(moneyV0.frame))];
    [moneyV2.numBT  setTitle:@"2000.00" forState:0];
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

-(void)tapAction:(id)tap{
    NSLog(@"2222");
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    
  return YES;
    
}
@end
