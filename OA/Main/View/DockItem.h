//
//  DockItem.h
//  Test
//
//  Created by user on 14-7-31.
//  Copyright (c) 2014年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DockItem : UIButton
{
    int _currentTag;
    int _messageCount;
}
@property(nonatomic,assign) int messageCount;
@property(nonatomic,assign) int expertMessageCount;
@end
