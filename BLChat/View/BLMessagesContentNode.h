//
// Created by 黄泽宇 on 1/24/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//

@class BLMessagesViewController;
@class BLMessagesContentNode;

typedef  void(^BLMessagesContentNodeAction)(BLMessagesViewController *messagesViewController);
typedef  void(^BLMessagesContentNodeConfigureBlock)(BLMessagesViewController *messagesViewController);

@protocol BLMessagesContentNodeDelegate <NSObject>
- (void)didTapMessagesContentNode:(BLMessagesContentNode *)contentNode preferredAction:(BLMessagesContentNodeAction)action;
@end

@interface BLMessagesContentNode : ASDisplayNode
/**
 * contentNode的配置block，会传入此contentNode所在的messagesViewController，contentNode的代理在这里设置，注意循环引用
 */
@property (nonatomic, readonly, copy) BLMessagesContentNodeConfigureBlock configureBlock;
@property (nonatomic, weak) id<BLMessagesContentNodeDelegate> delegate;
@end