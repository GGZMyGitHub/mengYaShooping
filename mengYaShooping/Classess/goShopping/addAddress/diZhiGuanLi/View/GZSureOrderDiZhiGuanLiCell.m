//
//  GZSureOrderDiZhiGuanLiCell.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/23.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZSureOrderDiZhiGuanLiCell.h"
#import "GZSureOrderDiZhiGuanLiController.h"

@interface GZSureOrderDiZhiGuanLiCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *alterBtn;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;

//翻译
@property (weak, nonatomic) IBOutlet UIButton *setMoRenDiZhiBtn;
@property (weak, nonatomic) IBOutlet UIButton *xiuGaiBtn;
@property (weak, nonatomic) IBOutlet UIButton *shanChuBtn;



- (IBAction)defaultBtn:(UIButton *)sender;
- (IBAction)deleteBtn:(UIButton *)sender;
- (IBAction)alertBtn:(UIButton *)sender;

@end

@implementation GZSureOrderDiZhiGuanLiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDataModel:(GZSureOrderDiZhiGuanLiDataModel *)dataModel
{
    _dataModel = dataModel;
    
#warning
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
    {
        [self.setMoRenDiZhiBtn setTitle:@"设为默认地址" forState:UIControlStateNormal];
        [self.xiuGaiBtn setTitle:@"修改" forState:UIControlStateNormal];
        [self.shanChuBtn setTitle:@"删除" forState:UIControlStateNormal];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        [self.setMoRenDiZhiBtn setTitle:@"set as default address" forState:UIControlStateNormal];
        [self.xiuGaiBtn setTitle:@"修改英文" forState:UIControlStateNormal];
        [self.shanChuBtn setTitle:@"delete" forState:UIControlStateNormal];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        [self.setMoRenDiZhiBtn setTitle:@"alapértelmezett cím" forState:UIControlStateNormal];
        [self.xiuGaiBtn setTitle:@"修改匈牙利文" forState:UIControlStateNormal];
        [self.shanChuBtn setTitle:@"tőrlés" forState:UIControlStateNormal];
        
    }

    
    self.nameLabel.text = dataModel.person;
    self.telLabel.text = dataModel.tel;
    self.adressLabel.text = [NSString stringWithFormat:@"%@%@",dataModel.address,dataModel.area];
    
    if ([dataModel.ismoren isEqualToString:@"1"])
        {
            [self.defaultBtn setImage:[UIImage imageNamed:@"gouxuan2_"] forState:UIControlStateNormal];
        }else
        {
            [self.defaultBtn setImage:[UIImage imageNamed:@"gouxuan1_"] forState:UIControlStateNormal];
        }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)defaultBtn:(UIButton *)sender {
    
    [MBProgressHUD showMessage:@"加载中..."];
    
    if (_defaultBtnClickBlock) {
        _defaultBtnClickBlock();
    }    
}

- (IBAction)deleteBtn:(UIButton *)sender {
    
    if (_deleteBtnClickBlock) {
        _deleteBtnClickBlock();
    }
}

- (IBAction)alertBtn:(UIButton *)sender {
    
    if (_alterBtnClickBlock) {
        _alterBtnClickBlock();
    }
}
@end
