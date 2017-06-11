//
//  GZMessageListModel.h
//  mengYaShooping
//
//  Created by apple on 17/5/11.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GZMessageListModel <NSObject>

@end

@interface GZMessageListModel : JSONModel

@property (nonatomic, copy) NSString *n_id;
@property (nonatomic, copy) NSString *n_content;
@property (nonatomic, copy) NSString *n_date;

@end
