//
//  BLMessagesAudioContentNode.m
//  BLChat
//
//  Created by 黄泽宇 on 2/6/17.
//  Copyright © 2017 HZQ. All rights reserved.
//

#import "BLMessagesAudioContentNode.h"
@interface BLMessagesAudioContentNode ()
@property (nonatomic) ASImageNode *videoIconImageNode;
@property (nonatomic) ASTextNode *videoLengthTextNode;
@end
@implementation BLMessagesAudioContentNode
- (instancetype)initWithTimeLength:(NSTimeInterval)length {
    self = [super init];
    if (self) {
        _videoIconImageNode = ({
            ASImageNode *imageNode = [[ASImageNode alloc] init];
            imageNode.image = [UIImage imageNamed:@"audio_n"];
            imageNode;
        });

        _videoLengthTextNode = ({
            ASTextNode *textNode = [[ASTextNode alloc] init];

            textNode;
        });
    }

    return self;
}

- (nullable NSString *)timeLabelWithTime:(NSTimeInterval)time {
    if (time < 0) {
        return nil;
    } else if (time < 60) {
        return [NSString stringWithFormat:@"%ld\"", (long) time];
    } else {
        return [NSString stringWithFormat:@"%ld:%ld\"", (long) (time / 60.f), (long) ((NSInteger)(time) % 60)];
    }
}

@end
