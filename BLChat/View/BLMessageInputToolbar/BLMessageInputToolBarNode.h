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

typedef NS_ENUM(NSUInteger, BLInputToolBarState) {
    BLInputToolBarStateNone,
    BLInputToolBarStateVoice,
    BLInputToolBarStateExpression,
    BLInputToolBarStateAddition,
    BLInputToolBarStateKeyboard
};


@protocol BLMessageInputToolBarNodeDelegate <NSObject>

- (void)inputToolBarNode:(BLMessageInputToolBarNode *)inputToolBarNode
 didClickVoiceButtonNode:(ASButtonNode *)voiceButtonNode
            currentState:(BLInputToolBarState)currentState
             targetState:(BLInputToolBarState)targetState;

- (void)    inputToolBarNode:(BLMessageInputToolBarNode *)inputToolBarNode
didClickExpressionButtonNode:(ASButtonNode *)expressionButtonNode
                currentState:(BLInputToolBarState)currentState
                 targetState:(BLInputToolBarState)targetState;

- (void)    inputToolBarNode:(BLMessageInputToolBarNode *)inputToolBarNode
didClickAdditionalButtonNode:(ASButtonNode *)additionalButtonNode
                currentState:(BLInputToolBarState)currentState
                 targetState:(BLInputToolBarState)targetState;

- (void)inputToolBarTextNodeDidBeginEditing:(ASEditableTextNode *)editableTextNode
                               currentState:(BLInputToolBarState)currentState
                                targetState:(BLInputToolBarState)targetState;


@end

@interface BLMessageInputToolBarNode : ASDisplayNode
@property (nonatomic, readonly) BLInputToolBarState inputToolBarState;
@property (nonatomic, strong, readonly) ASEditableTextNode *inputTextNode;
@property (nonatomic) CGRect inputToolBarNormalFrame;
@property (nonatomic) CGRect inputToolBarRiseFrame;

- (instancetype)initWithDelegate:(id<BLMessageInputToolBarNodeDelegate>)delegate;
@end
