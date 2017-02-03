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
CGFloat const BLInputItemInsetHeight = 5.f;
CGFloat const BLInputTextNodeInsetHeight = 8.f;
#define BLInputToolBarLineHeight 1.f/[UIScreen mainScreen].scale

@interface BLMessageInputToolBarNode ()<ASEditableTextNodeDelegate>
@property (nonatomic, strong) ASEditableTextNode *inputTextNode;
@property (nonatomic, strong) ASButtonNode *voiceButtonNode;
@property (nonatomic, strong) ASButtonNode *expressionButtonNode;
@property (nonatomic, strong) ASButtonNode *additionalButtonNode;
@property (nonatomic, strong) ASDisplayNode *lineNode;
@property (nonatomic, weak) id<BLMessageInputToolBarNodeDelegate> delegate;
@property (nonatomic, readwrite) BLInputToolBarState inputToolBarState;
@property (nonatomic) CGRect inputToolBarNormalFrame;
@property (nonatomic) CGRect inputToolBarRiseFrame;
@property (nonatomic) CGFloat maxTextNodeHeight;
@property (nonatomic) NSInteger textNumberLine;
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

- (void)didLoad {
    [super didLoad];
    
    [self.voiceButtonNode addTarget:self action:@selector(didClickVoiceButtonNode:) forControlEvents:ASControlNodeEventTouchUpInside];
    [self.expressionButtonNode addTarget:self action:@selector(didClickExpressionButtonNode:) forControlEvents:ASControlNodeEventTouchUpInside];
    [self.additionalButtonNode addTarget:self action:@selector(didClickAdditionalButtonNode:) forControlEvents:ASControlNodeEventTouchUpInside];
}

- (void)setupSubNode {
    
    self.backgroundColor = [UIColor colorWithRed:239.f/255.f green:240.f/255.f blue:242.f/255.f alpha:1];
    self.automaticallyManagesSubnodes = YES;
    
    _voiceButtonNode = ({
        ASButtonNode *buttonNode = [ASButtonNode new];
        [self setupVoiceButtonNodeImage:buttonNode];
        buttonNode.style.spacingBefore = BLInputItemSpecWidth;
//        [self addSubnode:buttonNode];
        buttonNode;
    });
    
    _expressionButtonNode = ({
        ASButtonNode *buttonNode = [ASButtonNode new];
        [self setupExpressionButtonNodeImage:buttonNode];
//        [self addSubnode:buttonNode];
        buttonNode;
    });
    
    _additionalButtonNode = ({
        ASButtonNode *buttonNode = [ASButtonNode new];
        [self setupAdditionalButtonNodeImage:buttonNode];
        buttonNode.style.spacingAfter = BLInputItemSpecWidth;
//        [self addSubnode:buttonNode];
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
//        [self addSubnode:textNode];
        textNode;
    });
    
    _lineNode = ({
        ASDisplayNode *node = [ASDisplayNode new];
        node.backgroundColor = [UIColor colorWithRed:203.f/255.f green:203.f/255.f blue:203.f/255.f alpha:1];
        node.style.preferredSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), BLInputToolBarLineHeight);
//        [self addSubnode:node];
        node;
    });
}

#pragma mark - target action

