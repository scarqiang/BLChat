//
//  BLMessage.h
//  BLChat
//
//  Created by 黄泽宇 on 23/01/2017.
//  Copyright © 2017 HZQ. All rights reserved.
//

#import "BLMessageData.h"
#import "BLMessagesContentNode.h"

typedef NS_ENUM(NSUInteger, BLMessageDisplayType) {
    /*
     * 居左展示的消息，如接收到的聊天消息
     */
    BLMessageDisplayTypeLeft = 0,
    /*
     * 居中展示的消息，如公众号推送的文章消息，此种情况只展示消息主题内容，不展示头像、消息发送者名字等
     */
    BLMessageDisplayTypeCenter,
    /*
     * 居右展示的消息，如发送的聊天消息
     */
    BLMessageDisplayTypeRight,
};

@interface BLMessage : NSObject <BLMessageData>
@property (nonatomic) BLMessagesContentNode *contentNode;
@end
