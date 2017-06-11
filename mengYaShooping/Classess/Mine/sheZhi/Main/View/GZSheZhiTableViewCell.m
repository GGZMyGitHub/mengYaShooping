//
//  GZSheZhiTableViewCell.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/28.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZSheZhiTableViewCell.h"

@implementation GZSheZhiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 120, 0, 90, 43)];
        _detailLabel.text = [self caCheSize];
        _detailLabel.font = [UIFont systemFontOfSize:13];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        
        _detailLabel.textColor = YHRGBA(148, 148, 148, 1.0);
    }
    return _detailLabel;
}

-(void)setData:(id)data{

    _data = data;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.textLabel.text = data[@"title"];
    
    if (self.indexPath.section == 0 && self.indexPath.row == 5) {
        
        
        [self addSubview:self.detailLabel];
    }
}

#pragma mark - custom action
- (NSString *)caCheSize
{
    NSString *detailTitle = nil;
    CGFloat size = [SDImageCache sharedImageCache].getSize;
    
    if (size > 1024 * 1024){
        detailTitle = [NSString stringWithFormat:@"%.02fM",size / 1024 / 1024];
    }else if (size > 1024){
        detailTitle = [NSString stringWithFormat:@"%.02fKB",size / 1024];
    }else{
        detailTitle = [NSString stringWithFormat:@"%.02fB",size];
    }
    
    return detailTitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
