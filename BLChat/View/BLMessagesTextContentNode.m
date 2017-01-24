//
// Created by 黄泽宇 on 24/01/2017.
// Copyright (c) 2017 HZQ. All rights reserved.
//

#import "BLMessagesTextContentNode.h"


@interface BLMessagesTextContentNode ()
@property (nonatomic) ASTextNode *textNode;
@property (nonatomic, copy) NSString *text;
@property (nonatomic) BLMessageDisplayType messageDisplayType;
@property (nonatomic) ASImageNode *bubbleBackgroundImageNode;
@end
@implementation BLMessagesTextContentNode
- (instancetype)initWithText:(NSString *)text messageDisplayType:(BLMessageDisplayType)displayType {
    NSParameterAssert(text);
    self = [super init];
    if (self) {

        _text = text;
        _messageDisplayType = displayType;

        _bubbleBackgroundImageNode = ({
            ASImageNode *imageNode = [ASImageNode new];
            imageNode.image = [self resizableBubbleImageForMessageDisplayType:_messageDisplayType];
            imageNode;
        });

        _textNode = ({
            ASTextNode *textNode = [ASTextNode new];
            NSDictionary *attributes = @{
                    NSFontAttributeName:[UIFont systemFontOfSize:12],
                    NSForegroundColorAttributeName:[UIColor colorWithRed:53.f / 255.f green:53.f / 255.f blue:53.f / 255.f alpha:1.f]
            };

            textNode.attributedText =  [[NSAttributedString alloc] initWithString:text ?: @""
                                                                       attributes:attributes];
            textNode;
        });

        [self addSubnode:_bubbleBackgroundImageNode];
        [self addSubnode:_textNode];

    }

    return self;
}

+ (instancetype)textContentNodeWithText:(NSString *)text messageDisplayType:(BLMessageDisplayType)displayType {
    return [[self class] initWithText:text messageDisplayType:displayType];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    UIEdgeInsets insets = UIEdgeInsetsMake(
            kBLMessagesBubbleContentPadding,
            kBLMessagesBubbleContentPadding,
            kBLMessagesBubbleContentPadding,
            kBLMessagesBubbleContentPadding);
    ASInsetLayoutSpec *textNodeInsetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets
                                                                                    child:self.textNode];

    ASOverlayLayoutSpec *bubbleAndTextNodeOverlayLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:self.bubbleBackgroundImageNode
                                                                                                  overlay:textNodeInsetLayout];
    return bubbleAndTextNodeOverlayLayout;
}


@end