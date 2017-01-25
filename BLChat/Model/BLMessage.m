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
    message.contentNode = [BLMessagesTextContentNode textContentNodeWithText:[message randomText]
                                                          messageDisplayType:message.messageDisplayType];
    reversed = !reversed;
    return message;
}

- (NSString *)randomText {
    NSInteger random = arc4random_uniform(6);
    switch (random) {
        case 0:
            return @"今日是三星即将发布 Galaxy Note7爆炸原因的日子，此前，蓝鲸TMT曾报道过，有知情人士透露了三星Note 7爆炸的最终原因，如若不出意外是因电池尺寸与电池仓不匹配，导致电池过热，从而引发爆炸。基本上还是将目光锁定在电池元件的配比上，而今天上午9点的发布会，会将三星爆炸谜团进一步披露。对于全球三星的粉丝或者科技爱好者来说，都是一个特别时间节点，因为这款意在对抗苹果的手机已经注定将要留名史册，并非因为突出的综合能力，而是因为这是第一款因为手机爆炸停产的手机。这也是三星历史上寿命最短的旗舰手机。";
        case 1:
            return @"基本上还是将目光锁定在电池元件的配比上，而";
        case 2:
            return @"池过热，从而";
        case 3:
            return @"this is just for test!this is just for test!this is just for test!this is just for test!this is just for test!this is just for test!this is just for test!this is just for test!this is just for test!this is just for test!this is just for test!this is just for test!this is just for test!this is just for test!this is just for test!";
        case 4:
            return @"this is just for test!t";
            
        default:
            return @"今日是三星即将发布 Galaxy Note7爆炸原因的日子，此前，蓝鲸TMT曾报道过，有知情人士透露了三星Note 7爆炸的最终原因，如若不出意外是因电池尺寸与电池仓不匹配，导致电池过热，从而引发爆炸。基本上还是将目光锁定在电池元件的配比上，而今天上午9点的发布会，会将三星爆炸谜团进一步披露。对于全球三星的粉丝或者科技爱好者来说，都是一个特别时间节点，因为这款意在对抗苹果的手机已经注定将要留名史册，并非因为突出的综合能力，而是因为这是第一款因为手机爆炸停产的手机。这也是三星历史上寿命最短的旗舰手机。今日是三星即将发布 Galaxy Note7爆炸原因的日子，此前，蓝鲸TMT曾报道过，有知情人士透露了三星Note 7爆炸的最终原因，如若不出意外是因电池尺寸与电池仓不匹配，导致电池过热，从而引发爆炸。基本上还是将目光锁定在电池元件的配比上，而今天上午9点的发布会，会将三星爆炸谜团进一步披露。对于全球三星的粉丝或者科技爱好者来说，都是一个特别时间节点，因为这款意在对抗苹果的手机已经注定将要留名史册，并非因为突出的综合能力，而是因为这是第一款因为手机爆炸停产的手机。这也是三星历史上寿命最短的旗舰手机。今日是三星即将发布 Galaxy Note7爆炸原因的日子，此前，蓝鲸TMT曾报道过，有知情人士透露了三星Note 7爆炸的最终原因，如若不出意外是因电池尺寸与电池仓不匹配，导致电池过热，从而引发爆炸。基本上还是将目光锁定在电池元件的配比上，而今天上午9点的发布会，会将三星爆炸谜团进一步披露。对于全球三星的粉丝或者科技爱好者来说，都是一个特别时间节点，因为这款意在对抗苹果的手机已经注定将要留名史册，并非因为突出的综合能力，而是因为这是第一款因为手机爆炸停产的手机。这也是三星历史上寿命最短的旗舰手机。";
    }
}
@end
