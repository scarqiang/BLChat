//
//  BLMessagesAudioContentNode.m
//  BLChat
//
//  Created by 黄泽宇 on 2/6/17.
//  Copyright © 2017 HZQ. All rights reserved.
//

#import "BLMessagesAudioContentNode.h"
#import "ASDimension.h"

@interface BLMessagesAudioContentNode ()
@property (nonatomic) ASImageNode *bubbleBackgroundImageNode;
@property (nonatomic) ASImageNode *audioIconImageNode;
@property (nonatomic) ASTextNode *audioLengthTextNode;
@property (nonatomic) ASImageNode *audioListenedImageNode;
@property (nonatomic) ASDisplayNode *audioListenedNode;

@property (nonatomic) BLMessageDisplayType messageDisplayType;
@property (nonatomic) NSTimeInterval timeLength;

@property (nonatomic) CGFloat spaceBetweenVideoIconAndTimeLabel;
@end
@implementation BLMessagesAudioContentNode
- (instancetype)initWithTimeLength:(NSTimeInterval)length messageDisplayType:(BLMessageDisplayType)displayType {
    NSParameterAssert(length);
    NSParameterAssert(displayType != BLMessageDisplayTypeCenter);

    self = [super init];
    if (self) {
        _messageDisplayType = displayType;
        _timeLength = length;
        _spaceBetweenVideoIconAndTimeLabel = 10;

        _bubbleBackgroundImageNode = ({
            ASImageNode *imageNode = [ASImageNode new];
            imageNode.image = [self resizableBubbleImageForMessageDisplayType:_messageDisplayType highlighted:NO];
            imageNode;
        });

        _audioIconImageNode = ({
            ASImageNode *imageNode = [[ASImageNode alloc] init];
            imageNode.image = [UIImage imageNamed:displayType == BLMessageDisplayTypeLeft ? @"audioPlay_n" : @"audio_n"];

            imageNode;
        });

        _audioLengthTextNode = ({
            ASTextNode *textNode = [[ASTextNode alloc] init];
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.alignment = _messageDisplayType == BLMessageDisplayTypeLeft ? NSTextAlignmentRight : NSTextAlignmentLeft;
            NSDictionary *attributes = @{
                    NSFontAttributeName:[UIFont systemFontOfSize:14.f],
                    NSForegroundColorAttributeName:[UIColor colorWithRed:53.f / 255.f green:53.f / 255.f blue:53.f / 255.f alpha:1.f],
                    NSParagraphStyleAttributeName: paragraphStyle
            };

            textNode.attributedText = [[NSAttributedString alloc] initWithString:[self timeLabelWithTimeLength:length]
                                                                      attributes:attributes];

            textNode;
        });

        [self addSubnode:_bubbleBackgroundImageNode];
        [self addSubnode:_audioLengthTextNode];
        [self addSubnode:_audioIconImageNode];
    }

    return self;
}

- (void)didTapContentNode {
    [super didTapContentNode];
    if (!self.audioListenedImageNode) {
        self.audioListenedImageNode = ({
            ASImageNode *imageNode = [ASImageNode new];
            imageNode.image = [self resizableListenedBubbleImage:self.messageDisplayType == BLMessageDisplayTypeLeft];
            imageNode.frame = self.bounds;

            imageNode;
        });
        self.audioListenedNode = ({
            ASDisplayNode *node = [ASDisplayNode new];
            node.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
            node.clipsToBounds = YES;

            node;
        });

        [self.audioListenedNode addSubnode:self.audioListenedImageNode];
        [self insertSubnode:self.audioListenedNode aboveSubnode:self.bubbleBackgroundImageNode];

        [UIView animateWithDuration:10 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.audioListenedNode.frame = self.bounds;
         } completion:nil];
    } else {
        [self.audioListenedNode removeFromSupernode];
        self.audioListenedImageNode = nil;
        self.audioListenedNode = nil;
    }
}

+ (instancetype)audioContentNodeWithTimeLength:(NSTimeInterval)length messageDisplayType:(BLMessageDisplayType)displayType {
    return [[self alloc] initWithTimeLength:length
                         messageDisplayType:displayType];
}

- (nullable NSString *)timeLabelWithTimeLength:(NSTimeInterval)timeLength {
    if (timeLength < 0) {
        return nil;
    } else if (timeLength < 60) {
        return [NSString stringWithFormat:@"%ld\"", (long) timeLength];
    } else {
        long minutes = (long) (timeLength / 60.f);
        long seconds = (long) ((NSInteger)(timeLength) % 60);
        return seconds >= 10 ? [NSString stringWithFormat:@"%ld:%ld\"", minutes, seconds] : [NSString stringWithFormat:@"%ld:0%ld\"", minutes, seconds];
    }
}

