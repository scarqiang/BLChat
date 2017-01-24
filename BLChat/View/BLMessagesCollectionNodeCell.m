//
// Created by 黄泽宇 on 1/24/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//

#import "BLMessagesCollectionNodeCell.h"
#import "BLMessagesConstant.h"


@interface BLMessagesCollectionNodeCell ()
@property (nonatomic, assign) BLMessageDisplayType messageDisplayType;

@property (nonatomic) ASNetworkImageNode *avatarNode;
@property (nonatomic) ASTextNode *senderNameTextNode;
@property (nonatomic) ASTextNode *timeSeparatorTextNode;
@property (nonatomic) ASButtonNode *accessoryButton;
@property (nonatomic) UIActivityIndicatorView *indicatorView;
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
        [self addSubnode:_accessoryButton];
        [self addSubnode:_indicatorNode];
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
        ASTextNode *textNode = [[ASTextNode alloc] init];
        textNode.maximumNumberOfLines = 1;

        textNode;
    });

    _indicatorNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        return _indicatorView;
    }];

    _accessoryButton = ({
        ASButtonNode *buttonNode = [ASButtonNode new];

        buttonNode;
    });

}


- (void)stopIndicatorAnimating {
    [self.indicatorView stopAnimating];
    [self.indicatorNode removeFromSupernode];
}

- (void)startIndicatorAnimating {
    [self.indicatorView startAnimating];
}

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
            return [self layoutSpecThatFits:constrainedSize isSender:NO];
        case BLMessageDisplayTypeRight:
            return [self layoutSpecThatFits:constrainedSize isSender:YES];
    }
    NSAssert(NO, @"unexpected message display type");
    return nil;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize isSender:(BOOL)isSender {
    ASLayoutSpec *contentLayoutSpec = !self.shouldDisplayName ? [self.contentNode preferredLayoutSpec] :
            [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                    spacing:0
                                             justifyContent:ASStackLayoutJustifyContentStart
                                                 alignItems:ASStackLayoutAlignItemsStart
                                                   children:@[self.senderNameTextNode, [self.contentNode preferredLayoutSpec]]];
    NSArray *contentArray = isSender ? @[ contentLayoutSpec, self.avatarNode ] : @[ self.avatarNode, contentLayoutSpec ];
    ASStackLayoutJustifyContent contentJustifyContent = isSender ? ASStackLayoutJustifyContentEnd : ASStackLayoutJustifyContentStart;
    ASStackLayoutAlignItems contentAlignItems = isSender ? ASStackLayoutAlignItemsEnd : ASStackLayoutAlignItemsStart;

    ASStackLayoutSpec *avatarAndContentLayoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                       spacing:0
                                                                                justifyContent:contentJustifyContent
                                                                                    alignItems:contentAlignItems
                                                                                      children:contentArray];
    NSArray *timestampAndMainContentArray = self.formattedTime ? @[self.timeSeparatorTextNode, avatarAndContentLayoutSpec] :
            @[avatarAndContentLayoutSpec];
    ASStackLayoutJustifyContent timestampAndMainContentJustifyContent = ASStackLayoutJustifyContentStart;
    avatarAndContentLayoutSpec.style.alignSelf = isSender ? ASStackLayoutAlignSelfEnd : ASStackLayoutAlignSelfStart;
    
    ASStackLayoutSpec *timestampAndMainContentLayoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                                   spacing:0
                                                                                            justifyContent:timestampAndMainContentJustifyContent
                                                                                                alignItems:ASStackLayoutAlignItemsStretch
                                                                                                  children:timestampAndMainContentArray];

    return timestampAndMainContentLayoutSpec;
}

#pragma mark - setters
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
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:12.f],
            NSForegroundColorAttributeName:[UIColor colorWithRed:53.f / 255.f green:53.f / 255.f blue:53.f / 255.f alpha:1.f],
            NSParagraphStyleAttributeName: paragraphStyle
    };

    self.timeSeparatorTextNode.attributedText = [[NSAttributedString alloc] initWithString:formattedTime
                                                                          attributes:attributes];
}

- (void)setContentNode:(BLMessagesContentNode *)contentNode {
    _contentNode = contentNode;
    [self addSubnode:contentNode];
}
@end
