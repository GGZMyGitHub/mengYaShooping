//
//  GZAddressViewController.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/22.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZAddressViewController.h"
#import "GZVaulePickerView.h"
#import "GZAdressResultModel.h"
#import "GZAdressDataModel.h"

@interface GZAddressViewController ()<UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *telTF;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (weak, nonatomic) IBOutlet UIButton *adressBtn;

@property (nonatomic, strong) UILabel *placeHolderLabel;

/** 所在区域的数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/** 所在区域的ID */
@property (nonatomic, strong) NSMutableArray *dataIDSource;

/** 所在区域的数据 */
@property (nonatomic, strong) NSArray *adressDataArr;

@property (nonatomic, strong) GZVaulePickerView *pickerView;

//翻译
@property (weak, nonatomic) IBOutlet UILabel *shouJianRenLabel;
@property (weak, nonatomic) IBOutlet UILabel *dianHuaLabel;
@property (weak, nonatomic) IBOutlet UILabel *suoZaiQuYuLabel;
@property (weak, nonatomic) IBOutlet UIButton *sheWeiMoRenDiZhiBtn;



- (IBAction)adressBtn:(UIButton *)sender;
- (IBAction)defaultBtn:(UIButton *)sender;

@end

@implementation GZAddressViewController

-(UILabel *)placeHolderLabel
{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc] init];
        
        if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
        {
            _placeHolderLabel.text = @"请填写详细地址，不少于5个字";
            
        }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
            
            _placeHolderLabel.text = @"please fill in detailed address, no less than five characters";
            
        }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
            
            _placeHolderLabel.text = @"töltse ki a címet，egyéb";
        }
        
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.textColor = [UIColor lightGrayColor];
        [_placeHolderLabel sizeToFit];
        [self.textView addSubview:_placeHolderLabel];
        
        _placeHolderLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _placeHolderLabel;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableArray *)dataIDSource
{
    if (!_dataIDSource) {
        _dataIDSource = [NSMutableArray array];
    }
    return _dataIDSource;
}

