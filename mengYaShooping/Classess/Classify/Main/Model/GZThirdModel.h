//
//  GZThirdModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/24.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GZThirdModel <NSObject>

@end

@interface GZThirdModel : JSONModel

@property (nonatomic, copy) NSString *one_id;
@property (nonatomic, copy) NSString *one_name;
@property (nonatomic, copy) NSString *one_img;

@end
