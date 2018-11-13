//
//  HelpCenterViewController.m
//  mdffx
//
//  Created by xinping-2 on 2017/7/20.
//  Copyright © 2017年 xinpingTech. All rights reserved.
//

#import "HelpCenterViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
@interface HelpCenterViewController ()
{
    UIWebView *_webViews;
    WKWebView *_wkWebView;
    
    UIProgressView *progressView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@property (nonatomic,strong)NSArray *cookiesArr;
@end

@implementation HelpCenterViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self preferredStatusBarStyle];

}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
//    {
        //1、加载空页面
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
-(void)back{
    [_webViews goBack];
}
-(void)popAction{
    [_webViews loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
    if (IS_NOT_EMPTY(self.tag)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGotoHome object:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatBackBtn{
    int tempHeight = [AdaptInterface convertHeightWithHeight:20];

    if (iPhoneX||iPhoneXr||iPhoneXs||iPhoneX_Max) {
        tempHeight = 44;
    }
    int buttonHeight = 44;
     if (iPhoneXr){
        buttonHeight = 47;
     }else if (iPhoneX_Max){
          buttonHeight = 48;
     }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake([AdaptInterface convertWidthWithWidth:10],tempHeight, [AdaptInterface convertWidthWithWidth:25], buttonHeight);
    [button setImage:[UIImage imageNamed:@"return"] forState:0];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_webViews addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setImage:[UIImage imageNamed:@"tuichu"] forState:0];
    button2.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button2 addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(CGRectGetMaxX(button.frame), CGRectGetMinY(button.frame), CGRectGetWidth(button.frame), CGRectGetHeight(button.frame));
    [_webViews addSubview:button2];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self preferredStatusBarStyle];
    // 导航栏左侧按钮
    [self creatBackBtn];
    [SVProgressHUD showWithStatus:@"请稍后..."];
    //[self createRightItemWithTitle:nil withImageName:@"More_feedback" highlightedImageName:nil action:@selector(gotoFeedBack) target:self];
   
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.html",kRequestIP,_urlstring]]];
    [request setValue:@"DAssist" forHTTPHeaderField:@"DTOAUTH"];
    [request setValue:@"www.diyoupin.com" forHTTPHeaderField: @"Referer"];
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
    if (iPhoneX||iPhoneXr||iPhoneXs||iPhoneX_Max) {
        tempHeight = 44;
    }
    
    _webViews = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, currentViewWidth, currentViewHeight-tempHeight)];
    _webViews.scrollView.backgroundColor =[UIColor whiteColor];
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
            [SVProgressHUD dismiss];
            [AdaptInterface tipMessageTitle:NSLocalizedString(@"无网络连接", nil) view:self.view];
        }
//    }
    [self creatBackBtn];
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
    [SVProgressHUD dismiss];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
   
    [SVProgressHUD dismiss];
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
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [SVProgressHUD dismiss];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestSt=[[request URL] absoluteString];
    //将":"前后字符串切割为数组
    
    if([requestSt containsString:@"forapphome"])
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kGotoHome object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
       
        return NO;
    }else if([requestSt containsString:@"forappstore"])
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kGotoStore object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return NO;
    }else if([requestSt containsString:@"forapplist"])
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kGotoList object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return NO;
    }else if([requestSt containsString:@"forappshopping"])
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kGotoShopping object:nil];

        [self.navigationController popViewControllerAnimated:YES];

        return NO;
    }else if([requestSt containsString:@"forappuser"])
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kGotoUser object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return NO;
    }
    
    
    return YES;
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [SVProgressHUD dismiss];
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
