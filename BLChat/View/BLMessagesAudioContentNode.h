//
//  BLMessagesAudioContentNode.h
//  BLChat
//
//  Created by 黄泽宇 on 2/6/17.
//  Copyright © 2017 HZQ. All rights reserved.
//


#import "BLMessagesContentNode.h"

@interface BLMessagesAudioContentNode : BLMessagesContentNode

- (instancetype)initWithTimeLength:(NSTimeInterval)length messageDisplayType:(BLMessageDisplayType)displayType;
+ (instancetype)audioContentNodeWithTimeLength:(NSTimeInterval)length messageDisplayType:(BLMessageDisplayType)displayType;
@end
