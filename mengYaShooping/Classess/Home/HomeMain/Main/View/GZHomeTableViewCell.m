//
//  GZHomeTableViewCell.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/15.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZHomeTableViewCell.h"

@interface GZHomeTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoV;

@end

@implementation GZHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setHotListModel:(GZHotListModel *)hotListModel
{
    _hotListModel = hotListModel;
    
    NSString * url = [NSString stringWithFormat:@"%@%@",YUMING,hotListModel.Ad_logo];
    [self.photoV sd_setImageWithURL:[NSURL URLWithString:url]];
}

@end
