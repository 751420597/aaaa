//
//  MessageViewController.m
//  OA
//
//  Created by llc on 16/4/13.
//  Copyright (c) 2016年 xinpingTech. All rights reserved.
//

#import "SortViewController.h"
#import "SortViewCell.h"
#import "SortModel.h"
#import "SubSortModel.h"
@interface SortViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
{
    UITableView *tableView;
    UILabel *nameLB;
    UIView * _topView;
    NSDictionary *imageDic;
}
@property(nonatomic ,strong)UIButton *imgBtn;
@property(nonatomic, strong) UICollectionView *homeCollectionView;
@property(nonatomic,strong)NSMutableArray *categoryTreeArr;
@property(nonatomic,strong)NSMutableArray *subCategoryArr;
@end

@implementation SortViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self loadData];
    [self getDataforHDP];
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
    self.imgBtn.backgroundColor =[UIColor whiteColor];
    self.imgBtn.userInteractionEnabled = NO;
    [self.imgBtn addTarget:self action:@selector(linkAction) forControlEvents:UIControlEventTouchUpInside];
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
    return self.categoryTreeArr.count;
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
    SortModel *model = self.categoryTreeArr[indexPath.row];
    cell.textLabel.text = model.name;
    cell.textLabel.font = [UIFont systemFontOfSize:13.5f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self getSubMenu:indexPath];
}


#pragma mark - UICollectionViewDataSource
//设置分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.subCategoryArr.count;
}

//设置元素内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SortViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"home_cell" forIndexPath:indexPath];
    SubSortModel *model = self.subCategoryArr[indexPath.row];
    cell.titleLB.text = model.name;
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:model.imgeUrl]];
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
    SubSortModel *model = self.subCategoryArr[indexPath.row];
    NSString *url = [NSString stringWithFormat:@"mobile/goods/goodsList/id/%@",model.id];
    HelpCenterViewController *vc = [[HelpCenterViewController alloc]init];
    vc.urlstring = url;
    [self.navigationController pushViewController:vc animated:YES];
    
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
    searchBtn.frame = CGRectMake([AdaptInterface convertWidthWithWidth:40], 44/2-[AdaptInterface convertHeightWithHeight:30/2], currentViewWidth-[AdaptInterface convertWidthWithWidth:80], [AdaptInterface convertHeightWithHeight:30]);
    [searchBtn setBackgroundColor:[UIColor whiteColor]];
    [searchBtn setImage:[UIImage imageNamed:@"home_search"] forState:UIControlStateNormal];
    //[searchBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -CGRectGetWidth(searchBtn.frame)/2-[AdaptInterface convertWidthWithWidth:110],0, 0)];
    searchBtn.layer.cornerRadius = [AdaptInterface convertHeightWithHeight:15];
    //searchBtn.alpha = 0.5;
    [searchBtn setTitle:@"请输入您所搜索的商品" forState:0];
    [searchBtn setTitleColor:[UIColor lightGrayColor] forState:0];
    searchBtn.titleLabel.font =[UIFont systemFontOfSize:14.5];
    [searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:searchBtn];
    
//    UIButton *screenButton =[UIButton buttonWithType:UIButtonTypeCustom];
//    screenButton.frame = CGRectMake(CGRectGetMaxX(searchBtn.frame)+[AdaptInterface convertWidthWithWidth:5], CGRectGetMinY(searchBtn.frame), [AdaptInterface convertWidthWithWidth:40], [AdaptInterface convertHeightWithHeight:30]);
//    screenButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    [screenButton setTitle:@"搜索" forState:0];
//    [screenButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
//    screenButton.titleLabel.font =[UIFont systemFontOfSize:14.5];
//    [screenButton setTitleColor:[UIColor blackColor] forState:0];
//    [_topView addSubview:screenButton];
    
}
-(void)searchAction:(UIButton *)btn{
    HelpCenterViewController *helpVC =[[HelpCenterViewController alloc]init];
    helpVC.urlstring =  @"mobile/Goods/ajaxSearch";
    [self.navigationController pushViewController:helpVC animated:YES];
}
-(void)loadData{
    [HttpManager requestDataWithURL2:@"mobile/goods/categoryList" hasHttpHeaders:YES params:nil withController:self httpMethod:@"POST" completion:^(id result) {
        NSDictionary *goodsCategoryTree = result[@"data"][@"goods_category_tree"];
        NSArray *allKeys= goodsCategoryTree.allKeys;
        self.categoryTreeArr = [NSMutableArray array];
        for (NSString *key in allKeys) {
            SortModel *model = [[SortModel alloc]initSortModelWithDic:goodsCategoryTree[key]];
            [self.categoryTreeArr addObject:model];
        }
        [tableView reloadData];
        [self getSubMenu:[NSIndexPath indexPathForRow:0 inSection:0]];
    } error:^(id result) {
        
    } failure:^(id result) {
        
    }];
    
}
-(void)getSubMenu:(NSIndexPath *)index{
    self.subCategoryArr =[NSMutableArray array];
    SortModel *model = self.categoryTreeArr[index.row];
    
    NSDictionary *dic = model.tmenu[0];
    nameLB.text = dic[@"name"];
    
    NSArray *arr =dic[@"sub_menu"];
    for (NSDictionary *subDic in arr) {
        SubSortModel *subModel = [[SubSortModel alloc]initSubSortModelWithDic:subDic];
        [self.subCategoryArr addObject:subModel];
    }
    [_homeCollectionView reloadData];
}
//获取幻灯片
-(void)getDataforHDP{
    [HttpManager requestDataWithURL2:@"Home/Api/getAdData" hasHttpHeaders:YES params:@{@"pid":@(400),@"limit":@(1)} withController:self httpMethod:@"POST" completion:^(id result) {
        imageDic =result[0];
        [self.imgBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kRequestIP,imageDic[@"ad_code"]]] forState:0];
        self.imgBtn.userInteractionEnabled = YES;
    } error:^(id result) {
        
    } failure:^(id result) {
        
    }];
}
-(void)linkAction{
    HelpCenterViewController *helpVC =[[HelpCenterViewController alloc]init];
    helpVC.urlstring =  imageDic[@"ad_link"];
    [self.navigationController pushViewController:helpVC animated:YES];
}
@end
