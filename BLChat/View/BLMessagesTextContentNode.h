//
// Created by 黄泽宇 on 24/01/2017.
// Copyright (c) 2017 HZQ. All rights reserved.
//

#import "BLMessagesContentNode.h"

@interface BLMessagesTextContentNode : BLMessagesContentNode

- (instancetype)initWithText:(NSString *)text messageDisplayType:(BLMessageDisplayType)displayType;

+ (instancetype)textContentNodeWithText:(NSString *)text messageDisplayType:(BLMessageDisplayType)displayType;
@end