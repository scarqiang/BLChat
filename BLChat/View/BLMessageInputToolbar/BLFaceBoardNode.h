//
//  BLFaceBoardNode.h
//  BLChat
//
//  Created by HZQ on 17/2/6.
//  Copyright © 2017年 HZQ. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "FaceBoard.h"

@class BLFaceBoardNode;

@protocol BLFaceBoardNodeDelegate <NSObject>
- (void)faceBoardNode:(BLFaceBoardNode *)faceBoardNode
   didClickSendButton:(ASButtonNode *)buttonNode
                 text:(NSString *)text;


- (void)faceBoardDidSelectEmojiAction:(BLFaceBoardNode *)faceBoardNode
                          boardHeight:(CGFloat)boardHeight;

@end

@interface BLFaceBoardNode : ASDisplayNode

- (instancetype)initWithDelegate:(id <BLFaceBoardNodeDelegate>)delegate textViewNode:(ASEditableTextNode *)textViewNode;
@end
