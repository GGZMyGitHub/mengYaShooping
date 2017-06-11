//
//  GZFMDBTool.h
//  DongHeng
//
//  Created by apple on 17/3/16.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@class GZModel;
@interface GZFMDBTool : NSObject

/** 插入模型数据 */
+ (BOOL)insertModal:(GZModel *)modal;

/** 查询数据,如果 传空 默认会查询表中所有数据 */
+ (NSArray *)queryData:(NSString *)querySql;

/** 删除数据,如果 传空 默认会删除表中所有数据 */
+ (BOOL)deleteData:(NSString *)deleteSql;

/** 修改数据 */
+ (BOOL)modifyData:(NSString *)modifySql;

@end
