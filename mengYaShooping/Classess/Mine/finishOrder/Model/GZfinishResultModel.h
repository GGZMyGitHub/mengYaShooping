//
//  GZfinishResultModel.h
//  mengYaShooping
//
//  Created by apple on 17/5/25.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GZfinishResultModel : JSONModel

@property (nonatomic, copy) NSString *msgcode;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSDictionary *data;

@end
