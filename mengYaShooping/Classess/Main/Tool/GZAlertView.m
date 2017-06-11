//
//  GZAlertView.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/21.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZAlertView.h"

@interface GZAlertView()
{
    NSString * sureTitles;
    NSString * cancelTitles;
    NSString * messages;
    NSString * titleimage;
}

@property(nonatomic , strong)UIButton * canBtn;
@property(nonatomic , strong)UIButton * sureBtn;
@property(nonatomic , strong)UILabel * messageLable;
@property(nonatomic , strong)UIImageView * images;
@property(nonatomic , strong)UIView * showView;



@end

@implementation GZAlertView

+ (instancetype)sharedAlertView{
    
    return  [[self alloc]init];
}
- (instancetype)init{
    if (self == [super init]) {
        
        [self setUpframe];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (cancelTitles != nil) {
        [self.canBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.frame.size.width/2);
            make.height.mas_equalTo(35);
            make.bottom.left.mas_equalTo(self);
        }];
    }
    
    if (sureTitles != nil) {
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.frame.size.width/2);
            make.height.mas_equalTo(35);
            make.bottom.right.mas_equalTo(self);
        }];
    }
    
    if (titleimage != nil) {
        [self.images mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.top.mas_equalTo(23);
            make.width.mas_equalTo(45);
            make.height.mas_equalTo(41);
        }];
    }
    
    if (messages != nil) {
        [self.messageLable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(80);
            make.height.mas_equalTo(41);
            make.top.mas_equalTo(28);
            make.width.mas_equalTo(150);
        }];
    }
}

- (void)setUpframe{
    
    self.showView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.showView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [[UIApplication sharedApplication].keyWindow addSubview:self.showView];
    [self.showView addSubview:self];
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = YHRGBA(247, 247, 247, 1.0).CGColor;
    self.layer.borderWidth = 1;
    
    self.frame = CGRectMake(0, 0, 250, 150);
    self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    
    _canBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _canBtn.backgroundColor = [UIColor whiteColor];
    _canBtn.layer.borderColor = YHRGBA(247, 247, 247, 1.0).CGColor;
    _canBtn.layer.borderWidth = 1;
    _canBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_canBtn setTitleColor:YHRGBA(81, 81, 81, 1.0) forState:UIControlStateNormal];

    [_canBtn addTarget:self action:@selector(cancelTitle) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_canBtn];
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.backgroundColor = [UIColor whiteColor];
    _sureBtn.layer.borderColor = YHRGBA(247, 247, 247, 1.0).CGColor;
    _sureBtn.layer.borderWidth = 1;
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_sureBtn setTitleColor:YHRGBA(81, 81, 81, 1.0) forState:UIControlStateNormal];

    [_sureBtn addTarget:self action:@selector(sureTitle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sureBtn];
    
    _messageLable = [[UILabel alloc]init];
    _messageLable.textAlignment = NSTextAlignmentCenter;
    _messageLable.font = [UIFont systemFontOfSize:18.0f];
    _messageLable.numberOfLines = 0;
    [self addSubview:_messageLable];
    
    _images = [[UIImageView alloc]init];

    [self addSubview:_images];
}

- (void)alertViewMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle image:(NSString *)image Block:(GZAlertViewSureBlock)block{
    
    cancelTitles = cancelTitle;
    sureTitles = sureTitle;
    titleimage = image;
    messages = message;
    self.block = block;
    
    
    [_canBtn setTitle:cancelTitles forState:UIControlStateNormal];
    [_sureBtn setTitle:sureTitles forState:UIControlStateNormal];
    _messageLable.text = messages;
    _images.image = [UIImage imageNamed:titleimage];
}

-(void) animationAlert
{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:popAnimation forKey:nil];
    
}

- (void)cancelTitle{
    self.block(@"cancel");
    [self.showView removeFromSuperview];
}

- (void)sureTitle{
    self.block(@"sure");
    [self.showView removeFromSuperview];
}

- (void)setMessageSize:(CGFloat)messageSize{
    self.messageLable.font = [UIFont systemFontOfSize:messageSize];
}

- (void)setCancelSize:(CGFloat)cancelSize{
    self.canBtn.titleLabel.font = [UIFont systemFontOfSize:cancelSize];
}

- (void)setSureSize:(CGFloat)sureSize{
    self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:sureSize];
}

- (void)setMessageColor:(UIColor *)messageColor{
    self.messageLable.textColor = messageColor;
}

- (void)setSureColor:(UIColor *)sureColor{
    [self.sureBtn setTitleColor:sureColor forState:UIControlStateNormal];
}

- (void)setCancelColor:(UIColor *)cancelColor{
    [self.canBtn setTitleColor:cancelColor forState:UIControlStateNormal];
}

- (void)setSureBackColor:(UIColor *)sureBackColor{
    self.sureBtn.backgroundColor = sureBackColor;
}

- (void)setCancelBackColor:(UIColor *)cancelBackColor{
    self.canBtn.backgroundColor = cancelBackColor;
}

@end
