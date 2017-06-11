//
//  GZSecondModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/24.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GZThirdModel.h"

@protocol  GZSecondModel <NSObject>

@end

@interface GZSecondModel : JSONModel

@property (nonatomic, copy) NSString *one_id;
@property (nonatomic, copy) NSString *one_name;
@property (nonatomic, copy) NSString *one_img;

@property (nonatomic, strong) NSArray <GZThirdModel,Optional> *three_dic_list;

@end
