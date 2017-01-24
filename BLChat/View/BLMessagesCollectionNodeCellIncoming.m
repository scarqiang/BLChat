//
//  BLMessagesCollectionNodeCellIncoming.m
//  BLChat
//
//  Created by 黄泽宇 on 23/01/2017.
//  Copyright © 2017 HZQ. All rights reserved.
//

#import "BLMessagesCollectionNodeCellIncoming.h"

@implementation BLMessagesCollectionNodeCellIncoming

- (void)addSubnodes {
    [self addSubnode:self.avatarNode];
    [self addSubnode:self.senderNameTextNode];
    [self addSubnode:self.timeSeparatorTextNode];
    [self addSubnode:self.textMessageNode];
    [self addSubnode:self.indicatorNode];
}

#pragma mark - layout
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASStackLayoutSpec *contentLayoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                       spacing:0
                                                                                justifyContent:ASStackLayoutJustifyContentStart
                                                                                    alignItems:ASStackLayoutAlignItemsStart
                                                                                      children:@[self.avatarNode, self.textMessageNode]];
    contentLayoutSpec.style.alignSelf = ASStackLayoutAlignSelfStart;


    return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                   spacing:0
                                            justifyContent:ASStackLayoutJustifyContentStart
                                                alignItems:ASStackLayoutAlignItemsStretch
                                                  children:@[self.timeSeparatorTextNode, contentLayoutSpec]];;
}
@end
