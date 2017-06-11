//
//  GZGoShoppingCell.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/16.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZGoShoppingCell.h"

@interface GZGoShoppingCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *specificationsLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UIButton *jianBtn;
@property (weak, nonatomic) IBOutlet UIButton *jiaBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIView *selectView;

//选中
- (IBAction)NoSelect:(UIButton *)sender;
- (IBAction)jian:(UIButton *)sender;
- (IBAction)jia:(UIButton *)sender;

@end

@implementation GZGoShoppingCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


-(void)setIndexpath:(NSIndexPath *)indexpath
{
    _indexpath = indexpath;
    self.jiaBtn.tag = indexpath.row;
    self.jianBtn.tag = indexpath.row;
    self.NoSelect.tag = indexpath.row;
}

-(void)setAllModel:(GZGoShoppAllModel *)allModel
{
    _allModel = allModel;
    
    self.titleLabel.text = allModel.P_name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@FT",allModel.P_price];
    self.countLabel.text = [NSString stringWithFormat:@"%zd",allModel.P_count];
    self.countLabel.layer.borderWidth = 1;
    self.countLabel.layer.borderColor = YHRGBA(153, 153, 153, 1.0).CGColor;
    self.specificationsLabel.text = allModel.diy_name;
    
    self.jianBtn.layer.masksToBounds = YES;
    self.jianBtn.layer.borderWidth = 1;
    self.jianBtn.layer.borderColor = YHRGBA(129, 129, 129, 1.0).CGColor;
    self.jianBtn.layer.cornerRadius = 1;
    
    self.jiaBtn.layer.masksToBounds = YES;
    self.jiaBtn.layer.borderWidth = 1;
    self.jiaBtn.layer.borderColor = YHRGBA(129, 129, 129, 1.0).CGColor;
    self.jiaBtn.layer.cornerRadius = 1;
    
    if ([self.countLabel.text isEqualToString:@"1"]) {
        [self.jianBtn setTitleColor:YHRGBA(231, 231, 231, 1.0) forState:UIControlStateNormal];
    }else
    {
        [self.jianBtn setTitleColor:YHRGBA(21, 21, 21, 1.0) forState:UIControlStateNormal];
    }
    
    
    
    NSString *imgUrl = [NSString stringWithFormat:@"%@%@",YUMING,allModel.P_logo];
    
    __weak typeof(self) weakCell = self;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:imgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image && cacheType == SDImageCacheTypeNone) {
            weakCell.imageV.alpha = 0;
            [UIView animateWithDuration:1.0 animations:^{
                weakCell.imageV.alpha = 1.0;
            }];
        }
        else
        {
            weakCell.imageV.alpha = 1.0;
        }
    }];
    
    //避免cell重用
    if (allModel.status == YES) {
        [self.NoSelect setImage:[UIImage imageNamed:@"redxuanzhong_"] forState:UIControlStateNormal];
    }else
    {
        [self.NoSelect setImage:[UIImage imageNamed:@"weixuan_"] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (IBAction)NoSelect:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(shopPlatformTableViewCell:andTag:)]) {
        [self.delegate shopPlatformTableViewCell:self andTag:sender.tag];
    }
}

- (IBAction)jian:(UIButton *)sender {
    
    if (_reduceClickBlock) {
        _reduceClickBlock(sender);
    }
}

- (IBAction)jia:(UIButton *)sender {
    
    if (_addClickBlock) {
        _addClickBlock(sender);
    }
}

@end
