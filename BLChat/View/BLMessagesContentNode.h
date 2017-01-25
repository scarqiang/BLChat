//
// Created by 黄泽宇 on 1/24/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//
#import "BLMessage.h"
#import "BLMessagesConstant.h"
#import "BLMessagesViewController.h"
#import "BLMessagesCollectionNode.h"
#import "BLMessagesCollectionNodeCell.h"
NS_ASSUME_NONNULL_BEGIN

@class BLMessagesContentNode;

typedef void(^BLMessagesContentNodeAction)(BLMessagesViewController *messagesViewController, BLMessagesCollectionNode *collectionNode, BLMessagesCollectionNodeCell *collectionNodeCell);

@protocol BLMessagesContentNodeDelegate <NSObject>
- (void)didTapMessagesContentNode:(BLMessagesContentNode *)contentNode preferredAction:(BLMessagesContentNodeAction)action;
@end

@interface BLMessagesContentNode : ASDisplayNode
/**
 * 代理
 */
@property (nonatomic, weak) id<BLMessagesContentNodeDelegate> delegate;

/**
 * content node偏好布局
 * @return
 */
- (ASLayoutSpec *)preferredLayoutSpec;
/**
 * cell布局时调用，content node可在此方法内约束自己或subnode的大小，子类需要重写
 * @param constrainedSize
 */
- (void)addConstrainWithCollectionNodeCellConstrainedSize:(ASSizeRange)constrainedSize;

/**
 * 获取响应消息展示类型的气泡图片
 * @param displayType
 * @return
 */
- (nullable UIImage *)resizableBubbleImageForMessageDisplayType:(BLMessageDisplayType)displayType;
@end
NS_ASSUME_NONNULL_END
