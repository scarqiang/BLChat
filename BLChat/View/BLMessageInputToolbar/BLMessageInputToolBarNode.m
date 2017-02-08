//
//  BLMessageInputToolBarNode.m
//  BLChat
//
//  Created by HZQ on 17/1/24.
//  Copyright © 2017年 HZQ. All rights reserved.
//

#import "BLMessageInputToolBarNode.h"
#import "YYWebImage.h"
#import "BLMessagesConstant.h"

CGFloat const BLInputTextNodeHeight = 34.f;
CGFloat const BLInputTextNodeFontSize = 15.f;
CGFloat const BLInputItemSpecWidth = 10.f;
CGFloat const BLInputItemInsetHeight = 5.f;
CGFloat const BLInputTextNodeInsetHeight = 8.f;
NSTimeInterval const BLInputAnimationDuration = 0.25f;
#define BLInputToolBarLineHeight 1.f/[UIScreen mainScreen].scale

@interface BLMessageInputToolBarNode ()<ASEditableTextNodeDelegate>
@property (nonatomic, strong) ASEditableTextNode *inputTextNode;
@property (nonatomic, strong) ASButtonNode *voiceButtonNode;
@property (nonatomic, strong) ASButtonNode *expressionButtonNode;
@property (nonatomic, strong) ASButtonNode *additionalButtonNode;
@property (nonatomic, strong) ASButtonNode *recordingButtonNode;
@property (nonatomic, strong) ASDisplayNode *lineNode;
@property (nonatomic, weak) id<BLMessageInputToolBarNodeDelegate> delegate;
@property (nonatomic, readwrite) BLInputToolBarState inputToolBarCurrentState;
@property (nonatomic, readwrite) BLInputToolBarState inputToolBarPreviousState;
@property (nonatomic) CGRect maxTextNodeFrame;
@property (nonatomic) CGFloat maxTextNodeHeight;
@property (nonatomic) NSInteger textNumberLine;
@end

@implementation BLMessageInputToolBarNode

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithDelegate:(id<BLMessageInputToolBarNodeDelegate>)delegate {
    self = [super init];
    
    if (self) {
        _delegate = delegate;
        [self setupSubNode];
        [self addNotification];
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
        buttonNode;
    });
    
    _expressionButtonNode = ({
        ASButtonNode *buttonNode = [ASButtonNode new];
        [self setupExpressionButtonNodeImage:buttonNode];
        buttonNode;
    });
    
    _additionalButtonNode = ({
        ASButtonNode *buttonNode = [ASButtonNode new];
        [self setupAdditionalButtonNodeImage:buttonNode];
        buttonNode.style.spacingAfter = BLInputItemSpecWidth;
        buttonNode;
    });
    
    _inputTextNode = ({
        ASEditableTextNode *textNode = [ASEditableTextNode new];
        textNode.delegate = self;
        textNode.backgroundColor = [UIColor whiteColor];
        textNode.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        textNode.layer.borderColor = [UIColor colorWithRed:203.f/255.f green:203.f/255.f blue:203.f/255.f alpha:1].CGColor;
        textNode.layer.cornerRadius = 4.f;
        textNode.clipsToBounds = YES;
        textNode.style.flexGrow = 1.f;
        textNode.style.flexShrink = 1.f;
        textNode.style.preferredSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, BLInputTextNodeHeight);
        textNode.textView.font = [UIFont systemFontOfSize:BLInputTextNodeFontSize];
        textNode.textContainerInset = UIEdgeInsetsMake(8, 5, 8, 5);
        textNode.returnKeyType = UIReturnKeySend;
        textNode;
    });
    
    _lineNode = ({
        ASDisplayNode *node = [ASDisplayNode new];
        node.backgroundColor = [UIColor colorWithRed:203.f/255.f green:203.f/255.f blue:203.f/255.f alpha:1];
        node.style.preferredSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), BLInputToolBarLineHeight);
        node;
    });
    
    UIImage *normalButtonImage = [UIImage yy_imageWithColor:[UIColor colorWithRed:80.f/255.f green:82.f/255.f blue:83.f/255.f alpha:1]];
    UIImage *highlightButtonImage = [UIImage yy_imageWithColor:[UIColor colorWithRed:180.f/255.f green:180.f/255.f
                                                                             blue:181.f/255.f alpha:1]];
    
    _recordingButtonNode = ({
        ASButtonNode *button = [ASButtonNode new];
        [button setBackgroundImage:normalButtonImage forState:ASControlStateNormal];
        [button setBackgroundImage:highlightButtonImage forState:ASControlStateHighlighted];

        [button setTitle:@"按住说话" withFont:[UIFont systemFontOfSize:15.f] withColor:[UIColor whiteColor] forState:ASControlStateNormal];
        [button setTitle:@"松开发送" withFont:[UIFont systemFontOfSize:15.f] withColor:[UIColor whiteColor] forState:ASControlStateHighlighted];

        [button addTarget:self action:@selector(pressRecordButtonNode:) forControlEvents:ASControlNodeEventTouchDown];
        [button addTarget:self action:@selector(didLoosenButtonNode:) forControlEvents:ASControlNodeEventTouchUpInside];

        button.layer.cornerRadius = 4.f;
        button.clipsToBounds = YES;
        button.style.flexGrow = 1.f;
        button.style.flexShrink = 1.f;
        
        button.style.preferredSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, BLInputTextNodeHeight);
        button;
    });
}

