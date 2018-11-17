//
//  HelpCenterViewController.m
//  mdffx
//
//  Created by xinping-2 on 2017/7/20.
//  Copyright © 2017年 xinpingTech. All rights reserved.
//

#import "HelpCenterViewController1.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WKWebView+PAWebCookie.h"
#import "WebChatPayH5VIew.h"
@interface HelpCenterViewController1 ()
{
    UIWebView *_webViews;
    
    
    UIProgressView *progressView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    NSMutableURLRequest *requestAll;
    NSMutableURLRequest *requestGoods;
    int flag ;
    NSString *backUrl;
    NSString *backStr;
    NSString *shareStatus;
    BOOL isOpen;
}
@property (nonatomic,strong)NSArray *cookiesArr;
@property (nonatomic, strong) WKWebViewConfiguration *config;
@property (nonatomic, strong) WKWebView *wkWebView;
@end

@implementation HelpCenterViewController1
-(WKWebViewConfiguration *)config
{
    if (_config == nil) {
        _config = [[WKWebViewConfiguration alloc] init];
        _config.userContentController = [[WKUserContentController alloc] init];
        _config.preferences = [[WKPreferences alloc] init];
        _config.preferences.javaScriptEnabled = YES; //是否支持 JavaScript
        _config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        _config.processPool = [[WKProcessPool alloc] init];
        
        _config.allowsInlineMediaPlayback = YES;        // 允许在线播放
        if (@available(iOS 9.0, *)) {
            _config.allowsAirPlayForMediaPlayback = YES;  //允许视频播放
        }
        
        NSMutableString *javascript = [NSMutableString string];
        [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
        //        [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
        WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [_config.userContentController addUserScript:noneSelectScript];
    }
    return _config;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        //1、加载空页面
        [_webViews stopLoading];
        _webViews.delegate = nil;
        
         [_progressView removeFromSuperview];
        _progressProxy.webViewProxyDelegate = nil;
        _progressProxy.progressDelegate = nil;
    }
    else
    {
        [_wkWebView stopLoading];

        [progressView removeFromSuperview];
    }
}
-(void)back{
     backUrl = @"back";
    if(_wkWebView){
        [_wkWebView goBack];
    }else{
        [_webViews goBack];
    }
   
    
}
-(void)popAction{
    if(_wkWebView){
        [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
    }else{
        [_webViews loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
    }
    
    if (IS_NOT_EMPTY(self.tag)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGotoHome object:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)refresh:(NSNotification *)infor{
    if([infor.userInfo[@"infor"] isEqualToString:@"0"]){
        shareStatus = @"1";
    }else{
        shareStatus = @"0";
    }
    if(_wkWebView){
         [_wkWebView loadRequest:requestAll];
    }else{
         [_webViews loadRequest:requestAll];
    }
   
    flag = 1;
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
    button.frame = CGRectMake([AdaptInterface convertWidthWithWidth:10],tempHeight, [AdaptInterface convertWidthWithWidth:30], buttonHeight);
    [button setImage:[UIImage imageNamed:@"return"] forState:0];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_webViews addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setImage:[UIImage imageNamed:@"tuichu"] forState:0];
    button2.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button2 addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake([AdaptInterface convertWidthWithWidth:40], tempHeight, [AdaptInterface convertWidthWithWidth:30],buttonHeight);
    [_webViews addSubview:button2];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self preferredStatusBarStyle];
    // 导航栏左侧按钮
    [self creatBackBtn];
    [SVProgressHUD showWithStatus:@"请稍后..."];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh:) name:@"weiXinShare" object:nil];
    
    //[self createRightItemWithTitle:nil withImageName:@"More_feedback" highlightedImageName:nil action:@selector(gotoFeedBack) target:self];
   
    //requestAll = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.html",kRequestIP,_urlstring]] ] ;
    //requestAll = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.diyoupin.com/testCookies.php"]];
    requestAll = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.diyoupin.com"]];
    
    [requestAll setValue:@"DAssist" forHTTPHeaderField:@"DTOAUTH"];
    [requestAll setValue:@"www.diyoupin.com" forHTTPHeaderField: @"Referer"];
    
