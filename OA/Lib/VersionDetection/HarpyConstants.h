//
//  HarpyConstants.h
//  
//
//  Created by Arthur Ariel Sabintsev on 1/30/13.
//
//

//*******#warning Please customize Harpy's static variables

/*
 Option 1 (DEFAULT): NO gives user option to update during next session launch
 Option 2: YES forces user to update app on launch
 */
static BOOL harpyForceUpdate = NO;

// 2. Your AppID (found in iTunes Connect) 你的app的id(需要从苹果那边获取)
#define kHarpyAppID                 @"1095909826"

// 3. Customize the alert title and action buttons
#define kHarpyAlertViewTitle        @"版本更新"
#define kHarpyCancelButtonTitle     @"稍后更新"
#define kHarpyUpdateButtonTitle     @"现在更新"
#define aPPName                     @"善盈宝"