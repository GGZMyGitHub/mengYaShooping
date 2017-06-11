//
//  GZWoDeDIngDanCell.m
//  mengYaShooping
//
//  Created by apple on 17/5/24.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZWoDeDIngDanCell.h"
#import "GZWoDeDingDanListModel.h"

@interface GZWoDeDIngDanCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end


@implementation GZWoDeDIngDanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setListModel:(GZWoDeDingDanListModel *)listModel
{
    _listModel = listModel;
    
    self.titleLabel.text = listModel.p_name;
    self.rankLabel.text = listModel.diy_name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@FT",listModel.p_price];
    self.countLabel.text = [NSString stringWithFormat:@"X%@",listModel.p_count];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",YUMING,listModel.p_img];
    __weak typeof(self) weakCell = self;
    [self.headerImgV sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image && cacheType == SDImageCacheTypeNone) {
            weakCell.headerImgV.alpha = 0;
            
            [UIView animateWithDuration:1.0 animations:^{
                
                weakCell.headerImgV.alpha = 1.0;
            }];
        }
        else
        {
            weakCell.headerImgV.alpha = 1.0;
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
