//
//  BLMessageInputToolBarNode.h
//  BLChat
//
//  Created by HZQ on 17/1/24.
//  Copyright © 2017年 HZQ. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class BLMessageInputToolBarNode;

extern CGFloat const BLInputToolBarNodeHeight;
extern CGFloat const BLInputTextNodeHeight;;

typedef NS_ENUM(NSUInteger, BLInuptToolBarState) {
    BLInuptToolBarStateNone,
    BLInuptToolBarStateVoice,
    BLInuptToolBarStateExpression,
    BLInuptToolBarStateAddition,
    BLInuptToolBarStateKeyboard
};


@protocol BLMessageInputToolBarNodeDelegate <NSObject>

- (void)inputToolBarNode:(BLMessageInputToolBarNode *)inputToolBarNode
 didClickVoiceButtonNode:(ASButtonNode *)voiceButtonNode
            currentState:(BLInuptToolBarState)currentState
             targetState:(BLInuptToolBarState)targetState;

- (void)    inputToolBarNode:(BLMessageInputToolBarNode *)inputToolBarNode
didClickExpressionButtonNode:(ASButtonNode *)expressionButtonNode
                currentState:(BLInuptToolBarState)currentState
                 targetState:(BLInuptToolBarState)targetState;

- (void)    inputToolBarNode:(BLMessageInputToolBarNode *)inputToolBarNode
didClickAdditionalButtonNode:(ASButtonNode *)additionalButtonNode
                currentState:(BLInuptToolBarState)currentState
                 targetState:(BLInuptToolBarState)targetState;

- (void)inputToolBarTextNodeDidBeginEditing:(ASEditableTextNode *)editableTextNode
                               currentState:(BLInuptToolBarState)currentState
                                targetState:(BLInuptToolBarState)targetState;

@end

@interface BLMessageInputToolBarNode : ASDisplayNode
@property (nonatomic, readonly) BLInuptToolBarState inputToolBarState;
@property (nonatomic, strong, readonly) ASEditableTextNode *inputTextNode;

- (instancetype)initWithDelegate:(id<BLMessageInputToolBarNodeDelegate>)delegate;
@end
