//
//  GZGoShoppDataModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/16.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GZGoShoppAllModel.h"

@interface GZGoShoppDataModel : JSONModel

@property (nonatomic, copy) NSString *set_over_mony_noyunfeis;

@property (nonatomic, copy) NSArray<GZGoShoppAllModel, Optional> *all;

@end
