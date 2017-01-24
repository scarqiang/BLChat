//
// Created by 黄泽宇 on 1/24/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//

#import "BLMessagesContentNode.h"

@interface BLMessagesContentNode ()
@property (nonatomic, copy) BLMessagesContentNodeConfigureBlock configureBlock;

@end

@implementation BLMessagesContentNode
- (UIImage *)resizableBubbleImageForMessageDisplayType:(BLMessageDisplayType) displayType {
    switch (displayType) {
        case BLMessageDisplayTypeLeft: {
            UIEdgeInsets capInsets = UIEdgeInsetsMake(kBLMessagesIncomingBubbleCapTop, kBLMessagesIncomingBubbleCapLeft, kBLMessagesIncomingBubbleCapBottom, kBLMessagesIncomingBubbleCapRight);
            UIImage *image = [[UIImage imageNamed:@"receive_MsgBg"] resizableImageWithCapInsets:capInsets
                                                                                   resizingMode:UIImageResizingModeStretch];
            return image;
        }

        case BLMessageDisplayTypeCenter: {
            return nil;
        }

        case BLMessageDisplayTypeRight: {
            UIEdgeInsets capInsets = UIEdgeInsetsMake(kBLMessagesOutgoingBubbleCapTop,
                    kBLMessagesOutgoingBubbleCapLeft,
                    kBLMessagesOutgoingBubbleCapBottom,
                    kBLMessagesOutgoingBubbleCapRight);
            UIImage *image = [UIImage imageNamed:@"receive_MsgBg"];
            UIImage* flippedImage = [UIImage imageWithCGImage:image.CGImage
                                                        scale:image.scale
                                                  orientation:UIImageOrientationUpMirrored];

            return [flippedImage resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
        }
    }

    NSAssert(NO, @"unexpected message display type");
    return nil;
}

- (ASLayoutSpec *)preferredLayoutSpec {
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) child:self];
}
@end