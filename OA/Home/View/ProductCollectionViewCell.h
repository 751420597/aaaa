//
//  ProductCollectionViewCell.h
//  OA
//
//  Created by 翟凤禄 on 2018/10/28.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef  void (^Block)(NSString *link,NSInteger index);
@interface ProductCollectionViewCell : UICollectionViewCell
/**
 商品图片
 */
@property(nonatomic,strong) UIImageView *commodityImg;
/**
 商品名称
 */
@property(nonatomic,strong) UILabel *commodityNameLabel;


/**
 商品价格
 */
@property(nonatomic,strong) UILabel *commodityPriceLabel;

/**
 购物车按钮
 */
@property(nonatomic,strong) UIButton *shoppingCartBtn;

/**
 线
 */
@property(nonatomic,strong) UIView *lineView;

@property(nonatomic,copy)Block block;
@end

NS_ASSUME_NONNULL_END