- (void)addConstrainWithCollectionNodeCellConstrainedSize:(ASSizeRange)constrainedSize {
    self.audioLengthTextNode.style.width = ASDimensionMake([self timeLabelWidthWithConstrainedSize:constrainedSize
                                                                                        timeLength:self.timeLength]);
}

- (CGFloat)timeLabelWidthWithConstrainedSize:(ASSizeRange)constrainedSize timeLength:(NSTimeInterval)timeLength {
    CGFloat normalizedTimeLength = MAX(MIN((CGFloat) (timeLength / 120.f), 1), 0);
    CGFloat maxWidth = constrainedSize.max.width - 2 * (kBLMessagesCollectionNodeCellAvatarHeight + kBLMessagesIncomingMessageLeftMargin + kBLMessagesIncomingContentNodeLeftMargin) - kBLMessagesBubbleMouthWidth - self.audioIconImageNode.image.size.width - kBLMessagesIncomingBubbleContentLeftPadding - kBLMessagesIncomingBubbleContentRightPadding - self.spaceBetweenVideoIconAndTimeLabel;
    return MAX(sqrt(normalizedTimeLength) * maxWidth, 40);
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    BOOL isIncoming = self.messageDisplayType == BLMessageDisplayTypeLeft;
    NSArray *contentArray = isIncoming ? @[self.audioLengthTextNode, self.audioIconImageNode] : @[self.audioIconImageNode, self.audioLengthTextNode];
    ASStackLayoutSpec *contentStackLayoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                        spacing:self.spaceBetweenVideoIconAndTimeLabel
                                                                                 justifyContent:isIncoming ?ASStackLayoutJustifyContentEnd : ASStackLayoutJustifyContentStart
                                                                                     alignItems:ASStackLayoutAlignItemsCenter
                                                                                       children:contentArray];
    UIEdgeInsets insets = UIEdgeInsetsMake(
            kBLMessagesIncomingBubbleContentTopPadding,
            self.messageDisplayType ==  BLMessageDisplayTypeLeft ? kBLMessagesIncomingBubbleContentLeftPadding : kBLMessagesIncomingBubbleContentRightPadding,
            kBLMessagesIncomingBubbleContentBottomPadding,
            self.messageDisplayType ==  BLMessageDisplayTypeLeft ? kBLMessagesIncomingBubbleContentRightPadding : kBLMessagesIncomingBubbleContentLeftPadding);
    ASInsetLayoutSpec *contentInsetLayoutSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets
                                                                                    child:contentStackLayoutSpec];

    ASBackgroundLayoutSpec *bubbleAndContentBackgroundLayout = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:contentInsetLayoutSpec
                                                                                                          background:self.bubbleBackgroundImageNode];
    return bubbleAndContentBackgroundLayout;
}

- (UIImage *)resizableListenedBubbleImage:(BOOL)isIncoming {
    UIImage *image;
    if (isIncoming) {
        UIEdgeInsets capInsets = UIEdgeInsetsMake(
                kBLMessagesIncomingBubbleCapTop,
                kBLMessagesIncomingBubbleCapLeft,
                kBLMessagesIncomingBubbleCapBottom,
                kBLMessagesIncomingBubbleCapRight);
        image = [[UIImage imageNamed:kBLMessagesIncomingListenedAudioBubbleImageName] resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
    } else {
        UIEdgeInsets capInsets = UIEdgeInsetsMake(
                kBLMessagesIncomingBubbleCapTop,
                kBLMessagesIncomingBubbleCapRight,
                kBLMessagesIncomingBubbleCapBottom,
                kBLMessagesIncomingBubbleCapLeft);

        image = [[UIImage imageNamed:kBLMessagesOutgoingListenedAudioBubbleImageName] resizableImageWithCapInsets:capInsets
                                                                                                   resizingMode:UIImageResizingModeStretch];
    }
    return image;
}

- (void)setHighlighted:(BOOL)highlighted {
    self.bubbleBackgroundImageNode.image = [self resizableBubbleImageForMessageDisplayType:self.messageDisplayType
                                                                               highlighted:highlighted];
}

- (NSArray<UIMenuItem *> *)menuItemsForMenuController:(UIMenuController *)menuController {
    return @[self.deleteMenuItem];
}
@end
