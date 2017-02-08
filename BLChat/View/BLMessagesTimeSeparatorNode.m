//
// Created by 黄泽宇 on 1/24/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//
#import "BLMessagesConstant.h"
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
            NSForegroundColorAttributeName:[UIColor colorWithRed:180.f / 255.f green:181.f / 255.f blue:182.f / 255.f alpha:1.f],
            NSParagraphStyleAttributeName: paragraphStyle
    };

    self.timeSeparatorTextNode.attributedText = [[NSAttributedString alloc] initWithString:formattedTime
                                                                          attributes:attributes];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    self.timeSeparatorTextNode.style.spacingBefore = kBLMessagesTimeLabelTopMargin;
    self.timeSeparatorTextNode.style.spacingAfter = kBLMessagesTimeLabelBottomMargin;

    return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                   spacing:0
                                            justifyContent:ASStackLayoutJustifyContentCenter
                                                alignItems:ASStackLayoutAlignItemsCenter
                                                  children:@[self.timeSeparatorTextNode]];
}

@end