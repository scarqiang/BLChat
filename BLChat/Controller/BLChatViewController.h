//
//  BLChatViewController.h
//  BLChat
//
//  Created by 黄泽宇 on 1/23/17.
//  Copyright © 2017 HZQ. All rights reserved.
//

@class BLChatViewControllerDataSource;

@interface BLChatViewController : ASViewController
- (instancetype)initWithDataSource:(BLChatViewControllerDataSource *)dataSource;

+ (instancetype)controllerWithDataSource:(BLChatViewControllerDataSource *)dataSource;


@end
