//
//  HttpManager.h
//  SYB
//
//  Created by llc on 15/12/15.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Reachability.h"

typedef void(^CompletionBlockWithTime)(id result,long timeDiff,NSString *networkTime);
typedef void(^CompletionBlock)(id result);
typedef void(^ErrorBlock)(id result);
typedef void(^FailureBlock)(id result);
typedef void(^StopRequestBlock)();

@interface HttpManager : NSObject

/**
 *    请求数据
 *  @param urlString     接口地址(不完整)
 *  @param headers       请求头信息{@"sessionId":@"value"}
 *  @param params        参数(字典)
 *  @param method        请求的方式
 *  @param completion    完成回调block
 *  @param failure       失败回调block
 
 */
+ (AFHTTPRequestOperationManager *)requestDataWithURL:(NSString *)urlString
                                          httpHeaders:(NSString *)headers
                                               params:(NSMutableDictionary *)params
                                           tipMessage:(UIView *)view
                                           httpMethod:(NSString *)method
                                           completion:(CompletionBlock)block
                                              failure:(FailureBlock)failureBlock;

/**
 *    请求数据
 *  @param urlString     接口地址(不完整)
 *  @param headers       请求头信息{@"sessionId":@"value"}
 *  @param params        参数(字典)
 *  @param method        请求的方式
 *  @param completion    完成回调block
 *  @param failure       失败回调block
 *  @param stopRequest   停止请求block
 */
- (AFHTTPRequestOperation *)requestDataWithURL:(NSString *)urlString
                                       hasHttpHeaders:(BOOL)hasHeader
                                               params:(NSMutableDictionary *)params
                                           tipMessage:(UIView *)view
                                           httpMethod:(NSString *)method
                                           completion:(CompletionBlock)block
                                       failure:(FailureBlock)failureBlock;


//带返回时间
- (AFHTTPRequestOperation *)requestDataContainTimeWithURL:(NSString *)urlString
                                           hasHttpHeaders:(BOOL)hasHeader
                                                   params:(NSMutableDictionary *)params
                                               tipMessage:(UIView *)view
                                               httpMethod:(NSString *)method
                                               completion:(CompletionBlockWithTime)block
                                                  failure:(FailureBlock)failureBlock;

/**
 *   文件上传
 *  @param urlString     接口地址(不完整)
 *  @param params        参数(字典)
 *  @param filePath      文件路径
 *  @param completion    完成回调block
 *  @param failure       失败回调block
 
 */
+ (AFHTTPRequestOperationManager *)upLoadFileWithURL:(NSString *)urlString
                                              params:(NSMutableDictionary *)params
                                            filePath:(NSString *)filePath
                                          tipMessage:(UIView *)view
                                          completion:(CompletionBlock)block
                                             failure:(FailureBlock)failureBlock;






/**
 *  AFNetworking请求数据*****************添加一个错误回调
 *  @param urlString 接口地址(不完整)
 *  @param headers   请求头信息
 *  @param params    参数
 *  @param method    请求的方式
 *  @param block     回调block
 *  @param datas     要上传的数据,保存在数组中
 *  @param failureBlock     出错的回调
 *
 *  @return session的datatask任务
 */
- (AFHTTPRequestOperation *)afRequestWithURL2:(NSString *)urlString
                                hasHttpHeaders:(BOOL)headers
                                       params:(NSMutableDictionary *)params
                                       data:(NSMutableDictionary *)datas
                                 tipMessage:(UIView *)view
                                 httpMethod:(NSString *)method
                                 completion:(CompletionBlockWithTime)block
                                    failure:(FailureBlock)failureBlock;



- (AFHTTPRequestOperation *)requestDataWithURL:(NSString *)urlString
                                    hasHttpHeaders:(BOOL)hasHeader
                                            params:(NSMutableDictionary *)params
                                        withController:(BaseViewController *)controller
                                        httpMethod:(NSString *)method
                                        completion:(CompletionBlock)block
                                             error:(ErrorBlock)errorblock
                                           failure:(FailureBlock)failureBlock;
@end
