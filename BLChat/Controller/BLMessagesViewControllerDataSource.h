//
// Created by 黄泽宇 on 1/23/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//
@protocol BLMessageData;
@class BLMessagesViewControllerDataSource;
@protocol BLMessagesViewControllerDataSourceDelegate <NSObject>
- (void)messagesViewControllerDataSource:(BLMessagesViewControllerDataSource *)dateSource
                    didReceiveNewMessage:(id <BLMessageData>)newMessage index:(NSInteger)index;
@end

@interface BLMessagesViewControllerDataSource : NSObject
@property (weak, nonatomic) id<BLMessagesViewControllerDataSourceDelegate> delegate;
@property (nonatomic) NSMutableArray<id<BLMessageData>> *messages;
@property (nonatomic) BOOL didScrollToBottomWhenFirstLoading;

- (void)didReceiveNewMessage:(id<BLMessageData>)newMessage;
@end
