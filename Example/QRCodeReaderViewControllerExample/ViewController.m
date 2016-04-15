/*
 * QRCodeReaderViewController
 *
 * Copyright 2014-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "ViewController.h"
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"
#import "CBQRCodeViewController.h"
#import "UIImage+QRCode.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSString * qrResult;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        [_readButton removeFromSuperview];
    }
}

- (IBAction)tapGestureRecognizer:(id)sender {
    
    [_myTextView resignFirstResponder];
}

- (IBAction)scanAction:(id)sender
{
  if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
    static QRCodeReaderViewController *reader = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
      reader                        = [[QRCodeReaderViewController alloc] initWithCancelButtonTitle:@"取消" metadataObjectTypes:@[AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeUPCECode]];
      reader.modalPresentationStyle = UIModalPresentationFormSheet;
    });
    reader.delegate = self;
    
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
      NSLog(@"Completion with result: %@", resultAsString);
    }];
    
    [self presentViewController:reader animated:YES completion:NULL];
  }
  else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reader not supported by the current device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
  }
}

- (IBAction)creatAction:(id)sender {

    CBQRCodeViewController * codeVC = [[CBQRCodeViewController alloc]init];
    codeVC.text = _myTextView.text;
    
    [self presentViewController:codeVC animated:YES completion:NULL];
    
}

- (IBAction)readAction:(id)sender {
    
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    
    photoPicker.delegate = self;
    photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photoPicker.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:photoPicker animated:YES completion:NULL];
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage * srcImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSString *result = [UIImage readQRCodeFromImage:srcImage];
    
    if (result && ![result isEqualToString:@""])
    {
        qrResult = result;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫描结果" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"前往浏览器",@"复制文本",nil];
        [alert show];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有识别到二维码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    qrResult = result;
    [self dismissViewControllerAnimated:YES completion:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫描结果" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"前往浏览器",@"复制文本",nil];
        [alert show];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //确定
    }else if (buttonIndex == 1){
        //浏览器
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:qrResult]];
        
    }else if (buttonIndex == 2){
        //复制
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = qrResult;
    }
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
