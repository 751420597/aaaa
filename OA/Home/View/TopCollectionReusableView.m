//
//  TopCollectionReusableView.m
//  OA
//
//  Created by 翟凤禄 on 2018/10/28.
//  Copyright © 2018 xinpingTech. All rights reserved.
//

#import "TopCollectionReusableView.h"
#import "UIButton+WebCache.h"

@implementation TopCollectionReusableView

@synthesize hRAdview,cycleScrollView,activeBtn0,activeBtn1,activeBtn2,nameItem0,nameItem1,nameItem2,nameItem3,nameItem4,nameItem5,nameItem6,nameItem7;
-(instancetype)initWithFrame:(CGRect)frame{
    if([super initWithFrame:frame]){
        self.backgroundColor =[UIColor whiteColor];
        
        [self creatSubView];
        [self createSudokuView];
        [self creatActivityView];
    }
    return self;
}
-(void)creatSubView{
    
    // 情景二：采用网络图片实现
    //NSMutableArray *imagesURLStrings = _cycleImages;
    
    //网络加载 --- 创建带标题的图片轮播器
    cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [AdaptInterface convertWidthWithWidth:iphone6Width], [AdaptInterface convertHeightWithHeight:150]) imageURLStringsGroup:self.adImageArr]; // 模拟网络延时情景
    
    cycleScrollView.delegate = self;
    cycleScrollView.placeholderImage = [UIImage imageNamed:@"cyclePlaceholders.png"];
    
    [self addSubview:cycleScrollView];
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSDictionary *dic = self.adArr[index];
    NSString *linkStr = dic[@"ad_link"];
    if (self.block) {
        _block(linkStr,index);
    }
}
//8宫格
-(void)createSudokuView{
    
    OderItemView *v0 = [[OderItemView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(cycleScrollView.frame), currentViewWidth/4, currentViewWidth/4)];
    v0.textLB.text = @"我要开店";
    v0.imgView.tag = 1;
    [v0.imgView addTarget:self action:@selector(pushSudoku:)  forControlEvents:UIControlEventTouchUpInside];
    [v0.imgView setImage:[UIImage imageNamed:@"我要开店"] forState:0];
    [self addSubview:v0];
    
    OderItemView *v1 = [[OderItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(v0.frame), CGRectGetMaxY(cycleScrollView.frame), currentViewWidth/4, currentViewWidth/4)];
    v1.textLB.text = @"充值中心";
    [v1.imgView setImage:[UIImage imageNamed:@"充值中心"] forState:0];
    v1.imgView.tag = 2;
    [v1.imgView addTarget:self action:@selector(pushSudoku:)  forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:v1];
    
    OderItemView *v2 = [[OderItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(v1.frame), CGRectGetMaxY(cycleScrollView.frame), currentViewWidth/4, currentViewWidth/4)];
    v2.textLB.text = @"分享领红包";
    [v2.imgView setImage:[UIImage imageNamed:@"分享领红包"] forState:0];
    v2.imgView.tag = 3;
    [v2.imgView addTarget:self action:@selector(pushSudoku:)  forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:v2];
    
    OderItemView *v3 = [[OderItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(v2.frame), CGRectGetMaxY(cycleScrollView.frame), currentViewWidth/4, currentViewWidth/4)];
    v3.textLB.text = @"九九封顶";
    [v3.imgView setImage:[UIImage imageNamed:@"九九封顶"] forState:0];
    v3.imgView.tag = 4;
    [v3.imgView addTarget:self action:@selector(pushSudoku:)  forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:v3];
    
    
    OderItemView *v01 = [[OderItemView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(v0.frame), currentViewWidth/4, currentViewWidth/4)];
    v01.textLB.text = @"每日新品";
    [v01.imgView setImage:[UIImage imageNamed:@"每日新品"] forState:0];
    v01.imgView.tag = 5;
    [v01.imgView addTarget:self action:@selector(pushSudoku:)  forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:v01];
    
    OderItemView *v11 = [[OderItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(v0.frame), CGRectGetMaxY(v0.frame), currentViewWidth/4, currentViewWidth/4)];
    v11.textLB.text = @"微商爆款";
    [v11.imgView setImage:[UIImage imageNamed:@"微商爆款"] forState:0];
    v11.imgView.tag = 6;
    [v11.imgView addTarget:self action:@selector(pushSudoku:)  forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:v11];
    
    OderItemView *v21 = [[OderItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(v1.frame), CGRectGetMaxY(v0.frame), currentViewWidth/4, currentViewWidth/4)];
    v21.textLB.text = @"网红零食";
    [v21.imgView setImage:[UIImage imageNamed:@"网红零食"] forState:0];
    v21.imgView.tag = 7;
    [v21.imgView addTarget:self action:@selector(pushSudoku:)  forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:v21];
    
    OderItemView *v31 = [[OderItemView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(v2.frame), CGRectGetMaxY(v0.frame), currentViewWidth/4, currentViewWidth/4)];
    v31.textLB.text = @"拼团好货";
    [v31.imgView setImage:[UIImage imageNamed:@"拼团好货"] forState:0];
    v31.imgView.tag = 8;
    [v31.imgView addTarget:self action:@selector(pushSudoku:)  forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:v31];
    
    UILabel *line = [UILabel new];
    line.frame = CGRectMake(0, CGRectGetMaxY(v31.frame)+1, currentViewWidth, 2);
    line.backgroundColor = kThemeColor;
    [self addSubview:line];
    
    UILabel *notificationLb = [[UILabel alloc]initWithFrame:CGRectMake([AdaptInterface convertWidthWithWidth:15], CGRectGetMaxY(line.frame), [AdaptInterface convertWidthWithWidth:63], [AdaptInterface convertHeightWithHeight:35])];
    notificationLb.text = @"小迪公告:";
    
    notificationLb.font = [UIFont systemFontOfSize:13.f];
    [self addSubview:notificationLb];
    
    hRAdview = [[HRAdView alloc]initWithTitles:@[@"通知",@"通知"]];
    hRAdview.frame = CGRectMake(CGRectGetMaxX(notificationLb.frame), CGRectGetMinY(notificationLb.frame), currentViewWidth-[AdaptInterface convertWidthWithWidth:30]*2 , [AdaptInterface convertHeightWithHeight:35]);
    hRAdview.textAlignment = NSTextAlignmentLeft;//默认
    hRAdview.isHaveTouchEvent = YES;
    hRAdview.labelFont = [UIFont systemFontOfSize:14.f];
    hRAdview.backgroundColor = [UIColor clearColor];
    hRAdview.time = 3.0f;
    hRAdview.color = colorWithHexString(@"#787878");
    //hRAdview.edgeInsets = UIEdgeInsetsMake(8, 8,8, 0);
    __weak typeof(self) weakself = self;
    
    hRAdview.clickAdBlock = ^(NSUInteger index){
        
    };
    [self addSubview:hRAdview];
    [hRAdview beginScroll];
    
    UILabel *line2 = [UILabel new];
    line2.frame = CGRectMake(0, CGRectGetMaxY(hRAdview.frame)+1, currentViewWidth, 2);
    line2.backgroundColor = kThemeColor;
    [self addSubview:line2];
    
}
-(void)creatActivityView{
    
    activeBtn0 =[UIButton buttonWithType:UIButtonTypeCustom];
    activeBtn0.frame = CGRectMake([AdaptInterface convertWidthWithWidth:15], CGRectGetMaxY(hRAdview.frame)+3+[AdaptInterface convertHeightWithHeight:5], (currentViewWidth-[AdaptInterface convertWidthWithWidth:60])/3, [AdaptInterface convertHeightWithHeight:120]);
    activeBtn0.tag = 100;
    activeBtn0.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [activeBtn0 setImage:[UIImage imageNamed:@"indexc1"] forState:0];
    [activeBtn0 addTarget:self action:@selector(adAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:activeBtn0];
    
    activeBtn1 =[UIButton buttonWithType:UIButtonTypeCustom];
    activeBtn1.frame = CGRectMake([AdaptInterface convertWidthWithWidth:15]+CGRectGetMaxX(activeBtn0.frame), CGRectGetMinY(activeBtn0.frame), CGRectGetWidth(activeBtn0.frame), CGRectGetHeight(activeBtn0.frame));
    activeBtn1.tag = 101;
    activeBtn1.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [activeBtn1 setImage:[UIImage imageNamed:@"indexc2"] forState:0];
    [activeBtn1 addTarget:self action:@selector(adAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:activeBtn1];
    
    activeBtn2 =[UIButton buttonWithType:UIButtonTypeCustom];
    activeBtn2.frame = CGRectMake([AdaptInterface convertWidthWithWidth:15]+CGRectGetMaxX(activeBtn1.frame), CGRectGetMinY(activeBtn0.frame), CGRectGetWidth(activeBtn0.frame), CGRectGetHeight(activeBtn0.frame));

    [activeBtn2 setImage:[UIImage imageNamed:@"indexc3"] forState:0];
    activeBtn2.imageView.contentMode = UIViewContentModeScaleAspectFit;
    activeBtn2.tag = 102;
    [activeBtn2 addTarget:self action:@selector(adAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:activeBtn2];
    
    UILabel *line = [UILabel new];
    line.frame = CGRectMake(0, CGRectGetMaxY(activeBtn2.frame)+[AdaptInterface convertHeightWithHeight:5], currentViewWidth, 2);
    line.backgroundColor = kThemeColor;
    [self addSubview:line];
    
    UILabel *nameLb= [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame)+[AdaptInterface convertHeightWithHeight:5], currentViewWidth, [AdaptInterface convertHeightWithHeight:50])];
    nameLb.text = @"品牌折扣区";
    nameLb.textColor = [UIColor grayColor];
    nameLb.textAlignment = NSTextAlignmentCenter;
    nameLb.font =[UIFont systemFontOfSize:20.f];
    [self addSubview:nameLb];
    
    
    nameItem0 =[UIButton buttonWithType:UIButtonTypeCustom];
    nameItem0.frame = CGRectMake(0, CGRectGetMaxY(nameLb.frame), currentViewWidth/4,currentViewWidth/4);
    nameItem0.userInteractionEnabled = NO;
    nameItem0.tag = 1;
    [nameItem0 addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nameItem0];
    
    nameItem1 =[UIButton buttonWithType:UIButtonTypeCustom];
    nameItem1.frame = CGRectMake(CGRectGetMaxX(nameItem0.frame), CGRectGetMaxY(nameLb.frame), currentViewWidth/4,currentViewWidth/4);
    nameItem1.userInteractionEnabled = NO;
    nameItem1.tag = 2;
    [nameItem1 addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nameItem1];
    
    nameItem2 =[UIButton buttonWithType:UIButtonTypeCustom];
    nameItem2.frame = CGRectMake(CGRectGetMaxX(nameItem1.frame), CGRectGetMaxY(nameLb.frame), currentViewWidth/4,currentViewWidth/4);
    nameItem2.userInteractionEnabled = NO;
    nameItem2.tag = 3;
    [nameItem2 addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nameItem2];
    
    nameItem3 =[UIButton buttonWithType:UIButtonTypeCustom];
    nameItem3.frame = CGRectMake(CGRectGetMaxX(nameItem2.frame), CGRectGetMaxY(nameLb.frame), currentViewWidth/4,currentViewWidth/4);
    nameItem3.userInteractionEnabled = NO;
    nameItem3.tag = 4;
    [nameItem3 addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nameItem3];
    
    nameItem4 =[UIButton buttonWithType:UIButtonTypeCustom];
    nameItem4.frame = CGRectMake(0, CGRectGetMaxY(nameItem0.frame), currentViewWidth/4,currentViewWidth/4);
    nameItem4.userInteractionEnabled = NO;
    nameItem4.tag = 5;
    [nameItem4 addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nameItem4];
    
    nameItem5 =[UIButton buttonWithType:UIButtonTypeCustom];
    nameItem5.frame = CGRectMake(CGRectGetMaxX(nameItem4.frame), CGRectGetMaxY(nameItem0.frame), currentViewWidth/4,currentViewWidth/4);
    nameItem5.userInteractionEnabled = NO;
    nameItem5.tag = 6;
    [nameItem5 addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nameItem5];
    
    nameItem6 =[UIButton buttonWithType:UIButtonTypeCustom];
    nameItem6.frame = CGRectMake(CGRectGetMaxX(nameItem5.frame), CGRectGetMaxY(nameItem0.frame), currentViewWidth/4,currentViewWidth/4);
    nameItem6.userInteractionEnabled = NO;
    nameItem6.tag = 7;
    [nameItem6 addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nameItem6];
    
    nameItem7 =[UIButton buttonWithType:UIButtonTypeCustom];
    nameItem7.frame = CGRectMake(CGRectGetMaxX(nameItem6.frame), CGRectGetMaxY(nameItem0.frame), currentViewWidth/4,currentViewWidth/4);
    nameItem7.userInteractionEnabled = NO;
    nameItem7.tag = 8;
    [nameItem7 addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nameItem7];
    
    UILabel *line1 =[UILabel new];
    line1.frame = CGRectMake(0, CGRectGetMaxY(nameItem7.frame), currentViewWidth, 2);
    line1.backgroundColor = kThemeColor;
    [self addSubview:line1];
    
    
    self.pView0 = [[PrefectureVie alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line1.frame), currentViewWidth, [AdaptInterface convertHeightWithHeight:200])];
    [self addSubview:self.pView0];
    
    self.pView1 = [[PrefectureVie alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_pView0.frame), currentViewWidth, [AdaptInterface convertHeightWithHeight:200])];
    [self addSubview:self.pView1];
    
    self.pView2 = [[PrefectureVie alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_pView1.frame), currentViewWidth, [AdaptInterface convertHeightWithHeight:200])];
    [self addSubview:self.pView2];
    
    
    UILabel *line2 =[UILabel new];
    line2.frame = CGRectMake(0, CGRectGetMaxY(self.pView2.frame), currentViewWidth, 2);
    line2.backgroundColor = kThemeColor;
    [self addSubview:line2];
    
    UILabel *nameLb2= [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line2.frame)+[AdaptInterface convertHeightWithHeight:5], currentViewWidth, [AdaptInterface convertHeightWithHeight:50])];
    nameLb2.text = @"猜你喜欢";
    nameLb2.textColor = [UIColor grayColor];
    nameLb2.textAlignment = NSTextAlignmentCenter;
    nameLb2.font =[UIFont systemFontOfSize:20.f];
    [self addSubview:nameLb2];
    
    UILabel *line3 =[UILabel new];
    line3.frame = CGRectMake(0, CGRectGetMaxY(nameLb2.frame), currentViewWidth, 2);
    line3.backgroundColor = kThemeColor;
    [self addSubview:line3];
}

