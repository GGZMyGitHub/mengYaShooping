//
//  GZModel.m
//  DongHeng
//
//  Created by apple on 17/3/16.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZModel.h"

@implementation GZModel

+ (instancetype)modalWith:(NSString *)name age:(NSInteger)age no:(NSInteger)ID_No {
    GZModel *modal = [[GZModel alloc] init];
    modal.name = name;
    modal.age = age;
    modal.ID_No = ID_No;
    return modal;
    
}

@end
