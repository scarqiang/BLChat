//
// Created by 黄泽宇 on 1/23/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//

@protocol BLChatViewControllerDataSourceDelegate <NSObject>

@end

@interface BLChatViewControllerDataSource : NSObject
@property (weak, nonatomic) id<BLChatViewControllerDataSourceDelegate> delegate;

@end