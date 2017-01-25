//
// Created by 黄泽宇 on 1/23/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//
#import "BLMessagesContentNode.h"

#import <Foundation/Foundation.h>
@class BLMessagesCollectionNode;

@protocol BLMessagesCollectionNodeDelegate <ASCollectionDelegate>
- (void)    didTapContentNode:(BLMessagesContentNode *)contentNode
               inMessagesCell:(BLMessagesCollectionNodeCell *)cell
             inCollectionNode:(BLMessagesCollectionNode *)collectionNode
   preferredContentNodeAction:(BLMessagesContentNodeAction)action;

@end
@interface BLMessagesCollectionNode : ASCollectionNode <BLMessagesCollectionNodeCellDelegate>
@property (weak, nonatomic) id<BLMessagesCollectionNodeDelegate> delegate;

@end

