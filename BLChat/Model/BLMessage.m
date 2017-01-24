//
//  BLMessage.m
//  BLChat
//
//  Created by 黄泽宇 on 23/01/2017.
//  Copyright © 2017 HZQ. All rights reserved.
//

#import "BLMessage.h"
#import "BLMessagesTextContentNode.h"
static BOOL reversed = NO;
@implementation BLMessage
+ (instancetype)randomSampleMessage {
    BLMessage *message = [BLMessage new];
    message.senderName = @"黄志强";
    message.sendingTime = 1485270243;
    message.avatarImage = [UIImage imageNamed:@"demo_avatar_cook"];
    message.messageDisplayType = reversed ? BLMessageDisplayTypeLeft : BLMessageDisplayTypeRight;
    message.contentNode = [BLMessagesTextContentNode textContentNodeWithText:@"this is just for test!"
                                                          messageDisplayType:message.messageDisplayType];
    reversed = !reversed;
    return message;
}
@end
