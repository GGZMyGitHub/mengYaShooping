//
//  GZGoShoppAllModel.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/6/1.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZGoShoppAllModel.h"

@implementation GZGoShoppAllModel

//当后台没有status这样的字段的时候，需要重写这个方法。
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"status"] || [propertyName isEqualToString:@"totalPrice"]) {
        return YES;
    }
    return NO;
}

@end
