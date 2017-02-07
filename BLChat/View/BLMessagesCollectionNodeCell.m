//
// Created by 黄泽宇 on 1/24/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//

#import "BLMessagesCollectionNodeCell.h"
#import "ASDimension.h"
#import "BLMessagesTimeSeparatorNode.h"

@interface BLMessagesCollectionNodeCell () <BLMessagesContentNodeDelegate>
@property (nonatomic, assign) BLMessageDisplayType messageDisplayType;

@property (nonatomic) ASNetworkImageNode *avatarNode;
@property (nonatomic) ASTextNode *senderNameTextNode;
@property (nonatomic) BLMessagesTimeSeparatorNode *timeSeparatorTextNode;
@property (nonatomic) ASButtonNode *accessoryButton;
@property (nonatomic) ASDisplayNode *indicatorNode;

@end

@implementation BLMessagesCollectionNodeCell

- (instancetype)initWithMessageDisplayType:(BLMessageDisplayType)displayType {
    self = [super init];
    if (self) {
        _messageDisplayType = displayType;

        [self configureSubnodes];

        [self addSubnode:_avatarNode];
        [self addSubnode:_senderNameTextNode];
        [self addSubnode:_timeSeparatorTextNode];
    }

    return self;
}

- (void)configureSubnodes {
    _avatarNode = ({
        ASNetworkImageNode *imageNode = [[ASNetworkImageNode alloc] init];
        imageNode.style.preferredSize = CGSizeMake(kBLMessagesCollectionNodeCellAvatarHeight, kBLMessagesCollectionNodeCellAvatarHeight);
        imageNode.defaultImage = [UIImage imageNamed:kBLMessagesCollectionNodeCellDefaultAvatarName];

        imageNode;
    });

    _senderNameTextNode = ({
        ASTextNode *textNode = [[ASTextNode alloc] init];
        textNode.style.maxWidth = ASDimensionMake(kBLMessagesCollectionNodeCellSenderNameMaxWidth);
        textNode;
    });

    _timeSeparatorTextNode = ({
        BLMessagesTimeSeparatorNode *node = [[BLMessagesTimeSeparatorNode alloc] init];

        node;
    });

}

