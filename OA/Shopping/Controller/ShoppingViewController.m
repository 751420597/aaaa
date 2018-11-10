//
//  ShoppingViewController.m
//  OA
//
//  Created by 翟凤禄 on 2018/10/15.
//  Copyright © 2018年 xinpingTech. All rights reserved.
//

#import "ShoppingViewController.h"

@interface ShoppingViewController ()
{
    UIWebView *_webViews;
    WKWebView *_wkWebView;
    
    UIProgressView *progressView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    UIImageView *imageView ;
    UIButton *button;
    UIView *backView;
}
@property (nonatomic,strong)NSArray *cookiesArr;
@end

@implementation ShoppingViewController
-(void)loadData{
    NSDictionary *param = @{@"goods_num":@[@1],@"cart_select":@[@1]};
    [HttpManager requestDataWithURL2:@"mobile/cart/ajaxCartList" hasHttpHeaders:YES params:param withController:self httpMethod:@"POST" completion:^(id result) {
        NSDictionary *userDic = result[@"data"][@"user"];
        if(userDic==nil){
            //未登录
             UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc] init]];
            [self presentViewController:navc animated:YES completion:nil];
            return ;
        }else{
            NSArray *cartList =result[@"data"][@"cartList"];
            if(cartList.count>0){
                self.urlstring = @"mobile/cart/cart";
                if(_webViews==nil){
                    [self creatWebView];
                }else{
                     UIWebView *webV = [self.view viewWithTag:1];
                    [self.view bringSubviewToFront:webV];
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.html",kRequestIP,_urlstring]]];
                    [request setValue:@"DAssist" forHTTPHeaderField:@"DTOAUTH"];
                    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"cookie"];
                    if([cookiesdata length]) {
                        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
                        for(NSHTTPCookie*cookie in cookies){
                            if([cookie isKindOfClass:[NSHTTPCookie class]]){
                                if([cookie.name isEqualToString:@"PHPSESSID"]){
                                    NSNumber*sessionOnly =[NSNumber numberWithBool:cookie.sessionOnly];
                                    NSNumber*isSecure = [NSNumber numberWithBool:cookie.isSecure];
                                    self.cookiesArr = [NSArray arrayWithObjects:cookie.name, cookie.value, sessionOnly, cookie.domain, cookie.path, isSecure,nil];
                                    break;
                                }
                            }
                        }
                    }
                    if(_cookiesArr.count>0){
                        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
                        [cookieProperties setObject:[_cookiesArr objectAtIndex:0]forKey:NSHTTPCookieName];
                        [cookieProperties setObject:[_cookiesArr objectAtIndex:1]forKey:NSHTTPCookieValue];
                        [cookieProperties setObject:[_cookiesArr objectAtIndex:3]forKey:NSHTTPCookieDomain];
                        [cookieProperties setObject:[_cookiesArr objectAtIndex:4]forKey:NSHTTPCookiePath];
                        NSHTTPCookie*cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
                        [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:cookieuser];
                    }
                    if ([AdaptInterface isConnected])
                    {
                        [_webViews loadRequest:request];
                    }
                    else
                    {
                        [AdaptInterface tipMessageTitle:NSLocalizedString(@"无网络连接", nil) view:self.view];
                    }
                }
            }else{
                if (backView==nil) {
                    [self createNativeView];
                }else{
                    UIView *view = [self.view viewWithTag:2];
                    [self.view bringSubviewToFront:view];
                }
            }
            
        }
        
    } error:^(id result) {
        
    } failure:^(id result) {
        
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = YES;
    [self loadData];
//    [SVProgressHUD showWithStatus:@"请稍后"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
//    {
        [_webViews stopLoading];
        _webViews.delegate = nil;
        
        [_progressView removeFromSuperview];
        _progressProxy.webViewProxyDelegate = nil;
        _progressProxy.progressDelegate = nil;
//    }
//    else
//    {
//        [_wkWebView stopLoading];
//
//        [progressView removeFromSuperview];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createNativeView];
    
}
-(void)createNativeView{
    backView = [UIView new];
    backView.frame = self.view.bounds;
    backView.tag = 2;
    [self.view addSubview:backView];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
    imageView.image = [UIImage imageNamed:@"nothing"];
    imageView.center = CGPointMake(self.view.center.x, self.view.center.y-80) ;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backView addSubview:imageView];
    
    UILabel *titleLb =[UILabel new];
    titleLb.text = @"购物车暂无商品";
    titleLb.frame =CGRectMake(CGRectGetMinX(imageView.frame)- 25, CGRectGetMaxY(imageView.frame), CGRectGetWidth(imageView.frame)+50, 35);
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = [UIColor lightGrayColor];
    [backView addSubview:titleLb];
    
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(CGRectGetMinX(imageView.frame), CGRectGetMaxY(titleLb.frame), CGRectGetWidth(imageView.frame), 35);
    [button setTitle:@"去逛逛" forState:0];
    [button setTitleColor:[UIColor blackColor] forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [button addTarget:self action:@selector(goShipping) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:button];
}
-(void)goShipping{
    [[NSNotificationCenter defaultCenter] postNotificationName:kGotoHome object:nil];
}
-(void)creatWebView{

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.html",kRequestIP,_urlstring]]];
    [request setValue:@"DAssist" forHTTPHeaderField:@"DTOAUTH"];
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"cookie"];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        for(NSHTTPCookie*cookie in cookies){
            if([cookie isKindOfClass:[NSHTTPCookie class]]){
                if([cookie.name isEqualToString:@"PHPSESSID"]){
                    NSNumber*sessionOnly =[NSNumber numberWithBool:cookie.sessionOnly];
                    NSNumber*isSecure = [NSNumber numberWithBool:cookie.isSecure];
                    self.cookiesArr = [NSArray arrayWithObjects:cookie.name, cookie.value, sessionOnly, cookie.domain, cookie.path, isSecure,nil];
                    break;
                }
            }
        }
    }
    if(_cookiesArr.count>0){
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:[_cookiesArr objectAtIndex:0]forKey:NSHTTPCookieName];
        [cookieProperties setObject:[_cookiesArr objectAtIndex:1]forKey:NSHTTPCookieValue];
        [cookieProperties setObject:[_cookiesArr objectAtIndex:3]forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:[_cookiesArr objectAtIndex:4]forKey:NSHTTPCookiePath];
        NSHTTPCookie*cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:cookieuser];
    }
    
    //    //配置对象
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    //    {
    //
    //        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 20, currentViewWidth, currentViewHeight  -20- (iPhoneX ? 58 : 0))];
    //
    //        _wkWebView.UIDelegate = self;
    //        _wkWebView.navigationDelegate = self;
    //
    //        _wkWebView.scrollView.showsVerticalScrollIndicator = NO;
    //        _wkWebView.scrollView.showsHorizontalScrollIndicator = NO;
    //
    //        CGFloat progressBarHeight = 2.f;
    //        CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    //        CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    //        progressView = [[UIProgressView alloc] initWithFrame:barFrame];
    //        progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    //        progressView.tintColor = [UIColor redColor];
    //        progressView.trackTintColor = [UIColor whiteColor];
    //        [self.navigationController.navigationBar addSubview:progressView];
    //
    //        [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    //        [_wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    //
    //        [self.view addSubview:_wkWebView];
    //
    //        if ([AdaptInterface isConnected])
    //        {
    //            [_wkWebView loadRequest:request];
    //
    //        }
    //        else
    //        {
    //            [AdaptInterface tipMessageTitle:NSLocalizedString(@"无网络连接", nil) view:self.view];
    //        }
    //    }
    //    else
    //    {
    int tempHeight = 0;
    if (iPhoneX||self.view.bounds.size.height>=896) {
        tempHeight = 25;
    }
    _webViews = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20-tempHeight, currentViewWidth, currentViewHeight  -20- tempHeight)];
    _webViews.tag = 1;
    _webViews.scalesPageToFit = YES;
    NSString *userAgent = [_webViews stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    if(![userAgent containsString:@"native/app"]){
        NSString *newUserAgent = [userAgent stringByAppendingString:@" native/app"];//自定义需要拼接的字符串
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    }
    
    //隐藏拖拽UIWebView时上下的两个阴影效果
    UIScrollView *scrollView = [_webViews.subviews objectAtIndex:0];
    if (scrollView)
    {
        for (UIView *view in [scrollView subviews])
        {
            if ([view isKindOfClass:[UIImageView class]])
            {
                view.hidden = YES;
            }
        }
    }
    
    _webViews.delegate = self;
    
    //禁用UIWebView拖拽时的反弹效果
    [(UIScrollView *)[[_webViews subviews] objectAtIndex:0] setBounces:NO];
    
    _webViews.scrollView.showsVerticalScrollIndicator = NO;
    _webViews.scrollView.showsHorizontalScrollIndicator = NO;
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webViews.delegate = _progressProxy;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    [self.view addSubview:_webViews];
    
    if ([AdaptInterface isConnected])
    {
        [_webViews loadRequest:request];
    }
    else
    {
        [AdaptInterface tipMessageTitle:NSLocalizedString(@"无网络连接", nil) view:self.view];
    }
    //    }
}
- (void)setUrlString:(NSString *)urlString
{
    _urlstring = urlString;
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //[SVProgressHUD dismiss];
    if ([self.title isEqualToString:@"<null>"] || self.title ==nil)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
        
        //获取当前页面的title
        self.title =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        if (object == _wkWebView)
        {
            [progressView setAlpha:1.0f];
            [progressView setProgress:_wkWebView.estimatedProgress animated:YES];
            
            if(_wkWebView.estimatedProgress >= 1.0f)
            {
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    progressView.hidden = YES;
                    [progressView setProgress:0.0f animated:NO];
                }];
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else if ([keyPath isEqualToString:@"title"])
    {
        if (object == _wkWebView)
        {
            if ([self.title isEqualToString:@"<null>"] || self.title ==nil)
            {
                self.title = _wkWebView.title;
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
#pragma mark WKWebView createWebViewWithConfiguration
/**
 *  此方法不写,所有的 webview 里面的 navigation 跳转都没有作用
 */
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestSt=[[request URL] absoluteString];
    //将":"前后字符串切割为数组
    NSArray  *components=[requestSt componentsSeparatedByString:@":"];
    
    if([components count]>1 && [(NSString*)[components objectAtIndex:0] isEqualToString:@"http"])
    {
        
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"//download/"])
        {
            
            [_webViews removeFromSuperview];
            NSLog(@"+++++hahhahahh+");
            
            
            
        }
        return NO;
        
    }
    
    
    return YES;
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
   // [SVProgressHUD dismiss];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kRequestIP,_urlstring]]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"cookie"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:
(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 类似 UIWebView 的 -webView: shouldStartLoadWithRequest: navigationType:
    //在发送请求之前，决定是否跳转
    NSLog(@"4.%@",navigationAction.request);
    NSString *url = [navigationAction.request.URL.absoluteString
                     stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    decisionHandler(WKNavigationActionPolicyAllow);
    
    NSMutableURLRequest *mutableRequest = (NSMutableURLRequest*)navigationAction.request  ;
    NSDictionary *requestHeaders = mutableRequest.allHTTPHeaderFields;
    // 判断请求头是否已包含，如果不判断该字段会导致webview加载时死循环
    if (!IS_NOT_EMPTY(requestHeaders[@"DTOAUTH"])) {
        [mutableRequest setValue:@"DAssist" forHTTPHeaderField:@"DTOAUTH"];
        [webView loadRequest:navigationAction.request];
    }
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:url]];
    //    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    //    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"cookie"];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //将":"前后字符串切割为数组
    NSArray  *components=[url componentsSeparatedByString:@":"];
    if([components count]>1 && [(NSString*)[components objectAtIndex:0] isEqualToString:@"http"])
    {
        
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"//download/"])
        {
            
            [_webViews removeFromSuperview];
            NSLog(@"+++++hahhahahh+");
            
            
        }
        
    }
    
    
}


- (void)dealloc
{
    [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_wkWebView removeObserver:self forKeyPath:@"title"];
}


@end