- (CGRect)inputToolBarNormalFrame {
    NSAssert(!CGRectEqualToRect(CGRectZero, _inputToolBarNormalFrame), @"没有设置inputToolBarNormalFrame");
    return _inputToolBarNormalFrame;
}

- (CGRect)inputToolBarRiseFrame {
    NSAssert(!CGRectEqualToRect(CGRectZero, _inputToolBarRiseFrame), @"没有设置inputToolBarRiseFrame");
    return _inputToolBarRiseFrame;
}

- (void)addNotification {

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editableTextNodeDidUpdateText:)
                                                 name:kBLInputToolBarTextDidChangeNotification
                                               object:nil];
}

#pragma mark - target action

- (void)pressRecordButtonNode:(ASButtonNode *)buttonNode {
    
    if ([self.delegate respondsToSelector:@selector(inputToolBarNode:pressingSoundRecordButtonNode:)]) {
        [self.delegate inputToolBarNode:self pressingSoundRecordButtonNode:buttonNode];
    }
    
    NSLog(@"你按住了~~~");
}

- (void)didLoosenButtonNode:(ASButtonNode *)buttonNode {
    
    if ([self.delegate respondsToSelector:@selector(inputToolBarNode:didLoosenSoundRecordButtonNode:)]) {
        [self.delegate inputToolBarNode:self didLoosenSoundRecordButtonNode:buttonNode];
    }
    
    NSLog(@"你松开了~~~~");
}

- (void)didClickVoiceButtonNode:(ASButtonNode *)buttonNode {

    BLInputToolBarState targetState = buttonNode.selected ? BLInputToolBarStateKeyboard : BLInputToolBarStateVoice;
    BLInputToolBarState previousState = self.inputToolBarCurrentState;

    [self switchInputToolBarStateActionCurrentState:self.inputToolBarCurrentState
                                        targetState:targetState
                                   targetButtonNode:buttonNode];

    if ([self.delegate respondsToSelector:@selector(inputToolBarNode:didClickVoiceButtonNode:previousState:currentState:)]) {
        [self.delegate inputToolBarNode:self
                didClickVoiceButtonNode:buttonNode
                          previousState:previousState
                           currentState:targetState];
    }
}

- (void)didClickExpressionButtonNode:(ASButtonNode *)buttonNode {

    BLInputToolBarState targetState = buttonNode.selected ? BLInputToolBarStateKeyboard : BLInputToolBarStateExpression;
    BLInputToolBarState previousState = self.inputToolBarCurrentState;

    [self switchInputToolBarStateActionCurrentState:self.inputToolBarCurrentState
                                        targetState:targetState
                                   targetButtonNode:buttonNode];

    if ([self.delegate respondsToSelector:@selector(inputToolBarNode:didClickExpressionButtonNode:previousState:currentState:)]) {
        [self.delegate inputToolBarNode:self
           didClickExpressionButtonNode:buttonNode
                          previousState:previousState
                           currentState:targetState];
    }
}

- (void)didClickAdditionalButtonNode:(ASButtonNode *)buttonNode {

    BLInputToolBarState targetState = buttonNode.selected ? BLInputToolBarStateKeyboard : BLInputToolBarStateAddition;
    BLInputToolBarState previousState = self.inputToolBarCurrentState;

    [self switchInputToolBarStateActionCurrentState:self.inputToolBarCurrentState
                                        targetState:targetState
                                   targetButtonNode:buttonNode];

    if ([self.delegate respondsToSelector:@selector(inputToolBarNode:didClickAdditionalButtonNode:previousState:currentState:)]) {
        [self.delegate inputToolBarNode:self
           didClickAdditionalButtonNode:buttonNode
                          previousState:previousState
                           currentState:targetState];
    }
}

#pragma mark - exchange state action

