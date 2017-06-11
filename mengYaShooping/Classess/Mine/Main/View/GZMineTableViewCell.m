//
//  GZMineTableViewCell.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/6/3.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZMineTableViewCell.h"


@interface GZMineTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UIImageView *jianTouImgV;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation GZMineTableViewCell

-(UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 120, 0, 90, 43)];
        _detailLabel.text = @"查看全部订单";
        _detailLabel.font = [UIFont systemFontOfSize:13];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        
        _detailLabel.textColor = YHRGBA(148, 148, 148, 1.0);
    }
    return _detailLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDataSource:(NSDictionary *)dataSource
{
    _dataSource = dataSource;
   
    if (self.indexPath.section == 0 && self.indexPath.row == 0) {
        
        [self addSubview:self.detailLabel];

        if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
        {
            self.detailLabel.text = @"查看全部订单";
            
        }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
            
            self.detailLabel.text = @"check all orders";
            
        }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
            
            self.detailLabel.text = @"összes rendelés megtekintése";
        }
        
    }
    
    [self.iconBtn setTitle:dataSource[@"title"] forState:UIControlStateNormal];
    [self.iconBtn setImage:[UIImage imageNamed:dataSource[@"icon"]] forState:UIControlStateNormal];
    
    [self.iconBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
