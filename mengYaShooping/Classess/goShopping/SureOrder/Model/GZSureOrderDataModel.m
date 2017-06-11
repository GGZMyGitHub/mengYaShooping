//
//  GZSureOrderDataModel.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/20.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZSureOrderDataModel.h"

@implementation GZSureOrderDataModel

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper *)keyMapper {
    //使用这个方法解析不了关键字，initWithModelToJSONDictionary，还是使用这个方法能够转换关键字。
    
    JSONKeyMapper *mapper = [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"sureOrderID"}];
    return mapper;
}
@end
