//
//  GZXiuGaiMiMaViewController.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/21.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZBaseMineViewController.h"

typedef void(^changeMiMaClick)(NSString *);

@interface GZXiuGaiMiMaViewController : GZBaseMineViewController

@property (nonatomic, copy) changeMiMaClick changeMiMaClickBlock;

@end
