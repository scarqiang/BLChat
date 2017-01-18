//
//  BLChatMessageModel.h
//  BLChat
//
//  Created by 黄泽宇 on 1/18/17.
//  Copyright © 2017 HZQ. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, BLChatMessageType) {
    BLChatMessageTypeText = 0,
    BLChatMessageTypeImage,
    BLChatMessageTypeVoice,
    BLChatMessageTypeLocation
};

@interface BLChatMessageModel : NSObject

@end
