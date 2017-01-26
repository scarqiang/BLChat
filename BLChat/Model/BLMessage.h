//
//  BLMessage.h
//  BLChat
//
//  Created by 黄泽宇 on 23/01/2017.
//  Copyright © 2017 HZQ. All rights reserved.
//

#import "BLMessageData.h"
@class BLMessagesContentNode;

@interface BLMessage : NSObject <BLMessageData>
@property (nonatomic, copy) NSString *senderName;
@property (nonatomic) NSTimeInterval sendingTime;
@property (nonatomic) UIImage *avatarImage;
@property (nonatomic) BLMessagesContentNode *contentNode;
@property (nonatomic) BLMessageDisplayType messageDisplayType;

+ (instancetype)randomSampleMessage;
@end
