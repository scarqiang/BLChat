//
// Created by 黄泽宇 on 1/23/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//

#import "BLMessagesCollectionNode.h"


@interface BLMessagesCollectionNode () <BLMessagesCollectionNodeCellDelegate>
@end

@implementation BLMessagesCollectionNode
@dynamic delegate;
@dynamic dataSource;

- (instancetype)init {
    self = [super init];
    if (self) {

    }

    return self;
}

#pragma mark - BLMessagesCollectionNodeCellDelegate
- (void)didTapContentNode:(BLMessagesContentNode *)contentNode inMessagesCell:(BLMessagesCollectionNodeCell *)cell  preferredContentNodeAction:(BLMessagesContentNodeAction)action {
    [self.delegate didTapContentNode:contentNode
                      inMessagesCell:cell
                    inCollectionNode:self
          preferredContentNodeAction:action];
}
@end
