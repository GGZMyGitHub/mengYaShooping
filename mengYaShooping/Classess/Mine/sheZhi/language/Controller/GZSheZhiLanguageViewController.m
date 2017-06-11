//
//  GZSheZhiLanguageViewController.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/6/5.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZSheZhiLanguageViewController.h"

@interface GZSheZhiLanguageViewController ()

@property (weak, nonatomic) IBOutlet UIButton *magyarBtn;
@property (weak, nonatomic) IBOutlet UIImageView *magyarImgV;

@property (weak, nonatomic) IBOutlet UIButton *englishBtn;
@property (weak, nonatomic) IBOutlet UIImageView *englishImgV;

@property (weak, nonatomic) IBOutlet UIButton *ChineseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *chineseImgV;

- (IBAction)magyarBtn:(UIButton *)sender;
- (IBAction)EnglishBtn:(UIButton *)sender;
- (IBAction)ChineseBtn:(UIButton *)sender;

@end

@implementation GZSheZhiLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"]) {
      
        self.magyarBtn.selected = NO;
        self.englishBtn.selected = NO;
        self.ChineseBtn.selected = YES;
        
        self.magyarImgV.hidden = YES;
        self.englishImgV.hidden = YES;
        self.chineseImgV.hidden = NO;
        
        self.magyarBtn.backgroundColor = YHRGBA(221, 221, 221, 1.0);
        self.englishBtn.backgroundColor = YHRGBA(221, 221, 221, 1.0);
        self.ChineseBtn.backgroundColor = YHRGBA(255, 184, 0, 1.0);
        [self.ChineseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        self.englishBtn.selected = YES;
        self.magyarBtn.selected = NO;
        self.ChineseBtn.selected = NO;
        
        self.magyarImgV.hidden = YES;
        self.englishImgV.hidden = NO;
        self.chineseImgV.hidden = YES;
        
        self.magyarBtn.backgroundColor = YHRGBA(221, 221, 221, 1.0);
        self.englishBtn.backgroundColor = YHRGBA(255, 184, 0, 1.0);
        self.ChineseBtn.backgroundColor = YHRGBA(221, 221, 221, 1.0);
        [self.englishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        self.englishBtn.selected = NO;
        self.ChineseBtn.selected = NO;
        self.magyarBtn.selected = YES;

        self.magyarImgV.hidden = NO;
        self.englishImgV.hidden = YES;
        self.chineseImgV.hidden = YES;
        
        self.magyarBtn.backgroundColor = YHRGBA(255, 184, 0, 1.0);
        self.englishBtn.backgroundColor = YHRGBA(221, 221, 221, 1.0);
        self.ChineseBtn.backgroundColor = YHRGBA(221, 221, 221, 1.0);
        [self.magyarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)magyarBtn:(UIButton *)sender {
    
    [self setLanguageID:@"2"];
    
    self.magyarBtn.selected = YES;
    self.englishBtn.selected = NO;
    self.ChineseBtn.selected = NO;
    
    self.magyarImgV.hidden = NO;
    self.englishImgV.hidden = YES;
    self.chineseImgV.hidden = YES;
    
    self.magyarBtn.backgroundColor = YHRGBA(255, 184, 0, 1.0);
    self.englishBtn.backgroundColor = YHRGBA(221, 221, 221, 1.0);
    self.ChineseBtn.backgroundColor = YHRGBA(221, 221, 221, 1.0);
    
    [self.magyarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.englishBtn setTitleColor:YHRGBA(118, 118, 118, 1.0) forState:UIControlStateNormal];
    [self.ChineseBtn setTitleColor:YHRGBA(118, 118, 118, 1.0) forState:UIControlStateNormal];
}

- (IBAction)EnglishBtn:(UIButton *)sender {
    
    [self setLanguageID:@"1"];
    
    self.englishBtn.selected = YES;
    self.magyarBtn.selected = NO;
    self.ChineseBtn.selected = NO;
    
    self.magyarImgV.hidden = YES;
    self.englishImgV.hidden = NO;
    self.chineseImgV.hidden = YES;
    
    self.magyarBtn.backgroundColor = YHRGBA(221, 221, 221, 1.0);
    self.englishBtn.backgroundColor = YHRGBA(255, 184, 0, 1.0);
    self.ChineseBtn.backgroundColor = YHRGBA(221, 221, 221, 1.0);
    [self.englishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.magyarBtn setTitleColor:YHRGBA(118, 118, 118, 1.0) forState:UIControlStateNormal];
    [self.ChineseBtn setTitleColor:YHRGBA(118, 118, 118, 1.0) forState:UIControlStateNormal];
}

- (IBAction)ChineseBtn:(UIButton *)sender {
    
    [self setLanguageID:@"0"];

    self.magyarBtn.selected = NO;
    self.englishBtn.selected = NO;
    self.ChineseBtn.selected = YES;
    
    self.magyarImgV.hidden = YES;
    self.englishImgV.hidden = YES;
    self.chineseImgV.hidden = NO;
    
    self.magyarBtn.backgroundColor = YHRGBA(221, 221, 221, 1.0);
    self.englishBtn.backgroundColor = YHRGBA(221, 221, 221, 1.0);
    self.ChineseBtn.backgroundColor = YHRGBA(255, 184, 0, 1.0);
    
    [self.ChineseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.magyarBtn setTitleColor:YHRGBA(118, 118, 118, 1.0) forState:UIControlStateNormal];
    [self.englishBtn setTitleColor:YHRGBA(118, 118, 118, 1.0) forState:UIControlStateNormal];

}

- (void)setLanguageID:(NSString *)languageID
{
    NSDictionary *params = @{
                             @"uid":[GGZTool isUid],
                             @"language":languageID,
                             @"action":@"User_use_language"
                             };
    
    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        //替换语言，转化成服务器给的语言
        [defaults setObject:languageID forKey:@"languageID"];
        
        [defaults synchronize];
        
             
    } failure:^(NSError *error) {
        
    }];
}

@end
