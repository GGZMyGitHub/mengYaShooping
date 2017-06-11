//
//  ImagePicker.m
//  DWImagePicker
//
//  Created by dwang_sui on 16/6/20.
//  Copyright © 2016年 dwang_sui. All rights reserved.
//

#import "ImagePicker.h"

//如果有Debug这个宏的话,就允许log输出...可变参数
#ifdef DEBUG
#define DWLog(...) NSLog(__VA_ARGS__)
#else
#define DWLog(...)
#endif


@implementation ImagePicker

static ImagePicker *sharedManager = nil;

+ (ImagePicker *)sharedManager {
    
    @synchronized (self) {
        
        if (!sharedManager) {
            
            sharedManager = [[[self class] alloc] init];
            
        }
        
    }
    
    return sharedManager;
}

#pragma mark ---设置根控制器 弹框添加视图位置 所需图片样式 默认为UIImagePickerControllerEditedImage
- (void)dwSetPresentDelegateVC:(id)vc SheetShowInView:(UIView *)view InfoDictionaryKeys:(NSInteger)integer {
    
    picker = [[UIImagePickerController alloc]init];
    
    picker.delegate = self;
    
    self.integer = integer;
    
    NSString *fangshiStr;
    NSString *chongXiangCheStr;
    NSString *paiZhaoStr;
    NSString *quXiaoStr;
    if ([[GGZTool iSLanguageID] isEqualToString:@"0"])
    {

        fangshiStr = @"选择上传方式";
        chongXiangCheStr = @"从相册选择";
        paiZhaoStr = @"拍照";
        quXiaoStr = @"取消";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"1"]){
        
        fangshiStr = @"choose upload method";
        chongXiangCheStr = @"select from photo album";
        paiZhaoStr = @"take a picture";
        quXiaoStr = @"cancel";
        
    }else if ([[GGZTool iSLanguageID] isEqualToString:@"2"]){
        
        fangshiStr = @"feltöltési módszerek";
        chongXiangCheStr = @"válasszon az albumból";
        paiZhaoStr = @"fényképezni";
        quXiaoStr = @"törlés";
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:fangshiStr delegate:self cancelButtonTitle:quXiaoStr destructiveButtonTitle:nil otherButtonTitles:chongXiangCheStr,paiZhaoStr, nil];
    
    [sheet showInView:view];
    
    picker.allowsEditing = YES;
    
    self.allowsEditing = picker.allowsEditing;
    
    self.vc = vc;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        self.typeStr = @"支持相机";
        
    }
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        
        self.typeStr = @"支持图库";
        
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        
        self.typeStr = @"支持相片库";
        
    }
}

#pragma mark ---获取设备支持的类型与选中之后的图片
- (void)dwGetpickerTypeStr:(pickerTypeStr)pickerTypeStr pickerImagePic:(pickerImagePic)pickerImagePic {
    
    if (pickerTypeStr) {
        
        pickerTypeStr(self.typeStr);
        
    }
    
    self.pickerImagePic = ^(UIImage *image) {
        
        pickerImagePic(image);
        
    };
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
        UIImage *image = [[UIImage alloc] init];
        
        NSArray *array = @[@"UIImagePickerControllerMediaType",
                           @"UIImagePickerControllerOriginalImage",
                           @"UIImagePickerControllerEditedImage",
                           @"UIImagePickerControllerCropRect",
                           @"UIImagePickerControllerMediaURL",
                           @"UIImagePickerControllerReferenceURL",
                           @"UIImagePickerControllerMediaMetadata",
                           @"UIImagePickerControllerLivePhoto"];
        
        if (self.integer) {
            
            image = [info objectForKey:array[self.integer]];
            
        }else {
            
            image = [info objectForKey:array[2]];
            
        }
        
        if (self.pickerImagePic) {
            
            self.pickerImagePic(image);
            
        }
        
        [self.vc dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self.vc dismissViewControllerAnimated:YES completion:nil];
    
}

//此方法是用于判断点击了哪一个sheet上面的button
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunicode-whitespace"
        
        [self.vc presentViewController:picker animated:YES completion:nil];
        
#pragma clang diagnostic pop

    }else if (buttonIndex == 1) {
        
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunicode-whitespace"
        
        [self.vc presentViewController:picker animated:YES completion:nil];
        
#pragma clang diagnostic pop
        
    }
    
}


@end
