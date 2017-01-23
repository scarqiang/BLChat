//
// Created by 黄泽宇 on 1/23/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol BLChatCollectionNodeDelegate <ASCollectionDelegate>

@end
@interface BLChatCollectionNode : ASCollectionNode
@property (weak, nonatomic) id <BLChatCollectionNodeDelegate> delegate;

@end