- (void)switchInputToolBarStateActionCurrentState:(BLInputToolBarState)currentState
                                      targetState:(BLInputToolBarState)targetState
                                 targetButtonNode:(ASButtonNode *)buttonNode {
    
    self.inputToolBarPreviousState = currentState;
    
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
        self.inputToolBarCurrentState = targetState;
        [self.inputTextNode becomeFirstResponder];
    }
    else if (targetState == BLInputToolBarStateNone) {
        switch (currentState) {
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
        self.inputToolBarCurrentState = targetState;
        [self.inputTextNode resignFirstResponder];
    }

    if (currentState == BLInputToolBarStateVoice || targetState == BLInputToolBarStateVoice) {
        [self transitionLayoutWithAnimation:YES shouldMeasureAsync:NO measurementCompletion:nil];
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

    BLInputToolBarState currentState = BLInputToolBarStateKeyboard;
    self.inputToolBarCurrentState = currentState;
    
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
}

- (void)editableTextNodeDidFinishEditing:(ASEditableTextNode *)editableTextNode {
    if (self.inputToolBarCurrentState == BLInputToolBarStateKeyboard) {
        self.inputToolBarCurrentState = BLInputToolBarStateNone;
    }
}

- (BOOL)editableTextNode:(ASEditableTextNode *)editableTextNode
 shouldChangeTextInRange:(NSRange)range
         replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(inputToolBarNode:didClickSendButtonActionWithText:)]) {
            [self.delegate inputToolBarNode:self didClickSendButtonActionWithText:editableTextNode.textView.text];
        }

        [self triggerInputToolBarDidSendAction];
        return NO;
    }
    
    return YES;
}

- (void)editableTextNodeDidUpdateText:(ASEditableTextNode *)editableTextNode {
    self.textNumberLine = (NSInteger) (self.inputTextNode.textView.contentSize.height / self.inputTextNode.textView.font.lineHeight);
    CGFloat textNodeHeight = self.inputTextNode.textView.contentSize.height;

    if (self.textNumberLine == 5) {
        self.maxTextNodeHeight = self.inputTextNode.textView.contentSize.height;
    }

    if (self.textNumberLine > 5) {
        textNodeHeight = self.maxTextNodeHeight;
    }

    //判断是否是表情输入
    if(self.inputTextNode.textView.text.length > 0 && ![editableTextNode isKindOfClass:[ASEditableTextNode class]]) {
        NSRange bottom = NSMakeRange(self.inputTextNode.textView.text.length -1, 1);
        [self.inputTextNode.textView scrollRangeToVisible:self.inputTextNode.textView.selectedRange];
    }

    self.inputTextNode.style.preferredSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, textNodeHeight);
    [self transitionLayoutWithAnimation:YES shouldMeasureAsync:NO measurementCompletion:nil];
}

#pragma mark - layout

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    return [self inputToolBarLayoutSpec];
}

