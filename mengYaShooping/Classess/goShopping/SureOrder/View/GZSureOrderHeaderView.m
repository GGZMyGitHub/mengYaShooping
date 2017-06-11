//
//  GZSureOrderHeaderView.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/21.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZSureOrderHeaderView.h"

@interface GZSureOrderHeaderView ()

@property (nonatomic, strong) UIView *noDataView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImgV;
@property (weak, nonatomic) IBOutlet UILabel *shouHuoLabel;
@property (weak, nonatomic) IBOutlet UILabel *dianHuaLabel;
@property (weak, nonatomic) IBOutlet UILabel *diZhiLabel;

@end

@implementation GZSureOrderHeaderView

-(UIView *)noDataView
{
    if (!_noDataView) {
        _noDataView = [[UIView alloc] initWithFrame:CGRectMake(self.headerImgV.right, 0, kScreenWidth - self.headerImgV.right, 80)];
        _noDataView.backgroundColor = [UIColor whiteColor];
        
    }
    return _noDataView;
}

-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.noDataView.width, 20)];

        _label.text = @"暂无收货地址,快去添加地址吧~";
        
        _label.font = [UIFont systemFontOfSize:13];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = YHRGBA(149, 149, 149, 1.0);
    }
    return _label;
}

+(instancetype)sharedSureOrderHeaderView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SureOrderHeaderView" owner:nil options:nil] lastObject];
}

-(void)setDataModel:(GZSureOrderDataModel *)dataModel
{
    _dataModel = dataModel;

#warning 
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
        
        self.shouHuoLabel.text = @"收货人:";
        self.dianHuaLabel.text = @"电话:";
        self.diZhiLabel.text = @"地址:";

    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        self.shouHuoLabel.text = @"收货人:英文";
        self.dianHuaLabel.text = @"电话:英文";
        self.diZhiLabel.text = @"地址:英文";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        self.shouHuoLabel.text = @"收货人:匈牙利文";
        self.dianHuaLabel.text = @"电话:匈牙利文";
        self.diZhiLabel.text = @"地址:匈牙利文";
    }

    if (dataModel.person && dataModel.tel && dataModel.address) {
       
        [self.noDataView removeFromSuperview];
        
        self.nameLabel.text = dataModel.person;
        self.telLabel.text = dataModel.tel;
        self.addressLabel.text = dataModel.address;
        
    }else
    {
        
        [self.noDataView addSubview:self.label];
        [self addSubview:self.noDataView];

        if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
            
            self.label.text = @"暂无收货地址,快去添加地址吧~";
            
        }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
            
            self.label.text = @"No shipping address yet,add address~";

        }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){

            self.label.text = @"Nincs  szállítási címet,adja meg szállítás címe~";
        }
        
        self.nameLabel.text = @"";
        self.telLabel.text = @"";
        self.addressLabel.text = @"";
        
    }
}

@end
