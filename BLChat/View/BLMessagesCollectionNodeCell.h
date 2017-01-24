//
// Created by 黄泽宇 on 1/24/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//

@protocol BLMessagesCollectionNodeCellDelegate <NSObject>

@end

@interface BLMessagesCollectionNodeCell : ASCellNode
@property (weak, nonatomic) id<BLMessagesCollectionNodeCellDelegate> delegate;

- (void)stopIndicatorAnimating;
@end