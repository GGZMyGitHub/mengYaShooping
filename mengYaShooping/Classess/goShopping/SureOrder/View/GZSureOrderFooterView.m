
//
//  GZSureOrderFooterView.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/21.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZSureOrderFooterView.h"

@interface GZSureOrderFooterView ()

@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *dikouLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *getIntegralLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiexdKeShiYongLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiexdDiKouLabel;

//翻译
@property (weak, nonatomic) IBOutlet UILabel *yunFeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *keShiYongLabel;
@property (weak, nonatomic) IBOutlet UILabel *diKouLabel;
@property (weak, nonatomic) IBOutlet UILabel *shangPinHeJiLabel;
@property (weak, nonatomic) IBOutlet UILabel *fuKuanFangShiLabel;
@property (weak, nonatomic) IBOutlet UILabel *HuoDaoFuKuanLabel;



- (IBAction)integralBtn:(UIButton *)sender;
- (IBAction)problemBtn:(UIButton *)sender;

@end

@implementation GZSureOrderFooterView

+ (instancetype)sharedSureOrderFooterView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SureOrderFooterView" owner:nil options:nil] lastObject];
}

-(void)setDataModel:(GZSureOrderDataModel *)dataModel
{
    _dataModel = dataModel;
    
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
        self.yunFeiLabel.text = @"运费";
        self.keShiYongLabel.text = @"可使用";
        self.dikouLabel.text = @"抵扣";
        self.shangPinHeJiLabel.text = @"商品合计";
        self.fuKuanFangShiLabel.text = @"付款方式";
        self.HuoDaoFuKuanLabel.text = @"货到付款";
        self.getIntegralLabel.text = [NSString stringWithFormat:@"购买完成可获得%@积分",dataModel.get_jifen];

        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        self.yunFeiLabel.text = @"freight";
        self.keShiYongLabel.text = @"可使用英文";
        self.dikouLabel.text = @"抵扣英文";
        self.shangPinHeJiLabel.text = @"items in total";
        self.fuKuanFangShiLabel.text = @"payment method";
        self.HuoDaoFuKuanLabel.text = @"货到付款英文";
        self.getIntegralLabel.text = [NSString stringWithFormat:@"购买完成可获得%@point英文",dataModel.get_jifen];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        self.yunFeiLabel.text = @"fuvar díj";
        self.keShiYongLabel.text = @"可使用匈牙利文";
        self.dikouLabel.text = @"抵扣匈牙利文";
        self.shangPinHeJiLabel.text = @"rendelési összege";
        self.fuKuanFangShiLabel.text = @"fizetési mód";
        self.HuoDaoFuKuanLabel.text = @"货到付款匈牙利文";
        self.getIntegralLabel.text = [NSString stringWithFormat:@"购买完成可获得%@积分匈牙利文",dataModel.get_jifen];
        
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *yunfeiZZhongStr = [defaults objectForKey:@"set_over_mony_noyunfei"];
    
    if ([dataModel.all_wei_youhui floatValue] >= [yunfeiZZhongStr floatValue]) {
        
        self.freightLabel.text = @"0FT";
        
    }else
    {
        self.freightLabel.text = [NSString stringWithFormat:@"%@FT",dataModel.youfei];
    }

    if ([dataModel.use_jifen isEqualToString:@"0"]) {
        
        if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
            
            self.fiexdKeShiYongLabel.text = @"无可使用积分";

        }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
            
            self.fiexdKeShiYongLabel.text = @"无可使用积分英文";

        }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
           
            self.fiexdKeShiYongLabel.text = @"无可使用积分匈牙利文";
        }
        
        self.integralLabel.hidden = YES;
        self.fiexdDiKouLabel.hidden = YES;
        self.dikouLabel.hidden = YES;
                
        self.integralBtn.userInteractionEnabled = NO;
    }else
    {
#warning
        if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
          
            self.fiexdKeShiYongLabel.text = @"可使用";
            self.integralLabel.text = [NSString stringWithFormat:@"%@积分",dataModel.use_jifen];

        }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){

            self.fiexdKeShiYongLabel.text = @"可使用英文";
            self.integralLabel.text = [NSString stringWithFormat:@"%@point",dataModel.use_jifen];

        }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
            
            self.fiexdKeShiYongLabel.text = @"可使用匈牙利文";
            self.integralLabel.text = [NSString stringWithFormat:@"%@积分",dataModel.use_jifen];

        }
        
        self.fiexdDiKouLabel.hidden = NO;
        self.dikouLabel.hidden = NO;
        self.integralLabel.hidden = NO;

        self.dikouLabel.text = [NSString stringWithFormat:@"%@FT",dataModel.use_mony];
        self.integralBtn.userInteractionEnabled = YES;
    }
   
    
    self.totalLabel.text = [NSString stringWithFormat:@"%@FT",dataModel.all_wei_youhui];
    
}

- (IBAction)integralBtn:(UIButton *)sender {

    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"gouxuan1_"] forState:UIControlStateNormal];
        
    }else
    {
        [sender setImage:[UIImage imageNamed:@"gouxuan2_"] forState:UIControlStateNormal];
    }
    sender.selected = !sender.selected;
    
    if (_discountClickBlock) {
        _discountClickBlock(sender.selected);
    }
}

- (IBAction)problemBtn:(UIButton *)sender {
   
    if (_problemClickBlock) {
        _problemClickBlock();
    }
}


@end
