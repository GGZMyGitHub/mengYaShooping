
//
//  GZCollectionViewCell.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/24.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZCollectionViewCell.h"
#import "GZThirdModel.h"

@interface GZCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *name;

@end

@implementation GZCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {

        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(2, 15, self.frame.size.width - 4, self.frame.size.width - 4)];
        
        self.imageV.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageV];
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(2, self.frame.size.width + 10, self.frame.size.width - 4, 40)];
        self.name.numberOfLines = 2;
        self.name.font = [UIFont systemFontOfSize:11];
        self.name.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.name];
    }
    return self;
}

-(void)setSecondModel:(GZSecondModel *)secondModel
{
    _secondModel = secondModel;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",YUMING,secondModel.one_img];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:imgStr]];
    self.name.text = secondModel.one_name;
}

@end
