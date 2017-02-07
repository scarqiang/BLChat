//
// Created by 黄泽宇 on 1/23/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//
#import "BLMessagesContentNode.h"
#import "BLMessagesCollectionNodeCell.h"
@class BLMessagesCollectionNode;
@protocol BLMessageData;
NS_ASSUME_NONNULL_BEGIN
@protocol BLMessagesCollectionNodeDelegate <ASCollectionDelegate>
- (void)didTapContentNode:(BLMessagesContentNode *)contentNode
           inMessagesCell:(BLMessagesCollectionNodeCell *)cell
         inCollectionNode:(BLMessagesCollectionNode *)collectionNode
 performContentNodeAction:(BLMessagesContentNodeAction)action;

- (void)didTapAccessoryButtonInCell:(BLMessagesCollectionNodeCell *)cell collectionNode:(BLMessagesCollectionNode *)collectionNode;
@end

@protocol BLMessagesCollectionNodeDataSource <ASCollectionDataSource>
- (id<BLMessageData>)messageDataForCollectionNode:(BLMessagesCollectionNode *)collectionNode
                                      atIndexPath:(NSIndexPath *)indexPath;
- (nullable NSString *)formattedTimeForCollectionNode:(BLMessagesCollectionNode *)collectionNode
                                          atIndexPath:(NSIndexPath *)indexPath;
@end

@interface BLMessagesCollectionNode : ASCollectionNode <BLMessagesCollectionNodeCellDelegate>
@property (weak, nonatomic) id<BLMessagesCollectionNodeDelegate> delegate;
@property (weak, nonatomic) id<BLMessagesCollectionNodeDataSource> dataSource;
@end

NS_ASSUME_NONNULL_END
