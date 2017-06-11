//
//  GZClassListModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/3.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GZClassListModel <NSObject>

@end

@interface GZClassListModel : JSONModel

@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *class_img;
@property (nonatomic, copy) NSString *class_name;

@end
