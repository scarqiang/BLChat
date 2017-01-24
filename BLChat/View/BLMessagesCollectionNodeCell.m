//
// Created by 黄泽宇 on 1/24/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//

#import "BLMessagesCollectionNodeCell.h"
#import "BLMessagesConstant.h"


@interface BLMessagesCollectionNodeCell ()
@property (nonatomic) ASNetworkImageNode *avatarNode;
@property (nonatomic) ASTextNode *senderNameTextNode;
@property (nonatomic) ASTextNode *messageTextNode;
@property (nonatomic) ASTextNode *timeSeparatorTextNode;
@property (nonatomic) ASButtonNode *accessoryButton;
@property (nonatomic) UIActivityIndicatorView *indicatorView;
@property (nonatomic) ASDisplayNode *indicatorNode;
@end

@implementation BLMessagesCollectionNodeCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureSubnodes];
        [self addSubnodes];
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

        textNode;
    });

}

- (void)addSubnodes {
    [self addSubnode:_avatarNode];
}

- (void)stopIndicatorAnimating {
    [self.indicatorView stopAnimating];
    [self.indicatorNode removeFromSupernode];
}

- (void)startIndicatorAnimating {
    [self.indicatorView startAnimating];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    NSAssert(NO, @"layout must be done in subclass");
    return nil;
}
@end