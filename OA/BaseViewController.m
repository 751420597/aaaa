//
//  BaseViewController.m
//  mdffx
//
//  Created by 吴朋 on 2017/7/11.
//  Copyright © 2017年 xinpingTech. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>
{
    UIImageView *imageView;
}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kThemeColor;
        // 设置导航栏主题
    [self setNavigationBarTheme];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];//黑色底部
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];//进度轮转动的类型
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    /** 添加手势滑动返回 */
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
#pragma mark 设置导航栏样式
-(void) setNavigationBarTheme
{
    UINavigationBar *bar =[UINavigationBar appearance];
    [bar setShadowImage:[[UIImage alloc]init]];
    [bar setBackgroundImage:[AdaptInterface createImageWithColor:colorWithHexString(@"#38414f")] forBarMetrics:UIBarMetricsDefault];
    
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeZero;
        //设置文字风格
    [bar setTitleTextAttributes:@{
                                  NSForegroundColorAttributeName:[UIColor whiteColor],
                                  NSShadowAttributeName:shadow
                                  }];
        // 2.设置导航栏上的按钮样式
    UIBarButtonItem *barItem=[[UIBarButtonItem alloc] init];
        //设置背景图片
    [barItem setTitleTextAttributes:@{
                                      NSForegroundColorAttributeName:[UIColor whiteColor],
                                      NSShadowAttributeName:shadow,
                                      NSFontAttributeName:kNavigationTitleFont
                                      } forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:@{
                                      NSForegroundColorAttributeName:[UIColor whiteColor],
                                      NSShadowAttributeName:shadow,
                                      NSFontAttributeName:kNavigationTitleFont
                                      } forState:UIControlStateHighlighted];
    
    
}

#pragma mark 返回
-(void)createBackItemWithTarget:(id)target
{
    // 导航栏左侧按钮
    [self createLeftItemWithImage:@"common_back" highlightedImageName:@"" target:target action:@selector(pop)];
}
/*!
 @method
 @abstract   创建导航条左按钮
 @param 	imageName 	按钮图片
 @param 	highlightedImageName 	按钮选中后的图片
 @param 	target 	按钮点击事件响应对象
 @param 	selector 	按钮点击事件响应方法
 */
- (void)createLeftItemWithImage:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectZero;
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake([AdaptInterface convertWidthWithWidth:(44-48)/2], [AdaptInterface convertHeightWithHeight:(44-30)/2], [AdaptInterface convertWidthWithWidth:20], [AdaptInterface convertHeightWithHeight:20])];
    if (iPhone4) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake([AdaptInterface convertWidthWithWidth:(44-38)/2], [AdaptInterface convertHeightWithHeight:(44-20)/2], [AdaptInterface convertWidthWithWidth:20], [AdaptInterface convertHeightWithHeight:20])];
    }
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:imageName];
        //imageView.userInteractionEnabled = YES;
    [button addSubview:imageView];
    button.frame = CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:60], [AdaptInterface convertHeightWithHeight:44]);
    [button sizeToFit];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*!
 @method
 @abstract   创建导航条右边按钮
 @param 	target 	按钮点击事件响应对象
 @param 	selector 	按钮点击事件响应方法
 title_  按钮的名字
 */
- (void)createRightItemWithTitle:(NSString*)title withImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName action:(SEL)selector target:(id)target
{
    _rigntBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_rigntBtn setFrame:CGRectMake(0, 0, 60, 40)];
    _rigntBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_rigntBtn.titleLabel setFont:kSystemFontOfSize(14)];
    [_rigntBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [_rigntBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rigntBtn setTitle:title forState:UIControlStateNormal];
    [_rigntBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    _rigntBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 20, 12, 20);
    if (highlightedImageName.length > 0) { //这里是判断高亮图片没有设置值的话 就不需要设置了
        [_rigntBtn setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateSelected];
    }
    UIBarButtonItem *btnItem=[[UIBarButtonItem alloc] initWithCustomView:_rigntBtn];
    UIBarButtonItem *flexSpace =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    
    flexSpace.width = -20;
    
    if (IS_NOT_EMPTY(title))
    {
        flexSpace.width = -5;
        _rigntBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:flexSpace,btnItem,nil];
}

/**
 创建导航条上的选项
 
 @param titles 需要显示的items
 @param clickItem 点击item的回调
 @param selectedIndex 选择下标
 */
//- (void)createCenterSegementWithTitles:(NSArray *)titles clickItemsWithIndex:(void(^)(NSInteger index))clickItem selectedItemIndex:(NSInteger)selectedIndex{
//    self.title = nil;
//    /** 创建自定义SegmentControl */
//    LXDSegmentControlConfiguration * slide = [LXDSegmentControlConfiguration configurationWithControlType: LXDSegmentControlTypeSlideBlock items: titles];
//    /** 这里因为选项卡item文字长度不一  所以分开设置 根据文字 */
//    NSString *firstItem = titles.firstObject;
//    CGFloat itemsWidth = [self calculTheItemsWidthWithTitle:firstItem] + [AdaptInterface convertWidthWithWidth:20];
//    
//    LXDSegmentControl * slideControl = [LXDSegmentControl segmentControlWithFrame:CGRectMake(iphone6Width / 2.0 - itemsWidth, 2, itemsWidth * 2, 44) configuration: slide delegate: nil];
//    slideControl.defaultSelected = selectedIndex;
//    slideControl.clickItemsBlock = ^(NSInteger index) {
//        if (clickItem) {
//            clickItem(index);
//        }
//    };
//    self.navigationItem.titleView = slideControl;
//}

#pragma mark 去掉多余的分割线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

/** 根据item文字的长度 来计算选项卡所需要的尺寸 */
- (CGFloat)calculTheItemsWidthWithTitle:(NSString *)titles {
    CGFloat width = 0;
    if ([self respondsToSelector:@selector(sizeWithFont:constrainedToSize:lineBreakMode:)]) {
        width = [titles sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(200, 40) lineBreakMode:NSLineBreakByWordWrapping].width;
    } else {
        width = [titles boundingRectWithSize:CGSizeMake(200, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.width;
    }
    if (width < 42) {
        width = 42;
    }
    return width;
}


@end
