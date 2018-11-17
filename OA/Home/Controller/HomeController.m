//
//  ApplicationViewController.m
//  OA
//
//  Created by llc on 16/4/13.
//  Copyright (c) 2016年 xinpingTech. All rights reserved.
//

#import "HomeController.h"
#import"TopCollectionReusableView.h"
#import "UIImageView+HighlightedWebCache.h"
#import "HomeModel.h"
#import "LocationManager.h"
@interface HomeController ()<SDCycleScrollViewDelegate>
{
 
    TopCollectionReusableView *topView;
    
    CGFloat height;
    LocationManager *locationManger;
    
    int pageCount;
}
/**
 展示的CollectionView
 */
@property(nonatomic, strong) UICollectionView *homeCollectionView;
@property(nonatomic, strong) NSArray *yanxuanArr;
@property(nonatomic, strong) NSMutableArray *favouriteGoodArr;
@property(nonatomic, strong) NSArray *adArr;//广告
@property(nonatomic, strong) NSArray *iconeArr;//广告
@property(nonatomic, strong) NSDictionary *dicYX1;
@property(nonatomic, strong) NSDictionary *dicYX2;
@property(nonatomic, strong) NSDictionary *dicYX3;
@property(nonatomic,strong) NSString *infoStr;
@end

@implementation HomeController
-(NSArray *)yanxuanArr{
    if(_yanxuanArr==nil){
        self.yanxuanArr = [NSArray array];
    }
    return _yanxuanArr;
}
-(NSMutableArray *)favouriteGoodArr{
    if(_favouriteGoodArr==nil){
        self.favouriteGoodArr = [NSMutableArray array];
    }
    return _favouriteGoodArr;
}
-(NSArray *)adArr{
    if(_adArr==nil){
        self.adArr = [NSArray array];
    }
    return _adArr;
}
-(NSArray *)iconeArr{
    if(_iconeArr==nil){
        self.iconeArr = [NSArray array];
    }
    return _iconeArr;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self loadData];
    [self getDataforYX1];
    [self getDataforYX2];
    [self getDataforYX3];
   
    [self getIconData];
    [self getDataforHDP];
    [self getCollections];
    if(topView&&topView.scrollLable){
        [topView.scrollLable refreshLabels];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"首页";
    
    [self initCollectionView];
}
-(void)getLocation:(NSNotification *)info{
    NSDictionary *dic = info.userInfo;
    NSString *location = dic[@"location"];
    topView.addressLB.text = location;
}
/*初始化CollectionView*/
- (void)initCollectionView
{
    topView = [[TopCollectionReusableView alloc]initWithFrame:CGRectZero];
    __weak typeof(self) weakSelf = self;
    topView.block = ^(NSString *link, NSInteger index) {
        PAWebView *helpVC =[[PAWebView alloc]init];
        helpVC.urlstring = link;
        [weakSelf.navigationController pushViewController:helpVC animated:YES];
    };
    topView.blockLink = ^(NSString *link, NSInteger index) {
        PAWebView *helpVC =[[PAWebView alloc]init];
        helpVC.urlstring = link;
        [weakSelf.navigationController pushViewController:helpVC animated:YES];
    };
    topView.blockSudokuLink = ^(NSString *link, NSInteger index) {
        PAWebView *helpVC =[[PAWebView alloc]init];
        helpVC.urlstring = link;
        [weakSelf.navigationController pushViewController:helpVC animated:YES];
    };
    
    topView.blockAdLink= ^(NSString *link, NSInteger index) {
        PAWebView *helpVC =[[PAWebView alloc]init];
        helpVC.urlstring = link;
        [weakSelf.navigationController pushViewController:helpVC animated:YES];
    };
    topView.blockAdLink= ^(NSString *link, NSInteger index) {
        PAWebView *helpVC =[[PAWebView alloc]init];
        helpVC.urlstring = link;
        [weakSelf.navigationController pushViewController:helpVC animated:YES];
    };
    topView.blockTap= ^(NSString *link, NSInteger index) {
        PAWebView *helpVC =[[PAWebView alloc]init];
        helpVC.urlstring = link;
        [weakSelf.navigationController pushViewController:helpVC animated:YES];
    };
    height =  [topView getHeight];
    
    CGFloat tempHeight = 0;
    if (iPhoneX||iPhoneXr||iPhoneXs||iPhoneX_Max) {
        tempHeight = 44;
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
    _homeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0-tempHeight, currentViewWidth, currentViewHeight-48+tempHeight) collectionViewLayout:flowLayOut];
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
//    _homeCollectionView.header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self loadData];
//
//    }];
//
//    [_homeCollectionView.header beginRefreshing];
    _homeCollectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        pageCount++;
        [self getCollections];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLocation:) name:@"location" object:nil];
    locationManger = [LocationManager shareManager];
    [locationManger startGPS];
}


#pragma mark - UICollectionViewDataSource
//设置分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.favouriteGoodArr.count;
    
}

