//
//  LoginCell.h
//  OA
//
//  Created by 翟凤禄 on 2018/10/29.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"
NS_ASSUME_NONNULL_BEGIN
typedef  void (^Block)(BOOL isSelect);
@interface LoginCell : UITableViewCell
{
    BOOL isSelect;
}
@property(nonatomic,strong)UILabel *keyLB;
@property(nonatomic,strong)UITextField *valueTF;
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UIButton *seeBtn;
@property(nonatomic,copy)Block block;

-(void)changeImage;
@end

NS_ASSUME_NONNULL_END
