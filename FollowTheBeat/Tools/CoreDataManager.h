//
//  CoreDataManager.h
//  CoreData
//
//  Created by 张昭 on 15/10/20.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

/**
 *  coreData 管理单例方法
 *
 *  @return 管理器
 */
+ (CoreDataManager *)manager;

/**
 *  数据管理器， 相当于 临时存储， 类似 咨询师
 */
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;


/**
 *  数据模型器
 */
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;


/**
 *  数据连接器， 负责存储到本地
 */
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


/**
 *  保存到本地
 */
- (void)saveContext;


/**
 *  返回本地文件路径
 *
 *  @return 保存文件路径
 */
- (NSURL *)applicationDocumentsDirectory;



@end
