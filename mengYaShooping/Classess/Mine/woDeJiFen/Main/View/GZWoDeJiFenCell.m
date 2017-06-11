//
//  GZWoDeJiFenCell.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/11.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZWoDeJiFenCell.h"

@interface GZWoDeJiFenCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation GZWoDeJiFenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setListModel:(GZWoDeJiFenListModel *)listModel
{
    _listModel = listModel;
    
    self.titleLabel.text = listModel.jifen_name;
    self.timeLabel.text = listModel.jifen_date;
    self.countLabel.text = listModel.jifen_count;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