- (void)didClickVoiceButtonNode:(ASButtonNode *)buttonNode {

    BLInputToolBarState targetState = buttonNode.selected ? BLInputToolBarStateKeyboard : BLInputToolBarStateVoice;
    
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

    BLInputToolBarState targetState = buttonNode.selected ? BLInputToolBarStateKeyboard : BLInputToolBarStateExpression;
    
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

    BLInputToolBarState targetState = buttonNode.selected ? BLInputToolBarStateKeyboard : BLInputToolBarStateAddition;
    
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

- (void)switchInputToolBarStateActionCurrentState:(BLInputToolBarState)currentState
                                      targetState:(BLInputToolBarState)targetState
                                 targetButtonNode:(ASButtonNode *)buttonNode {
    
    if (targetState == BLInputToolBarStateKeyboard) {
        switch (currentState) {
            case BLInputToolBarStateVoice:
                [self setupVoiceButtonNodeImage:self.voiceButtonNode];
                break;
            case BLInputToolBarStateExpression:
                [self setupExpressionButtonNodeImage:self.expressionButtonNode];
                break;
            case BLInputToolBarStateAddition:
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
            case BLInputToolBarStateVoice:
                [self setupVoiceButtonNodeImage:self.voiceButtonNode];
                self.voiceButtonNode.selected = NO;
                break;
            case BLInputToolBarStateExpression:
                [self setupExpressionButtonNodeImage:self.expressionButtonNode];
                self.expressionButtonNode.selected = NO;
                break;
            case BLInputToolBarStateAddition:
                [self setupAdditionalButtonNodeImage:self.additionalButtonNode];
                self.additionalButtonNode.selected = NO;
                break;
            default:
                break;
        }
        
        switch (targetState) {
            case BLInputToolBarStateVoice:
                [self setupKeyboardButtonNodeImage:buttonNode];
                break;
            case BLInputToolBarStateExpression:
                [self setupKeyboardButtonNodeImage:buttonNode];
                break;
            case BLInputToolBarStateAddition:
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

    BLInputToolBarState currentState = BLInputToolBarStateNone;
    
    if (self.expressionButtonNode.selected) {
        [self switchInputToolBarStateActionCurrentState:BLInputToolBarStateExpression
                                            targetState:BLInputToolBarStateKeyboard
                                       targetButtonNode:self.expressionButtonNode];
        currentState = BLInputToolBarStateExpression;
    }
    
    if (self.additionalButtonNode.selected) {
        [self switchInputToolBarStateActionCurrentState:BLInputToolBarStateAddition
                                            targetState:BLInputToolBarStateKeyboard
                                       targetButtonNode:self.additionalButtonNode];
        currentState = BLInputToolBarStateAddition;
    }
    
    if ([self.delegate respondsToSelector:@selector(inputToolBarTextNodeDidBeginEditing:currentState:targetState:)]) {
        [self.delegate inputToolBarTextNodeDidBeginEditing:editableTextNode currentState:currentState targetState:BLInputToolBarStateKeyboard];
    }
}

- (BOOL)editableTextNode:(ASEditableTextNode *)editableTextNode
 shouldChangeTextInRange:(NSRange)range
         replacementText:(NSString *)text {
    
    return YES;
}


- (void)editableTextNodeDidUpdateText:(ASEditableTextNode *)editableTextNode {
    
    self.textNumberLine = editableTextNode.textView.contentSize.height / editableTextNode.textView.font.lineHeight;
    CGFloat textNodeHeight = self.inputTextNode.textView.contentSize.height;
    
    if (self.textNumberLine == 5) {
        self.maxTextNodeHeight = self.inputTextNode.textView.contentSize.height;
    }
    
    if (self.textNumberLine > 5) {
        textNodeHeight = self.maxTextNodeHeight;
    }
    
    CGFloat barHeight = textNodeHeight + BLInputToolBarLineHeight + 2 * BLInputTextNodeInsetHeight;
    
    if ([self.delegate respondsToSelector:@selector(inputToolBarTextNodeDidUpdateText:textNumberLine:barHeight:)]) {
        [self.delegate inputToolBarTextNodeDidUpdateText:editableTextNode textNumberLine:self.textNumberLine barHeight:barHeight];
       
    }
}

#pragma mark - layout

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    
    return self.textNumberLine > 1 ? [self inputToolBarTextMultipleLineLayoutSpec] :
                                      [self inputToolBarTextSingleLineLayoutSpec];
    
    return [self inputToolBarTextSingleLineLayoutSpec];

}

- (ASLayoutSpec *)inputToolBarTextMultipleLineLayoutSpec {
    
    CGFloat textNodeHeight = self.inputTextNode.textView.contentSize.height;
    self.inputTextNode.style.preferredSize = CGSizeMake(100.f, textNodeHeight);
    self.voiceButtonNode.contentEdgeInsets = UIEdgeInsetsMake(BLInputItemInsetHeight, 0, BLInputItemInsetHeight, 0);
    self.expressionButtonNode.contentEdgeInsets = UIEdgeInsetsMake(BLInputItemInsetHeight, 0, BLInputItemInsetHeight, 0);
    self.additionalButtonNode.contentEdgeInsets = UIEdgeInsetsMake(BLInputItemInsetHeight, 0, BLInputItemInsetHeight, 0);
    
    NSArray *specChildren = @[self.voiceButtonNode, self.inputTextNode, self.expressionButtonNode, self.additionalButtonNode];
    
    ASStackLayoutSpec *contentLayoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                  spacing:BLInputItemSpecWidth
                                                                           justifyContent:ASStackLayoutJustifyContentSpaceAround
                                                                               alignItems:ASStackLayoutAlignItemsEnd
                                                                                 children:specChildren];
    
    ASLayoutSpec *bottomSpec = [ASLayoutSpec new];
    
    contentLayoutSpec.style.spacingBefore = BLInputTextNodeInsetHeight;
    contentLayoutSpec.style.spacingAfter = BLInputTextNodeInsetHeight;
    
    ASStackLayoutSpec *packSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                          spacing:0.f
                                                                   justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                       alignItems:ASStackLayoutAlignItemsStretch
                                                                         children:@[self.lineNode, contentLayoutSpec, bottomSpec]];
    
    return packSpec;
}

- (ASLayoutSpec *)inputToolBarTextSingleLineLayoutSpec {
    
    self.inputTextNode.style.preferredSize = CGSizeMake(100.f, BLInputTextNodeHeight);
    self.voiceButtonNode.contentEdgeInsets = UIEdgeInsetsZero;
    self.expressionButtonNode.contentEdgeInsets = UIEdgeInsetsZero;
    self.additionalButtonNode.contentEdgeInsets = UIEdgeInsetsZero;
    
    NSArray *specChildren = @[self.voiceButtonNode, self.inputTextNode, self.expressionButtonNode, self.additionalButtonNode];
    
    ASStackLayoutSpec *contentLayoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                  spacing:BLInputItemSpecWidth
                                                                           justifyContent:ASStackLayoutJustifyContentSpaceAround
                                                                               alignItems:ASStackLayoutAlignItemsCenter
                                                                                 children:specChildren];
    
    ASLayoutSpec *bottomSpec = [ASLayoutSpec new];
    
    contentLayoutSpec.style.spacingBefore = 0.f;
    contentLayoutSpec.style.spacingAfter = 0.f;
    
    ASStackLayoutSpec *packSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                          spacing:0.f
                                                                   justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                       alignItems:ASStackLayoutAlignItemsStretch
                                                                         children:@[self.lineNode, contentLayoutSpec, bottomSpec]];
    
    return packSpec;
}


@end