//设置元素内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"home_cell" forIndexPath:indexPath];
//    NSDictionary *dic = self.favouriteGoodArr[indexPath];
//    NSString *url = [NSString stringWithFormat:@"%@%@",kRequestIP,[@"original_img"]];
//    [cell.commodityImg sd_setHighlightedImageWithURL:[NSURL URLWithString: ];
    HomeModel *model=  self.favouriteGoodArr[indexPath.row];
    [cell.commodityImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kRequestIP,model.imageUrl]]];
    cell.commodityNameLabel.text = model.comment;
    cell.commodityPriceLabel.text = model.price;
     __weak typeof(self) weakSelf = self;
    cell.block = ^(NSString * _Nonnull link, NSInteger index) {
        PAWebView *helpVC =[[PAWebView alloc]init];
        helpVC.urlstring =[NSString stringWithFormat:@"Mobile/Goods/goodsList/id/%@", model.idStr2];
        [weakSelf.navigationController pushViewController:helpVC animated:YES];
    };
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
    HomeModel *model=  self.favouriteGoodArr[indexPath.row];
    PAWebView *helpVC =[[PAWebView alloc]init];
    helpVC.urlstring = [NSString stringWithFormat:@"mobile/Goods/goodsInfo/id/%@",model.idStr];
    [self.navigationController pushViewController:helpVC animated:YES];
}

-(void)loadData{
    [HttpManager requestDataWithURL2:@"Mobile/Index/index" hasHttpHeaders:YES params:nil withController:self httpMethod:@"POST" completion:^(id result) {
        self.yanxuanArr = result[@"data"][@"ad_list"];
        self.infoStr = result[@"data"][@"info"][@"info"];
        topView.yanxuanArr = self.yanxuanArr;
        topView.info = self.infoStr;
        topView.messageLB.text =[NSString stringWithFormat:@"消息(%@)",result[@"data"][@"get_num"]];
    } error:^(id result) {
        
    } failure:^(id result) {
        
    }];
}
//获取幻灯片
-(void)getDataforHDP{
    [HttpManager requestDataWithURL2:@"Home/Api/getAdData" hasHttpHeaders:YES params:@{@"pid":@(2),@"limit":@(3)} withController:self httpMethod:@"POST" completion:^(id result) {
        self.adArr = result;
        topView.adArr = self.adArr;
    } error:^(id result) {
        
    } failure:^(id result) {
        
    }];
}
//获取品牌
-(void)getIconData{
    [HttpManager requestDataWithURL2:@"Home/Api/getBrandList" hasHttpHeaders:YES params:@{@"limit":@(8)} withController:self httpMethod:@"POST" completion:^(id result) {
        self.iconeArr = result;
        topView.iconeArr = self.iconeArr;
    } error:^(id result) {
        
    } failure:^(id result) {
        
    }];
}
//获取shangpin
-(void)getCollections{
    [HttpManager requestDataWithURL2:@"mobile/index/ajaxGetMore" hasHttpHeaders:YES params:@{@"p":@(pageCount)} withController:self httpMethod:@"POST" completion:^(id result) {
        NSArray *array = result[@"data"][@"favourite_goods"];
        for (NSDictionary *dic in array) {
            HomeModel *model = [[HomeModel alloc]initHomeModelWithDic:dic];
            [self.favouriteGoodArr addObject:model];
        }
        [_homeCollectionView reloadData];
        [_homeCollectionView.footer endRefreshing];
    } error:^(id result) {
        
    } failure:^(id result) {
        
    }];
}
//获取严选
-(void)getDataforYX1{
    [HttpManager requestDataWithURL2:@"Home/Api/getAdData" hasHttpHeaders:YES params:@{@"pid":@(303)} withController:self httpMethod:@"POST" completion:^(id result) {
        self.dicYX1 =[NSDictionary dictionary] ;
        self.dicYX1 = result[0];
        topView.dicYX1 = self.dicYX1;
    } error:^(id result) {
        
    } failure:^(id result) {
        
    }];
}
-(void)getDataforYX2{
    [HttpManager requestDataWithURL2:@"Home/Api/getAdData" hasHttpHeaders:YES params:@{@"pid":@(304)} withController:self httpMethod:@"POST" completion:^(id result) {
        self.dicYX2 =[NSDictionary dictionary] ;
        self.dicYX2 = result[0];
        topView.dicYX2 = self.dicYX2;
    } error:^(id result) {
        
    } failure:^(id result) {
        
    }];
}
-(void)getDataforYX3{
    [HttpManager requestDataWithURL2:@"Home/Api/getAdData" hasHttpHeaders:YES params:@{@"pid":@(305)} withController:self httpMethod:@"POST" completion:^(id result) {
        self.dicYX3 =[NSDictionary dictionary] ;
        self.dicYX3= result[0];
        topView.dicYX3 = self.dicYX3;
    } error:^(id result) {
        
    } failure:^(id result) {
        
    }];
}
@end
