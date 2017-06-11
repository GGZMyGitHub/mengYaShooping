//
//  GZWoDeJiFenListModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/11.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GZWoDeJiFenListModel <NSObject>

@end

@interface GZWoDeJiFenListModel : JSONModel

@property (nonatomic, copy) NSString *jifen_count;
@property (nonatomic, copy) NSString *jifen_date;
@property (nonatomic, copy) NSString *jifen_id;
@property (nonatomic, copy) NSString *jifen_name;

@end
