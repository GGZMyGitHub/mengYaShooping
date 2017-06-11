//
//  GZHomeDetailDiylistModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/12.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GZHomeDetailDiylistModel <NSObject>

@end

@interface GZHomeDetailDiylistModel : JSONModel

@property (nonatomic, copy) NSString *diy_id;
@property (nonatomic, copy) NSString *diy_name;

@end
