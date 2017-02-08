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
                    performAction:(BLMessagesContentNodeAction)action;
- (void)deleteMessageActionDidHappenInContentNode:(BLMessagesContentNode *)contentNode;
@end

@interface BLMessagesContentNode : ASDisplayNode
/**
 * 复制menu item
 */
@property (nonatomic, readonly) UIMenuItem *theCopyMenuItem;
/**
 * 删除menu item
 */
@property (nonatomic, readonly) UIMenuItem *deleteMenuItem;
/**
 * 转发menu item
 */
@property (nonatomic, readonly) UIMenuItem *forwardMenuItem;
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
 * @param highlighted 是否是高亮的
 * @return UIImage
 */
- (UIImage *)resizableBubbleImageForMessageDisplayType:(BLMessageDisplayType)displayType highlighted:(BOOL)highlighted;
/**
 * content node的点击action，供子类重写，子类中必需调用父类实现
 */
- (void)didTapContentNode NS_REQUIRES_SUPER;
/**
 * 背景气泡高亮和不高亮时状态切换，子类必需实现
 */
- (void)setHighlighted:(BOOL)highlighted;
/**
 * 返回所需要的menu items, 子类可以重写，默认有"复制"，"转发"和"删除"
 * @param menuController
 * @return
 */
- (NSArray<UIMenuItem *> *)menuItemsForMenuController:(UIMenuController *)menuController;
@end
NS_ASSUME_NONNULL_END
