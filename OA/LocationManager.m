//
//  LocationManager.m
//  eld
//
//  Created by liye on 2018/1/23.
//  Copyright © 2018年 bus. All rights reserved.
//

#import "LocationManager.h"
/** 最大定位失败次数 */
//static int const MAX_FAILED_COUNT = 10;

@interface LocationManager() <CLLocationManagerDelegate>

/** 定位管理器 */
@property (nonatomic, strong) CLLocationManager *locationMgr;
@property (nonatomic, strong) CLGeocoder *geo;
/** 定位失败次数 */
@property (nonatomic, assign) int failedCount;

/** gps 故障监听 定时器 */
@property (nonatomic, strong) NSTimer *gpsMalfunctionTimer;

@property (nonatomic, strong) CLLocation *lastlocation;
@property (nonatomic, strong) CLLocation *currentlocation;
/** 检测时间 (秒)*/
@property (nonatomic, assign) float checkTime;
/** 一个检测定时器监听了几次*/
@property (nonatomic, assign) int checkCount;

/** 累计时间 (秒)*/
@property (nonatomic, assign) int  accumulationTime;

/** gps log 上报 的定时器 */
@property (nonatomic, strong) NSTimer *gpsLogTimer;


@end

@implementation LocationManager

+ (LocationManager *) shareManager {
    static LocationManager *_LocationManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _LocationManager = [[LocationManager alloc]init];
    });
    return _LocationManager;
}

#pragma mark - 初始化
- (instancetype)init {
    if (self = [super init]) {
        // 初始化定位系统
        self.locationMgr = [[CLLocationManager alloc] init];
        self.locationMgr.delegate = self;
        self.locationMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        self.locationMgr.distanceFilter = kCLDistanceFilterNone;
//        self.locationMgr.allowsBackgroundLocationUpdates = NO;
//        self.locationMgr.pausesLocationUpdatesAutomatically = YES;//不允许系统自动暂停
        // 判断定位
        [self requestLocationAuth];
    }
    return self;
}
- (void)requestLocationAuth {
    
    if ([self.locationMgr respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        NSLog(@"requestAlwaysAuthorization %d",[CLLocationManager locationServicesEnabled]);
        [self.locationMgr requestAlwaysAuthorization];
    }
    
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        //定位功能可用
        // 开始定位
        self.isEnable = YES;
        [self.locationMgr startUpdatingLocation];
        [self.locationMgr startMonitoringSignificantLocationChanges];
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        self.isEnable = NO;
        //定位不能用
    }
}
#pragma mark - 公共方法
/** 开启定位功能 */
- (void)startGPS {
    
    // 判断权限
    if ([CLLocationManager locationServicesEnabled]) {
        self.isEnable = YES;
        [self.locationMgr startUpdatingLocation];
    } else {
        self.isEnable = NO;
    }
}
/** 关闭定位功能 */
- (void)closeGPS {
    self.isEnable = NO;
    //[self stopGPSMalfunctionTimer];
}

//获取gps 可用状态
-(BOOL)isEnable{
    if(![CLLocationManager locationServicesEnabled]){
        self.isEnable = NO;
        return _isEnable;
    }
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways){
        self.isEnable = YES;
        
        return _isEnable;
    }else{
        self.isEnable = NO;
        return _isEnable;
    }
    
}

#pragma mark - 代理方法
/** 定位刷新 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {

    if (locations.count > 0) {
        
        // 获取位置
        CLLocation *location = locations.firstObject;
        
        self.latitude = location.coordinate.latitude;
        self.longitude = location.coordinate.longitude;
        
        //反地理编码
        self.geo=[[CLGeocoder alloc] init];
        CLGeocodeCompletionHandler handle=^(NSArray *placemarks,NSError *error){
            for (CLPlacemark *placeMark in placemarks) {
                //获取地理位置名称
                NSDictionary *addressDic=placeMark.addressDictionary;
                self.location=[addressDic objectForKey:@"City"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"location" object:nil userInfo:@{@"location":self.location}];
            }
        };
        //执行
        [self.geo reverseGeocodeLocation:location completionHandler:handle];
    }
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
}
/** 定位失败 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位失败:%@",error);
    if ([error code] == kCLErrorDenied ||[error code] ==kCLErrorRegionMonitoringDenied)
    {
        //访问被拒绝
        self.isEnable = NO;
    }
    
}

@end
