//
//  GZPopShoppDetailView.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/6.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZPopShoppDetailView.h"
#import "BuyCountView.h"
#import "GZScanImage.h"

@interface GZPopShoppDetailView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *integralImgV;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *rankPromptLabel;
@property (nonatomic, strong) UILabel *classLabel;
@property (nonatomic, strong) UILabel *bottomLineLabel;

@property (nonatomic, retain) UIImageView *headerImgView;

@property (nonatomic, strong) UIScrollView *classScrollView;

@end

@implementation GZPopShoppDetailView

-(UIView *)alphaiView
{
    if (!_alphaiView) {
        _alphaiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _alphaiView.backgroundColor = [UIColor blackColor];
        _alphaiView.alpha = 0.2;
    }
    return _alphaiView;
}

- (UIView *)whiteView
{
    if (!_whiteView) {
        _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 385, self.frame.size.width, 385)];
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteView;
}

-(UIImageView *)integralImgV
{
    if (!_integralImgV) {
        _integralImgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.titleLabel.right + 5, 22, 60, 16)];

        _integralImgV.image = [[UIImage imageNamed:@"songjifen_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        _integralImgV.layer.masksToBounds = YES;
        _integralImgV.layer.cornerRadius = 4;
    }
    return _integralImgV;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headerImgView.right + 14, self.headerImgView.top + 2, 100, 20)];
        _priceLabel.font = [UIFont systemFontOfSize:17];
        _priceLabel.textColor = YHRGBA(226, 77, 58, 1.0);
        _priceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _priceLabel;
}

-(UILabel *)rankPromptLabel
{
    if (!_rankPromptLabel) {
        _rankPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headerImgView.right + 14, self.priceLabel.bottom + 10, kScreenWidth - self.headerImgView.right - 14 -20, 20)];
        _rankPromptLabel.text = @"请选择规格与数量";
        _rankPromptLabel.textAlignment = NSTextAlignmentLeft;
        _rankPromptLabel.font = [UIFont systemFontOfSize:15];
        
    }
    return _rankPromptLabel;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
    
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 0 , 20)];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    
    }
    return _titleLabel;
}

-(UILabel *)lineLabel
{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.titleLabel.bottom + 20, kScreenWidth, 1)];
        _lineLabel.backgroundColor = YHRGBA(233, 233, 233, 1.0);
    }
    return _lineLabel;
}

-(UILabel *)classLabel
{
    if (!_classLabel) {
        _classLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.headerImgView.bottom + 15, 100, 20)];
        _classLabel.text = @"分类";
        _classLabel.textColor = [UIColor blackColor];
        _classLabel.font = [UIFont systemFontOfSize:15];
        _classLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _classLabel;
}

-(UIImageView *)headerImgView
{
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.lineLabel.bottom + 15, 100, 100)];
        
        UITapGestureRecognizer *tapGestureRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
        [_headerImgView addGestureRecognizer:tapGestureRecognizer3];

        [_headerImgView setUserInteractionEnabled:YES];
    }
    return _headerImgView;
}

-(BuyCountView *)buyCountView
{
    if (!_buyCountView) {
        
        _buyCountView = [[BuyCountView alloc] initWithFrame:CGRectMake(self.headerImgView.right + 14, self.rankPromptLabel.bottom + 10, 124, 32)];
        
        //点击数量的block回调，如果countNum为空，说明用户没选，数量为1
        GZWeakSelf;
        _buyCountView.countChangeClickBlock = ^(NSString * countNum) {
            if (weakSelf.countClickBlock) {
                weakSelf.countClickBlock(countNum);
            }
        };
        
    }
    return _buyCountView;
}

-(UIButton *)bt_cancle
{
    if (!_bt_cancle) {
        _bt_cancle = [UIButton buttonWithType:UIButtonTypeCustom];
        _bt_cancle.frame = CGRectMake(self.whiteView.frame.size.width-40, 25,15, 15);
        [_bt_cancle setBackgroundImage:[UIImage imageNamed:@"guanbi_"] forState:0];
    }
    return _bt_cancle;
}

-(UIButton *)bt_sure
{
    if (!_bt_sure) {
        _bt_sure = [UIButton buttonWithType:UIButtonTypeCustom];

        _bt_sure.frame = CGRectMake(71, self.whiteView.frame.size.height-50,self.whiteView.frame.size.width - 71, 50);
        [_bt_sure setBackgroundColor:[UIColor redColor]];
        [_bt_sure setTitleColor:[UIColor whiteColor] forState:0];
        _bt_sure.titleLabel.font = [UIFont systemFontOfSize:20];
        [_bt_sure setTitle:@"确定" forState:0];
        [_bt_sure addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bt_sure;
}

-(GGZButton *)addShoppCarBtn
{
    if (!_addShoppCarBtn) {
        _addShoppCarBtn = [GGZButton createGGZButton];
        _addShoppCarBtn.frame = CGRectMake(0, self.whiteView.frame.size.height-50, 71, 50);
        [_addShoppCarBtn setImage:[UIImage imageNamed:@"gouwuche_select_"] forState:UIControlStateNormal];
        
        GZWeakSelf;
        _addShoppCarBtn.block = ^(GGZButton *btn) {
        
            if (weakSelf.carBtnClickBlock) {
                weakSelf.carBtnClickBlock();
            }
        };
        
    }
    return _addShoppCarBtn;
}

-(UILabel *)bottomLineLabel
{
    if (!_bottomLineLabel) {
        _bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.whiteView.frame.size.height-51, self.addShoppCarBtn.right, 1)];
        _bottomLineLabel.backgroundColor = YHRGBA(204, 204, 204, 1.0);
    }
    return _bottomLineLabel;
}

