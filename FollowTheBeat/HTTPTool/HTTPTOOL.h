//
//  HTTPTOOL.h
//  MVC
//
//  Created by dllo on 15/9/22.
//  Copyright (c) 2015年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSUInteger, responseStyle)  {
    DATA,
    JSON,
    XML,
};

typedef NS_ENUM(NSUInteger, bodyStyle) {
    JSONStyle,
    stringStyle,
};

@interface HTTPTOOL : NSObject

/* GET请求 
 * @param url: 请求网址
 * @param body: 请求参数
 * @param sucess:请求成功时返回的数据
 * @param fail: 请求失败时的错误信息
 */
+ (void)GETWithURL:(NSString *)url body:(NSDictionary *)body httpHead:(NSDictionary *)head resoponseStyle:(responseStyle)style success:(void(^)(id result))success fail:(void(^)(NSError *error))fail;

/**
 *  POST请求
 *
 *  @param url       网址
 *  @param body      body
 *  @param bodyStyle body数据类型
 *  @param head      请求头
 *  @param style     返回数据类型
 *  @param success   请求成功
 *  @param fail      请求失败
 */
+ (void)POSTWithURL:(NSString *)url body:(id)body bodyStyle:(bodyStyle)bodyStyle httpHead:(NSDictionary *)head responseStyle:(responseStyle)style success:(void(^)(id result))success fail:(void(^)(NSError *error))fail;

@end
