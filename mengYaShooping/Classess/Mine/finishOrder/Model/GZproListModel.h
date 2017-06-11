//
//  GZproListModel.h
//  mengYaShooping
//
//  Created by apple on 17/5/25.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GZproListModel <NSObject>

@end

@interface GZproListModel : JSONModel

@property (nonatomic, copy) NSString *diy_id;
@property (nonatomic, copy) NSString *diy_name;
@property (nonatomic, copy) NSString *p_count;
@property (nonatomic, copy) NSString *p_id;
@property (nonatomic, copy) NSString *p_img;
@property (nonatomic, copy) NSString *p_name;
@property (nonatomic, copy) NSString *p_price;

@end
