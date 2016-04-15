//
//  UIImage+QRCode.m
//  ClassBook
//
//  Created by User on 14-4-2.
//  Copyright (c) 2014年 AlphaStudio. All rights reserved.
//

#import "UIImage+QRCode.h"

@implementation UIImage (QRCode)

+(CIImage*)createQRCodeImage:(NSString*)str withLevel:(QRCorrectionLevel)level
{
    // 1. 实例化一个滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 1.1 设置filter的默认值
    // 因为之前如果使用过滤镜，输入有可能会被保留，因此，在使用滤镜之前，最好设置恢复默认值
    [filter setDefaults];
    
    // 2. 将传入的字符串转换为NSData
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    // 3. 将NSData传递给滤镜(通过KVC的方式，设置inputMessage)
    [filter setValue:data forKey:@"inputMessage"];
    
    // 4. 纠错等级 L: 7%   M: 15%   Q: 25%   H: 30%
    switch (level) {
        case QRCorrectionLevelL:
            [filter setValue:@"L" forKey:@"inputCorrectionLevel"];
            break;
        case QRCorrectionLevelM:
            [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
            break;
        case QRCorrectionLevelQ:
            [filter setValue:@"Q" forKey:@"inputCorrectionLevel"];
            break;
        case QRCorrectionLevelH:
            [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
            break;
        default:
            break;
    }
    
    //5. 上色滤镜
    UIColor *onColor = [UIColor blackColor];
    UIColor *offColor = [UIColor whiteColor];
    
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",filter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:onColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:offColor.CGColor],
                             nil];
    
    // 6. 由filter输出图像
    CIImage *outputImage = [colorFilter outputImage];
    
    // 7. 将CIImage转换为UIImage
    //[UIImage imageWithCIImage:outputImage];
    
    return outputImage;
}

+(CIImage*)createQRCodeImage:(NSString*)str
{
    return [self createQRCodeImage:str withLevel:QRCorrectionLevelQ];
}


+(NSString *)readQRCodeFromImage:(UIImage *)srcImage
{
    NSMutableString * result = [[NSMutableString alloc]init];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        CIImage *image = [CIImage imageWithCGImage:srcImage.CGImage];
        
        // 创建CIDetector
        CIDetector *qrDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                                    context:[CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}]
                                                    options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
        NSArray *features = [qrDetector featuresInImage:image];
        if ([features count] > 0)
        {
            for (CIFeature *feature in features)
            {
                if (![feature isKindOfClass:[CIQRCodeFeature class]])
                {
                    continue;
                }
                
                CIQRCodeFeature *qrFeature = (CIQRCodeFeature *)feature;
                NSString *code = qrFeature.messageString;
                
                [result appendString:code];
            }
        }
    }
    
    return result;
}
@end
