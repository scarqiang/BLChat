//
// Created by 黄泽宇 on 1/24/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//

#import "BLMessagesContentNode.h"

@interface BLMessagesContentNode ()

@end

@implementation BLMessagesContentNode

- (void)didLoad {
    [super didLoad];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapContentNode)];
    [self.view addGestureRecognizer:tapGR];
}

- (void)didTapContentNode {
    
}

- (UIImage *)resizableBubbleImageForMessageDisplayType:(BLMessageDisplayType)displayType {
    switch (displayType) {
        case BLMessageDisplayTypeLeft: {
            UIEdgeInsets capInsets = UIEdgeInsetsMake(
                    kBLMessagesIncomingBubbleCapTop,
                    kBLMessagesIncomingBubbleCapLeft,
                    kBLMessagesIncomingBubbleCapBottom,
                    kBLMessagesIncomingBubbleCapRight);
            UIImage *image = [[UIImage imageNamed:kBLMessagesIncomingBubbleImageName] resizableImageWithCapInsets:capInsets
                                                                                   resizingMode:UIImageResizingModeStretch];
            return image;
        }

        case BLMessageDisplayTypeCenter: {
            return nil;
        }

        case BLMessageDisplayTypeRight: {
            UIEdgeInsets capInsets = UIEdgeInsetsMake(
                    kBLMessagesIncomingBubbleCapTop,
                    kBLMessagesIncomingBubbleCapRight,
                    kBLMessagesIncomingBubbleCapBottom,
                    kBLMessagesIncomingBubbleCapLeft);

            return [[UIImage imageNamed:kBLMessagesOutgoingBubbleImageName] resizableImageWithCapInsets:capInsets
                                                                                           resizingMode:UIImageResizingModeStretch];
        }
    }

    NSAssert(NO, @"unexpected message display type");
    return nil;
}

- (ASLayoutSpec *)preferredLayoutSpec {
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) child:self];
}

- (void)addConstrainWithCollectionNodeCellConstrainedSize:(ASSizeRange)constrainedSize {

}
@end
