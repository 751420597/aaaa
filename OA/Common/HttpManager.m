//
//  HttpManager.m
//  SYB
//
//  Created by llc on 15/12/15.
//  Copyright (c) 2015年 xinpingTech. All rights reserved.
//

#import "HttpManager.h"
#import "NSDate+InternetDateTime.h"
@implementation HttpManager

//普通的上传方式
+ (NSURLSessionDataTask *)requestDataWithURL2:(NSString *)urlString
                               hasHttpHeaders:(BOOL)hasHeader
                                       params:(NSDictionary *)params
                               withController:(BaseViewController *)controller
                                   httpMethod:(NSString *)method
                                   completion:(CompletionBlock)block
                                        error:(ErrorBlock)errorblock
                                      failure:(FailureBlock)failureBlock{
    //1.拼接完整的网址
    //拼接完整URL
    NSString *fullURLString = [kRequestIP stringByAppendingString:urlString];
    
    //2.拼接参数
    if (params == nil)
    {
        params = [NSMutableDictionary dictionary];
    }
    
    NSURLSessionDataTask *operation;
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15;//设置请求超时时间
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];//申明请求的数据是json类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer ];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/zip",@"application/octet-stream",@"text/json",@"text/plain",@"application/msword",@"application/x-img",@"application/x-jpg",@"application/x-png",@"application/json",@"image/png",@"text/javascript", nil];//申明接收类型可能是json，可能是字符串
    if (hasHeader) {
        [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"ACCEPT"];
    }
    
    [manager.requestSerializer setValue:@"DAssist" forHTTPHeaderField:@"DTOAUTH"];
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:PAWKCookiesKey];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
        
    }
    // 安全策略
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    
    //5.发送请求
    if ([[method uppercaseString] isEqualToString:@"GET"])
    {
        NSLog(@"%@提交的数据%@",fullURLString,params);
        operation = [manager GET:fullURLString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:fullURLString]];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:PAWKCookiesKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                id dict=[NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
                //NSLog(@"获取到的数据为：%@",dict);;
                int code0 = [dict[@"status"] intValue] ;
                 int code1 = [dict[@"code"] intValue] ;
                [SVProgressHUD dismiss];
                if (code1 == 1||code0==1) {
                    block(dict);
                }
                else{
                    NSString *message =dict[@"msg"];
                    if(message.length<=0){
                        [AdaptInterface tipMessageTitle:@"未知错误" view:controller.view];
                    }else{
                        [AdaptInterface tipMessageTitle:message view:controller.view];
                    }
                    
                    errorblock(dict);
                }
                
            });
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            //这里用userDefaults这么做的目的是为了解决请求数据时调用这个方法的同时进行下拉刷新，解决请求超时时刷新时间改变的这一变态的可有可无的bug。
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [userDefaults setInteger:error.code forKey:@"kCFURLErrorTimedOut"];
            [userDefaults synchronize];
            
            if (error.code == NSURLErrorCannotFindHost || error.code ==kCFURLErrorNotConnectedToInternet) {
                
                [AdaptInterface tipMessageTitle:@"请检查网络连接" view:controller.view];
            }
            else if(error.code == kCFURLErrorTimedOut){
                
                [AdaptInterface tipMessageTitle:@"网络连接失败" view:controller.view];
                
            }
            else if(error.code == kCFURLErrorCancelled){
                
                NSLog(@"请求已取消___");
            }
            else{
                
                [AdaptInterface tipMessageTitle:@"操作失败" view:controller.view];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock(@"");
            });
        }];
    }
    else{
        //post提交
        operation =[manager POST:fullURLString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSHTTPURLResponse *response=  (NSHTTPURLResponse *)task.response;
//                NSString * setCookie = [[NSUserDefaults standardUserDefaults]  objectForKey:@"setCookie"];
//                if(!setCookie){
//                    setCookie = @"";
//                }
//                    NSDictionary *dic = response.allHeaderFields;
//                NSString *cookie = dic[@"Set-Cookie"];
//
//                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@%@",setCookie,cookie] forKey:@"setCookie"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
                
               
                NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:fullURLString]];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:PAWKCookiesKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                id dict=[NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
                if ([dict isKindOfClass:[NSArray class]]) {
                    block(dict);
                }else if([dict isKindOfClass:[NSDictionary class]]){
                   // NSLog(@"获取到的数据为：%@",dict[@"data"]);
                    //[AdaptInterface tipMessageTitle:dict[@"data"][@"user_id"] view:controller.view];
                    int code0 = [dict[@"status"] intValue] ;
                    int code1 = [dict[@"code"] intValue] ;
                    int code2 = [dict[@"errNo"] intValue] ;
                    
                    [SVProgressHUD dismiss];
                    if (code1 == 1||code0==1 ||code2 ==1 ||dict[@"iosApplying"] !=nil) {
                        block(dict);
                    }
                    else{
                        NSString *message =dict[@"msg"];
                        if(message.length<=0){
                            
                        }else{
                            [AdaptInterface tipMessageTitle:message view:controller.view];
                        }
                        
                        errorblock(dict);
                    }
                }
                
                //
            });
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            //这里用userDefaults这么做的目的是为了解决请求数据时调用这个方法的同时进行下拉刷新，解决请求超时时刷新时间改变的这一变态的可有可无的bug。
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [userDefaults setInteger:error.code forKey:@"kCFURLErrorTimedOut"];
            [userDefaults synchronize];
            
            if (error.code == NSURLErrorCannotFindHost || error.code ==kCFURLErrorNotConnectedToInternet) {
                
                [AdaptInterface tipMessageTitle:@"请检查网络连接" view:controller.view];
            }
            else if(error.code == kCFURLErrorTimedOut){
                
                [AdaptInterface tipMessageTitle:@"网络连接失败" view:controller.view];
                
            }
            else if(error.code == kCFURLErrorCancelled){
                
                NSLog(@"请求已取消___");
            }
            else{
                
                [AdaptInterface tipMessageTitle:@"操作失败" view:controller.view];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock(@"");
            });
        }];
        
        
    }
    return operation;
    
}

