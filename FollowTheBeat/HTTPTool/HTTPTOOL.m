//
//  HTTPTOOL.m
//  MVC
//
//  Created by dllo on 15/9/22.
//  Copyright (c) 2015年 zz. All rights reserved.
//

#import "HTTPTOOL.h"
#import "AFNetworking.h"

@implementation HTTPTOOL

+ (void)GETWithURL:(NSString *)url body:(NSDictionary *)body httpHead:(NSDictionary *)head resoponseStyle:(responseStyle)style success:(void(^)(id result))success fail:(void(^)(NSError *error))fail {

    /* 判断网络状态 */
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == -1) {
            NSLog(@"网络状态 = 未知网络");
            
        } else if (0 == status) {
            NSLog(@"网络状态 = 无连接");
            
        } else if (1 == status) {
            NSLog(@"网络状态 = 3G 已连接");
            
        } else  {
            NSLog(@"网络状态 = wifi 已连接");
           
        }
    }];

    /* 创建一个网络请求管理者 */
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    /* 添加请求头 */
    if (head) {
        for (NSString *key in head) {
            [manager.requestSerializer setValue:head[key] forHTTPHeaderField:key];
        }
    }
    
    switch (style) {
        case DATA:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
            
        case JSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            
        case XML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            
        default:
            break;
    }
    /* 设置请求接受的数据类型 */
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
    
    /* 本地缓存设置 */
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *pathString = path.lastObject;
    
    NSString *pathLast =[NSString stringWithFormat:@"/Caches/imusic.default/%lu.text", (unsigned long)[url hash]];
    //创建字符串文件存储路径
    NSString *PathName =[pathString stringByAppendingString:pathLast];
    //第一次进入判断有没有文件夹，如果没有就创建一个
    NSString * textPath = [pathString stringByAppendingFormat:@"/Caches/imusic.default"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:textPath]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:textPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
////    //设BOOL值 判断解析后的数据是数组还是字典
//    __block  BOOL isClass = NO;
    
    
    
//
    
    
    /* 5.GET请求 */
    [manager GET:url parameters:body success:^void(AFHTTPRequestOperation *operation, id responseObject) {
        
        [responseObject writeToFile:PathName atomically:YES];
        success(responseObject);

        
    } failure:^void(AFHTTPRequestOperation * operation, NSError * error) {
        if (fail) {
            
            fail(error);
        }
        NSString * cachePath = PathName;
        if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
            //从本地读缓存文件
            id responseObject = nil;
            responseObject = [NSMutableDictionary dictionaryWithContentsOfFile:cachePath];
            
            
            success(responseObject);
        }
        
    }];
      
}

+ (void)POSTWithURL:(NSString *)url body:(id)body bodyStyle:(bodyStyle)bodyStyle httpHead:(NSDictionary *)head responseStyle:(responseStyle)style success:(void (^)(id result))success fail:(void (^)(NSError *error))fail {
    /* 判断网络状态 */
    AFNetworkReachabilityManager *netWorkManager = [AFNetworkReachabilityManager sharedManager];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == -1) {
            NSLog(@"网络状态 = 未知网络");
        } else if (0 == status) {
            NSLog(@"网络状态 = 无连接");
        } else if (1 == status) {
            NSLog(@"网络状态 = 3G 已连接");
        } else  {
            NSLog(@"网络状态 = wifi 已连接");
        }
    }];

    /* 创建一个HTTP 请求管理者 */
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    /* 处理body 类型 */
    switch (bodyStyle) {
        case JSONStyle:
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
            
        case stringStyle:
            [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError **error) {
                return parameters;
            }];
            break;
            
        default:
            break;
    }
    
    /* 添加请求头 */
    if (head) {
        for (NSString *key in head) {
            [manager.requestSerializer setValue:head[key] forKey:key];
        }
    }
    
    /* 设置接收返回值类型 */
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
    
    /* 判断整体返回值类型 */
    switch (style) {
        case DATA:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
            
        case JSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            
        case XML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            

        default:
            break;
    }
    
    /* 发送post请求 */
    [manager POST:url parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [netWorkManager stopMonitoring];
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
    
}


@end


