//
//  BLMessageInputToolBarViewController.m
//  BLChat
//
//  Created by HZQ on 17/1/24.
//  Copyright © 2017年 HZQ. All rights reserved.
//

#import "BLMessageInputToolBarViewController.h"
#import "BLMessageInputToolBarNode.h"
#import "BLFaceBoardNode.h"
#import "BLMessagesConstant.h"

NSTimeInterval const kBLBottomBoardRiseAnimationTime = 0.35;

@interface BLMessageInputToolBarViewController ()<BLMessageInputToolBarNodeDelegate,BLFaceBoardNodeDelegate>
@property (nonatomic, strong) BLMessageInputToolBarNode *inputToolBarNode;
@property (nonatomic, strong) BLFaceBoardNode *faceBoardNode;
@property (nonatomic, readwrite) CGFloat inputToolBarHeight;
@property (nonatomic) CGRect inputToolBarNormalFrame;
@property (nonatomic) CGRect inputToolBarRiseFrame;
@property (nonatomic, weak) id<BLMessageInputToolBarViewControllerDelegate> delegate;
@end

@implementation BLMessageInputToolBarViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super initWithNode:[ASDisplayNode new]];
    
    if (self) {

    }
    
    return self;
}

- (instancetype)initWithDelegate:(id <BLMessageInputToolBarViewControllerDelegate>)delegate {
    self = [self init];
    
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotificationAction];
    [self setupSubNode];
    // Do any additional setup after loading the view.
}

- (void)setupSubNode {
    //input tool bar
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    self.inputToolBarNode = [[BLMessageInputToolBarNode alloc] initWithDelegate:self];
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGSize size = [self.inputToolBarNode layoutThatFits:ASSizeRangeMake(CGSizeZero, self.view.frame.size)].size;
    CGFloat barY = screenFrame.size.height - size.height - statusBarHeight - navigationBarHeight;
    
    self.inputToolBarNode.frame = CGRectMake(0, barY, CGRectGetWidth(screenFrame), size.height);
    self.inputToolBarNormalFrame = self.inputToolBarNode.frame;
    self.inputToolBarNode.inputToolBarNormalFrame = self.inputToolBarNormalFrame;
    [self.view addSubnode:self.inputToolBarNode];
    
    //face board node
    self.faceBoardNode = [[BLFaceBoardNode alloc] initWithDelegate:self textViewNode:self.inputToolBarNode.inputTextNode];
    CGSize faceSize = [self.faceBoardNode layoutThatFits:ASSizeRangeMake(CGSizeZero, self.view.frame.size)].size;
    self.faceBoardNode.frame = CGRectMake(0, self.view.bounds.size.height - navigationBarHeight - statusBarHeight, faceSize.width,
            faceSize.height);
    [self.view addSubnode:self.faceBoardNode];
}

- (CGFloat)inputToolBarHeight {
    return CGRectGetHeight(_inputToolBarNode.frame);
}

- (void)resignTextNodeFirstResponder {
    [self.inputToolBarNode resignInputToolBarFirstResponder];
}
#pragma mark - keyboard notification action

- (void)addNotificationAction {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    
    UIViewAnimationCurve animationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSInteger animationCurveOption = (animationCurve << 16);
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    if (kbSize.height <= 0) {
        return;
    }
    
    double animationDuration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    CGRect barFrame = self.inputToolBarNode.inputToolBarCurrentState != BLInputToolBarStateVoice ?
                                                                     self.inputToolBarNode.frame :
                                                                     self.inputToolBarNormalFrame;

    CGFloat riseHeight = CGRectGetHeight(self.view.bounds) - barFrame.origin.y - CGRectGetHeight(barFrame);
    CGFloat increaseHeight = riseHeight - kbSize.height;
    barFrame.origin.y = barFrame.origin.y + increaseHeight;
    self.inputToolBarRiseFrame = barFrame;
    self.inputToolBarNode.inputToolBarRiseFrame = barFrame;

    [UIView animateWithDuration:animationDuration
                          delay:0.f
                        options:animationCurveOption
                     animations:^{
                         //触发键盘时候把其他board给隐藏
                         [self resetBottomBoardFrame];

                         self.inputToolBarNode.frame = barFrame;


                         [self setupCollectionNodeFrameWithBarFrame:barFrame];
                     } completion:nil];
}

- (void)keyboardWillHidden:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    
    UIViewAnimationCurve animationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSInteger animationCurveOption = (animationCurve << 16);
    
    double animationDuration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration
                          delay:0.f
                        options:animationCurveOption
                     animations:^{
                         CGFloat barY = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.inputToolBarNode.frame);

                         //通过打开了face board按钮，而隐藏keyboard，就把通过其高度调整bar的y轴
                         if (self.inputToolBarNode.inputToolBarCurrentState == BLInputToolBarStateExpression) {
                             CGFloat faceBoardHeight = [self faceBoardAnimationTransition];
                             barY -= faceBoardHeight;
                         }

                         CGRect barFrame = self.inputToolBarNode.frame;
                         barFrame.origin.y = barY;
                         self.inputToolBarNode.frame = barFrame;
                         [self setupCollectionNodeFrameWithBarFrame:barFrame];
                         
                     } completion:nil];
}