/**
 *  文件下载
 */
+ (NSURLSessionDownloadTask *)downloadFromUrl:(NSString *)urlString success:(CompletionBlock)success faile:(ErrorBlock)faile{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15;//设置请求超时时间
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/zip",@"text/json",@"text/plain",@"application/msword",@"application/x-img",@"application/x-jpg",@"image/png",@"application/x-png",@"image/jpeg",@"application/ms-excel",@"application/octet-stream",@"application/pdf",@"text/css",@"text/xml",@"image/gif",@"application/vnd.ms-powerpoint",@"text/rtf", nil];//申明接收类型可能是json，可能是字符串,zip,word,jpg,png
    
    NSURL *urlpath = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlpath];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
       
        
        if (error) {
             faile(error);
        }else{
            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:urlString]];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:PAWKCookiesKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            success(filePath);
        }
    }];
    
    [downloadTask resume];
    return downloadTask;
    
}

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
                                              failure:(FailureBlock)failureBlock

{
    //1.拼接完整的网址
    //拼接完整URL
    NSString *fullURLString = [kRequestIP stringByAppendingString:urlString];
    
    //2.拼接参数
    if (params == nil)
    {
        params = [NSMutableDictionary dictionary];
    }
    
    AFHTTPRequestOperation *operation;
    
    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 15;//设置请求超时时间
    
    //处理返回键,时防止多次弹出提示框
    NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
    BOOL notRequsrt = [user boolForKey:@"notRequsrt"];
    BOOL formRegistVCnotRequest=[user boolForKey:@"formRegistVCnotRequest"];
    if(notRequsrt){
        [SVProgressHUD dismiss];
        return operation;
    }
    if (formRegistVCnotRequest) {
        [SVProgressHUD dismiss];
        [user setBool:NO forKey:@"formRegistVCnotRequest"];
        [user synchronize];
        return operation;
    }
    
    if (hasHeader) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *sessionId = [userDefaults objectForKey:@"sessionId"];
        [manager.requestSerializer setValue:sessionId forHTTPHeaderField:@"loginSessionId"];
    }
    NSArray *array = [fullURLString componentsSeparatedByString:@"/"]; //为打印方法名
    //5.发送请求
    if ([[method uppercaseString] isEqualToString:@"GET"])
    {
        
        operation = [manager GET:fullURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(responseObject);
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //[SVProgressHUD dismiss];
            //这里用userDefaults这么做的目的是为了解决请求数据时调用这个方法的同时进行下拉刷新，解决请求超时时刷新时间改变的这一变态的可有可无的bug。
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [userDefaults setInteger:error.code forKey:@"kCFURLErrorTimedOut"];
            [userDefaults synchronize];
            
            if (error.code == NSURLErrorCannotFindHost || error.code ==kCFURLErrorNotConnectedToInternet) {
                
                [AdaptInterface tipMessageTitle:@"请检查网络连接" view:view];
            }
            else if(error.code == kCFURLErrorTimedOut){
                
                [AdaptInterface tipMessageTitle:@"网络连接失败" view:view];
               
            }
            else if(error.code == kCFURLErrorCancelled){
                
                NSLog(@"请求已取消___%@",[array lastObject]);
            }
            else{
                
                [AdaptInterface tipMessageTitle:@"操作失败" view:view];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock(@"");
            });
        }];
        
        
    }
    else{ //post提交
        
        operation = [manager POST:fullURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(responseObject);
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //这里用userDefaults这么做的目的是为了解决请求数据时调用这个方法的同时进行下拉刷新，解决请求超时时刷新时间改变的这一变态的可有可无的bug。
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [userDefaults setInteger:error.code forKey:@"kCFURLErrorTimedOut"];
            [userDefaults synchronize];

            
            if (error.code == NSURLErrorCannotFindHost || error.code ==kCFURLErrorNotConnectedToInternet) {
                
                [AdaptInterface tipMessageTitle:@"请检查网络连接" view:view];
            }
            else if(error.code == kCFURLErrorTimedOut){
                
                [AdaptInterface tipMessageTitle:@"网络连接失败" view:view];
            }
            else if(error.code == kCFURLErrorCancelled){
                
                NSLog(@"请求已取消___%@",[array lastObject]);
            }
            else{
                
                [AdaptInterface tipMessageTitle:@"操作失败" view:view];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock(@"");
            });
        }];
    }
    
    return operation;
}



