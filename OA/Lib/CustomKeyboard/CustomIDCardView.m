//
//  CustomIDCardView.m
//  CustomKeyBoard
//
//  Created by xinping-imac-1 on 16/1/4.
//  Copyright (c) 2016年 libaozi. All rights reserved.
//

#import "CustomIDCardView.h"
#define Kwidth self.frame.size.width
#define Kheight self.frame.size.height
@implementation CustomIDCardView
@synthesize toolBar,btnItem,space,space1,space2,doneBtn;
@synthesize TField,temString;
@synthesize delegate;
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
        self.backgroundColor=[UIColor lightGrayColor];
        temString=[NSMutableString string];
    }
    return self;
}

-(void)setToolBarWithTarget:(id)target action:(SEL)action withTitleColor:(UIColor *)doneBtnColor{
    toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, Kwidth, 44)];
    
    btnItem=[UIButton buttonWithType:UIButtonTypeCustom];
    btnItem.frame=CGRectMake(0, 0, 20, 20);
    [btnItem setBackgroundImage:[UIImage imageNamed:@"shan_03"] forState:UIControlStateNormal];
    
    btnItem.userInteractionEnabled=NO;
    space=[[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    
    space.customView=btnItem;
    
    space1=[[UIBarButtonItem alloc]initWithTitle:@"轻松理财" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [space1 setTitleTextAttributes:@{NSForegroundColorAttributeName:colorWithHexString(@"#FFD200"),NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    
    space1.enabled=NO;
    space2=[[UIBarButtonItem alloc]initWithTitle:@"快乐生活" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [space2 setTitleTextAttributes:@{NSForegroundColorAttributeName:colorWithHexString(@"#FFD200"),NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    space2.enabled=NO;
    
    doneBtn= [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:target action:action];
    
    [doneBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:doneBtnColor,NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    
    //调整两个item之间的距离.flexible表示距离是动态的,fixed表示是固定的
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [toolBar setItems:@[flexible,space1,space,space2,flexible,doneBtn]];
}
-(void)initView{
    for (int i=0; i<12; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(i%3*(self.frame.size.width/3+.5)+.5, i/3*(self.frame.size.height/4+.5)+.5, self.frame.size.width/3, self.frame.size.height/4);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag=100+(i+1);
        
        if (i<9) {
            [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        }else if(i==9){
            [btn setTitle:@"X" forState:UIControlStateNormal];
        }else if (i==10){
            [btn setTitle:@"0" forState:UIControlStateNormal];
        }
        else if (i==11){
            [btn setBackgroundImage:[UIImage imageNamed:@"delete_h"] forState:UIControlStateNormal];
            
            [btn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateHighlighted];
            
        }
        
        [btn setBackgroundColor:[UIColor whiteColor]];
        if (i!=11) {
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_bg_h"] forState:UIControlStateHighlighted];
        }
        
        
        
        [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
    }
}

-(void)clickAction:(UIButton *)button{
    if([TField.text isEqualToString:@""]){
        temString= [NSMutableString stringWithString:@""];
    }
    NSString *keyText=button.titleLabel.text;
    if (button.tag>100&&button.tag<112) {
        [temString appendString:keyText];
        if (temString.length<19) {
             [TField insertText:keyText];//在光标处进行添加
        }
    }else if (button.tag==112){
         [TField deleteBackward];//在光标处删除
        temString = [NSMutableString stringWithString:TField.text];
       
        if (temString.length>0) {
           // [temString deleteCharactersInRange:NSMakeRange(temString.length-1, 1)];
            NSLog(@"删除tem=%@",temString);
        }
    }
    if ([self.delegate respondsToSelector:@selector(changeTField:withString:)]) {
        [self.delegate changeTField:TField withString:temString];
    }
     //TField.text = temString;
    
}

-(void)limitWordCount:(int)count1 {
    
    [self.TField addTarget:self action:@selector(limit) forControlEvents:UIControlEventEditingChanged];
    self.count1 = count1;
}
-(void)limit{
    if(self.TField.text.length>self.count1){
    
        self.TField.text =[self.TField.text substringToIndex:self.count1];
        return;
    }
}

//- (void)setTextField:(UITextField *)textField {
//   
//    TField = textField;
//    
//    TField.delegate=self;
//    TField.clearButtonMode=UITextFieldViewModeWhileEditing;
//    
//}


@end
