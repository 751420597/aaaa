//
//  StoreCell.m
//  OA
//
//  Created by 翟凤禄 on 2018/10/23.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import "StoreCell.h"

@implementation StoreCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatView];
        self.backgroundColor = [UIColor whiteColor];
        self.backgroundView = nil;
    }
    return self;
    
}
-(void)creatView{
   
    self.textLB = [[UILabel alloc]init];
    self.textLB.font = [UIFont systemFontOfSize:16.5f];
    self.textLB.frame = CGRectMake([AdaptInterface convertWidthWithWidth:15], 0,[AdaptInterface convertWidthWithWidth:120], [AdaptInterface convertHeightWithHeight:60]);
    [self.contentView addSubview:self.textLB];
    
    self.numLB =[[UILabel alloc]init];
    self.numLB.frame = CGRectMake(currentViewWidth -[AdaptInterface convertWidthWithWidth:80], 0,[AdaptInterface convertWidthWithWidth:50] , [AdaptInterface convertHeightWithHeight:60]);
    
    self.numLB.font = [UIFont systemFontOfSize:14.5f];
    self.numLB.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.numLB];
    
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(currentViewWidth -[AdaptInterface convertHeightWithHeight:30]-[AdaptInterface convertWidthWithWidth:28], [AdaptInterface convertHeightWithHeight:15],[AdaptInterface convertHeightWithHeight:30] , [AdaptInterface convertHeightWithHeight:30])];
    self.imgView.contentMode = 1;
    
    [self.contentView addSubview:self.imgView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
