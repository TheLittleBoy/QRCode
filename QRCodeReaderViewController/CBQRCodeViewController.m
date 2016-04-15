//
//  CBQRCodeViewController.m
//  QRCodeReaderViewControllerExample
//
//  Created by MAC_AO on 15/3/11.
//  Copyright (c) 2015年 Yannick Loriot. All rights reserved.
//

#import "CBQRCodeViewController.h"
#import "UIImage+QRCode.h"

@interface CBQRCodeViewController ()
{
    UIImageView *myImageView;
}

@end

@implementation CBQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"二维码";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //将编码后的信息生成二维码
    CIImage *outputImage = [UIImage createQRCodeImage:_text];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    //将CGImage转换成UIImage
    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:1.
                                   orientation:UIImageOrientationUp];
    
    // Resize without interpolating
    UIImage *resized = [self resizeImage:image
                             withQuality:kCGInterpolationNone
                                    rate:5.0];
    
    
    myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    myImageView.center = self.view.center;
    
    myImageView.image = resized;
    
    [self.view addSubview:myImageView];
    
    CGImageRelease(cgImage);
    
    
    UIButton * backbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backbutton setTitle:@"返回" forState:UIControlStateNormal];
    backbutton.frame = CGRectMake((self.view.frame.size.width-300)/3, self.view.frame.size.height-80, 150, 50);
    [backbutton addTarget:self action:@selector(backButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbutton];
    
    UIButton * savebutton = [UIButton buttonWithType:UIButtonTypeSystem];
    [savebutton setTitle:@"保存到相册" forState:UIControlStateNormal];
    savebutton.frame = CGRectMake((self.view.frame.size.width-300)/3*2 + 150, self.view.frame.size.height-80, 150, 50);
    [savebutton addTarget:self action:@selector(saveButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:savebutton];
    
    NSArray * ar = [NSArray arrayWithObjects:@"L",@"M",@"Q",@"H", nil];

    int lever[4] = {QRCorrectionLevelL,QRCorrectionLevelM,QRCorrectionLevelQ,QRCorrectionLevelH};
    
    for (int i = 0;i<4;i++) {
        
        NSString * str = ar[i];
        
        CGFloat width = 50;
        CGFloat height = 40;
        CGFloat space = (self.view.frame.size.width-width*4)/5.0;
        
        UIButton * button = [UIButton buttonWithType: UIButtonTypeSystem];
        [button setTitle:str forState:UIControlStateNormal];
        button.frame = CGRectMake(space*(i+1) + width*i, 30 ,width, height);
        button.tag = lever[i];
        [button addTarget:self action:@selector(qualityButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
}

-(void)qualityButtonPress:(UIButton *)button
{
    //将编码后的信息生成二维码
    CIImage *outputImage = [UIImage createQRCodeImage:_text withLevel:button.tag];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    //将CGImage转换成UIImage
    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:1.
                                   orientation:UIImageOrientationUp];
    
    // Resize without interpolating
    UIImage *resized = [self resizeImage:image
                             withQuality:kCGInterpolationNone
                                    rate:5.0];
    
    myImageView.image = resized;
}

-(void)backButtonPress
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//保存图片到本地相册
-(void)saveButtonPress
{
    UIImage * image = myImageView.image;
    UIImageWriteToSavedPhotosAlbum(image,
                                   self,
                                   @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:),
                                   NULL);
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        // Do anything needed to handle the error or display it to the user
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"error.localizedDescription" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    } else {
        // .... do anything you want here to handle
        // .... when the image has been saved in the photo album
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"以保存到相册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

/*
 * 缩放图片
 */
- (UIImage *)resizeImage:(UIImage *)image
             withQuality:(CGInterpolationQuality)quality
                    rate:(CGFloat)rate
{
    UIImage *resized = nil;
    CGFloat width = image.size.width * rate;
    CGFloat height = image.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resized;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
