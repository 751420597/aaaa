
#import "KDGoalBar.h"

@implementation KDGoalBar
@synthesize    percentLabel;

#pragma Init & Setup
- (id)init
{
	if ((self = [super init]))
	{
		[self setup];
	}
    
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		[self setup];
	}
    
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		[self setup];
	}
    
	return self;
}


-(void)layoutSubviews {
    
    int percent;
    
    NSLog(@"%f",percentLayer.percent);
    if (percentLayer.percent != -1) {
        float currentPercent =  percentLayer.percent;
        if (currentPercent < 1 && currentPercent > 0) {
            percent = 1;
        }
        else if (currentPercent >=99 && currentPercent <100) {
            percent = 99;
        }
        else{
            percent = (int)ceilf(currentPercent);
        }
        
        if (percent > 0) {
            NSString *percentStr =[NSString stringWithFormat:@"%i%%", percent];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:percentStr];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(str.length -1,1)];
            percentLabel.attributedText = str;
            percentLabel.textColor =colorWithHexString(@"#01C8B5");
        }
        else{
            percentLabel.text =@"0%";
            percentLabel.textColor = colorWithHexString(@"#828282");
        }
    }
    else{  //表示大于1亿元
        percentLabel.text =@"无限额";
        percentLabel.textColor = colorWithHexString(@"#828282");
    }
    
    

    CGRect frame = self.frame;
    CGRect labelFrame = percentLabel.frame;
    labelFrame.origin.x = frame.size.width / 2 - percentLabel.frame.size.width / 2;
    labelFrame.origin.y = frame.size.height / 2 - percentLabel.frame.size.height / 2;
    percentLabel.frame = labelFrame;
    
    [super layoutSubviews];
}

-(void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;

    
    percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 125, 125)];
    [percentLabel setFont:[UIFont systemFontOfSize:14]];
    [percentLabel setTextAlignment:NSTextAlignmentCenter];
    [percentLabel setBackgroundColor:[UIColor clearColor]];
    percentLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:percentLabel];
    
    thumbLayer = [CALayer layer];
    thumbLayer.contentsScale = [UIScreen mainScreen].scale;
    thumbLayer.contents = (id) thumb.CGImage;
    thumbLayer.frame = CGRectMake(self.frame.size.width / 2 - thumb.size.width/2, 0, thumb.size.width, thumb.size.height);
    thumbLayer.hidden = YES;

   
    
    percentLayer = [KDGoalBarPercentLayer layer];
    percentLayer.contentsScale = [UIScreen mainScreen].scale;
    percentLayer.percent = 0;
    percentLayer.frame = self.bounds;
    percentLayer.masksToBounds = NO;
    [percentLayer setNeedsDisplay];
    
    [self.layer addSublayer:percentLayer];
    [self.layer addSublayer:thumbLayer];
     
    
}


#pragma mark - Touch Events
- (void)moveThumbToPosition:(CGFloat)angle {
    CGRect rect = thumbLayer.frame;
    NSLog(@"%@",NSStringFromCGRect(rect));
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    angle -= (M_PI/2);
    NSLog(@"%f",angle);

    rect.origin.x = center.x + 75 * cosf(angle) - (rect.size.width/2);
    rect.origin.y = center.y + 75 * sinf(angle) - (rect.size.height/2);
    
    NSLog(@"%@",NSStringFromCGRect(rect));

    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    thumbLayer.frame = rect;
    
    [CATransaction commit];
}
#pragma mark - Custom Getters/Setters
- (void)setPercent:(float)percent animated:(BOOL)animated {
    
    CGFloat floatPercent = percent;
    if (percent == -1) { //表示大于1亿元
        floatPercent = -1;
    }
    else{
        //floatPercent = MIN(1, MAX(0, floatPercent));
    }
    
    
    percentLayer.percent = floatPercent;
    [self setNeedsLayout];
    [percentLayer setNeedsDisplay];
    
    //[self moveThumbToPosition:floatPercent * (2 * M_PI) - (M_PI/2)];
    
}


@end
