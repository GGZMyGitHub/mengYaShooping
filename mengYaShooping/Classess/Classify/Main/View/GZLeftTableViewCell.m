
//
//  GZLeftTableViewCell.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/24.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZLeftTableViewCell.h"

@interface GZLeftTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *redView;

@end

@implementation GZLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 40)];
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont systemFontOfSize:11];
        _nameLabel.textColor = YHRGBA(130, 130, 130, 1);
        _nameLabel.highlightedTextColor = YHRGBA(233, 76, 60, 1.0);
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(UIView *)redView
{
    if (!_redView) {
        
        _redView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 5, 45)];
        _redView.backgroundColor = YHRGBA(229, 78, 57, 1.0);
    }
    return _redView;
}

-(void)setFirstModel:(GZFirstModel *)firstModel
{
    _firstModel = firstModel;
    
    self.nameLabel.text = firstModel.one_name;
    
    [self.contentView addSubview:self.redView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.contentView.backgroundColor = selected ? [UIColor colorWithWhite:0 alpha:0.1] : [UIColor whiteColor];
    self.highlighted = selected;
    self.nameLabel.highlighted = selected;
    self.redView.hidden = !selected;
}

@end
