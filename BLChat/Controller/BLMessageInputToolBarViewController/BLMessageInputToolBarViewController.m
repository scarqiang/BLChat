//
//  BLMessageInputToolBarViewController.m
//  BLChat
//
//  Created by HZQ on 17/1/24.
//  Copyright © 2017年 HZQ. All rights reserved.
//

#import "BLMessageInputToolBarViewController.h"
#import "BLMessageInputToolBarNode.h"


@interface BLMessageInputToolBarViewController ()<BLMessageInputToolBarNodeDelegate>
@property (nonatomic, strong) BLMessageInputToolBarNode *inputToolBarNode;
@property (nonatomic, readwrite) CGFloat inputToolBarHeight;
@property (nonatomic, weak) ASCollectionNode *collectionNode;
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


- (instancetype)initWithContentCollectionNode:(ASCollectionNode *)collectionNode
                                     delegate:(id<BLMessageInputToolBarViewControllerDelegate>)delegate {
    self = [self init];
    
    if (self) {
        _collectionNode = collectionNode;
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
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    self.inputToolBarNode = [[BLMessageInputToolBarNode alloc] initWithDelegate:self];
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGSize size = [_inputToolBarNode layoutThatFits:ASSizeRangeMake(CGSizeZero, self.view.frame.size)].size;
    CGFloat barY = screenFrame.size.height - size.height - statusBarHeight - navigationBarHeight;
    
    self.inputToolBarNode.frame = CGRectMake(0, barY, CGRectGetWidth(screenFrame), size.height);
    self.inputToolBarNormalFrame = self.inputToolBarNode.frame;
    self.inputToolBarNode.inputToolBarNormalFrame = self.inputToolBarNormalFrame;
    [self.view addSubnode:self.inputToolBarNode];
}

- (CGFloat)inputToolBarHeight {
        return CGRectGetHeight(_inputToolBarNode.frame);
}


- (CGRect)collectionInitialFrame {
    NSAssert(!CGRectIsEmpty(_collectionInitialFrame), @"未设置collectionNode的frame");
    return _collectionInitialFrame;
}

- (void)resignTextNodeFirstResponder {
    [self.inputToolBarNode.inputTextNode resignFirstResponder];
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
    
    
    CGRect barFrame = self.inputToolBarNode.frame;
    CGFloat riseHeight = CGRectGetHeight(self.view.bounds) - barFrame.origin.y - CGRectGetHeight(barFrame);
    CGFloat increaseHeight = riseHeight - kbSize.height;
    barFrame.origin.y = barFrame.origin.y + increaseHeight;
    self.inputToolBarNode.frame = barFrame;
    self.inputToolBarRiseFrame = self.inputToolBarNode.frame;
    self.inputToolBarNode.inputToolBarRiseFrame = self.inputToolBarNode.frame;

    
    CGPoint bottomOffset = CGPointMake(0, self.collectionNode.view.contentSize.height);
    [self.collectionNode.view setContentOffset:bottomOffset animated:NO];
    
    [UIView animateWithDuration:animationDuration
                          delay:0.f
                        options:animationCurveOption
                     animations:^{
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
                         
                         CGRect barFrame = self.inputToolBarNode.frame;
                         barFrame.origin.y = barY;
                         self.inputToolBarNode.frame = barFrame;
                         [self setupCollectionNodeFrameWithBarFrame:barFrame];
                         
                     } completion:nil];
}

- (void)setupCollectionNodeFrameWithBarFrame:(CGRect)barFrame {
    CGRect collectionNodeFrame = self.collectionNode.frame;
    collectionNodeFrame.size.height = barFrame.origin.y;
    self.collectionNode.frame = collectionNodeFrame;
}

#pragma mark - BLMessageInputToolBarNodeDelegate

- (void)    inputToolBarNode:(BLMessageInputToolBarNode *)inputToolBarNode
layoutTransitionWithBarFrame:(CGRect)barFrame
                    duration:(NSTimeInterval)duration {
    
    if (inputToolBarNode.inputToolBarCurrentState == BLInputToolBarStateKeyboard) {
        CGPoint bottomOffset = CGPointMake(0, self.collectionNode.view.contentSize.height);
        [self.collectionNode.view setContentOffset:bottomOffset animated:NO];
    }
    
    [self setupCollectionNodeFrameWithBarFrame:barFrame];
}

- (void)inputToolBarTextNodeDidUpdateText:(ASEditableTextNode *)editableTextNode
                           textNumberLine:(NSInteger)textNumberLine
                                barHeight:(CGFloat)barHeight {
    
}


- (void)    inputToolBarNode:(BLMessageInputToolBarNode *)inputToolBarNode
didClickSendButtonActionWithText:(NSString *)inputText {
    if ([self.delegate respondsToSelector:@selector(barViewController:didClickInputBarSendButtonWithInputText:)]) {
        [self.delegate barViewController:self didClickInputBarSendButtonWithInputText:inputText];
    }
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
