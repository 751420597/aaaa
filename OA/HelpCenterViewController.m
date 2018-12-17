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
    UIView *shareView;
    UIView *shareBackView;
    
    UIProgressView *progressView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    NSMutableURLRequest *requestAll;
    NSMutableURLRequest *requestGoods;
    int flag ;
    NSString *backUrl;
    NSString *backStr;
    NSString *shareStatus;
    NSString *shareRequestStr;
    BOOL isOpen;
}
@property (nonatomic,strong)NSArray *cookiesArr;
@property (nonatomic, strong) WKWebViewConfiguration *config;
@property (nonatomic, strong) WKWebView *wkWebView;
@end

@implementation HelpCenterViewController
-(void)back{
   backUrl = @"back";
   [_webViews goBack];
}
-(void)popAction{
    if(self.isShopping){
        [_webViews loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@mobile/cart/cart.html",kRequestIP]] ]];
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
-(void)createShareView{
    shareBackView =[[UIView alloc]initWithFrame:self.view.bounds];
    shareBackView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [shareBackView addGestureRecognizer:tapGesturRecognizer];
    shareBackView.hidden = YES;
    shareBackView.userInteractionEnabled = YES;
    shareBackView.alpha = 0.7;
    [self.view addSubview:shareBackView];
    shareView = [[UIView alloc]initWithFrame:CGRectMake(0, currentViewHeight-130-30, currentViewWidth, 130+30)];
    shareView.backgroundColor = [UIColor whiteColor];
    shareView.userInteractionEnabled = YES;
    shareView.alpha = 1;
    shareView.hidden = YES;
    [self.view addSubview:shareView];
    
    UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendBtn.frame = CGRectMake(50, 15, 50, 50);
    [friendBtn setBackgroundImage:[UIImage imageNamed:@"share0.png"] forState:0];
    friendBtn.tag = 100;
    [friendBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:friendBtn];
    
    UILabel *friendlLB = [UILabel new];
    friendlLB.frame = CGRectMake(CGRectGetMinX(friendBtn.frame), CGRectGetMaxY(friendBtn.frame), CGRectGetWidth(friendBtn.frame), 30);
    friendlLB.text = @"微信";
    friendlLB.textAlignment = NSTextAlignmentCenter;
    friendlLB.font = [UIFont systemFontOfSize:13.5];
    [shareView addSubview:friendlLB];
    
    
    UIButton *imagePoolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imagePoolBtn.frame = CGRectMake(currentViewWidth-50-50, CGRectGetMinY(friendBtn.frame), 50, 50);
    [imagePoolBtn setBackgroundImage:[UIImage imageNamed:@"share1.png"] forState:0];
    imagePoolBtn.tag = 101;
    [imagePoolBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:imagePoolBtn];
    
    UILabel *imagePoolLB = [UILabel new];
    imagePoolLB.frame = CGRectMake(CGRectGetMinX(imagePoolBtn.frame), CGRectGetMaxY(friendBtn.frame), CGRectGetWidth(friendBtn.frame), 30);
    imagePoolLB.text = @"朋友圈";
    imagePoolLB.textAlignment = NSTextAlignmentCenter;
    imagePoolLB.font = [UIFont systemFontOfSize:13.5];
    [shareView addSubview:imagePoolLB];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake((currentViewWidth-60)/2, CGRectGetMaxY(imagePoolLB.frame), 70, 50);
    [cancleBtn setTitle:@"取消" forState:0];
    cancleBtn.titleLabel.font =[UIFont systemFontOfSize:14.7];
    [cancleBtn setTitleColor:[UIColor blackColor] forState:0];
    [cancleBtn addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cancleBtn];
}
-(void)tapAction{
    shareView.hidden = YES;
    shareBackView.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
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
    //[requestAll setValue:@"www.diyoupin.com" forHTTPHeaderField: @"Referer"];
    
//    //配置对象
    int tempHeight = 0;
    if (iPhoneX||iPhoneXr||iPhoneXs||iPhoneX_Max) {
        tempHeight = 44;
    }
        NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:PAWKCookiesKey];
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
    [self createShareView];
}

-(void)setIsShopping:(BOOL)isShopping{
    int tempHeight = 0;
    if (iPhoneX||iPhoneXr||iPhoneXs||iPhoneX_Max) {
        tempHeight = 44;
    }
    _webViews.frame =CGRectMake(0, 0, currentViewWidth, currentViewHeight-tempHeight-56);
    _isShopping = isShopping;
    
    UIView *button = [_webViews viewWithTag:1];
    CGRect frame = button.frame;
    UIView *button2 = [_webViews viewWithTag:2];
    button2.frame = frame;
    [button removeFromSuperview];
    
    int height = 130;
    if (self.isShopping) {
        height = 130+48;
    }
    shareView.frame = CGRectMake(0, currentViewHeight-height, currentViewWidth, 130);
    
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
    //[requestAll setValue:@"www.diyoupin.com" forHTTPHeaderField: @"Referer"];
    
    //    //配置对象
    int tempHeight = 0;
    if (iPhoneX||iPhoneXr||iPhoneXs||iPhoneX_Max) {
        tempHeight = 44;
    }
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:PAWKCookiesKey];
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
   
    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 32*1024*1024; // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];

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
    
    NSString *userAgent = [_webViews stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    if(![userAgent containsString:@"native/app"]){
        NSString *newUserAgent = [userAgent stringByAppendingString:@" native/app"];//自定义需要拼接的字符串
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    }
    
    if([requestSt isEqualToString:@"https://www.diyoupin.com/mobile/User/logout.html"]){
        //删除NSHTTPCookieStorage中的cookies
        NSHTTPCookieStorage *NSCookiesStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [NSCookiesStore removeCookiesSinceDate:[NSDate dateWithTimeIntervalSince1970:0]];
        
        NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: @[]];
        [[NSUserDefaults standardUserDefaults] setObject:cookiesData forKey:PAWKCookiesKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
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
        shareBackView.hidden = NO;
        shareView.hidden = NO;
        shareRequestStr = requestSt;
        return NO;
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
-(void)shareAction:(UIButton *)btn{
    NSString *requestSt = shareRequestStr;
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
    if(btn.tag==100){
        //好友
        req1.scene = WXSceneSession;
    }else if (btn.tag ==101){
        req1.scene = WXSceneTimeline;
    }
    
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
    if([WXApi openWXApp]){
         [WXApi sendReq:req1];
    }else{
        [AdaptInterface tipMessageTitle:@"请检查是否安装了微信客户端!" view: self.view];
    }
   
    
    shareBackView.hidden = YES;
    shareView.hidden = YES;
}
- (void)dealloc
{
    //1、加载空页面
     _webViews.delegate = nil;
    [_webViews stopLoading];
    [_webViews removeFromSuperview];
    
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    
    [_progressView removeFromSuperview];
    _progressProxy.webViewProxyDelegate = nil;
    _progressProxy.progressDelegate = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