- (AFHTTPRequestOperation *)requestDataContainTimeWithURL:(NSString *)urlString
                                hasHttpHeaders:(BOOL)hasHeader
                                        params:(NSMutableDictionary *)params
                                    tipMessage:(UIView *)view
                                    httpMethod:(NSString *)method
                                    completion:(CompletionBlockWithTime)block
                                       failure:(FailureBlock)failureBlock

{
    //1.拼接完整的网址
    //拼接完整URL
    NSString *fullURLString = [kRequestIP stringByAppendingString:urlString];
    
    //2.拼接参数
    if (params == nil)
    {
        params = [NSMutableDictionary dictionary];
    }
    
    //3.构造AFHTTPSessionManager对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval =15;
    //4.序列化方式
    //序列化response
    manager.responseSerializer =[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    
    
    NSURLSessionDataTask *task = nil;
    
    //GET请求, 设置参数
    task = [manager GET:fullURLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        //回到主线程刷新UI界面
        //拿到请求结果,回调
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            NSString *time =response.allHeaderFields[@"Date"];
            NSLog(@"字典数据：%@",response.allHeaderFields);
            NSDate* inputDate = [NSDate dateFromRFC822String:time];
            //NSDate *loac =[NSDate date];
            //NSDate *localTime =[AdaptInterface getNowDateFromatAnDate:inputDate];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
            dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8 * 3600];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *networkTime = [dateFormatter stringFromDate:inputDate];
            
            NSTimeInterval differTime = (long)[inputDate timeIntervalSinceDate:[NSDate date]];
            block(responseObject,differTime,networkTime);
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error:%@",error);
        
        [SVProgressHUD dismiss];
        if (error.code == NSURLErrorCannotFindHost || error.code ==kCFURLErrorNotConnectedToInternet) {
            
            [AdaptInterface tipMessageTitle:@"请检查网络连接" view:view];
        }
        else if(error.code == kCFURLErrorTimedOut){
            
            [AdaptInterface tipMessageTitle:@"网络连接失败" view:view];
        }
        else{
            
            [AdaptInterface tipMessageTitle:@"操作失败" view:view];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            failureBlock(@"");
        });
        return;
    }];
    NSLog(@"task%@",task);
    return nil;
}
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
                                            failure:(FailureBlock)failureBlock
{
    //1.拼接完整的网址
    //拼接完整URL
    NSString *fullURLString = [kRequestIP stringByAppendingString:urlString];
    
    //2.拼接参数
    if (params == nil)
    {
        params = [NSMutableDictionary dictionary];
    }
    
    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 15;//设置请求超时时间

    
    [manager POST:fullURLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"file" fileName:@"user.png" mimeType:@"image/png" error:nil];
        //[formData]
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //这里用userDefaults这么做的目的是为了解决请求数据时调用这个方法的同时进行下拉刷新，解决请求超时时刷新时间改变的这一变态的可有可无的bug。
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:error.code forKey:@"kCFURLErrorTimedOut"];
        [userDefaults synchronize];

        
        if (error.code == NSURLErrorCannotFindHost || error.code ==kCFURLErrorNotConnectedToInternet) {
            
            [AdaptInterface tipMessageTitle:@"请检查网络连接" view:view];
        }
        else if(error.code == kCFURLErrorTimedOut){
            
            [AdaptInterface tipMessageTitle:@"网络连接失败" view:view];
        }
        else if(error.code == kCFURLErrorCancelled){
            
            NSLog(@"请求已取消___Upload");
        }
        else{
            
            [AdaptInterface tipMessageTitle:@"操作失败" view:view];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            failureBlock(@"");
        });
    }];
    return manager;
}


