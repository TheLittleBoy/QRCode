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
    
    
    UIImageView *myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    myImageView.center = self.view.center;
    
    myImageView.image = resized;
    
    [self.view addSubview:myImageView];
    
    CGImageRelease(cgImage);
    
    
    UIButton * backbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backbutton setTitle:@"返回" forState:UIControlStateNormal];
    backbutton.frame = CGRectMake((self.view.frame.size.width-150)/2, self.view.frame.size.height-80, 150, 50);
    [backbutton addTarget:self action:@selector(backButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbutton];
    
}

-(void)backButtonPress
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
