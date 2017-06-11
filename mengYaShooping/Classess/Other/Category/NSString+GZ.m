//
//  NSString+GZ.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/18.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "NSString+GZ.h"

@implementation NSString (GZ)

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isEmpty
{
    NSString *string = [self trim];
    if ([string isEqualToString:@""] || string == nil) {
        return YES;
    }
    return NO;
}
@end