- (void)setupCollectionNodeFrameWithBarFrame:(CGRect)barFrame {

    CGFloat riseHeight = self.inputToolBarNormalFrame.origin.y - barFrame.origin.y;

    if ([self.delegate respondsToSelector:@selector(barViewController:didUpdateContentNodeWihtRiseHeight:)]) {
        [self.delegate barViewController:self didUpdateContentNodeWihtRiseHeight:riseHeight];
    }
}

- (CGFloat)faceBoardAnimationTransition {

    BOOL currentStateExpression = self.inputToolBarNode.inputToolBarCurrentState == BLInputToolBarStateExpression;
    BOOL previousStateExpression = self.inputToolBarNode.inputToolBarPreviousState == BLInputToolBarStateExpression;

    if (currentStateExpression) {
        CGRect frame = self.faceBoardNode.frame;
        frame.origin.y = self.view.bounds.size.height - frame.size.height;
        self.faceBoardNode.frame = frame;
        return frame.size.height;
    }

    if (previousStateExpression) {
        CGRect frame = self.faceBoardNode.frame;
        frame.origin.y = self.view.bounds.size.height;
        self.faceBoardNode.frame = frame;
        return frame.size.height;
    }

    return  0.f;
}

- (void)resetBottomBoardFrame {
    //之前点击表情按钮后，然后直接触发键盘，收起face board
    CGRect frame = self.faceBoardNode.frame;
    frame.origin.y = self.view.bounds.size.height;
    self.faceBoardNode.frame = frame;
}

#pragma mark - BLMessageInputToolBarNodeDelegate

- (void)    inputToolBarNode:(BLMessageInputToolBarNode *)inputToolBarNode
didClickExpressionButtonNode:(ASButtonNode *)expressionButtonNode
               previousState:(BLInputToolBarState)previousState
                currentState:(BLInputToolBarState)currentState {
    //点击表情按钮，之前状态是键盘，不经过此处理face board升起动画，在键盘降下处理防止动画重复
    if (previousState == BLInputToolBarStateKeyboard) {
        return;
    }

    //点击表情按钮，之前状态是表情，再点击则为键盘弹出事件交给键盘动画处理face board
    if (previousState == BLInputToolBarStateExpression) {
        return;
    }

    //升起face board
    [UIView animateWithDuration:kBLBottomBoardRiseAnimationTime animations:^{

        CGFloat riseHeight = [self faceBoardAnimationTransition];
        CGRect barFrame = self.inputToolBarNode.frame;
        barFrame.origin.y -= riseHeight;
        self.inputToolBarNode.frame = barFrame;
        [self setupCollectionNodeFrameWithBarFrame:barFrame];
    }];

}

- (void)inputToolBarNode:(BLMessageInputToolBarNode *)inputToolBarNode
 didClickVoiceButtonNode:(ASButtonNode *)voiceButtonNode
           previousState:(BLInputToolBarState)previousState
            currentState:(BLInputToolBarState)currentState {
    //点击表情按钮，之前状态是表情，把face board给降下来
    if (previousState == BLInputToolBarStateExpression) {
        [self triggerFallFaceBoardAnimation];
        return;
    }
}

- (void)    inputToolBarNode:(BLMessageInputToolBarNode *)inputToolBarNode
layoutTransitionWithBarFrame:(CGRect)barFrame
                    duration:(NSTimeInterval)duration {

    [self setupCollectionNodeFrameWithBarFrame:barFrame];
}

- (void)    inputToolBarNode:(BLMessageInputToolBarNode *)inputToolBarNode
didClickSendButtonActionWithText:(NSString *)inputText {
    if ([self.delegate respondsToSelector:@selector(barViewController:didClickInputBarSendButtonWithInputText:)]) {
        [self.delegate barViewController:self didClickInputBarSendButtonWithInputText:inputText];
    }
}

- (void)           inputToolBarNode:(BLMessageInputToolBarNode *)inputToolBarNode
resignFirstResponderWithResignState:(BLInputToolBarState)resignState {

    if (resignState == BLInputToolBarStateExpression) {
        [self triggerFallFaceBoardAnimation];
    }
}

#pragma mark - BLFaceBoardNodeDelegate

- (void)faceBoardNode:(BLFaceBoardNode *)faceBoardNode
   didClickSendButton:(ASButtonNode *)buttonNode
                 text:(NSString *)text {

    if ([self.delegate respondsToSelector:@selector(barViewController:didClickInputBarSendButtonWithInputText:)]) {
        [self.delegate barViewController:self didClickInputBarSendButtonWithInputText:text];
    }

    [self.inputToolBarNode triggerInputToolBarDidSendAction];
}

- (void)faceBoardDidSelectEmojiAction:(BLFaceBoardNode *)faceBoardNode boardHeight:(CGFloat)boardHeight {
    self.inputToolBarNode.inputToolBarRiseFrame = self.inputToolBarNode.frame;

    [[NSNotificationCenter defaultCenter] postNotificationName:kBLInputToolBarTextDidChangeNotification object:nil];
}

#pragma mark - bottom board animation action
- (void)triggerFallFaceBoardAnimation {

    [UIView animateWithDuration:kBLBottomBoardRiseAnimationTime animations:^{
        CGFloat riseHeight = [self faceBoardAnimationTransition];
        CGRect barFrame = self.inputToolBarNode.frame;
        barFrame.origin.y += riseHeight;
        self.inputToolBarNode.frame = barFrame;
        [self setupCollectionNodeFrameWithBarFrame:barFrame];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
