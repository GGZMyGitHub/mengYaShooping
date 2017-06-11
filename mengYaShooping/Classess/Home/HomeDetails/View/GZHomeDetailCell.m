//
//  GZHomeDetailCell.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/5.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZHomeDetailCell.h"

@interface GZHomeDetailCell ()<CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *describeLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

- (IBAction)goShoopping:(UIButton *)sender;


@end

@implementation GZHomeDetailCell
{
    CALayer     *layer;
    UILabel     *_cntLabel;
    NSInteger    _cnt;
    UIImageView *_imageView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setProlistModel:(GZHomeDetailProlistModel *)prolistModel
{
    _prolistModel = prolistModel;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",YUMING,prolistModel.p_head];
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"moren_"]];
    
    self.titleLabel.text = prolistModel.p_name;
    self.describeLabel.text = prolistModel.p_miaoshu;
    self.priceLabel.text = [NSString stringWithFormat:@"%@FT",prolistModel.p_price];
    
    [self.goShoppingBtn setImage:[UIImage imageNamed:@"gouwuche_select_"] forState:UIControlStateNormal];
    
}

-(void)setNoDataModel:(GZNoDataProlist *)noDataModel
{
    _noDataModel = noDataModel;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",YUMING,noDataModel.P_head];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"moren_"]];
    
    self.titleLabel.text = noDataModel.p_name;
    self.describeLabel.text = noDataModel.p_miaoshu;
    self.priceLabel.text = [NSString stringWithFormat:@"%@FT",noDataModel.p_price];

}


- (IBAction)goShoopping:(UIButton *)sender {

    if (_addGoShoppingBlock) {
        _addGoShoppingBlock();
    }
}



@end