//    //配置对象
    int tempHeight = 0;
    if (iPhoneX||iPhoneXr||iPhoneXs||iPhoneX_Max) {
        tempHeight = 44;
    }
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)
    {

        self.wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, currentViewWidth, currentViewHeight-tempHeight) configuration:self.config];
        _wkWebView.scrollView.backgroundColor =[UIColor whiteColor];
        
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;

        _wkWebView.scrollView.showsVerticalScrollIndicator = NO;
        _wkWebView.scrollView.showsHorizontalScrollIndicator = NO;

        CGFloat progressBarHeight = 2.f;
        CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
        progressView = [[UIProgressView alloc] initWithFrame:barFrame];
        progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        progressView.tintColor = [UIColor redColor];
        progressView.trackTintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar addSubview:progressView];

        [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        [_wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];

       
        NSString *Domain = requestAll.URL.host;
        
        
//        /** 插入cookies JS */
        if (Domain)[self.config.userContentController addUserScript:[_wkWebView searchCookieForUserScriptWithDomain:Domain]];
//        /** 插入cookies PHP */
        if (@available(iOS 11.0, *)){
            NSMutableArray *cookies= [_wkWebView sharedHTTPCookieStorage];
            for(NSHTTPCookie *cookie in cookies){
                [_wkWebView insertCookie:cookie];
            }
        }else{
            if (Domain)[requestAll setValue:[_wkWebView phpCookieStringWithDomain:Domain]  forHTTPHeaderField:@"Cookie"];
        }
        
        if ([AdaptInterface isConnected])
        {
            [_wkWebView loadRequest:requestAll];

        }
        else
        {
            [AdaptInterface tipMessageTitle:NSLocalizedString(@"无网络连接", nil) view:self.view];
        }
         [self.view addSubview:_wkWebView];
    }
    else
    {
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
                [_webViews loadRequest:requestAll];
            }
            else
            {
                [SVProgressHUD dismiss];
                [AdaptInterface tipMessageTitle:NSLocalizedString(@"无网络连接", nil) view:self.view];
            }
   }
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
    if(flag!=0){
        JSContext *context=[_webViews valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
       NSString *alertJS=[NSString stringWithFormat:@"shareCallback('%@')",shareStatus] ;
        if(backStr.length>0){
            alertJS = [NSString stringWithFormat:@"%@('%@')",alertJS,shareStatus];
        }
        
        [context evaluateScript:alertJS];//通过oc方法调用js的alert
        flag = 0;
    }
    
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
    
    if([[requestSt lowercaseString] containsString:@"goods/goodslist"]){
        requestGoods =[NSMutableURLRequest requestWithURL:[NSURL URLWithString: requestSt]];
        backUrl = @"";
        return YES;
    }

    //将":"前后字符串切割为数组
    if([requestSt containsString:@"forappshare"]){
        if([backUrl isEqualToString:@"back"]){
           // [_webViews loadRequest:requestGoods];
           //backUrl = @"";
            [_webViews goBack];
             [_webViews goBack];
            return YES;
        }
        flag = 0;
        NSString *title = nil;
        NSString *desc  =nil;
        UIImage *decodedImage = nil;
        NSArray *arr0 = [requestSt componentsSeparatedByString:@"/title/"];
        requestAll =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@.html",arr0[0]] ]];
        if(arr0.count>1){
            NSString *temptitle = arr0[1];
            NSArray *titleArr = [temptitle componentsSeparatedByString:@"/"];
            title = [titleArr[0] stringByRemovingPercentEncoding];
            NSLog(@"分享的 title:%@",title);
        }
        
        NSArray *arr1 = [requestSt componentsSeparatedByString:@"desc/"];
        if(arr1.count>1){
            NSString *tempContent = arr1[1];
            NSArray *descArr = [tempContent componentsSeparatedByString:@"/"];
            desc = [descArr[0] stringByRemovingPercentEncoding];
            NSLog(@"分享的 desc:%@",desc);
        }
        
        NSArray *arr2 = [requestSt componentsSeparatedByString:@"img/"];
        if(arr2.count>1){
            NSString *tempImgArr  = arr2[1];
            NSArray *imgArr = [tempImgArr componentsSeparatedByString:@"/"];
            NSString *urlImg =[imgArr[0] stringByRemovingPercentEncoding];
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlImg]];
            decodedImage  = [UIImage imageWithData:data scale:0.6];
        }
        
        NSArray *arr3 = [requestSt componentsSeparatedByString:@"callback/"];
        if(arr3.count>1){
            NSString *back  = arr3[1];
            NSArray *backArr = [back componentsSeparatedByString:@"/"];
            backStr =backArr[0];
        }
        SendMessageToWXReq *req1 = [[SendMessageToWXReq alloc]init];
        
        // 是否是文档
        req1.bText =  NO;
        req1.scene = WXSceneTimeline;
        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = title;//分享标题
        urlMessage.description = desc;//分享描述
        [urlMessage setThumbImage:[UIImage imageNamed:@"share"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
        
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl =requestSt ;//分享链接
        
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        req1.message = urlMessage;
        //发送分享信息
        [WXApi sendReq:req1];
    }
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
    
    backUrl = @"";
    return YES;
}
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [SVProgressHUD show];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [SVProgressHUD dismiss];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kRequestIP,_urlstring]]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"cookie"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if(flag!=0){
        
        NSString *alertJS=[NSString stringWithFormat:@"callJsAlert('%@')",shareStatus] ;
        if(backStr.length>0){
            alertJS = [NSString stringWithFormat:@"%@('%@')",alertJS,shareStatus];
        }
        [webView evaluateJavaScript:alertJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            
        }];
        
        flag = 0;
    }
    
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    
    NSString *requestSt = navigationAction.request.URL.absoluteString;
    //再次注入 cookie
    if (@available(iOS 11.0, *)){
        NSMutableArray *cookies= [_wkWebView sharedHTTPCookieStorage];
        for(NSHTTPCookie *cookie in cookies){
            [_wkWebView insertCookie:cookie];
        }
    }else{
        [requestAll setValue:[_wkWebView phpCookieStringWithDomain:navigationAction.request.URL.host]  forHTTPHeaderField:@"Cookie"];
    }
    
    if ([requestSt containsString:@"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb?"]) {
        
        WebChatPayH5VIew *h5View = [[WebChatPayH5VIew alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        //url是没有拼接redirect_url微信h5支付链接
        [h5View loadingURL:requestSt withIsWebChatURL:NO];
        [_wkWebView addSubview:h5View];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if([[requestSt lowercaseString] containsString:@"goods/goodslist"]){
        requestGoods =[NSMutableURLRequest requestWithURL:[NSURL URLWithString: requestSt]];
        backUrl = @"";
    }
    
    //将":"前后字符串切割为数组
    if([requestSt containsString:@"forappshare"]){
        if([backUrl isEqualToString:@"back"]){
            // [_webViews loadRequest:requestGoods];
            //backUrl = @"";
            [_wkWebView goBack];
            [_wkWebView goBack];
            decisionHandler(WKNavigationActionPolicyCancel);
            return ;
        }
        flag = 0;
        NSString *title = nil;
        NSString *desc  =nil;
        UIImage *decodedImage = nil;
        NSArray *arr0 = [requestSt componentsSeparatedByString:@"/title/"];
        requestAll =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@.html",arr0[0]] ]];
        if(arr0.count>1){
            NSString *temptitle = arr0[1];
            NSArray *titleArr = [temptitle componentsSeparatedByString:@"/"];
            title = [titleArr[0] stringByRemovingPercentEncoding];
            NSLog(@"分享的 title:%@",title);
        }
        
        NSArray *arr1 = [requestSt componentsSeparatedByString:@"desc/"];
        if(arr1.count>1){
            NSString *tempContent = arr1[1];
            NSArray *descArr = [tempContent componentsSeparatedByString:@"/"];
            desc = [descArr[0] stringByRemovingPercentEncoding];
            NSLog(@"分享的 desc:%@",desc);
        }
        
        NSArray *arr2 = [requestSt componentsSeparatedByString:@"img/"];
        if(arr2.count>1){
            NSString *tempImgArr  = arr2[1];
            NSArray *imgArr = [tempImgArr componentsSeparatedByString:@"/"];
            NSString *urlImg =[imgArr[0] stringByRemovingPercentEncoding];
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlImg]];
            decodedImage  = [UIImage imageWithData:data scale:0.6];
        }
        
        NSArray *arr3 = [requestSt componentsSeparatedByString:@"callback/"];
        if(arr3.count>1){
            NSString *back  = arr3[1];
            NSArray *backArr = [back componentsSeparatedByString:@"/"];
            backStr =backArr[0];
        }
        SendMessageToWXReq *req1 = [[SendMessageToWXReq alloc]init];
        
        // 是否是文档
        req1.bText =  NO;
        req1.scene = WXSceneTimeline;
        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = title;//分享标题
        urlMessage.description = desc;//分享描述
        [urlMessage setThumbImage:[UIImage imageNamed:@"share"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
        
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl =requestSt ;//分享链接
        
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        req1.message = urlMessage;
        //发送分享信息
        [WXApi sendReq:req1];
        
        
    }
    if([requestSt containsString:@"forapphome"])
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kGotoHome object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return ;
    }else if([requestSt containsString:@"forappstore"])
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kGotoStore object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return ;
    }else if([requestSt containsString:@"forapplist"])
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kGotoList object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return ;
    }else if([requestSt containsString:@"forappshopping"])
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kGotoShopping object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return ;
    }else if([requestSt containsString:@"forappuser"])
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kGotoUser object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return ;
    }
    
    backUrl = @"";
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)dealloc
{
    [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_wkWebView removeObserver:self forKeyPath:@"title"];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
