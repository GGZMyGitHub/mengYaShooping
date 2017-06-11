//
//  GZSureOrderTableViewCell.m
//  mengYaShooping
//
//  Created by apple on 17/5/21.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZSureOrderTableViewCell.h"

@interface GZSureOrderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *explainLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end


@implementation GZSureOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setOrderprolistModel:(GZSureOrderProListModel *)OrderprolistModel
{
    _OrderprolistModel = OrderprolistModel;
    
    self.titleLabel.text = OrderprolistModel.P_name;
    self.explainLabel.text = OrderprolistModel.P_diyname;
    self.priceLabel.text = [NSString stringWithFormat:@"%@FT",OrderprolistModel.P_price];

    self.countLabel.text = [NSString stringWithFormat:@"x%@",OrderprolistModel.P_count];

    NSString * url = [NSString stringWithFormat:@"%@%@",YUMING,OrderprolistModel.P_logo];
    __weak typeof(self) weakCell = self;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

        if (image && cacheType == SDImageCacheTypeNone) {
            weakCell.headerImage.alpha = 0;

            [UIView animateWithDuration:1.0 animations:^{

                weakCell.headerImage.alpha = 1.0;
            }];
        }
        else
        {
            weakCell.headerImage.alpha = 1.0;
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