-(UIScrollView *)classScrollView
{
    if (!_classScrollView) {
        _classScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.classLabel.bottom, kScreenWidth, self.whiteView.height - self.classLabel.bottom - self.bt_sure.height)];
        _classScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _classScrollView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        //半透明视图
        [self addSubview:self.alphaiView];
        
        //装载商品信息的视图
        [self addSubview:self.whiteView];
        
        [self.whiteView addSubview:self.titleLabel];
        [self.whiteView addSubview:self.integralImgV];
        [self.whiteView addSubview:self.lineLabel];
        [self.whiteView addSubview:self.headerImgView];
        [self.whiteView addSubview:self.priceLabel];
        [self.whiteView addSubview:self.rankPromptLabel];
        [self.whiteView addSubview:self.buyCountView];
        [self.whiteView addSubview:self.classLabel];
        [self.whiteView addSubview:self.classScrollView];
        
        
        [self.whiteView addSubview:self.bt_cancle];
        [self.whiteView addSubview:self.bt_sure];
        [self.whiteView addSubview:self.addShoppCarBtn];
        [self.whiteView addSubview:self.bottomLineLabel];
        
        if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
        {
            
            self.rankPromptLabel.text = @"请选择规格与数量";
            self.classLabel.text = @"分类";
            
        }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
            
            self.rankPromptLabel.text = @"please choose specification and quantity";
            self.classLabel.text = @"Classification";
            
        }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
            
            self.rankPromptLabel.text = @"válassza ki méretet és mennyiséget";
            self.classLabel.text = @"besorolás";
        }
    }
    return self;
}

-(void)setDataModel:(GZOrderDetailDataModel *)dataModel
{
    _dataModel = dataModel;
    
    self.titleLabel.text = dataModel.p_name;
    if ([dataModel.isjifen_back isEqualToString:@"0"]) {
        self.integralImgV.hidden = YES;
    }
    
    self.titleLabel.text = dataModel.p_name;
    //自适应titleLabel文字宽度
    CGFloat width = [UILabel getWidthWithTitle:self.titleLabel.text font:[UIFont systemFontOfSize:15]];
    self.titleLabel.width = width;
    self.integralImgV.x = self.titleLabel.right + 10;
    self.priceLabel.text = [NSString stringWithFormat:@"%@FT",dataModel.p_price];
    
    for (int i = 0; i < dataModel.diylist.count; i ++) {
        
        CGFloat width = (kScreenWidth - 45) / 2;
        GGZButton *button = [GGZButton createGGZButton];
        button.frame = CGRectMake(15 + (i % 2)* (width + 15), 15 + (i / 2) * (31 + 5), width, 31);
        [button setTitle:[dataModel.diylist[i] valueForKey:@"diy_name"] forState:0];
        [button setTitleColor:YHRGBA(123, 123, 123, 1.0) forState:0];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
    
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 1;
        button.layer.borderColor = YHRGBA(163, 163, 163, 1.0).CGColor;
        
        button.block = ^(GGZButton *btn) {
            
            if (_selectBtn == btn) {
                
            }else {
                btn.backgroundColor = [UIColor orangeColor];
                _selectBtn.backgroundColor = [UIColor whiteColor];
                
                if (_classClickBlock) {
                    _classClickBlock([dataModel.diylist[i] valueForKey:@"diy_id"]);
                }
            }
            _selectBtn = btn;
        };
        
        
        [self.classScrollView addSubview:button];
        
        if (i == dataModel.diylist.count - 1) {
            self.classScrollView.contentSize = CGSizeMake(0, 15 + (i /2)* (31 + 5) + 41);
        }
    }
    
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",YUMING,dataModel.p_head]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image && cacheType == SDImageCacheTypeNone) {
            self.headerImgView.alpha = 0;
            
            [UIView animateWithDuration:1.0 animations:^{
                self.headerImgView.alpha = 1.0;
            }];
        }
        else
        {
            self.headerImgView.alpha = 1.0;
        }
    }];
}

- (void)sureClick
{
    if (_sureClickBlock) {
        _sureClickBlock();
    }
}

#pragma mark - 浏览大图点击事件
-(void)scanBigImageClick:(UITapGestureRecognizer *)tap{
    
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [GZScanImage scanBigImageWithImageView:clickedImageView];
}

@end