-(CGFloat)getHeight{
    return CGRectGetMaxY(self.pView2.frame)+4+[AdaptInterface convertHeightWithHeight:55];
}
-(void)setYanxuanArr:(NSArray *)yanxuanArr{
//    [self.pView0.imgViewBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:yanxuanArr[0]] forState:0];
    self.pView0.titleLB.text =yanxuanArr[0][@"position_name"];
     self.pView1.titleLB.text =yanxuanArr[1][@"position_name"];
     self.pView2.titleLB.text =yanxuanArr[2][@"position_name"];
    
    self.pView0.contentLB.text =yanxuanArr[0][@"position_desc"];
    self.pView1.contentLB.text =yanxuanArr[1][@"position_desc"];
    self.pView2.contentLB.text =yanxuanArr[2][@"position_desc"];
}
-(void)setAdArr:(NSArray *)adArr{
    _adArr = adArr;
    self.adImageArr = [NSMutableArray array];
    for (NSDictionary *dic in adArr) {
        [self.adImageArr addObject:[NSString stringWithFormat:@"%@%@",kRequestIP,dic[@"ad_code"]]];
    }
    cycleScrollView.imageURLStringsGroup = self.adImageArr;
}
-(void)setIconeArr:(NSArray *)iconeArr{
    _iconeArr= iconeArr;
    [nameItem0 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kRequestIP,iconeArr[0][@"logo"]]] forState:0];
    [nameItem1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kRequestIP,iconeArr[1][@"logo"]]] forState:0];
    [nameItem2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kRequestIP,iconeArr[2][@"logo"]]] forState:0];
    [nameItem3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kRequestIP,iconeArr[3][@"logo"]]] forState:0];
    [nameItem4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kRequestIP,iconeArr[4][@"logo"]]] forState:0];
    [nameItem5 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kRequestIP,iconeArr[5][@"logo"]]] forState:0];
    [nameItem6 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kRequestIP,iconeArr[6][@"logo"]]] forState:0];
    [nameItem7 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kRequestIP,iconeArr[7][@"logo"]]] forState:0];
    
    nameItem0.userInteractionEnabled = YES;
    nameItem1.userInteractionEnabled = YES;
    nameItem2.userInteractionEnabled = YES;
    nameItem3.userInteractionEnabled = YES;
    nameItem4.userInteractionEnabled = YES;
    nameItem5.userInteractionEnabled = YES;
    nameItem6.userInteractionEnabled = YES;
    nameItem7.userInteractionEnabled = YES;
}
-(void)pushAction:(UIButton*)btn{
    if (self.blockLink) {
        self.blockLink(self.iconeArr[btn.tag -1][@"url"], btn.tag);
    }
}
-(void)pushSudoku:(UIButton*)btn{
    NSString *url = @"";
    switch (btn.tag) {
        case 1:
            url = @"Mobile/User/level_add";
            break;
        case 2:
            url = @"mobile/User/mobilemoney";
            break;
        case 3:
            url = @"mobile/Shop/share/id/{}";
            break;
        case 4:
            url = @"Mobile/Goods/goodsList/id/1080";
            break;
        case 5:
            url = @"Mobile/Goods/goodsList/id/1081";
            break;
        case 6:
            url = @"Mobile/Goods/goodsList/id/1082";
            break;
        case 7:
            url = @"Mobile/Goods/goodsList/id/1328";
            break;
        case 8:
            url = @"mobile/Activity/group_list";
            break;
            
        default:
            break;
    }
    if(self.blockSudokuLink){
        self.blockSudokuLink(url, btn.tag);
    }
    
}
-(void)adAction:(UIButton *)btn{
    NSString *url = @"";
    switch (btn.tag) {
        case 100:
                url = @"/Mobile/Goods/goodsList/id/1115";
            break;
        case 101:
            url = @"/Mobile/Goods/goodsList/id/1116";
            break;
        case 102:
            url = @"/Mobile/Goods/goodsList/id/1117";
            break;
            
        default:
            break;
    }
    if(self.blockAdLink){
        self.blockAdLink(url, btn.tag);
    }
}
-(void)setInfo:(NSString *)info{
    
   
}
@end
