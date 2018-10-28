//
//  MyCell.m
//  OA
//
//  Created by 翟凤禄 on 2018/10/22.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatView];
        self.backgroundColor = [UIColor whiteColor];
        self.backgroundView = nil;
    }
    return self;
    
}
-(void)creatView{
    
    self.imgView =[[UIImageView alloc]init];
    self.imgView.frame =CGRectMake([AdaptInterface convertWidthWithWidth:15], [AdaptInterface convertHeightWithHeight:10],[AdaptInterface convertHeightWithHeight:20], [AdaptInterface convertHeightWithHeight:20]);
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.imgView];
    
    
    self.textLB = [[UILabel alloc]init];
    self.textLB.font = [UIFont systemFontOfSize:15.5f];
    self.textLB.frame = CGRectMake(CGRectGetMaxX(self.imgView.frame)+[AdaptInterface convertWidthWithWidth:5], 0,[AdaptInterface convertWidthWithWidth:120], [AdaptInterface convertHeightWithHeight:40]);
    [self.contentView addSubview:self.textLB];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
