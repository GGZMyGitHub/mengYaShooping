//
//  GZcollectionCell.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/24.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZcollectionCell.h"

@interface GZcollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImgV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelCellecBtn;

//翻译
@property (weak, nonatomic) IBOutlet UIButton *quXiaoSouCangBtn;


- (IBAction)cancelCollecBtn:(UIButton *)sender;

@end

@implementation GZcollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDataModel:(GZColletcionDataModel *)dataModel
{
    _dataModel = dataModel;
    
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
    {
        [self.quXiaoSouCangBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        [self.quXiaoSouCangBtn setTitle:@"取消收藏英文" forState:UIControlStateNormal];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        [self.quXiaoSouCangBtn setTitle:@"取消收藏匈牙利文" forState:UIControlStateNormal];
    }
    
    self.titleLabel.text = dataModel.p_name;
    self.messageLabel.text = dataModel.p_miaoshu;
    self.priceLabel.text = [NSString stringWithFormat:@"%@FT",dataModel.p_price];
    
    self.cancelCellecBtn.layer.masksToBounds = YES;
    self.cancelCellecBtn.layer.borderWidth = 1;
    self.cancelCellecBtn.layer.borderColor = YHRGBA(224, 224, 224, 1.0).CGColor;
    self.cancelCellecBtn.layer.cornerRadius = 2;
    
    NSString * url = [NSString stringWithFormat:@"%@%@",YUMING,dataModel.p_img];
    __weak typeof(self) weakCell = self;
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image && cacheType == SDImageCacheTypeNone) {
            weakCell.headImgV.alpha = 0;
            
            [UIView animateWithDuration:1.0 animations:^{
                
                weakCell.headImgV.alpha = 1.0;
            }];
        }
        else
        {
            weakCell.headImgV.alpha = 1.0;
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//取消收藏
- (IBAction)cancelCollecBtn:(UIButton *)sender {
    
    NSDictionary *params = @{
                             @"cid":_dataModel.C_id,
                             @"language":[GGZTool iSLanguageID],
                             @"action":@"Del_Collection"
                             };
    
    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
        if ([[obj valueForKey:@"msgcode"] isEqualToString:@"1"]) {
            
            if (_didSelectClickBlock) {
                _didSelectClickBlock();
            }
        }
        
        [MBProgressHUD showAlertMessage:[obj valueForKey:@"msg"]];
        

    } failure:^(NSError *error) {
        [MBProgressHUD showAlertMessage:@"网络错误"];
    }];
}
@end
