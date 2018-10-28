//
//  ApplicationViewController.m
//  OA
//
//  Created by llc on 16/4/13.
//  Copyright (c) 2016年 xinpingTech. All rights reserved.
//

#import "HomeController.h"
#import"TopCollectionReusableView.h"
@interface HomeController ()<SDCycleScrollViewDelegate>
{
    
    
    TopCollectionReusableView *topView;
    
    CGFloat height;
}
/**
 展示的CollectionView
 */
@property(nonatomic, strong) UICollectionView *homeCollectionView;
@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"首页";
    self.navigationController.navigationBar.hidden = YES;
    
    [self initCollectionView];
    
}
/*初始化CollectionView*/
- (void)initCollectionView
{
    topView = [[TopCollectionReusableView alloc]initWithFrame:CGRectZero];
    height =  [topView getHeight];
    
    CGFloat tempHeight = 0;
    if (iPhoneX) {
        tempHeight = 58;
    }
    //创建布局对象
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    //每个item的宽度
    CGFloat wd;
    wd = (currentViewWidth-15)/2;
    //设置item的宽高
    flowLayOut.itemSize = CGSizeMake(wd, [AdaptInterface convertHeightWithHeight:254+3]);
    //设置行距
    flowLayOut.minimumLineSpacing = 2;
    //设置每个item之间的距离
    flowLayOut.minimumInteritemSpacing = 5;
    
    //创建collectionView
    _homeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -20, currentViewWidth, currentViewHeight-48-tempHeight+20) collectionViewLayout:flowLayOut];
    //_homeCollectionView.backgroundColor = kThemeColor;
    _homeCollectionView.backgroundColor = colorWithHexString(@"#f4f4f4");
    
    //隐藏滚动条
    _homeCollectionView.showsVerticalScrollIndicator = NO;
    //设置代理
    _homeCollectionView.delegate = self;
    _homeCollectionView.dataSource = self;
    
    //设置滚动范围偏移200
    _homeCollectionView.scrollIndicatorInsets = UIEdgeInsetsMake(height, 0, 0, 0);
    //设置内容范围偏移200
    _homeCollectionView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
    _homeCollectionView.contentOffset =CGPointMake(0,-height);
    topView.frame = CGRectMake(0, -height, currentViewWidth, height);
    [_homeCollectionView addSubview:topView];
    [self.view addSubview:_homeCollectionView];
    
    //注册cell
    [_homeCollectionView registerClass:[ProductCollectionViewCell class] forCellWithReuseIdentifier:@"home_cell"];
//    [_homeCollectionView registerClass:[TopCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    //下拉刷新
//    _homeCollectionView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self loadData];
//
//    }];
//
//    [_homeCollectionView.mj_header beginRefreshing];
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
    
    ProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"home_cell" forIndexPath:indexPath];
   
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

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//
//{
//    UICollectionReusableView *reusableview = nil;
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
//    {
//        //加载头视图
//        topView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
//        //_headerView.applictionTitles = _applictionTitles;
//        //_headerView.applicationIconNames = _applicationIconNames;
//        //topView.frame = CGRectMake(0, 0, currentViewWidth,  topView.height);
//        topView.backgroundColor = [UIColor whiteColor];
//        topView.cycleScrollView.delegate = self;
//
//        reusableview = topView;
//    }
//    return reusableview;
//
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    CGSize size = CGSizeZero;
//    CGFloat singleViewHeight = (currentViewWidth - [AdaptInterface convertWidthWithWidth:100]) / 4.0 + [AdaptInterface convertHeightWithHeight:10];
//    NSInteger rowCount = (10 - 1) / 2.0 + 1;
//    CGFloat itemViewHeight = singleViewHeight * rowCount;
//
//    CGFloat headerHeight = [AdaptInterface convertHeightWithHeight:160+8+42]+itemViewHeight;
//    if (section == 0)
//    {
//        size = CGSizeMake(currentViewWidth, headerHeight);
//    }
//    return size;
//}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"点击轮播图");
}
@end