#pragma mark - layout
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    if (!self.contentNode) {
        NSAssert(NO, @"content node must not be nil");
        return nil;
    }

    switch (self.messageDisplayType) {
        case BLMessageDisplayTypeCenter:
            return [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY
                                                              sizingOptions:ASCenterLayoutSpecSizingOptionDefault
                                                                      child:self.contentNode];
        case BLMessageDisplayTypeLeft:
            return [self layoutSpecThatFits:constrainedSize isIncoming:YES];
        case BLMessageDisplayTypeRight:
            return [self layoutSpecThatFits:constrainedSize isIncoming:NO];
    }
    NSAssert(NO, @"unexpected message display type");
    return nil;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize isIncoming:(BOOL)isIncoming {
    ASLayoutSpec *contentNodeLayoutSpec = [self contentNodeLayoutSpecWithIsIncoming:isIncoming constrainedSize:constrainedSize];
    ASLayoutSpec *contentLayoutSpec = !self.shouldDisplayName ? contentNodeLayoutSpec :
            [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                    spacing:0
                                             justifyContent:ASStackLayoutJustifyContentStart
                                                 alignItems:isIncoming ? ASStackLayoutAlignItemsStart : ASStackLayoutAlignItemsEnd
                                                   children:@[[self senderNameLayoutSpecWithIsIncoming:isIncoming], contentNodeLayoutSpec]];

    NSArray *contentArray;
    switch (self.messageLoadingStatus) {
        case BLMessageLoadingStatusLoading: {
            contentArray = isIncoming ? @[self.avatarNode, contentLayoutSpec, self.indicatorNode] : @[self.indicatorNode, contentLayoutSpec, self.avatarNode];
            self.indicatorNode.style.alignSelf = ASStackLayoutAlignSelfCenter;
            if (isIncoming) {
                self.indicatorNode.style.spacingBefore = kBLMessagesSpaceBetweenAccessoryViewAndContentNode;
            } else {
                self.indicatorNode.style.spacingAfter = kBLMessagesSpaceBetweenAccessoryViewAndContentNode;
            }
        }
            break;
        case BLMessageLoadingStatusLoadingFailed: {
            contentArray = isIncoming ? @[self.avatarNode, contentLayoutSpec, self.accessoryButton] : @[self.accessoryButton, contentLayoutSpec, self.avatarNode];
            self.accessoryButton.style.alignSelf = ASStackLayoutAlignSelfCenter;
            if (isIncoming) {
                self.accessoryButton.style.spacingBefore = kBLMessagesSpaceBetweenAccessoryViewAndContentNode;
            } else {
                self.accessoryButton.style.spacingAfter = kBLMessagesSpaceBetweenAccessoryViewAndContentNode;
            }
        }
            break;
        default:
            contentArray = isIncoming ? @[self.avatarNode, contentLayoutSpec] : @[contentLayoutSpec, self.avatarNode];
    }
    ASStackLayoutSpec *avatarAndContentLayoutSpec =
    [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                            spacing:0
                                     justifyContent:isIncoming ? ASStackLayoutJustifyContentStart : ASStackLayoutJustifyContentEnd
                                         alignItems:ASStackLayoutAlignItemsStart
                                           children:contentArray];

    ASInsetLayoutSpec *avatarAndContentInsetLayout = [self avatarAndContentInsetLayoutWithLayout:avatarAndContentLayoutSpec
                                                                                      isIncoming:isIncoming];
    NSArray *timestampAndMainContentArray = self.formattedTime ? @[self.timeSeparatorTextNode, avatarAndContentInsetLayout] :
            @[avatarAndContentInsetLayout];
    avatarAndContentLayoutSpec.style.alignSelf = isIncoming ? ASStackLayoutAlignSelfStart : ASStackLayoutAlignSelfEnd;
    
    ASStackLayoutSpec *timestampAndMainContentLayoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                                   spacing:0
                                                                                            justifyContent:ASStackLayoutJustifyContentStart
                                                                                                alignItems:ASStackLayoutAlignItemsStretch
                                                                                                  children:timestampAndMainContentArray];


    return timestampAndMainContentLayoutSpec;
}

- (ASInsetLayoutSpec *)avatarAndContentInsetLayoutWithLayout:(ASLayoutSpec *)avatarAndContentLayoutSpec isIncoming:(BOOL)isIncoming {
    UIEdgeInsets avatarAndContentInsets =
            UIEdgeInsetsMake(kBLMessagesIncomingMessageTopMargin,
                             isIncoming ? kBLMessagesIncomingMessageLeftMargin : kBLMessagesIncomingMessageRightMargin,
                             kBLMessagesIncomingMessageBottomMargin,
                             isIncoming ? kBLMessagesIncomingMessageRightMargin : kBLMessagesIncomingMessageLeftMargin);
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:avatarAndContentInsets child:avatarAndContentLayoutSpec];
}

- (ASLayoutSpec *)senderNameLayoutSpecWithIsIncoming:(BOOL)isIncoming {
    UIEdgeInsets insets =
            UIEdgeInsetsMake(kBLMessagesIncomingSenderNameTopMargin,
                             isIncoming ? kBLMessagesIncomingSenderNameLeftMargin : kBLMessagesIncomingSenderNameRightMargin,
                             kBLMessagesIncomingSenderNameBottomMargin,
                             isIncoming ? kBLMessagesIncomingSenderNameRightMargin : kBLMessagesIncomingSenderNameLeftMargin);
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets
                                                  child:self.senderNameTextNode];
}

