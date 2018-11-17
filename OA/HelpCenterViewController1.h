//
//  HelpCenterViewController.h
//  mdffx
//
//  Created by xinping-2 on 2017/7/20.
//  Copyright © 2017年 xinpingTech. All rights reserved.
//

#import "BaseViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import <WebKit/WebKit.h>

@interface HelpCenterViewController1 : BaseViewController<UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate,NJKWebViewProgressDelegate,
WKScriptMessageHandler,WKScriptMessageHandler>
@property (nonatomic, strong) NSString *urlstring;
@property(nonatomic,strong) NSString *tag;
@end
