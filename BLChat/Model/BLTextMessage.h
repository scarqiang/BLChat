//
// Created by 黄泽宇 on 2/7/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//

#import "BLMessageData.h"

@interface BLTextMessage : NSObject <BLMessageData>
@property (nonatomic, copy) NSString *senderName;
@property (nonatomic) NSTimeInterval sendingTime;
@property (nonatomic) UIImage *avatarImage;
@property (nonatomic) BLMessagesContentNode *contentNode;
@property (nonatomic) BLMessageDisplayType messageDisplayType;
@property (nonatomic) BLMessageLoadingStatus messageLoadingStatus;
+ (instancetype)textMessageWithText:(NSString *)text messageDisplayType:(BLMessageDisplayType)displayType;
@end