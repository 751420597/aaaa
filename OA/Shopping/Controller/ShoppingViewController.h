//
//  ShoppingViewController.h
//  OA
//
//  Created by 翟凤禄 on 2018/10/15.
//  Copyright © 2018年 xinpingTech. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface ShoppingViewController : BaseViewController<UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate,NJKWebViewProgressDelegate>
@property (nonatomic, strong) NSString *urlstring;
@end


