//
//  GZModel.h
//  DongHeng
//
//  Created by apple on 17/3/16.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, assign) NSInteger ID_No;


+ (instancetype)modalWith:(NSString *)name age:(NSInteger)age no:(NSInteger)ID_No;

@end
