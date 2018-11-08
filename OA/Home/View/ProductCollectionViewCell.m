//
//  ProductCollectionViewCell.m
//  OA
//
//  Created by 翟凤禄 on 2018/10/28.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import "ProductCollectionViewCell.h"

@implementation ProductCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self creatView];
        self.contentView.backgroundColor = kThemeColor;
        
        
    }
    return self;
}

-(void)creatView
{
    CGFloat width = (currentViewWidth-15)/2;
    CGFloat height = [AdaptInterface convertHeightWithHeight:254+3];
    //商品图片
    _commodityImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height-80)] ;
    _commodityImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_commodityImg];
    
    //商品名称
    _commodityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height-80, width, 50)];
    _commodityNameLabel.font = kSystemFontOfSize(13);
    _commodityNameLabel.textColor = colorWithHexString(@"#333333");
    _commodityNameLabel.numberOfLines = 0;
    [self.contentView addSubview:_commodityNameLabel];

    //商品价格
    _commodityPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height-30,width/2, 30)];
    _commodityPriceLabel.font = kSystemFontOfSize(14);
    _commodityPriceLabel.textColor = [UIColor blueColor];
    [self.contentView addSubview:_commodityPriceLabel];
    
    //购物车按钮
    _shoppingCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shoppingCartBtn.frame = CGRectMake(CGRectGetMaxX(_commodityPriceLabel.frame), height-30, width/2, 30);
    [_shoppingCartBtn addTarget:self action:@selector(shoppingCartBtn) forControlEvents:UIControlEventTouchUpInside];
    [_shoppingCartBtn setTitle:@"找相似" forState:0];
    _shoppingCartBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_shoppingCartBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.contentView addSubview:_shoppingCartBtn];
    
    //线
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = colorWithHexString(@"#f4f4f4");
    [self.contentView addSubview:_lineView];
}
-(void)shoppingCartBtn{
    
}
@end
