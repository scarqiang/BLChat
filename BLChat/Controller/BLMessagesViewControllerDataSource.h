//
// Created by 黄泽宇 on 1/23/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//
NS_ASSUME_NONNULL_BEGIN
@protocol BLMessageData;
@class BLMessagesViewControllerDataSource;
@protocol BLMessagesViewControllerDataSourceDelegate <NSObject>
- (void)messagesViewControllerDataSource:(BLMessagesViewControllerDataSource *)dateSource
                    didReceiveNewMessage:(id <BLMessageData>)newMessage;
- (void)messagesViewControllerDataSource:(BLMessagesViewControllerDataSource *)dateSource
           messageDidChangeLoadingStatus:(id <BLMessageData>)message;
@end

@interface BLMessagesViewControllerDataSource : NSObject
@property (weak, nonatomic) id<BLMessagesViewControllerDataSourceDelegate> delegate;
@property (nonatomic) NSMutableArray<id<BLMessageData>> *messages;
@property (nonatomic) BOOL didScrollToBottomWhenFirstLoading;

- (void)didReceiveNewMessage:(id<BLMessageData>)newMessage;

- (nullable NSIndexPath *)indexPathOfMessage:(id <BLMessageData>)message;
@end
NS_ASSUME_NONNULL_END