//
//  BLMessageInputToolBarNode.m
//  BLChat
//
//  Created by HZQ on 17/1/24.
//  Copyright © 2017年 HZQ. All rights reserved.
//

#import "BLMessageInputToolBarNode.h"

CGFloat const BLInputToolBarNodeHeight = 50.f;
CGFloat const BLInputTextNodeHeight = 34.f;
CGFloat const BLInputTextNodeFontSize = 15.f;
CGFloat const BLInputItemSpecWidth = 10.f;

@interface BLMessageInputToolBarNode ()<ASEditableTextNodeDelegate>
@property (nonatomic, strong) ASEditableTextNode *inputTextNode;
@property (nonatomic, strong) ASButtonNode *voiceButtonNode;
@property (nonatomic, strong) ASButtonNode *expressionButtonNode;
@property (nonatomic, strong) ASButtonNode *additionalButtonNode;
@property (nonatomic, strong) ASDisplayNode *lineNode;
@property (nonatomic, weak) id<BLMessageInputToolBarNodeDelegate> delegate;
@property (nonatomic, readwrite) BLInuptToolBarState inputToolBarState;
@end

@implementation BLMessageInputToolBarNode
- (instancetype)initWithDelegate:(id<BLMessageInputToolBarNodeDelegate>)delegate {
    self = [super init];
    
    if (self) {
        _delegate = delegate;
        [self setupSubNode];
    }
    return self;
}

