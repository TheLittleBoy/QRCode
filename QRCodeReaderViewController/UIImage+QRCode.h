//
//  UIImage+QRCode.h
//  ClassBook
//
//  Created by User on 14-4-2.
//  Copyright (c) 2014年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QRCorrectionLevel) {
    QRCorrectionLevelL = 7,  //
    QRCorrectionLevelM = 15, //
    QRCorrectionLevelQ = 25, //
    QRCorrectionLevelH = 30, //
};

@interface UIImage (QRCode)
/*
 * 生成二维码图像
 */
+(CIImage*)createQRCodeImage:(NSString*)str;
+(CIImage*)createQRCodeImage:(NSString*)str withLevel:(QRCorrectionLevel)level;


+(NSString *)readQRCodeFromImage:(UIImage *)image;

@end