- (ASLayoutSpec *)inputToolBarLayoutSpec {
    
    self.voiceButtonNode.contentEdgeInsets = UIEdgeInsetsMake(BLInputItemInsetHeight, 0, BLInputItemInsetHeight, 0);
    self.expressionButtonNode.contentEdgeInsets = UIEdgeInsetsMake(BLInputItemInsetHeight, 0, BLInputItemInsetHeight, 0);
    self.additionalButtonNode.contentEdgeInsets = UIEdgeInsetsMake(BLInputItemInsetHeight, 0, BLInputItemInsetHeight, 0);
    
    ASDisplayNode *middleNode = self.voiceButtonNode.selected ? self.recordingButtonNode : self.inputTextNode;
    
    NSArray *specChildren = @[self.voiceButtonNode, middleNode, self.expressionButtonNode, self.additionalButtonNode];
    
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

#pragma mark - animate layout transition

- (void)animateLayoutTransition:(id<ASContextTransitioning>)context {
    
    if (self.voiceButtonNode.selected) {
        [self voiceStateLayoutTransition:context];
        return;
    }
    
    [self keyboardStateLayoutTransition:context];
}

- (void)voiceStateLayoutTransition:(id<ASContextTransitioning>)context {
    
    [UIView animateWithDuration:BLInputAnimationDuration animations:^{
        
        CGSize fromSize = [context layoutForKey:ASTransitionContextFromLayoutKey].size;
        CGSize toSize = [context layoutForKey:ASTransitionContextToLayoutKey].size;
        BOOL isResized = (CGSizeEqualToSize(fromSize, toSize) == NO);
        if (isResized == YES) {
            CGPoint position = self.inputToolBarNormalFrame.origin;
            self.frame = CGRectMake(position.x, position.y, toSize.width, toSize.height);
            self.voiceButtonNode.frame = [context finalFrameForNode:self.voiceButtonNode];
            self.additionalButtonNode.frame = [context finalFrameForNode:self.additionalButtonNode];
            self.expressionButtonNode.frame = [context finalFrameForNode:self.expressionButtonNode];
        }
        
        if ([self.delegate respondsToSelector:@selector(inputToolBarNode:layoutTransitionWithBarFrame:duration:)]) {
            [self.delegate inputToolBarNode:self layoutTransitionWithBarFrame:self.frame duration:BLInputAnimationDuration];
        }
        
    } completion:^(BOOL finished) {
        
        [context completeTransition:finished];
    }];

}

- (void)keyboardStateLayoutTransition:(id<ASContextTransitioning>)context {
    
    ASDisplayNode *removeNode = nil;
    if (self.inputToolBarPreviousState == BLInputToolBarStateVoice) {
        removeNode = [[context removedSubnodes] firstObject];
        removeNode.hidden = YES;
    }
    
    CGRect fromFrame = [context initialFrameForNode:self.inputTextNode];
    CGFloat textViewHeigth = self.inputTextNode.textView.contentSize.height;
    
    fromFrame.size.height = self.textNumberLine < 5 ? textViewHeigth : self.maxTextNodeHeight;
    
    [UIView animateWithDuration:BLInputAnimationDuration animations:^{
        
        CGSize fromSize = [context layoutForKey:ASTransitionContextFromLayoutKey].size;
        CGSize toSize = [context layoutForKey:ASTransitionContextToLayoutKey].size;
        BOOL isResized = (CGSizeEqualToSize(fromSize, toSize) == NO);
        if (isResized == YES) {
            CGPoint position = self.frame.origin;
            CGFloat textNodeHeight = self.textNumberLine < 5 ? textViewHeigth : self.maxTextNodeHeight;
            CGFloat barHeight = textNodeHeight + BLInputToolBarLineHeight + 2 * BLInputTextNodeInsetHeight;
            CGFloat barY = CGRectGetMinY(self.inputToolBarRiseFrame) + CGRectGetHeight(self.inputToolBarRiseFrame) - barHeight;
            CGRect barFrame = self.frame;
            barFrame.origin.y = barY;
            barFrame.size.height = barHeight;
            position.y = barY;
            self.frame = CGRectMake(position.x, position.y, toSize.width, toSize.height);
            self.voiceButtonNode.frame = [context finalFrameForNode:self.voiceButtonNode];
            self.additionalButtonNode.frame = [context finalFrameForNode:self.additionalButtonNode];
            self.expressionButtonNode.frame = [context finalFrameForNode:self.expressionButtonNode];
            
            if ([self.delegate respondsToSelector:@selector(inputToolBarNode:layoutTransitionWithBarFrame:duration:)]) {
                [self.delegate inputToolBarNode:self layoutTransitionWithBarFrame:self.frame duration:BLInputAnimationDuration];
            }
        }
        
        self.inputTextNode.frame = fromFrame;
        
    } completion:^(BOOL finished) {
        
        [context completeTransition:finished];
        removeNode.hidden = NO;
    }];
}

- (void)resignInputToolBarFirstResponder {

    if (self.inputToolBarCurrentState == BLInputToolBarStateVoice) {
        return;
    }

    self.inputToolBarPreviousState = self.inputToolBarCurrentState;
    self.inputToolBarCurrentState = BLInputToolBarStateNone;

    if (self.inputTextNode.isFirstResponder) {
        [self.inputTextNode resignFirstResponder];
    }

    switch (self.inputToolBarPreviousState) {
        case BLInputToolBarStateExpression:
            [self switchInputToolBarStateActionCurrentState:BLInputToolBarStateExpression
                                                targetState:BLInputToolBarStateNone
                                           targetButtonNode:self.expressionButtonNode];
            break;
        case BLInputToolBarStateAddition:
            [self switchInputToolBarStateActionCurrentState:BLInputToolBarStateAddition
                                                targetState:BLInputToolBarStateNone
                                           targetButtonNode:self.additionalButtonNode];
            break;
        default:
            break;
    }

    if ([self.delegate respondsToSelector:@selector( inputToolBarNode:resignFirstResponderWithResignState:)]) {
        [self.delegate inputToolBarNode:self resignFirstResponderWithResignState:self.inputToolBarPreviousState];
    }
}

- (void)triggerInputToolBarDidSendAction {
    self.inputTextNode.textView.text = @"";

    CGFloat textNodeHeight = self.inputTextNode.textView.contentSize.height;
    self.textNumberLine = 1;
    self.inputTextNode.style.preferredSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, textNodeHeight);
    [self transitionLayoutWithAnimation:YES shouldMeasureAsync:NO measurementCompletion:nil];
}

@end
