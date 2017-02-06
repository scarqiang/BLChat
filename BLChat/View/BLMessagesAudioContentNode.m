//
//  BLMessagesAudioContentNode.m
//  BLChat
//
//  Created by 黄泽宇 on 2/6/17.
//  Copyright © 2017 HZQ. All rights reserved.
//

#import "BLMessagesAudioContentNode.h"
#import "ASDimension.h"
#include "math.h"
@interface BLMessagesAudioContentNode ()
@property (nonatomic) ASImageNode *bubbleBackgroundImageNode;
@property (nonatomic) ASImageNode *videoIconImageNode;
@property (nonatomic) ASTextNode *videoLengthTextNode;
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
            imageNode.image = [self resizableBubbleImageForMessageDisplayType:_messageDisplayType];
            imageNode;
        });

        _videoIconImageNode = ({
            ASImageNode *imageNode = [[ASImageNode alloc] init];
            imageNode.image = [UIImage imageNamed:displayType == BLMessageDisplayTypeLeft ? @"audioPlay_n" : @"audio_n"];
            imageNode;
        });

        _videoLengthTextNode = ({
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
        [self addSubnode:_videoLengthTextNode];
        [self addSubnode:_videoIconImageNode];
    }

    return self;
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
        return seconds > 10 ? [NSString stringWithFormat:@"%ld:%ld\"", minutes, seconds] : [NSString stringWithFormat:@"%ld:0%ld\"", minutes, seconds];
    }
}

- (void)addConstrainWithCollectionNodeCellConstrainedSize:(ASSizeRange)constrainedSize {
    self.videoLengthTextNode.style.width = ASDimensionMake([self timeLabelWidthWithConstrainedSize:constrainedSize
                                                                                        timeLength:self.timeLength]);
}

- (CGFloat)timeLabelWidthWithConstrainedSize:(ASSizeRange)constrainedSize timeLength:(NSTimeInterval)timeLength {
    CGFloat normalizedTimeLength = MAX(MIN((CGFloat) (timeLength / 120.f), 1), 0);
    CGFloat maxWidth = constrainedSize.max.width - 2 * (kBLMessagesCollectionNodeCellAvatarHeight + kBLMessagesIncomingMessageLeftMargin + kBLMessagesIncomingContentNodeLeftMargin) - kBLMessagesBubbleMouthWidth - self.videoIconImageNode.image.size.width - kBLMessagesIncomingBubbleContentLeftPadding - kBLMessagesIncomingBubbleContentRightPadding - self.spaceBetweenVideoIconAndTimeLabel;
    return MAX(sqrt(normalizedTimeLength) * maxWidth, 40);
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    BOOL isIncoming = self.messageDisplayType == BLMessageDisplayTypeLeft;
    NSArray *contentArray = isIncoming ? @[self.videoLengthTextNode, self.videoIconImageNode] : @[self.videoIconImageNode, self.videoLengthTextNode];
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

@end
