//
//  HelpCenterViewController.h
//  mdffx
//
//  Created by xinping-2 on 2017/7/20.
//  Copyright © 2017年 xinpingTech. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
@interface HelpCenterViewController : BaseViewController<UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate,NJKWebViewProgressDelegate>
@property (nonatomic, strong) NSString *urlstring;
@end