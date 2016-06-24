//
//  UIImage+ImageContentWithColor.m
//  DouBan_pro
//
//  Created by lanou3g on 16/6/1.
//  Copyright © 2016年 me. All rights reserved.
//

#import "UIImage+ImageContentWithColor.h"

@implementation UIImage (ImageContentWithColor)

+(UIImage *)imageWithColor:(UIColor *)color{
    //给定绘图的大小
    CGRect rect = CGRectMake(0, 0, 1, 1);
    //
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1);
    //设置填充颜色
    [color setFill];
    //填充范围
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
        return image;
}

@end