-(void)loginWithToken:(NSString *)token withImei:(NSString *)imei
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"loginToken":token,@"imei":imei}];
    
    
    if ([AdaptInterface isConnected]) {
        
        [HttpManager requestDataWithURL:@"/syb/mobilemember/public/savelogin.html" httpHeaders:nil params:params tipMessage:nil httpMethod:@"POST" completion:^(id result) {
            
            NSLog(@"denglu------%@",result);
            int code = [result[@"code"] intValue];
            //NSString *message = result[@"message"];
            NSString *sessionId = result[@"sessionId"];
            
            if (code == 0)
            {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:sessionId forKey:@"sessionId"];
                [userDefaults synchronize];
            }
            else{
                
            }
            
        } failure:^(id result) {
            
        }];
    }else
    {
        return;
    }
}





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
- (AFHTTPRequestOperation *)afRequestWithURL2:(NSString *)urlString hasHttpHeaders:(BOOL)headers params:(NSMutableDictionary *)params data:(NSMutableDictionary *)datas tipMessage:(UIView *)view httpMethod:(NSString *)method completion:(CompletionBlockWithTime)block failure:(FailureBlock)failureBlock
{
    
    
    //1.拼接完整的网址
    //拼接完整URL
    NSString *fullURLString = [kRequestIP stringByAppendingString:urlString];
    
    //2.拼接参数
    if (params == nil)
    {
        params = [NSMutableDictionary dictionary];
    }
    
    AFHTTPRequestOperation *operation;
    
    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 15;//设置请求超时时间
    if (headers) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *sessionId = [userDefaults objectForKey:@"sessionId"];
        [manager.requestSerializer setValue:sessionId forHTTPHeaderField:@"loginSessionId"];
    }
    NSArray *array = [fullURLString componentsSeparatedByString:@"/"]; //为打印方法名
    
    //5.发送请求
    if ([[method uppercaseString] isEqualToString:@"GET"])
    {
        
        operation = [manager GET:fullURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)operation.response;
                NSString *time =response.allHeaderFields[@"Date"];
                NSDate* inputDate = [NSDate dateFromRFC822String:time];
              
                //NSDate *loac =[NSDate date];
                //NSDate *localTime =[AdaptInterface getNowDateFromatAnDate:inputDate];
                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *networkTime = [dateFormatter stringFromDate:inputDate];
                
                NSTimeInterval differTime = (long)[inputDate timeIntervalSinceDate:[NSDate date]] + 66;
                block(responseObject,differTime,networkTime);
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //[SVProgressHUD dismiss];
            //这里用userDefaults这么做的目的是为了解决请求数据时调用这个方法的同时进行下拉刷新，解决请求超时时刷新时间改变的这一变态的可有可无的bug。
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [userDefaults setInteger:error.code forKey:@"kCFURLErrorTimedOut"];
            [userDefaults synchronize];

            
            if (error.code == NSURLErrorCannotFindHost || error.code ==kCFURLErrorNotConnectedToInternet) {
                
                [AdaptInterface tipMessageTitle:@"请检查网络连接" view:view];
            }
            else if(error.code == kCFURLErrorTimedOut){
                
                [AdaptInterface tipMessageTitle:@"网络连接失败" view:view];
            }
            else if(error.code == kCFURLErrorCancelled){
                
                NSLog(@"请求已取消___%@",[array lastObject]);
            }
            else{
                
                [AdaptInterface tipMessageTitle:@"操作失败" view:view];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock(@"");
            });
        }];
        
        
    }
    else{ //post提交
        
        operation = [manager POST:fullURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)operation.response;
                NSString *time =response.allHeaderFields[@"Date"];
                NSDate* inputDate = [NSDate dateFromRFC822String:time];
                  NSLog(@"inputDate=%@",inputDate);
                
                NSDate*date2=[inputDate dateByAddingTimeInterval:24*60*60];
                NSLog(@"%@",date2);
                
                
                
                
                
                
               // NSDate *loac =[NSDate date];
                //NSDate *localTime =[AdaptInterface getNowDateFromatAnDate:inputDate];
                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *networkTime = [dateFormatter stringFromDate:date2];
                
                NSTimeInterval differTime = (long)[date2 timeIntervalSinceDate:[NSDate date]] + 66;
                block(responseObject,differTime,networkTime);
                
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //这里用userDefaults这么做的目的是为了解决请求数据时调用这个方法的同时进行下拉刷新，解决请求超时时刷新时间改变的这一变态的可有可无的bug。
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [userDefaults setInteger:error.code forKey:@"kCFURLErrorTimedOut"];
            [userDefaults synchronize];

            
            if (error.code == NSURLErrorCannotFindHost || error.code ==kCFURLErrorNotConnectedToInternet) {
                
                [AdaptInterface tipMessageTitle:@"请检查网络连接" view:view];
            }
            else if(error.code == kCFURLErrorTimedOut){
                
                [AdaptInterface tipMessageTitle:@"网络连接失败" view:view];
            }
            else if(error.code == kCFURLErrorCancelled){
                
                NSLog(@"请求已取消___%@",[array lastObject]);
            }
            else{
                
                [AdaptInterface tipMessageTitle:@"操作失败" view:view];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock(@"");
            });
        }];
    }
    
    return operation;

}


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
                                        withController:(BaseViewController *)controller
                                        httpMethod:(NSString *)method
                                        completion:(CompletionBlock)block
                                             error:(ErrorBlock)errorblock
                                           failure:(FailureBlock)failureBlock

