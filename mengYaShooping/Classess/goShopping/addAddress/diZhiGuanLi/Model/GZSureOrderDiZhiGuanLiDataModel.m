//
//  GZSureOrderDiZhiGuanLiDataModel.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/23.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZSureOrderDiZhiGuanLiDataModel.h"

@implementation GZSureOrderDiZhiGuanLiDataModel

//当后台没有status这样的字段的时候，需要重写这个方法。
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"isDefaultAddress"]) {
        return YES;
    }
    return NO;
}

+(JSONKeyMapper *)keyMapper {
    //使用这个方法解析不了关键字，initWithModelToJSONDictionary，还是使用这个方法能够转换关键字。
    
    JSONKeyMapper *mapper = [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"sureOrderDiZhiGuanLiID"}];
    return mapper;
}

@end
