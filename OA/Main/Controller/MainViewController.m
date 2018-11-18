//
//  MainViewController.m
//  MFB
//
//  Created by llc on 15/8/3.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#define  KBarBtnColor kGetColor(77, 167, 238)
#define KDockHeight 48

#import "MainViewController.h"
#import "DockItem.h"
#import "Reachability.h"
#import "VersionUpdateView.h"
#import "Harpy.h"
#import "MenuLabel.h"
#import "HyPopMenuView.h"
#import "POP.h"
#import "SettingViewController.h"
#import "HomeController.h"
#import "SortViewController.h"
#import "StoreViewController.h"
#import "ShoppingViewController.h"
#import "ShoppingWkController.h"
@interface MainViewController ()
{
    UIImageView *_tabBarView;
    UIViewController *_selectedViewController;
   
    int Selected;
    
    int lastSelected;
    
    int redBag;
    
    int data;
    Reachability *hostReach;
    
    int currentSelected;
    
    UIViewController *currentViewController;
}
@property(nonatomic,assign)int needBackSelec;
@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Selected = 0;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    //self.tabBar.hidden= YES;  //隐藏原来的tabbar
    CGFloat _tabBarViewY =self.view.frame.size.height - KDockHeight;
    _dockView = [[Dock alloc] initWithFrame:CGRectMake(0, _tabBarViewY, [AdaptInterface convertWidthWithWidth:iphone6Width], KDockHeight)];
    _dockView.contentMode = UIViewContentModeBottom;
    _dockView.backgroundColor = colorWithHexString(@"ffffff");
    _dockView.userInteractionEnabled = YES;
    [self.view addSubview:_dockView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:iphone6Width], 0.5)];
    lineView.backgroundColor = colorWithHexString(@"e1e1e1");
    [_dockView addSubview:lineView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectIndex) name:kGotoHome object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectIndexList) name:kGotoList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectIndexShop) name:kGotoShopping object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectIndexStore) name:kGotoStore object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectIndexUser) name:kGotoUser object:nil];
    
    __weak MainViewController *main = self;
    __block int select = Selected;
    __block int lastselect = lastSelected;
    ;
    //按钮点击进入相应的控制器
    _dockView.dockItemClick = ^(int tag){
        
        currentSelected = tag;
        
        if (select != tag) {
            lastselect = select;
        }
        
        select = tag;
        [main selectedControllerAtIndex:tag];
    };
    
    // 3.创建控制器
    [self createChildViewController];
    // 4.版本检测
    //[self checkVersion];
}
-(void)selectIndex{
    [self selectedControllerAtIndex:0];
}
-(void)selectIndexList{
     [self selectedControllerAtIndex:1];
}
-(void)selectIndexShop{
     [self selectedControllerAtIndex:3];
}
-(void)selectIndexStore{
     [self selectedControllerAtIndex:2];
}
-(void)selectIndexUser{
     [self selectedControllerAtIndex:4];
}
-(void) selectedControllerAtIndex:(int)index
{
    UIViewController *newViewController = self.childViewControllers[index];
    if (newViewController == _selectedViewController) {
        return;
    }
    
    [_selectedViewController.view removeFromSuperview];
    
    newViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - KDockHeight);
    
    [self.view addSubview:newViewController.view];
    
    _selectedViewController = newViewController;
    
}

-(void) createChildViewController
{
    HomeController *messageVC =[[HomeController alloc] init];
    UINavigationController *nav1 =[[UINavigationController alloc] initWithRootViewController:messageVC];
    nav1.delegate = self;
    [self addChildViewController:nav1];
    
    SortViewController *AddressVC =[[SortViewController alloc] init];
    UINavigationController *nav2 =[[UINavigationController alloc] initWithRootViewController:AddressVC];
    nav2.delegate = self;
    [self addChildViewController:nav2];
    
    StoreViewController *appVC =[[StoreViewController alloc] init];
    UINavigationController *nav3 =[[UINavigationController alloc] initWithRootViewController:appVC];
    nav3.delegate = self;
    [self addChildViewController:nav3];
    
    
    if (@available(iOS 11.0, *)) {
        ShoppingViewController *moreVC =[[ShoppingViewController alloc] init];
        UINavigationController *nav4 =[[UINavigationController alloc] initWithRootViewController:moreVC];
        nav4.delegate = self;
        [self addChildViewController:nav4];
    }else{
        ShoppingWkController *moreVC =[[ShoppingWkController alloc] init];
        UINavigationController *nav4 =[[UINavigationController alloc] initWithRootViewController:moreVC];
        nav4.delegate = self;
        [self addChildViewController:nav4];
    }
    
    
    SettingViewController *setVC =[[SettingViewController alloc] init];
    UINavigationController *nav5 =[[UINavigationController alloc] initWithRootViewController:setVC];
    nav5.delegate = self;
    [self addChildViewController:nav5];
    
    // 4.初始化执行第一个控制器
    [self selectedControllerAtIndex:0];
    [_dockView setSelectedIndex:0];
    
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    UIViewController *root =navigationController.viewControllers[0];
    if (viewController != root) {
        navigationController.view.frame = self.view.bounds ;
        //移除dock
        [_dockView removeFromSuperview];
        
        //需要改变dock的Y值
        CGRect frame = _dockView.frame;
        
//        if ([root isKindOfClass:[MessageViewController class]] || [root isKindOfClass:[AddressBookViewController class]]  || [root isKindOfClass:[ApplicationViewController class]]|| [root isKindOfClass:[MoreViewController class]]) {
//            if (IS_HOTSPOT_CONNECTED) {  // 如果有热点
//                frame.origin.y -= KDockHeight -12;
//                if (frame.origin.y != currentViewHeight-(64+48+20)) {
//                    frame.origin.y =currentViewHeight-(64+48+20);
//                }
//            }
//            else{
//                frame.origin.y -= KDockHeight -12;
//                if (frame.origin.y != currentViewHeight-(64+48)) {
//                    frame.origin.y =currentViewHeight-(64+48);
//                }
//            }
//            
//        }
        

        
        _dockView.frame = frame;
        //NSLog(@"bbbb:%@",NSStringFromCGRect(frame));
        //NSLog(@"root.view:%@",NSStringFromCGRect(root.view.frame));
        
        //将dock添加到根控制器上
        [root.view addSubview:_dockView];
    }
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    currentViewController = viewController;
    UIViewController *root =navigationController.viewControllers[0];
    if (viewController == root) {
        //更改导航控制器的frame
        navigationController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -KDockHeight);
        
        //移除根控制器上的dock
        [_dockView removeFromSuperview];
        
        //NSLog(@"cccc:%f",self.view.frame.size.height- KDockHeight);
        //改变dock的Y值
        _dockView.frame = CGRectMake(0, self.view.frame.size.height - KDockHeight, self.view.frame.size.width, KDockHeight);
        
        //导航控制器上添加dock
        [self.view addSubview:_dockView];
        
    }
    
}
@end
