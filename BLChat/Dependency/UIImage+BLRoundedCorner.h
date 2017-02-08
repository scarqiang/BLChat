//
//  UIImageView+BLRoundedCorner.h
//  beiliao
//
//  Created by huangzeyu on 9/22/16.
//  Copyright © 2016 beiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BLRoundedCorner)
/**
 *  给头像添加贝聊圆角
 *
 *  @param height      头像尺寸，宽度同高度
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 *
 *  @return 添加完贝聊圆角的头像
 */
- (UIImage *)bl_beiLiaoAvatarWithHeight:(CGFloat)height
                            borderWidth:(CGFloat)borderWidth
                            borderColor:(UIColor *)borderColor;
/**
 *  给头像添加贝聊圆角,无边框
 *
 *  @param height 头像尺寸，宽度同高度
 *
 *  @return 添加完贝聊圆角的头像
 */
- (UIImage *)bl_beiLiaoAvatarWithHeight:(CGFloat)height;

@end
