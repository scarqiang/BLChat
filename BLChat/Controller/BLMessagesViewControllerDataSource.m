//
// Created by 黄泽宇 on 1/23/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//

#import "BLMessagesViewControllerDataSource.h"
#import "NSArray+YYAdd.h"

@interface BLMessagesViewControllerDataSource ()

@end

@implementation BLMessagesViewControllerDataSource
- (void)didReceiveNewMessage:(id<BLMessageData>)newMessage {
    [self.messages appendObject:newMessage];
    [self.delegate messagesViewControllerDataSource:self
                               didReceiveNewMessage:newMessage index:self.messages.count - 1];
}
@end