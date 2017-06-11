//
//  GZResultHomeModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/3.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GZResultHomeModel : JSONModel

@property (nonatomic, copy) NSString *msgcode;

@property (nonatomic, strong) NSDictionary *data;

@end
