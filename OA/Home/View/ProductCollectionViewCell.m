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
    //商品图片
    _commodityImg = [[UIImageView alloc] init];
    _commodityImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_commodityImg];
    
    //商品名称
    _commodityNameLabel = [[UILabel alloc] init];
    _commodityNameLabel.font = kSystemFontOfSize(14);
    _commodityNameLabel.textColor = colorWithHexString(@"#333333");
    //_commodityNameLabel.numberOfLines = 2;
    [_commodityNameLabel sizeToFit];
    [self.contentView addSubview:_commodityNameLabel];
    
    //商品规格
    _commoditySpecLabel = [[UILabel alloc] init];
    _commoditySpecLabel.font = kSystemFontOfSize(10);
    _commoditySpecLabel.textColor = colorWithHexString(@"#999999");
    [self.contentView addSubview:_commoditySpecLabel];
    
    //商品最小批发数量
    _minWholesaleQuanLabel = [[UILabel alloc] init];
    _minWholesaleQuanLabel.font = kSystemFontOfSize(10);
    _minWholesaleQuanLabel.textColor = colorWithHexString(@"#ffffff");
    _minWholesaleQuanLabel.backgroundColor = colorWithHexString(@"#4a90e2");
    _minWholesaleQuanLabel.layer.cornerRadius = [AdaptInterface convertWidthWithWidth:2];
    _minWholesaleQuanLabel.layer.masksToBounds = YES;
    _minWholesaleQuanLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_minWholesaleQuanLabel];
    
    //商品价格
    _commodityPriceLabel = [[UILabel alloc] init];
    _commodityPriceLabel.font = kSystemFontOfSize(14);
    _commodityPriceLabel.textColor = [UIColor blueColor];
    [self.contentView addSubview:_commodityPriceLabel];
    
    //购物车按钮
    _shoppingCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shoppingCartBtn addTarget:self action:@selector(shoppingCartBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_shoppingCartBtn];
    
    
    //线
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = colorWithHexString(@"#f4f4f4");
    [self.contentView addSubview:_lineView];
    
    
}
@end
