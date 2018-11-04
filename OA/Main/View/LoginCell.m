//
//  LoginCell.m
//  OA
//
//  Created by 翟凤禄 on 2018/10/29.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import "LoginCell.h"

@implementation LoginCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createView];
    }
    return self;
}
-(void)createView{
    
    self.keyLB =[[UILabel alloc]initWithFrame:CGRectZero];
    self.keyLB.font =[UIFont systemFontOfSize:15.5f];
    [self.contentView addSubview:self.keyLB];
    [self.keyLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.height.mas_offset([AdaptInterface convertHeightWithHeight:60]);
    }];
    
    self.valueTF =[[UITextField alloc]initWithFrame:CGRectZero];
    self.valueTF.font =[UIFont systemFontOfSize:15.5f];
    [self.contentView addSubview:self.valueTF];
    [self.valueTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.keyLB.mas_right).mas_offset(8);
        make.height.mas_equalTo(self.keyLB);
    }];
    
    self.btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right);
         make.height.mas_equalTo(self.keyLB);
    }];
    

    [self.btn addTarget:self action:@selector(changeImage) forControlEvents:UIControlEventTouchUpInside];
}
-(void)changeImage{
    
    
        
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies])
        {
            [storage deleteCookie:cookie];
        }
        //缓存web清除
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
    
    int x = arc4random() % 100000;
    NSString *url = [NSString stringWithFormat:@"https://www.diyoupin.com/Mobile/User/verify/rand/%d.html",x];
    [HttpManager downloadFromUrl:url success:^(id result) {
        [self.btn sd_setBackgroundImageWithURL:result forState:0];
    } faile:^(id result) {
        
    }];

    
}
@end
