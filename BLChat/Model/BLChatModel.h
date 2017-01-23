//
//  BLChatModel.h
//  BLChat
//
//  Created by 黄泽宇 on 1/18/17.
//  Copyright © 2017 HZQ. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, BLChatMessageType) {
    /**
     * 文字消息类型
     */
    BLChatMessageTypeText = 0,
    /**
     * 图片消息类型
     */
    BLChatMessageTypeImage,
    /**
     * 语音消息类型
     */
    BLChatMessageTypeVoice,
    /**
     * 位置消息类型
     */
    BLChatMessageTypeLocation,
    /**
     * 视频消息类型
     */
    BLChatMessageTypeVedio
};

@interface BLChatModel : NSObject

@end
