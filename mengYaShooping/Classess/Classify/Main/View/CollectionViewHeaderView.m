//
//  CollectionViewHeaderView.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//

#import "CollectionViewHeaderView.h"

@interface CollectionViewHeaderView ()

@property (nonatomic, strong) UILabel *lineLabel;

@end

@implementation CollectionViewHeaderView

-(UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(self.x + 20, 15, 150, 20)];
        _title.font = [UIFont systemFontOfSize:14];
        _title.textAlignment = NSTextAlignmentLeft;
    }
    return _title;
}

- (UILabel *)lineLabel
{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.title.left - 10, 15, 4, self.title.height)];
        _lineLabel.backgroundColor = YHRGBA(229, 78, 57, 1.0);
    }
    return _lineLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.lineLabel];
        [self addSubview:self.title];
        
    }
    return self;
}


@end
