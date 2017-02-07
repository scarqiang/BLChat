//
// Created by 黄泽宇 on 1/24/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//
#import "BLMessagesContentNode.h"
#import "BLMessage.h"

NS_ASSUME_NONNULL_BEGIN
@class BLMessagesCollectionNodeCell;

@protocol BLMessagesCollectionNodeCellDelegate <NSObject>
- (void)didTapContentNode:(BLMessagesContentNode *)contentNode
           inMessagesCell:(BLMessagesCollectionNodeCell *)cell
 performContentNodeAction:(BLMessagesContentNodeAction)action;
- (void)didTapAccessoryButtonInCell:(BLMessagesCollectionNodeCell *)cell;
@end

@interface BLMessagesCollectionNodeCell : ASCellNode
@property (nonatomic, weak) id<BLMessagesCollectionNodeCellDelegate> delegate;

@property (nonatomic, copy) NSString *senderName;
@property (nonatomic, copy) NSString *formattedTime;
@property (nonatomic, readonly) ASNetworkImageNode *avatarNode;

@property (nonatomic) BLMessagesContentNode *contentNode;
@property (nonatomic, assign) BOOL shouldDisplayName;
@property (nonatomic) BLMessageLoadingStatus messageLoadingStatus;

- (instancetype)initWithMessageDisplayType:(BLMessageDisplayType)displayType;

- (void)checkMessageLoadingStatus;
@end
NS_ASSUME_NONNULL_END
