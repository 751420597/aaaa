//
//  MessageViewController.m
//  OA
//
//  Created by llc on 16/4/13.
//  Copyright (c) 2016年 xinpingTech. All rights reserved.
//

#import "SortViewController.h"
#import "SortViewCell.h"
@interface SortViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
{
    UITableView *tableView;
    UILabel *nameLB;
    UIView * _topView;
}
@property(nonatomic ,strong)UIButton *imgBtn;
@property(nonatomic, strong) UICollectionView *homeCollectionView;
@end

@implementation SortViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =kThemeColor;
    [self initTopView];
    
    tableView = [[UITableView alloc]init];
    tableView.frame =CGRectMake(0, CGRectGetMaxY(_topView.frame), [AdaptInterface convertWidthWithWidth:100], currentViewHeight-56);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView =[UIView new];
    [self.view addSubview:tableView];
    
    self.imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imgBtn.frame = CGRectMake(CGRectGetMaxX(tableView.frame)+[AdaptInterface convertWidthWithWidth:7],CGRectGetMinY(tableView.frame)+1, currentViewWidth-CGRectGetMaxX(tableView.frame)-[AdaptInterface convertWidthWithWidth:14], [AdaptInterface convertHeightWithHeight:130]);
    self.imgBtn.backgroundColor =[UIColor blueColor];
    [self.view addSubview:self.imgBtn];
    
    nameLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.imgBtn.frame), CGRectGetMaxY(self.imgBtn.frame)+[AdaptInterface convertWidthWithWidth:5], CGRectGetWidth(self.imgBtn.frame), [AdaptInterface convertHeightWithHeight:40])];
    nameLB.text = @"全球购";
    nameLB.font = [UIFont systemFontOfSize:18.f];
    [self.view addSubview:nameLB];
    
    CGFloat tempHeight = 0;
    if (iPhoneX) {
        tempHeight = 58;
    }
    //创建布局对象
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    //每个item的宽度
    CGFloat wd;
    wd = (CGRectGetWidth(self.imgBtn.frame)-15)/3;
    //设置item的宽高
    flowLayOut.itemSize = CGSizeMake(wd, [AdaptInterface convertHeightWithHeight:110]);
    //设置行距
    flowLayOut.minimumLineSpacing = 2;
    //设置每个item之间的距离
    flowLayOut.minimumInteritemSpacing = 2;
    
    //创建collectionView
    _homeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tableView.frame)+[AdaptInterface convertWidthWithWidth:7], CGRectGetMaxY(nameLB.frame)+[AdaptInterface convertHeightWithHeight:5],CGRectGetWidth(self.imgBtn.frame), currentViewHeight-48-CGRectGetMaxY(nameLB.frame)) collectionViewLayout:flowLayOut];
    _homeCollectionView.backgroundColor = [UIColor whiteColor];
    //隐藏滚动条
    _homeCollectionView.showsVerticalScrollIndicator = NO;
    //设置代理
    _homeCollectionView.delegate = self;
    _homeCollectionView.dataSource = self;
    [self.view addSubview:_homeCollectionView];
    
    //注册cell
    [_homeCollectionView registerClass:[SortViewCell class] forCellWithReuseIdentifier:@"home_cell"];
    
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AdaptInterface convertHeightWithHeight:40];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ident = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.textLabel.text = @"分类";
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}



#pragma mark - UICollectionViewDataSource
//设置分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 10;
    
}

//设置元素内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SortViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"home_cell" forIndexPath:indexPath];
    
    return cell;
    
}

//设置显示的位置
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 5, 0, 5);
    
}

#pragma mark - UICollectionViewDelegate
//点击item响应的事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"+++++点击item响应的事件----");
    
}

- (void)initTopView
{
    CGFloat statuesHeight = 0;
    if (iPhoneX) {
        statuesHeight = 24;
    }
    _topView = [[UIView alloc] init];
    _topView.backgroundColor = [UIColor clearColor];
    _topView.frame = CGRectMake(0, 20+statuesHeight, currentViewWidth, 44);
    [self.view addSubview:_topView];
    
    //创建搜索框
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake([AdaptInterface convertWidthWithWidth:40], 44/2-[AdaptInterface convertHeightWithHeight:30/2], currentViewWidth-[AdaptInterface convertWidthWithWidth:100], [AdaptInterface convertHeightWithHeight:30]);
    [searchBtn setBackgroundColor:[UIColor whiteColor]];
    [searchBtn setImage:[UIImage imageNamed:@"home_search"] forState:UIControlStateNormal];
    [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -CGRectGetWidth(searchBtn.frame)/2-[AdaptInterface convertWidthWithWidth:110],0, 0)];
    searchBtn.layer.cornerRadius = [AdaptInterface convertHeightWithHeight:15];
    //searchBtn.alpha = 0.5;
    [searchBtn setTitle:@"请输入您所搜索的商品" forState:0];
    [searchBtn setTitleColor:[UIColor blackColor] forState:0];
    searchBtn.titleLabel.font =[UIFont systemFontOfSize:14.5];
    [searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:searchBtn];
    
    UIButton *screenButton =[UIButton buttonWithType:UIButtonTypeCustom];
    screenButton.frame = CGRectMake(CGRectGetMaxX(searchBtn.frame)+[AdaptInterface convertWidthWithWidth:5], CGRectGetMinY(searchBtn.frame), [AdaptInterface convertWidthWithWidth:40], [AdaptInterface convertHeightWithHeight:30]);
    screenButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [screenButton setTitle:@"搜索" forState:0];
    [screenButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    screenButton.titleLabel.font =[UIFont systemFontOfSize:14.5];
    [screenButton setTitleColor:[UIColor blackColor] forState:0];
    [_topView addSubview:screenButton];
    
}
-(void)searchAction:(UIButton *)btn{
    
}
-(void)loadData{
    [HttpManager requestDataWithURL2:@"mobile/user/index" hasHttpHeaders:YES params:nil withController:self httpMethod:@"POST" completion:^(id result) {
        
    } error:^(id result) {
        
    } failure:^(id result) {
        
    }];
}
@end
