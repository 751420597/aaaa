//
//  Dock.h
//  Test
//
//  Created by user on 14-7-31.
//  Copyright (c) 2014年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Dock : UIImageView

-(void) addDockItemWithIcon:(NSString *)icon withSelect:(NSString *)selectedIcon withTitle:(NSString *)title withMark:(int)mark;

@property(nonatomic,copy) void (^dockItemClick)(int index);

@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, retain) UIButton *redMessage;

@end
