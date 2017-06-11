//
//  GZFirstModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/24.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GZSecondModel.h"

@protocol GZFirstModel <NSObject>

@end

@interface GZFirstModel : JSONModel

@property (nonatomic, copy) NSString *one_id;
@property (nonatomic, copy) NSString *one_name;
@property (nonatomic, copy) NSString *one_img;

@property (nonatomic, strong) NSArray <GZSecondModel,Optional>*two_dic_list;

@end