-(NSArray *)adressDataArr
{
    if (!_adressDataArr) {
        _adressDataArr = [NSArray array];
    }
    return _adressDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSString *saveStr;
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
    {
        saveStr = @"保存";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        saveStr = @"save";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        saveStr = @"mentés";
    }
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:saveStr style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
    {
        self.shouJianRenLabel.text = @"收件人姓名";
        self.dianHuaLabel.text = @"联系电话";
        self.suoZaiQuYuLabel.text = @"所在区域";
        [self.sheWeiMoRenDiZhiBtn setTitle:@"设为默认地址" forState:UIControlStateNormal];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        self.shouJianRenLabel.text = @"recipient's name";
        self.dianHuaLabel.text = @"telephone";
        self.suoZaiQuYuLabel.text = @"location";
        [self.sheWeiMoRenDiZhiBtn setTitle:@"set as default address" forState:UIControlStateNormal];
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        self.shouJianRenLabel.text = @"címzett neve";
        self.dianHuaLabel.text = @"telefonszám";
        self.suoZaiQuYuLabel.text = @"meggye";
        [self.sheWeiMoRenDiZhiBtn setTitle:@"alapértelmezett cím" forState:UIControlStateNormal];
    }
    
    [self.textView setValue:self.placeHolderLabel forKey:@"_placeholderLabel"];
    self.nameTF.delegate = self;
    self.telTF.delegate = self;
    self.textView.delegate = self;
    
    if ([self.title isEqualToString:@"修改地址"]) {
        
        self.nameTF.text = [NSString stringWithFormat:@"%@",self.dataModel.person];
        self.telTF.text = [NSString stringWithFormat:@"%@",self.dataModel.tel];
       
        [self.adressBtn setTitle:[NSString stringWithFormat:@"%@",self.dataModel.area] forState:UIControlStateNormal];
        self.textView.text = [NSString stringWithFormat:@"%@",self.dataModel.address];
    }
    
    [self.defaultBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    
    self.pickerView = [[GZVaulePickerView alloc]init];
}

#pragma mark - UITextViewDelegate -
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return

        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)saveBtnClick
{
    NSString *isSelect = [NSString stringWithFormat:@"%zd",self.defaultBtn.selected];
    NSString *adressStr = self.adressBtn.titleLabel.text;
    NSString *adressID = nil;
    
    if ([self.title isEqualToString:@"修改地址"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        adressID = [defaults objectForKey:@"area_id"];
    }
    
    for (GZAdressDataModel *dataModel in self.adressDataArr) {
        
        if ([self.adressBtn.titleLabel.text isEqualToString:dataModel.area_name]) {
            adressID = dataModel.area_id;
        }
    }
    
    if (self.nameTF.text.length != 0 && self.telTF.text.length != 0 && adressStr.length != 0 && adressID != nil && [GGZTool valiMobile:self.telTF.text]) {
        
        if ([self.title isEqualToString:@"新增地址"]) {
            NSDictionary *params = @{
                                     @"uid":[GGZTool isUid],
                                     @"person":self.nameTF.text,
                                     @"tel":self.telTF.text,
                                     @"area_id":adressID,
                                     @"area_name":adressStr,
                                     @"address":self.textView.text,
                                     @"ismoren":isSelect,
                                     @"action":@"my_address_add"
                                     };
            
            [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
                if ([[obj valueForKey:@"msgcode"] isEqualToString:@"1"]) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            } failure:^(NSError *error) {
                [MBProgressHUD showAlertMessage:@"保存失败"];

            }];
            
        }else if ([self.title isEqualToString:@"修改地址"]){
            NSDictionary *params = @{
                                     @"id":self.adressID,
                                     @"person":self.nameTF.text,
                                     @"tel":self.telTF.text,
                                     @"area_id":adressID,
                                     @"area_name":adressStr,
                                     @"address":self.textView.text,
                                     @"ismoren":isSelect,
                                     @"action":@"my_address_update"
                                     };
            [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
                [self.navigationController popViewControllerAnimated:YES];

            } failure:^(NSError *error) {
                [MBProgressHUD showAlertMessage:@"保存失败"];
            }];
        }
    }else if (self.nameTF.text.length == 0 && self.telTF.text.length == 0 && adressStr.length == 0){
        
        [MBProgressHUD showAlertMessage:@"请填写信息"];
        
    }else if (self.nameTF.text.length == 0 && self.telTF.text.length != 0  && adressStr.length != 0){
        
        [MBProgressHUD showAlertMessage:@"请输入姓名"];
        
    }else if (self.nameTF.text.length != 0 && self.telTF.text.length == 0 && adressStr.length != 0){
        
        [MBProgressHUD showAlertMessage:@"请输入联系电话"];
        
    }else if (self.nameTF.text.length != 0 && self.telTF.text.length != 0 && adressStr.length == 0){
        
        [MBProgressHUD showAlertMessage:@"请选择区域"];
        
    }else if (self.nameTF.text.length != 0 && self.telTF.text.length != 0 && adressStr.length != 0 && ![GGZTool valiMobile:self.telTF.text]){
        [MBProgressHUD showAlertMessage:@"手机号格式不对"];
    }
}

- (IBAction)adressBtn:(UIButton *)sender {
   
    [self.nameTF resignFirstResponder];
    [self.textView resignFirstResponder];
    [self.telTF resignFirstResponder];
    
    NSDictionary *params = @{
                             @"language":[GGZTool iSLanguageID],
                             @"action":@"Area_list"
                             };
    
    [GZHttpTool post:URL params:params success:^(NSDictionary *obj) {
        GZAdressResultModel *resultModel = [[GZAdressResultModel alloc] initWithDictionary:obj error:nil];
        
        if ([resultModel.msgcode isEqualToString:@"1"]) {
            
            GZAdressDataModel *dataModel = resultModel.data[0];
            
            [self.dataSource removeAllObjects];
            
            self.adressDataArr = resultModel.data;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            //先清空，再添加
            [defaults removeObjectForKey:@"area_id"];
            [defaults setObject:dataModel.area_id forKey:@"area_id"];
            
            [defaults synchronize];
            
            for (GZAdressDataModel *dataModel in resultModel.data) {
                [self.dataSource addObject:dataModel.area_name];
                [self.dataIDSource addObject:dataModel.area_id];
            }
            
            self.pickerView.dataSource = self.dataSource;
            
            //选择的城市
            __weak typeof(self) weakSelf = self;
            self.pickerView.valueDidSelect = ^(NSString *value){
                
                [weakSelf.adressBtn setTitle:value forState:UIControlStateNormal];
            };
            
            [self.pickerView show];
        }
        

    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常"];

    }];
}

- (IBAction)defaultBtn:(UIButton *)sender {
    
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"weixuan_"] forState:UIControlStateNormal];
    }else
    {
        [sender setImage:[UIImage imageNamed:@"yixuan_"] forState:UIControlStateNormal];
    }
    
    sender.selected = !sender.selected;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
