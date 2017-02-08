//
//  UIImageView+BLRoundedCorner.m
//  beiliao
//
//  Created by huangzeyu on 9/22/16.
//  Copyright © 2016 beiliao. All rights reserved.
//

#import "UIImage+BLRoundedCorner.h"
#import "UIImage+YYWebImage.h"

#define BLFloor(number) floorf(number*factor)+0.5;
@implementation UIImage (BLRoundedCorner)
- (UIImage *)bl_beiLiaoAvatarWithHeight:(CGFloat)height {
    return [self bl_beiLiaoAvatarWithHeight:height
                                borderWidth:0
                                borderColor:[UIColor clearColor]
                             borderLineJoin:kCGLineJoinMiter];
}

- (UIImage *)bl_beiLiaoAvatarWithHeight:(CGFloat)height
                            borderWidth:(CGFloat)borderWidth
                            borderColor:(UIColor *)borderColor {
    return [self bl_beiLiaoAvatarWithHeight:height
                                borderWidth:borderWidth
                                borderColor:borderColor
                             borderLineJoin:kCGLineJoinMiter];
}

- (UIImage *)bl_beiLiaoAvatarWithHeight:(CGFloat)height
                   borderWidth:(CGFloat)borderWidth
                   borderColor:(UIColor *)borderColor
                borderLineJoin:(CGLineJoin)borderLineJoin {
    
    CGSize size = CGSizeMake(height, height);
    UIImage *scaledImage = [UIImage imageWithCGImage:self.CGImage scale:UIScreen.mainScreen.scale orientation:self.imageOrientation];
    UIImage *resizedImage = [scaledImage yy_imageByResizeToSize:size contentMode:UIViewContentModeScaleAspectFill];

    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, height, height);
    //转换坐标
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);

    //画图像
    CGFloat minSize = height;
    CGFloat factor = height / 100.f;

    UIBezierPath* path = [UIBezierPath bezierPath];
    if (borderWidth < minSize / 2) {
            [path moveToPoint: CGPointMake(99.40, 64.30)];
        [path addCurveToPoint: CGPointMake(64.30, 99.40)
                controlPoint1: CGPointMake(97.30, 86.00)
                controlPoint2: CGPointMake(84.10, 97.00)];
        [path addCurveToPoint: CGPointMake(50.20, 100.0)
                controlPoint1: CGPointMake(64.30, 99.40)
                controlPoint2: CGPointMake(57.10, 100.0)];
         [path addLineToPoint: CGPointMake(50.10, 100.0)];
         [path addLineToPoint: CGPointMake(50.00, 100.0)];
        [path addCurveToPoint: CGPointMake(35.90, 99.40)
                controlPoint1: CGPointMake(43.10, 100.0)
                controlPoint2: CGPointMake(35.90, 99.40)];
        [path addCurveToPoint: CGPointMake(0.600, 64.30)
                controlPoint1: CGPointMake(15.90, 97.00)
                controlPoint2: CGPointMake(2.700, 86.00)];
        [path addCurveToPoint: CGPointMake(0.000, 50.00)
                controlPoint1: CGPointMake(0.600, 64.30)
                controlPoint2: CGPointMake(0.000, 57.00)];
        [path addCurveToPoint: CGPointMake(0.600, 35.70)
                controlPoint1: CGPointMake(0.000, 43.00)
                controlPoint2: CGPointMake(0.600, 35.70)];
        [path addCurveToPoint: CGPointMake(35.70, 0.600)
                controlPoint1: CGPointMake(2.700, 14.00)
                controlPoint2: CGPointMake(15.90, 3.000)];
        [path addCurveToPoint: CGPointMake(49.80, 0.000)
                controlPoint1: CGPointMake(35.70, 0.600)
                controlPoint2: CGPointMake(42.90, 0.000)];
         [path addLineToPoint: CGPointMake(49.90, 0.000)];
         [path addLineToPoint: CGPointMake(50.00, 0.000)];
        [path addCurveToPoint: CGPointMake(64.10, 0.600)
                controlPoint1: CGPointMake(56.90, 0.000)
                controlPoint2: CGPointMake(64.10, 0.600)];
        [path addCurveToPoint: CGPointMake(99.40, 35.70)
                controlPoint1: CGPointMake(84.10, 3.000)
                controlPoint2: CGPointMake(97.30, 14.00)];
        [path addCurveToPoint: CGPointMake(100.0, 50.00)
                controlPoint1: CGPointMake(99.40, 35.70)
                controlPoint2: CGPointMake(100.0, 43.00)];
        [path addCurveToPoint: CGPointMake(99.40, 64.30)
                controlPoint1: CGPointMake(100.0, 57.00)
                controlPoint2: CGPointMake(99.40, 64.30)];
        [path closePath];
        if (borderWidth && borderColor) {
            factor = (height - borderWidth) / 100.f;
            [path applyTransform:CGAffineTransformScale(CGAffineTransformIdentity, factor, factor)];
            [path applyTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, borderWidth / 2, borderWidth / 2)];
        } else {
            [path applyTransform:CGAffineTransformScale(CGAffineTransformIdentity, factor, factor)];
        }
        CGContextSaveGState(context);
        [path addClip];
        CGContextDrawImage(context, rect, resizedImage.CGImage);
        CGContextRestoreGState(context);
    }
    
    if (borderColor && borderWidth < minSize / 2 && borderWidth > 0) {
        path.lineWidth = borderWidth;
        path.lineJoinStyle = borderLineJoin;
        [borderColor setStroke];
        [path stroke];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



@end
