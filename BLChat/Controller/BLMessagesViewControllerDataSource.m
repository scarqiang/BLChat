//
// Created by 黄泽宇 on 1/23/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//

#import "BLMessagesViewControllerDataSource.h"
#import "BLMessageData.h"

@interface BLMessagesViewControllerDataSource ()

@end

@implementation BLMessagesViewControllerDataSource
- (void)didReceiveNewMessage:(id<BLMessageData>)newMessage {
    [self.messages addObject:newMessage];
    [self.delegate messagesViewControllerDataSource:self didReceiveNewMessage:newMessage];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        newMessage.messageLoadingStatus = BLMessageLoadingStatusLoadingFailed;
//        [self.delegate messagesViewControllerDataSource:self
//                          messageDidChangeLoadingStatus:newMessage];
//    });
}

- (nullable NSIndexPath *)indexPathOfMessage:(id<BLMessageData>)message {
    __block BOOL messageExist = NO;
    __block NSInteger messageIndex = 0;
    [self.messages enumerateObjectsUsingBlock:^(id<BLMessageData> item, NSUInteger index, BOOL *stop) {
        if (message == item) {
            messageIndex = index;
            messageExist = YES;
            *stop = YES;
        }
    }];
    if (!messageExist) {
        return nil;
    }

    return [NSIndexPath indexPathForItem:messageIndex inSection:0];
}

- (void)deleteMessage:(id<BLMessageData>)message {
    NSIndexPath *indexPath = [self indexPathOfMessage:message];
    [self.messages removeObjectAtIndex:(NSUInteger) indexPath.item];
    if (!indexPath) {
        return;
    }

    [self.delegate messagesViewControllerDataSource:self
                                   didDeleteMessage:message
                                        atIndexPath:indexPath];
}
@end
