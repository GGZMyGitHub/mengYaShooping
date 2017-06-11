//
//  GZMessageCell.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/10.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZMessageCell.h"

@interface GZMessageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImg;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation GZMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setListModel:(GZMessageListModel *)listModel
{
    _listModel = listModel;
    
    self.messageLabel.text = listModel.n_content;
    self.timeLabel.text = listModel.n_date;
    
    switch (self.typeMessage) {
        case 0:
        {
            self.titleLabel.text = [self setLanguage:@"系统消息"];
            break;
        }
        case 1:
        {
            
            self.titleLabel.text = [self setLanguage:@"积分消息"];
            break;
        }
        case 2:
        {
          
            self.titleLabel.text = [self setLanguage:@"订单消息"];
            break;
        }
        default:
            break;
    }
}

- (NSString *)setLanguage:(NSString *)Str
{
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
        
        if ([Str isEqualToString:@"系统消息"]) {
            Str = @"系统消息";

        }else if ([Str isEqualToString:@"积分消息"]){
            Str = @"积分消息";

        }else if ([Str isEqualToString:@"订单消息"]){
            Str = @"订单消息";

        }
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        if ([Str isEqualToString:@"系统消息"]) {
            Str = @"system message";
            
        }else if ([Str isEqualToString:@"积分消息"]){
            Str = @"point message";
            
        }else if ([Str isEqualToString:@"订单消息"]){
            Str = @"order message";
            
        }
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        if ([Str isEqualToString:@"系统消息"]) {
            Str = @"rendszer üzenetek";
            
        }else if ([Str isEqualToString:@"积分消息"]){
            Str = @"pont gyüjtés információk";
            
        }else if ([Str isEqualToString:@"订单消息"]){
            Str = @"rendelés információk";
            
        }
    }
    return Str;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
