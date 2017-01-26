//
// Created by 黄泽宇 on 1/24/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//
#import "BLMessage.h"
#import "BLMessagesConstant.h"
NS_ASSUME_NONNULL_BEGIN

@class BLMessagesContentNode;
@class BLMessagesViewController;
@class BLMessagesCollectionNode;
@class BLMessagesCollectionNodeCell;

typedef void(^BLMessagesContentNodeAction)(BLMessagesViewController *messagesViewController, BLMessagesCollectionNode *collectionNode, BLMessagesCollectionNodeCell *collectionNodeCell);

@protocol BLMessagesContentNodeDelegate <NSObject>
- (void)didTapMessagesContentNode:(BLMessagesContentNode *)contentNode
                  preferredAction:(BLMessagesContentNodeAction)action;
@end

@interface BLMessagesContentNode : ASDisplayNode
/**
 * 代理
 */
@property (nonatomic, weak) id<BLMessagesContentNodeDelegate> delegate;

/**
 * content node偏好布局
 * @return ASLayoutSpec
 */
- (ASLayoutSpec *)preferredLayoutSpec;
/**
 * cell布局时调用，content node可在此方法内约束自己或subnode的大小，子类需要重写
 * @param constrainedSize 约束尺寸
 */
- (void)addConstrainWithCollectionNodeCellConstrainedSize:(ASSizeRange)constrainedSize;

/**
 * 获取响应消息展示类型的气泡图片
 * @param displayType 需要展示消息的类型
 * @return UIImage
 */
- (nullable UIImage *)resizableBubbleImageForMessageDisplayType:(BLMessageDisplayType)displayType;
/**
 * content node的点击action，供子类重写，默认没有任何实现
 */
- (void)didTapContentNode;
@end
NS_ASSUME_NONNULL_END
