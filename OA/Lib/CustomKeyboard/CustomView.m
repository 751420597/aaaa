//
//  CustomView.m
//  CustomKeyBoard
//
//  Created by xinping-imac-1 on 15/11/11.
//  Copyright (c) 2015年 libaozi. All rights reserved.
//

#import "CustomView.h"
#define Kwidth self.frame.size.width
#define Kheight self.frame.size.height


@implementation CustomView

@synthesize btnItem;
@synthesize toolBar;
@synthesize space,space1,space2,doneBtn;
//@synthesize TField;
//@synthesize temString;
@synthesize num1,num2;
@synthesize alertView;
@synthesize decimalNumber;
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor lightGrayColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(editingDidBegin:)
                                                     name:UITextFieldTextDidBeginEditingNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(editingDidEnd:)
                                                     name:UITextFieldTextDidEndEditingNotification
                                                   object:nil];
        //temString=[NSMutableString string];
    }
    return self;
}
-(void)setMaxNumber:(double)maxNumber{
    _maxNumber = maxNumber;
}
-(void)setPointFlag:(BOOL)pointFlag{
    _pointFlag=pointFlag;
}
-(void)keyboardPointView{
    [self initInvestView];
}
-(void)initInvestView{
    
    for (int i=0; i<16; i++) {
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(i%4*(self.frame.size.width/4+.5)+.5, i/4*(self.frame.size.height/4+.5)+.5, self.frame.size.width/4, self.frame.size.height/4);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag=100+(i+1);
        if (i<3&&i>=0) {
            [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        }else if (i==3){
            [btn setTitle:@"+100" forState:UIControlStateNormal];
        }else if (i>=4&&i<=6){
            [btn setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        }else if (i==7){
            [btn setTitle:@"+1000" forState:UIControlStateNormal];
        }else if (i>=8&&i<=10){
            [btn setTitle:[NSString stringWithFormat:@"%d",i-1] forState:UIControlStateNormal];
        }else if (i==11){
            [btn setTitle:@"+10000" forState:UIControlStateNormal];
        }else if (i==12){
            [btn setTitle:@"." forState:UIControlStateNormal];
            if (self.pointFlag==YES) {
                btn.enabled=YES;
                [btn setBackgroundColor:[UIColor whiteColor]];
            }else{
                btn.enabled=NO;
                [btn setBackgroundColor:[UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1]];
            }
        }else if (i==13){
            [btn setTitle:@"0" forState:UIControlStateNormal];
        }else if (i==14){
            //[btn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"delete_h"] forState:UIControlStateHighlighted];
            //[btn setBackgroundImage:[UIImage imageNamed:@"delete_h"] forState:UIControlStateHighlighted];
        }else if (i==15){
            [btn setBackgroundImage:[UIImage imageNamed:@"Keyboard_Hide_Click"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"Keyboard_Hide_Normal"] forState:UIControlStateHighlighted];
        }
        if (i!=12) {
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
        
        if (i!=14&&i!=15) {
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_bg_h"] forState:UIControlStateHighlighted];
        }
        [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
    }
    
    
    
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


-(void)clickAction:(UIButton *)sender{
    
    //如果有点击任意 button 会出现以前输的字符的话请注开一下三行代码
    
    //    if([TField.text isEqualToString:@""]){
    //        temString= [NSMutableString stringWithString:@""];
    //    }
    //     NSString *keyText=sender.titleLabel.text;
    NSString *oldString;
    if ((sender.tag>=101&&sender.tag<=103)||(sender.tag>=105&&sender.tag<=107)||(sender.tag>=109&&sender.tag<=111)||(sender.tag>=113&&sender.tag<=114)){
        NSString *keyText=sender.titleLabel.text;
        oldString = self.textInput.text;
        NSLog(@"oldString=%@",oldString);
        [self.textInput insertText:keyText];
        NSLog(@"self.textInput=%@",self.textInput.text);
        //        NSRange rangeNumber = [self.textInput.text rangeOfString:keyText];
        //        if (rangeNumber.location==0&&[keyText isEqualToString:@"."]) {
        //            self.textInput.text = oldString;
        //        }
        
        //输入一般数字
        if ([self.textInput.text doubleValue]<self.maxNumber) {
            //把所点击的按钮对应数字添加进可变字符串
            
            /**
             *  判断当前字符串中是否为空并且当前输入的值是否是小数点
             */
            if ([self.textInput.text isEqualToString:@"."]&&[keyText isEqualToString:@"."]) {
                self.textInput.text=[NSMutableString stringWithFormat:@"0%@",keyText];
                self.num1 = [self.textInput.text doubleValue];
            }else{
                
                /**
                 *  如果是字符串中的数值为0. 的时候，再判断当前输入的sender是不是小数点，如果是，则展示
                 */
                if ([self.textInput.text isEqualToString:@"0."]) {
                    if ([keyText isEqualToString:@"."]) {
                        
                        return ;
                    }
                }
                else if (oldString.length!=0&&[self.textInput.text characterAtIndex:0]=='0'){//判断当前旧值有值，并且现在输入的值当中首位为0，且旧值当中不包含0.的
                    if (![oldString containsString:@"0."]) {
                        if ([oldString characterAtIndex:0]=='0'&&![keyText isEqualToString:@"0"]) {
                            self.textInput.text = keyText;
                            return;
                        }
                        self.textInput.text = oldString;//当第一次输入0时，第二次输入0时此时显示一个0；
                        return;
                    }else {
                        if ([oldString characterAtIndex:0]=='0'&&![keyText isEqualToString:@"."]) {
                            //判断小数点位数
                            NSArray *ary=[self.textInput.text componentsSeparatedByString:@"."];
                            NSString *pointString=[ary objectAtIndex:1];
                            if (pointString.length<=decimalNumber) {
                                NSLog(@"小数点位数=%lu",(unsigned long)pointString.length);
                            }else{
                                self.textInput.text=[self.textInput.text substringToIndex:[self.textInput.text length]-1];//如果超出范围则减去临时字符串中的最后一位
                                return;
                            }
                            return;
                        }
                        self.textInput.text = oldString;//当第一次输入0时，第二次输入0时此时显示一个0；
                        return;
                    }
                    
                    
                }
                /**
                 *  如果是字符串中的数值是否包含多个小数点. 的时候，再判断当前输入的sender是不是小数点，如果是，则清除临时字符串中的小数点，并return
                 */
                else if ([self.textInput.text containsString:@".."]){
                    
                    if ([keyText isEqualToString:@"."]) {
                        self.textInput.text=[self.textInput.text substringToIndex:[self.textInput.text length]-1];//如果超出范围则减去临时字符串中的最后一位
                        return ;
                    }
                }
                else if ([self.textInput.text containsString:@"."]){//判断当前值里面有点.
                    if ([keyText isEqualToString:@"."]) {
                        
                        if ([self.textInput.text characterAtIndex:0]=='.') {//判断首位等于.点的时候
                            self.textInput.text=[NSString stringWithFormat:@"0%@",keyText];
                            return;
                        }
                        else{//判断首位不等于.点的时候
                            if (![oldString containsString:@"."]) {//判断旧值不包含.点的时候
                                if ([[self.textInput.text substringToIndex:[self.textInput.text length]-1] containsString:@"."]) {
                                    self.textInput.text=[self.textInput.text substringToIndex:[self.textInput.text length]-1];//如果超出范围则减去临时字符串中的最后一位
                                    
                                    return;
                                }
                            }else{//旧值包含.点的时候
                                if ([keyText isEqualToString:@"."]){//判断当前输入值依然是.点
                                    self.textInput.text = oldString;
                                    return;
                                }
                            }
                        }
                    }
                    //判断小数点位数
                    NSArray *ary=[self.textInput.text componentsSeparatedByString:@"."];
                    NSString *pointString=[ary objectAtIndex:1];
                    if (pointString.length<=decimalNumber) {
                        NSLog(@"小数点位数=%lu",(unsigned long)pointString.length);
                    }else{
                        self.textInput.text=[self.textInput.text substringToIndex:[self.textInput.text length]-1];//如果超出范围则减去临时字符串中的最后一位
                        return;
                    }
                }
                else if ([self.textInput.text isEqualToString:@"00"]&&[keyText isEqualToString:@"0"]){
                    self.textInput.text=[self.textInput.text substringToIndex:[self.textInput.text length]-1];//首位是0，第二位输入依然是0，此时显示一个0
                    return;
                }
                else{
                    //判断第一个字符是0时，不输入小数点，此时输入其他数字进行替换
                    if (![self.textInput.text containsString:@"."]&&[[self.textInput.text substringToIndex:1] doubleValue]==0&&[keyText doubleValue]>0) {
                        self.textInput.text = keyText;
                    }
                }
            }
        }
        else {
            if ([self.textInput.text containsString:@"."]&&[self.textInput.text doubleValue]<self.maxNumber) {
                if ([keyText isEqualToString:@"."]) {
                    return ;
                }
            }//额度等于最大值时并且字符串包含小数点
            else if ([self.textInput.text containsString:@"."]&&[self.textInput.text doubleValue]==self.maxNumber){
                
                self.textInput.text = [self.textInput.text substringToIndex:[self.textInput.text length]-1];
                return;
            }
            else if ([self.textInput.text containsString:@"."]&&[self.textInput.text doubleValue]>self.maxNumber){
                //这里解决的是首次连续输入两次+10000，输入小数点及两位小数，然后选择光标到中间位置输入个位数越界时引起的问题。oldString 是原始值，self.textInput.text 是最新值，当输入的数字越界，则继续使用原始值
                self.textInput.text = oldString;
                alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的金额已超出最大范围" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertView show];
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideView:) userInfo:nil repeats:NO];
                return;
            }
            else{
                //额度等于最大值时
                if ([self.textInput.text doubleValue]==self.maxNumber) {
                    if ([self.textInput.text characterAtIndex:0]=='0') {
                        self.textInput.text = oldString;
                    }
                    return;
                }
                if ([keyText isEqualToString:@"."]) {
                    
                }else{
                    alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的金额已超出最大范围" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    [alertView show];
                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideView:) userInfo:nil repeats:NO];
                    self.textInput.text=oldString;
                    return;
                }
                self.textInput.text=oldString;
            }
        }
        
    }
    else if (sender.tag==116){
        //确认按钮，回收键盘
        [self.textInput resignFirstResponder];
    }
    else if (sender.tag==115){
        //清除按钮
        if (self.textInput.text.length>0) {
            [self.textInput deleteBackward];
        }
    }
    else if (sender.tag==104||sender.tag==108||sender.tag==112){
        //+100，+1000，+10000
        NSString *keyText=[sender.titleLabel.text substringFromIndex:1];
        NSLog(@"相加前数据=%@",self.textInput.text);
        if ([self.textInput.text doubleValue]<self.maxNumber) {
            self.num1 = [self.textInput.text doubleValue];
            //判断当tfield.text为空时
            if ([self.textInput.text isEqualToString:@""]) {
                self.num2 = [keyText doubleValue];
                self.num2+=self.num1;
                self.textInput.text = [NSString stringWithFormat:@"%.0f",self.num2];
            }
            //当tfield.text 包含小数点时
            else if([self.textInput.text containsString:@"."]){
                NSLog(@"~~~~%@",[self.textInput.text substringFromIndex:self.textInput.text.length-1]);
                
                if (![[self.textInput.text substringToIndex:self.textInput.text.length-2] containsString:@"."]) {
                    if (![self.textInput.text isEqualToString:@""]) {
                        self.num2 = [self.textInput.text doubleValue];
                    }
                    self.num1 = [keyText doubleValue];
                    self.num2+=self.num1;
                    
                    NSString *subString=[NSString stringWithFormat:@"%f",self.num2];
                    //iOS精确货币计算
                    NSDecimalNumberHandler *roundUp=[NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:2
                                                                                                raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
                    //将NSString类型转化为NSDecimalNumber类型
                    NSDecimalNumber *decN=[NSDecimalNumber decimalNumberWithString:subString];
                    //将取得的值进行处理，取两位小数，并且不四舍五入
                    NSDecimalNumber *decM = [decN decimalNumberByRoundingAccordingToBehavior:roundUp];
                    
                    self.textInput.text = [NSString stringWithFormat:@"%@",decM];
                    NSLog(@"tf2=%@",self.textInput.text);
                }
                else{
                    if (![self.textInput.text isEqualToString:@""]) {
                        self.num2 = [self.textInput.text doubleValue];
                        NSLog(@"num2=%lf",self.num2);
                    }
                    self.num1 = [keyText doubleValue];
                    NSLog(@"num1=%lf",self.num1);
                    self.num2+=self.num1;
                    NSLog(@"num2q=%lf",self.num2);
                    
                    
                    if (self.num2>self.maxNumber) {
                        alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的金额已超出最大范围" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                        
                        [alertView show];
                        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideView:) userInfo:nil repeats:NO];
                        return;
                    }
                    NSString *subString=[NSString stringWithFormat:@"%f",self.num2];
                    //iOS精确货币计算
                    NSDecimalNumberHandler *roundUp=[NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:2
                                                                                                raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
                    //将NSString类型转化为NSDecimalNumber类型
                    NSDecimalNumber *decN=[NSDecimalNumber decimalNumberWithString:subString];
                    //将取得的值进行处理，取两位小数，并且不四舍五入
                    NSDecimalNumber *decM = [decN decimalNumberByRoundingAccordingToBehavior:roundUp];
                    
                    //将NSDecimalNumber类型再次转为NSString类型并给tfield赋值
                    self.textInput.text = [NSString stringWithFormat:@"%@",decM];
                    NSLog(@"tf2=%@",self.textInput.text);
                }
            }
            else{
                //不为空，则输出计算结果
                if ([keyText isEqualToString:@"100"]||[keyText isEqualToString:@"1000"]||[keyText isEqualToString:@"10000"]) {
                    
                    if (![self.textInput.text isEqualToString:@""]) {
                        self.num2 = [self.textInput.text doubleValue];
                    }
                    self.num1 = [keyText doubleValue];
                    //判断当前输入值是否小于一百万 因为最大为7位，如果大于则提示金额超出范围
                    if (self.num2<self.maxNumber) {
                        self.num2+=self.num1;
                        if (self.num2>self.maxNumber) {
                            alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的金额已超出最大范围" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                            
                            [alertView show];
                            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideView:) userInfo:nil repeats:NO];
                            return;
                        }
                    }else{
                        alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的金额已超出最大范围" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                        
                        [alertView show];
                        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideView:) userInfo:nil repeats:NO];
                        return ;
                    }
                    self.textInput.text = [NSString stringWithFormat:@"%.0lf",self.num2];
                    NSLog(@"tf2=%@",self.textInput.text);
                }
            }
            
        }
        else{
            alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的金额已超出最大范围" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            
            [alertView show];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideView:) userInfo:nil repeats:NO];
            
            return ;
        }
    }
    if ([self.delegate respondsToSelector:@selector(changeTField:withString:)]) {
        [self.delegate changeTField:self.textInput withString:self.textInput.text];
    }
}
-(void)limitWordCount:(int)count1 {
    
    [self.textInput addTarget:self action:@selector(limit) forControlEvents:UIControlEventEditingChanged];
    self.count1 = count1;
}
-(void)limit{
    if(self.textInput.text.length>self.count1){
        
        self.textInput.text =[self.textInput.text substringToIndex:self.count1];
        return;
    }
}
-(void)hideView:(NSTimer*)sender{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark -
#pragma mark - Notification Action
- (void)editingDidBegin:(NSNotification *)notification {
    if (![notification.object conformsToProtocol:@protocol(UITextInput)])
    {
        self.textInput = nil;
        return;
    }
    self.textInput = notification.object;
}

- (void)editingDidEnd:(NSNotification *)notification
{
    self.textInput = nil;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
