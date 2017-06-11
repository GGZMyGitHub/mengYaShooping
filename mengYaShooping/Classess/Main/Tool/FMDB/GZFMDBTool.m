//
//  GZFMDBTool.m
//  DongHeng
//
//  Created by apple on 17/3/16.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZFMDBTool.h"
#import "GZModel.h"

#define LVSQLITE_NAME @"modals.sqlite"

static FMDatabase *_fmdb;

@implementation GZFMDBTool

+ (void)initialize {
    // 执行打开数据库和创建表操作
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:LVSQLITE_NAME];
    _fmdb = [FMDatabase databaseWithPath:filePath];
    
    [_fmdb open];
    
#warning 必须先打开数据库才能创建表。。。否则提示数据库没有打开
    [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_modals(id INTEGER PRIMARY KEY, name TEXT NOT NULL, age INTEGER NOT NULL, ID_No INTEGER NOT NULL);"];
}

+ (BOOL)insertModal:(GZModel *)modal {
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO t_modals(name, age, ID_No) VALUES ('%@', '%zd', '%zd');", modal.name, modal.age, modal.ID_No];
    return [_fmdb executeUpdate:insertSql];
}

+ (NSArray *)queryData:(NSString *)querySql {
    
    if (querySql == nil) {
        querySql = @"SELECT * FROM t_modals;";
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *name = [set stringForColumn:@"name"];
        NSString *age = [set stringForColumn:@"age"];
        NSString *ID_No = [set stringForColumn:@"ID_No"];
        
        GZModel *modal = [GZModel modalWith:name age:age.intValue no:ID_No.intValue];
        [arrM addObject:modal];
    }
    return arrM;
}

+ (BOOL)deleteData:(NSString *)deleteSql {
    
    if (deleteSql == nil) {
        deleteSql = @"DELETE FROM t_modals";
    }
    
    return [_fmdb executeUpdate:deleteSql];
    
}

+ (BOOL)modifyData:(NSString *)modifySql {
    
    if (modifySql == nil) {
        modifySql = @"UPDATE t_modals SET ID_No = '789789' WHERE name = 'lisi'";
    }
    return [_fmdb executeUpdate:modifySql];
}

@end
