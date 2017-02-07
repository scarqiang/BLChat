//
// Created by 黄泽宇 on 2/7/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//

#import "BLTextMessage.h"
#import "BLMessagesTextContentNode.h"

@interface BLTextMessage ()
@property (nonatomic, copy) NSString *text;
@end

@implementation BLTextMessage
- (instancetype)initWithText:(NSString *)text messageDisplayType:(BLMessageDisplayType)displayType {
    self = [super init];
    if (self) {
        _text = text;
        _messageDisplayType = displayType;

        _senderName = @"黄志强";
        _sendingTime = [NSDate date].timeIntervalSince1970;
        _avatarImage = [UIImage imageNamed:@"demo_avatar_cook"];

    }

    return self;
}

- (BLMessagesContentNode *)contentNode {
    if (!_contentNode) {
        _contentNode = [BLMessagesTextContentNode textContentNodeWithText:self.text
                                                       messageDisplayType:self.messageDisplayType];
    }

    return _contentNode;
}

+ (instancetype)textMessageWithText:(NSString *)text messageDisplayType:(BLMessageDisplayType)displayType {
    return [[self alloc] initWithText:text messageDisplayType:displayType];
}

@end