{
    //1.拼接完整的网址
    //拼接完整URL
    NSString *fullURLString = [kRequestIP stringByAppendingString:urlString];
    
    //2.拼接参数
    if (params == nil)
    {
        params = [NSMutableDictionary dictionary];
    }
    
    AFHTTPRequestOperation *operation;
    
    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 15;//设置请求超时时间
    
    
    if (hasHeader) {
        [manager.requestSerializer setValue:@"DAssist" forHTTPHeaderField:@"Dtoauth"];
        [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X_Requested_With"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    }
    NSArray *array = [fullURLString componentsSeparatedByString:@"/"]; //为打印方法名
    //5.发送请求
    if ([[method uppercaseString] isEqualToString:@"GET"])
    {
        
        operation = [manager GET:fullURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
               // block(responseObject);
                int code = [responseObject[@"code"] intValue];
                
                if (code == 0) {
                    block(responseObject);
                }
                else if (code ==20007 || code ==20011 || code ==20012 || code ==20027) {//用户被挤下去，没有找到用户
                    errorblock(kTipLogin);
                }
                else{
                    errorblock(responseObject);
                }
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //[SVProgressHUD dismiss];
            //这里用userDefaults这么做的目的是为了解决请求数据时调用这个方法的同时进行下拉刷新，解决请求超时时刷新时间改变的这一变态的可有可无的bug。
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [userDefaults setInteger:error.code forKey:@"kCFURLErrorTimedOut"];
            [userDefaults synchronize];
            
            if (error.code == NSURLErrorCannotFindHost || error.code ==kCFURLErrorNotConnectedToInternet) {
                
                [AdaptInterface tipMessageTitle:@"请检查网络连接" view:controller.view];
            }
            else if(error.code == kCFURLErrorTimedOut){
                
                [AdaptInterface tipMessageTitle:@"网络连接失败" view:controller.view];
                
            }
            else if(error.code == kCFURLErrorCancelled){
                
                NSLog(@"请求已取消___%@",[array lastObject]);
            }
            else{
                
                [AdaptInterface tipMessageTitle:@"操作失败" view:controller.view];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock(@"");
            });
        }];
        
        
    }
    else{ //post提交
        
        operation = [manager POST:fullURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(responseObject);
                int code = [responseObject[@"code"] intValue];
                
                if (code == 0) {
                    block(responseObject);
                }
                else if (code ==20007 || code ==20011 || code ==20012 || code ==20027) {//用户被挤下去，没有找到用户
                    errorblock(kTipLogin);
                }
                else{
                    errorblock(responseObject);
                }
                
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //这里用userDefaults这么做的目的是为了解决请求数据时调用这个方法的同时进行下拉刷新，解决请求超时时刷新时间改变的这一变态的可有可无的bug。
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [userDefaults setInteger:error.code forKey:@"kCFURLErrorTimedOut"];
            [userDefaults synchronize];
            
            
            if (error.code == NSURLErrorCannotFindHost || error.code ==kCFURLErrorNotConnectedToInternet) {
                
                [AdaptInterface tipMessageTitle:@"请检查网络连接" view:controller.view];
            }
            else if(error.code == kCFURLErrorTimedOut){
                
                [AdaptInterface tipMessageTitle:@"网络连接失败" view:controller.view];
            }
            else if(error.code == kCFURLErrorCancelled){
                
                NSLog(@"请求已取消___%@",[array lastObject]);
            }
            else{
                
                [AdaptInterface tipMessageTitle:@"操作失败" view:controller.view];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock(@"");
            });
        }];
    }
    
    return operation;
}

@end
