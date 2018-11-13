//
//  LocationManager.h
//  eld
//
//  Created by liye on 2018/1/23.
//  Copyright © 2018年 bus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define LOCATION_MANAGER_LOCATION_CHANGED @"LocationManagerLocationChanged"
#define LocationGpsLog @"LocationGpsLog"

@interface LocationManager : NSObject


/** 经度 实时刷新 */
@property (nonatomic, assign) double latitude;

/** 纬度 实时刷新 */
@property (nonatomic, assign) double longitude;

/** 所在地点 */
@property (nonatomic, copy) NSString *location;

/** 是否可用 */
@property (nonatomic, assign) BOOL isEnable;

/** 申请location 权限 */
- (void)requestLocationAuth;

/** 开启定位功能 */
- (void)startGPS;
/** 关闭定位功能 */
- (void)closeGPS;

/** 开启后台运行功能 */
- (void)startBackgroundMode;
/** 关闭后台运行功能 */
- (void)closeBackgroundMode;

+ (LocationManager *) shareManager;
@end
