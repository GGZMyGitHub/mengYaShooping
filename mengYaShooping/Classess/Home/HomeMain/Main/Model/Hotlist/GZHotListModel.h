//
//  GZHotListModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/3.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GZHotListModel <NSObject>

@end

@interface GZHotListModel : JSONModel

@property (nonatomic, copy) NSString *Ad_logo;
@property (nonatomic, copy) NSString *Ad_link_type;
@property (nonatomic, copy) NSString *Ad_link_id;

@end
