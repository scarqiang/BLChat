//
// Created by 黄泽宇 on 1/24/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//

#import "BLMessagesTimeSeparatorNode.h"
@interface BLMessagesTimeSeparatorNode ()
@property (nonatomic) ASTextNode *timeSeparatorTextNode;
@end

@implementation BLMessagesTimeSeparatorNode
- (instancetype)init {
    self = [super init];
    if (self) {
        _timeSeparatorTextNode = [[ASTextNode alloc] init];
        [self addSubnode:_timeSeparatorTextNode];
    }

    return self;
}

- (void)setFormattedTime:(NSString *)formattedTime {
    if (!formattedTime) {
        return;
    }

    _formattedTime = formattedTime;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:12.f],
            NSForegroundColorAttributeName:[UIColor colorWithRed:53.f / 255.f green:53.f / 255.f blue:53.f / 255.f alpha:1.f],
            NSParagraphStyleAttributeName: paragraphStyle
    };

    self.timeSeparatorTextNode.attributedText = [[NSAttributedString alloc] initWithString:formattedTime
                                                                          attributes:attributes];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY
                                                      sizingOptions:ASCenterLayoutSpecSizingOptionDefault
                                                              child:self.timeSeparatorTextNode];
}

@end