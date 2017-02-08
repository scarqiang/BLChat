//
// Created by 黄泽宇 on 1/25/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//

#import "BLMessagesContentNode.h"


@interface BLMessagesPhotoContentNode : BLMessagesContentNode
- (instancetype)initWithImage:(UIImage *)image messageDisplayType:(BLMessageDisplayType)displayType;

+ (instancetype)photoContentNodeWithImage:(UIImage *)image messageDisplayType:(BLMessageDisplayType)displayType;
@end
