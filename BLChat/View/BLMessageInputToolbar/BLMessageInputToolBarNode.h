//
//  BLMessageInputToolBarNode.h
//  BLChat
//
//  Created by HZQ on 17/1/24.
//  Copyright © 2017年 HZQ. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class BLMessageInputToolBarNode;

extern CGFloat const BLInputTextNodeHeight;;

typedef NS_ENUM(NSUInteger, BLInputToolBarState) {
    BLInputToolBarStateNone,
    BLInputToolBarStateVoice,
    BLInputToolBarStateExpression,
    BLInputToolBarStateAddition,
    BLInputToolBarStateKeyboard
};


@protocol BLMessageInputToolBarNodeDelegate <NSObject>

@optional

- (void)inputToolBarNode:(BLMessageInputToolBarNode *)inputToolBarNode
 didClickVoiceButtonNode:(ASButtonNode *)voiceButtonNode
           previousState:(BLInputToolBarState)previousState
            currentState:(BLInputToolBarState)currentState;

- (void)    inputToolBarNode:(BLMessageInputToolBarNode *)inputToolBarNode
didClickExpressionButtonNode:(ASButtonNode *)expressionButtonNode
               previousState:(BLInputToolBarState)previousState
                currentState:(BLInputToolBarState)currentState;

- (void)    inputToolBarNode:(BLMessageInputToolBarNode *)inputToolBarNode
didClickAdditionalButtonNode:(ASButtonNode *)additionalButtonNode
               previousState:(BLInputToolBarState)previousState
                currentState:(BLInputToolBarState)currentState;

- (void)inputToolBarTextNodeDidBeginEditing:(ASEditableTextNode *)editableTextNode
                              previousState:(BLInputToolBarState)previousState
                               currentState:(BLInputToolBarState)currentState;

- (void)     inputToolBarNode:(BLMessageInputToolBarNode *)inputToolBarNode
pressingSoundRecordButtonNode:(ASButtonNode *)recordButtonNode;

- (void)      inputToolBarNode:(BLMessageInputToolBarNode *)inputToolBarNode
didLoosenSoundRecordButtonNode:(ASButtonNode *)recordButtonNode;

- (void) inputToolBarNode:(BLMessageInputToolBarNode *)inputToolBarNode
layoutTransitionWithBarFrame:(CGRect)barFrame
                 duration:(NSTimeInterval)duration;

- (void)    inputToolBarNode:(BLMessageInputToolBarNode *)inputToolBarNode
didClickSendButtonActionWithText:(NSString *)inputText;

- (void)           inputToolBarNode:(BLMessageInputToolBarNode *)inputToolBarNode
resignFirstResponderWithResignState:(BLInputToolBarState)resignState;

@end

@interface BLMessageInputToolBarNode : ASDisplayNode
@property (nonatomic, readonly) BLInputToolBarState inputToolBarCurrentState;
@property (nonatomic, readonly) BLInputToolBarState inputToolBarPreviousState;
@property (nonatomic, strong, readonly) ASEditableTextNode *inputTextNode;
@property (nonatomic) CGRect inputToolBarNormalFrame;
@property (nonatomic) CGRect inputToolBarRiseFrame;

- (instancetype)initWithDelegate:(id<BLMessageInputToolBarNodeDelegate>)delegate;

- (void)resignInputToolBarFirstResponder;

- (void)triggerInputToolBarDidSendAction;

@end
