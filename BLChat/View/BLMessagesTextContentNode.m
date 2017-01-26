//
// Created by 黄泽宇 on 24/01/2017.
// Copyright (c) 2017 HZQ. All rights reserved.
//

#import "BLMessagesTextContentNode.h"
#import "ASDimension.h"


@interface BLMessagesTextContentNode ()
@property (nonatomic) ASTextNode *textNode;
@property (nonatomic, copy) NSString *text;
@property (nonatomic) BLMessageDisplayType messageDisplayType;
@property (nonatomic) ASImageNode *bubbleBackgroundImageNode;
@end
@implementation BLMessagesTextContentNode
- (instancetype)initWithText:(NSString *)text messageDisplayType:(BLMessageDisplayType)displayType {
    NSParameterAssert(text);
    NSParameterAssert(displayType != BLMessageDisplayTypeCenter);

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
            textNode.maximumNumberOfLines = 0;
            textNode;
        });

        [self addSubnode:_bubbleBackgroundImageNode];
        [self addSubnode:_textNode];

    }

    return self;
}

+ (instancetype)textContentNodeWithText:(NSString *)text messageDisplayType:(BLMessageDisplayType)displayType {
    return [(BLMessagesTextContentNode *) [[self class] alloc] initWithText:text messageDisplayType:displayType];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    UIEdgeInsets insets = UIEdgeInsetsMake(
            kBLMessagesIncomingBubbleContentTopPadding,
            self.messageDisplayType ==  BLMessageDisplayTypeLeft ? kBLMessagesIncomingBubbleContentLeftPadding : kBLMessagesIncomingBubbleContentRightPadding,
            kBLMessagesIncomingBubbleContentBottomPadding,
            self.messageDisplayType ==  BLMessageDisplayTypeLeft ? kBLMessagesIncomingBubbleContentRightPadding : kBLMessagesIncomingBubbleContentLeftPadding);
    ASInsetLayoutSpec *textNodeInsetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets
                                                                                    child:self.textNode];

    ASBackgroundLayoutSpec *bubbleAndTextNodeBackgroundLayout = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:textNodeInsetLayout background:self.bubbleBackgroundImageNode];
    return bubbleAndTextNodeBackgroundLayout;
}

- (void)addConstrainWithCollectionNodeCellConstrainedSize:(ASSizeRange)constrainedSize {
    self.style.maxWidth = ASDimensionMake(constrainedSize.max.width - 2 * (kBLMessagesCollectionNodeCellAvatarHeight + kBLMessagesIncomingMessageLeftMargin + kBLMessagesIncomingContentNodeLeftMargin) - kBLMessagesBubbleMouthWidth);
}


@end
