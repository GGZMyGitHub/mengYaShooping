//
//  GZfeedBackViewController.m
//  mengYaShooping
//
//  Created by apple on 17/5/24.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZfeedBackViewController.h"

@interface GZfeedBackViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (nonatomic, strong) UILabel *placeHolderLabel;

- (IBAction)feedBack:(UIButton *)sender;


@end

@implementation GZfeedBackViewController

-(UILabel *)placeHolderLabel
{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.text = @"请简单描述您的意见或建议";
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.textColor = [UIColor lightGrayColor];
        [_placeHolderLabel sizeToFit];
        [self.textView addSubview:_placeHolderLabel];
        
        _placeHolderLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _placeHolderLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textView setValue:self.placeHolderLabel forKey:@"_placeholderLabel"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)feedBack:(UIButton *)sender {

    NSDictionary *params = @{
                             @"uid":[GGZTool isUid],
                             @"language":[GGZTool iSLanguageID],
                             @"info":self.textView.text,
                             @"action":@"Fankui"
                             };

    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
        
        [MBProgressHUD showAlertMessage:[obj valueForKey:@"msg"]];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showAlertMessage:@"提交失败"];

    }];
    
}


@end