- (void)setupSubNode {
    
    self.backgroundColor = [UIColor colorWithRed:239.f/255.f green:240.f/255.f blue:242.f/255.f alpha:1];
    
    _voiceButtonNode = ({
        ASButtonNode *buttonNode = [ASButtonNode new];
        [buttonNode addTarget:self action:@selector(didClickVoiceButtonNode:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self setupVoiceButtonNodeImage:buttonNode];
        [self addSubnode:buttonNode];
        buttonNode;
    });
    
    _expressionButtonNode = ({
        ASButtonNode *buttonNode = [ASButtonNode new];
        [buttonNode addTarget:self action:@selector(didClickExpressionButtonNode:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self setupExpressionButtonNodeImage:buttonNode];
        [self addSubnode:buttonNode];
        buttonNode;
    });
    
    _additionalButtonNode = ({
        ASButtonNode *buttonNode = [ASButtonNode new];
        [self setupAdditionalButtonNodeImage:buttonNode];
        [buttonNode addTarget:self action:@selector(didClickAdditionalButtonNode:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self addSubnode:buttonNode];
        buttonNode;
    });
    
    _inputTextNode = ({
        ASEditableTextNode *textNode = [ASEditableTextNode new];
        textNode.delegate = self;
        textNode.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        textNode.layer.borderColor = [UIColor colorWithRed:203.f/255.f green:203.f/255.f blue:203.f/255.f alpha:1].CGColor;
        textNode.layer.cornerRadius = 4.f;
        textNode.clipsToBounds = YES;
        textNode.style.flexGrow = 1.f;
        textNode.style.flexShrink = 1.f;
        textNode.style.preferredSize = CGSizeMake(100.f, BLInputTextNodeHeight);
        textNode.textView.font = [UIFont systemFontOfSize:BLInputTextNodeFontSize];
        textNode.textContainerInset = UIEdgeInsetsMake(8, 5, 8, 5);
        [self addSubnode:textNode];
        textNode;
    });
    
    _lineNode = ({
        ASDisplayNode *node = [ASDisplayNode new];
        node.backgroundColor = [UIColor colorWithRed:203.f/255.f green:203.f/255.f blue:203.f/255.f alpha:1];
        node.style.preferredSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 1.f / [UIScreen mainScreen].scale);
        [self addSubnode:node];
        node;
    });
}

#pragma mark - target action

- (void)didClickVoiceButtonNode:(ASButtonNode *)buttonNode {
    
    BLInuptToolBarState targetState = buttonNode.selected ? BLInuptToolBarStateKeyboard : BLInuptToolBarStateVoice;
    
    if ([self.delegate respondsToSelector:@selector(inputToolBarNode:didClickVoiceButtonNode:currentState:targetState:)]) {
        [self.delegate inputToolBarNode:self
                didClickVoiceButtonNode:buttonNode
                           currentState:self.inputToolBarState
                            targetState:targetState];
    }
    
    [self switchInputToolBarStateActionCurrentState:self.inputToolBarState
                                        targetState:targetState
                                   targetButtonNode:buttonNode];
}

- (void)didClickExpressionButtonNode:(ASButtonNode *)buttonNode {
    
    BLInuptToolBarState targetState = buttonNode.selected ? BLInuptToolBarStateKeyboard : BLInuptToolBarStateExpression;
    
    if ([self.delegate respondsToSelector:@selector(inputToolBarNode:didClickExpressionButtonNode:currentState:targetState:)]) {
        [self.delegate inputToolBarNode:self
           didClickExpressionButtonNode:buttonNode
                           currentState:self.inputToolBarState
                            targetState:targetState];
    }
    
    
    [self switchInputToolBarStateActionCurrentState:self.inputToolBarState
                                        targetState:targetState
                                   targetButtonNode:buttonNode];
}

- (void)didClickAdditionalButtonNode:(ASButtonNode *)buttonNode {
    
    BLInuptToolBarState targetState = buttonNode.selected ? BLInuptToolBarStateKeyboard : BLInuptToolBarStateAddition;
    
    if ([self.delegate respondsToSelector:@selector(inputToolBarNode:didClickAdditionalButtonNode:currentState:targetState:)]) {
        [self.delegate inputToolBarNode:self
           didClickAdditionalButtonNode:buttonNode
                           currentState:self.inputToolBarState
                            targetState:targetState];
    }
    
    [self switchInputToolBarStateActionCurrentState:self.inputToolBarState
                                        targetState:targetState
                                   targetButtonNode:buttonNode];
}

- (void)switchInputToolBarStateActionCurrentState:(BLInuptToolBarState)currentState
                                      targetState:(BLInuptToolBarState)targetState
                                 targetButtonNode:(ASButtonNode *)buttonNode {
    
    if (targetState == BLInuptToolBarStateKeyboard) {
        switch (currentState) {
            case BLInuptToolBarStateVoice:
                [self setupVoiceButtonNodeImage:self.voiceButtonNode];
                break;
            case BLInuptToolBarStateExpression:
                [self setupExpressionButtonNodeImage:self.expressionButtonNode];
                break;
            case BLInuptToolBarStateAddition:
                [self setupAdditionalButtonNodeImage:self.additionalButtonNode];
                break;
            default:
                break;
        }
        buttonNode.selected = NO;
        self.inputToolBarState = targetState;
        [self.inputTextNode becomeFirstResponder];
    }
    else {
        switch (currentState) {
            case BLInuptToolBarStateVoice:
                [self setupVoiceButtonNodeImage:self.voiceButtonNode];
                self.voiceButtonNode.selected = NO;
                break;
            case BLInuptToolBarStateExpression:
                [self setupExpressionButtonNodeImage:self.expressionButtonNode];
                self.expressionButtonNode.selected = NO;
                break;
            case BLInuptToolBarStateAddition:
                [self setupAdditionalButtonNodeImage:self.additionalButtonNode];
                self.additionalButtonNode.selected = NO;
                break;
            default:
                break;
        }
        
        switch (targetState) {
            case BLInuptToolBarStateVoice:
                [self setupKeyboardButtonNodeImage:buttonNode];
                break;
            case BLInuptToolBarStateExpression:
                [self setupKeyboardButtonNodeImage:buttonNode];
                break;
            case BLInuptToolBarStateAddition:
                [self setupCrossButtonNodeImage:buttonNode];
                break;
            default:
                break;
        }
        buttonNode.selected = YES;
        self.inputToolBarState = targetState;
        [self.inputTextNode resignFirstResponder];
    }
}

- (void)setupVoiceButtonNodeImage:(ASButtonNode *)buttonNode {
    [buttonNode setImage:[UIImage imageNamed:@"Message_List_Voice_N"] forState:ASControlStateNormal];
    [buttonNode setImage:[UIImage imageNamed:@"Message_List_Voice_H"] forState:ASControlStateHighlighted];
}

- (void)setupKeyboardButtonNodeImage:(ASButtonNode *)buttonNode {
    [buttonNode setImage:[UIImage imageNamed:@"Message_List_Keyboard_N"] forState:ASControlStateNormal];
    [buttonNode setImage:[UIImage imageNamed:@"Message_List_Keyboard_H"] forState:ASControlStateHighlighted];
}

- (void)setupExpressionButtonNodeImage:(ASButtonNode *)buttonNode {
    [buttonNode setImage:[UIImage imageNamed:@"Message_List_Emoji_N"] forState:ASControlStateNormal];
    [buttonNode setImage:[UIImage imageNamed:@"Message_List_Emoji_H"] forState:ASControlStateHighlighted];
}

- (void)setupAdditionalButtonNodeImage:(ASButtonNode *)buttonNode {
    [buttonNode setImage:[UIImage imageNamed:@"Message_List_More_N"] forState:ASControlStateNormal];
    [buttonNode setImage:[UIImage imageNamed:@"Message_List_More_H"] forState:ASControlStateHighlighted];
}

- (void)setupCrossButtonNodeImage:(ASButtonNode *)buttonNode {
    [buttonNode setImage:[UIImage imageNamed:@"Message_List_MoreC_N"] forState:ASControlStateNormal];
    [buttonNode setImage:[UIImage imageNamed:@"Message_List_MoreC_H"] forState:ASControlStateHighlighted];
}

#pragma mark - ASEditableTextNodeDelegate

- (void)editableTextNodeDidBeginEditing:(ASEditableTextNode *)editableTextNode {
    
    if (self.expressionButtonNode.selected) {
        [self switchInputToolBarStateActionCurrentState:BLInuptToolBarStateExpression
                                            targetState:BLInuptToolBarStateKeyboard
                                       targetButtonNode:self.expressionButtonNode];
    }
    
    if (self.additionalButtonNode.selected) {
        [self switchInputToolBarStateActionCurrentState:BLInuptToolBarStateAddition
                                            targetState:BLInuptToolBarStateKeyboard
                                       targetButtonNode:self.additionalButtonNode];

    }
}

#pragma mark - layout

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
     
    self.voiceButtonNode.style.spacingBefore = BLInputItemSpecWidth;
    self.additionalButtonNode.style.spacingAfter = BLInputItemSpecWidth;
    
    NSArray *specChildren = @[self.voiceButtonNode, self.inputTextNode, self.expressionButtonNode, self.additionalButtonNode];
    
    ASStackLayoutSpec *normalLayoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                            spacing:BLInputItemSpecWidth
                                                                     justifyContent:ASStackLayoutJustifyContentSpaceAround
                                                                         alignItems:ASStackLayoutAlignItemsCenter
                                                                           children:specChildren];
    
    ASLayoutSpec *bottomSpec = [ASLayoutSpec new];
    
    ASStackLayoutSpec *packSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                          spacing:0.f
                                                                   justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                       alignItems:ASStackLayoutAlignItemsStretch
                                                                         children:@[self.lineNode, normalLayoutSpec, bottomSpec]];
    
    return packSpec;
}



@end