- (ASLayoutSpec *)contentNodeLayoutSpecWithIsIncoming:(BOOL)isIncoming constrainedSize:(ASSizeRange)constrainedSize {
    [self.contentNode addConstrainWithCollectionNodeCellConstrainedSize:constrainedSize];
    UIEdgeInsets insets =
            UIEdgeInsetsMake(kBLMessagesIncomingContentNodeTopMargin,
                             isIncoming ? kBLMessagesIncomingContentNodeLeftMargin : kBLMessagesIncomingContentNodeRightMargin,
                             kBLMessagesIncomingContentNodeBottomMargin,
                             isIncoming ? kBLMessagesIncomingContentNodeRightMargin : kBLMessagesIncomingContentNodeLeftMargin);
    ASInsetLayoutSpec *insetLayoutSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets
                                                  child:[self.contentNode preferredLayoutSpec]];
    return insetLayoutSpec;
}
#pragma mark - setters and getters
- (void)setSenderName:(NSString *)senderName {
    if (!senderName) {
        return;
    }

    _senderName = senderName;
    NSDictionary *attributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:12],
            NSForegroundColorAttributeName:[UIColor colorWithRed:53.f / 255.f green:53.f / 255.f blue:53.f / 255.f alpha:1.f]
    };

    self.senderNameTextNode.attributedText = [[NSAttributedString alloc] initWithString:senderName
                                                                             attributes:attributes];
}

- (void)setFormattedTime:(NSString *)formattedTime {
    if (!formattedTime) {
        return;
    }

    _formattedTime = formattedTime;
    self.timeSeparatorTextNode.formattedTime = formattedTime;
}

- (void)setContentNode:(BLMessagesContentNode *)contentNode {
    _contentNode = contentNode;
    [self addSubnode:contentNode];
    contentNode.delegate = self;
}

- (void)setMessageLoadingStatus:(BLMessageLoadingStatus)messageLoadingStatus {
    //默认是BLMessageLoadingStatusLoadingSuccess
    if (_messageLoadingStatus == messageLoadingStatus) {
        return;
    }
    UIActivityIndicatorView *spinner = (UIActivityIndicatorView *) self.indicatorNode.view;
    _messageLoadingStatus = messageLoadingStatus;
    switch (messageLoadingStatus) {
        case BLMessageLoadingStatusLoading: {
            self.accessoryButton.hidden = YES;
            [spinner startAnimating];
            [self setNeedsLayout];
        }
            break;
        case BLMessageLoadingStatusLoadingFailed: {
            [spinner stopAnimating];
            self.accessoryButton.hidden = NO;
            [self setNeedsLayout];
        }
            break;
        case BLMessageLoadingStatusLoadingSuccess: {
            self.accessoryButton.hidden = YES;
            [spinner stopAnimating];
            [self setNeedsLayout];
        }
            break;
        default:
            NSAssert(NO, @"undefined message loading status");
            break;
    }
}

- (ASDisplayNode *)indicatorNode {
    if (!_indicatorNode) {
        _indicatorNode = ({
            ASDisplayNode *node = [[ASDisplayNode alloc] initWithViewBlock:^UIView * {
                return [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];;
            }];
            node.style.preferredSize = CGSizeMake(kBLMessagesSpaceAccessoryViewWidth, kBLMessagesSpaceAccessoryViewWidth);
            node.backgroundColor = [UIColor clearColor];

            node;
        });
        [self addSubnode:_indicatorNode];
    }
    return _indicatorNode;
}

- (ASButtonNode *)accessoryButton {
    if (!_accessoryButton) {
        _accessoryButton = ({
            ASButtonNode *buttonNode = [ASButtonNode new];
            [buttonNode setImage:[UIImage imageNamed:kBLMessagesLoadingFailedImageName] forState:ASControlStateNormal];
            [buttonNode addTarget:self action:@selector(didTapAccessoryButton:)
                 forControlEvents:ASControlNodeEventTouchUpInside];

            buttonNode;
        });

        [self addSubnode:_accessoryButton];
    }

    return _accessoryButton;
}

- (void)didTapAccessoryButton:(ASButtonNode *)button {
    [self.delegate didTapAccessoryButtonInCell:self];
}

#pragma mark - helpers
- (void)checkMessageLoadingStatus {
    if (self.messageLoadingStatus == BLMessageLoadingStatusLoading) {
        UIActivityIndicatorView *spinner = (UIActivityIndicatorView *) self.indicatorNode.view;
        [spinner startAnimating];
    }
}

#pragma mark - BLMessagesContentNodeDelegate
- (void)didTapMessagesContentNode:(BLMessagesContentNode *)contentNode performAction:(BLMessagesContentNodeAction)action {
    if (contentNode != self.contentNode) {
        return;
    }

    [self.delegate didTapContentNode:contentNode
                      inMessagesCell:self
            performContentNodeAction:action];
}

@end
