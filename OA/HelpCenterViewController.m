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
#import <JavaScriptCore/JavaScriptCore.h>
#import "WKWebView+PAWebCookie.h"
#import "WebChatPayH5VIew.h"
@interface HelpCenterViewController ()
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

@implementation HelpCenterViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

-(void)back{
   backUrl = @"back";
   [_webViews goBack];
}
-(void)popAction{
   
    [_webViews loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
    
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
    [_webViews loadRequest:requestAll];
    
    flag = 1;
}
-(void)getWXPayResult{
    NSString *str = @"showLayer('wxPay')";
    [_webViews stringByEvaluatingJavaScriptFromString:str];
}
-(void)getAliPayResult{
    NSString *str = @"showLayer('aliPay')";
   [_webViews stringByEvaluatingJavaScriptFromString:str];
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
    button.tag = 1;
    [button setImage:[UIImage imageNamed:@"return"] forState:0];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_webViews addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setImage:[UIImage imageNamed:@"tuichu"] forState:0];
    button2.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button2.tag = 2;
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh:) name:@"weiXinShare" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getWXPayResult) name:@"wechatpay" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAliPayResult) name:@"alipay" object:nil];
   
    if(!self.urlstring){
         requestAll = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"] ] ;
    }else{
         requestAll = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.html",kRequestIP,self.urlstring]] ] ;
    }
   
    //requestAll = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.diyoupin.com/testCookies.php"]];
    //requestAll = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.diyoupin.com"]];
    
    [requestAll setValue:@"DAssist" forHTTPHeaderField:@"DTOAUTH"];
    [requestAll setValue:@"www.diyoupin.com" forHTTPHeaderField: @"Referer"];
    
//    //配置对象
    int tempHeight = 0;
    if (iPhoneX||iPhoneXr||iPhoneXs||iPhoneX_Max) {
        tempHeight = 44;
    }
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
//                [SVProgressHUD dismiss];
                [AdaptInterface tipMessageTitle:NSLocalizedString(@"无网络连接", nil) view:self.view];
            }
   
    if(!self.isShopping){
        [self creatBackBtn];
    }
}

-(void)setIsShopping:(BOOL)isShopping{
    int tempHeight = 0;
    if (iPhoneX||iPhoneXr||iPhoneXs||iPhoneX_Max) {
        tempHeight = 44;
    }
    _webViews.frame =CGRectMake(0, 0, currentViewWidth, currentViewHeight-tempHeight-56);
    _isShopping = isShopping;
    UIView *button = [_webViews viewWithTag:1];
     UIView *button2 = [_webViews viewWithTag:2];
    [button removeFromSuperview];
    [button2 removeFromSuperview];
    
}
- (void)setUrlString:(NSString *)urlString
{
    _urlstring = urlString;
    
}
-(void)loadRequset:(NSString *)url{
    _urlstring = url;
    requestAll = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.html",kRequestIP,_urlstring]] ] ;
    //requestAll = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.diyoupin.com/testCookies.php"]];
    //requestAll = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.diyoupin.com"]];
    
    [requestAll setValue:@"DAssist" forHTTPHeaderField:@"DTOAUTH"];
    [requestAll setValue:@"www.diyoupin.com" forHTTPHeaderField: @"Referer"];
    
    //    //配置对象
    int tempHeight = 0;
    if (iPhoneX||iPhoneXr||iPhoneXs||iPhoneX_Max) {
        tempHeight = 44;
    }
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
        [_webViews loadRequest:requestAll];
    }
    else
    {
        //                [SVProgressHUD dismiss];
        [AdaptInterface tipMessageTitle:NSLocalizedString(@"无网络连接", nil) view:self.view];
    }
}
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    [SVProgressHUD dismiss];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [SVProgressHUD dismiss];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的,原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的,原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
   
    
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
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        
    }
    else if ([keyPath isEqualToString:@"title"])
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestSt=[[request URL] absoluteString];
    
    if([[requestSt lowercaseString] containsString:@"goods/goodslist"]){
        requestGoods =[NSMutableURLRequest requestWithURL:[NSURL URLWithString: requestSt]];
        backUrl = @"";
        return YES;
    }
    
    if ([requestSt rangeOfString:@"weixin://wap/pay"].location != NSNotFound || [requestSt rangeOfString:@"alipay://"].location != NSNotFound) {
        
        if([requestSt rangeOfString:@"alipay://"].location != NSNotFound){
            if([requestSt containsString:@"alipays"]){
                requestSt = [requestSt stringByReplacingOccurrencesOfString:@"alipays" withString:@"www.diyoupin.com"];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:requestSt] options:@{} completionHandler:^(BOOL success) {
                    [webView goBack];
                } ];
                return NO;
            }
        }else if([requestSt rangeOfString:@"weixin://"].location != NSNotFound){
            NSDictionary *headers = [request allHTTPHeaderFields];
            BOOL hasReferer = [headers objectForKey:@"Referer"] != nil;
            if (hasReferer) {
                return YES;
            } else {
                // relaunch with a modified request
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSURL *url = [request URL];
                        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
                        //设置授权域名
                        [request setValue:@"www.diyoupin.com://" forHTTPHeaderField: @"Referer"];
                        [webView loadRequest:request];
                        [webView goBack];
                    });
                });
                return NO;
            }
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:requestSt] options:@{} completionHandler:^(BOOL success) {
//                 [webView goBack];
//            } ];
//            return NO;
        }
        return NO;
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
- (void)dealloc
{
    //1、加载空页面
     _webViews.delegate = nil;
    [_webViews loadHTMLString:@"" baseURL:nil];
    [_webViews stopLoading];
    [_webViews removeFromSuperview];
    
    [_progressView removeFromSuperview];
    _progressProxy.webViewProxyDelegate = nil;
    _progressProxy.progressDelegate = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
