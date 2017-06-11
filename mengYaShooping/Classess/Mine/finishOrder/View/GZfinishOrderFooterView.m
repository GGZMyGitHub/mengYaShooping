//
//  GZfinishOrderFooterView.m
//  mengYaShooping
//
//  Created by apple on 17/5/26.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZfinishOrderFooterView.h"

@interface GZfinishOrderFooterView ()
@property (weak, nonatomic) IBOutlet UILabel *yunfeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *bianhaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatLabel;


- (IBAction)payforBtn:(UIButton *)sender;


@end

@implementation GZfinishOrderFooterView

+ (instancetype)sharedSureOrderHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"finishOrderFooterView" owner:nil options:nil] firstObject];
}

-(void)setDataModel:(GZfinishDataModel *)dataModel
{
    _dataModel = dataModel;
    
    self.payforBtn.layer.masksToBounds = YES;
    self.payforBtn.layer.cornerRadius = 3;
    
    self.yunfeiLabel.text = dataModel.yunfei;
    self.jifenLabel.text = dataModel.use_jifen;
    self.totalLabel.text = dataModel.price;
    self.bianhaoLabel.text = dataModel.order_num;
    self.creatLabel.text = dataModel.creat_time;
    self.fukuanLabel.text = dataModel.shouhuo_time;
    self.fahuoLabel.text = dataModel.fahuo_time;
    
}


- (IBAction)payforBtn:(UIButton *)sender {
    if (_payForAgainClickBlock) {
        _payForAgainClickBlock();
    }
}

@end
