//
//  GZHomeDetailClassListModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/4.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol  GZHomeDetailClassListModel <NSObject>

@end

@interface GZHomeDetailClassListModel : JSONModel

@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *class_name;

@end
