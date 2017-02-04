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
@property (nonatomic) CGRect inputToolBarNormalFrame;
@property (nonatomic) CGRect inputToolBarRiseFrame;
@end

@implementation BLMessageInputToolBarViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super initWithNode:[ASDisplayNode new]];
    
    if (self) {
        [self setupSubNode];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotificationAction];
    
    // Do any additional setup after loading the view.
}

- (void)setupSubNode {
    _inputToolBarNode = [[BLMessageInputToolBarNode alloc] initWithDelegate:self];
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGSize size = [_inputToolBarNode layoutThatFits:ASSizeRangeMake(CGSizeZero, self.view.frame.size)].size;
    _inputToolBarNode.frame = CGRectMake(0, screenFrame.size.height - BLInputToolBarNodeHeight, CGRectGetWidth(screenFrame), size.height);
    _inputToolBarNormalFrame = _inputToolBarNode.frame;
    _inputToolBarNode.inputToolBarNormalFrame = _inputToolBarNormalFrame;
    [self.view addSubnode:self.inputToolBarNode];
    
}

#pragma mark - notification action

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
    
    [UIView animateWithDuration:animationDuration
                          delay:0.f
                        options:animationCurveOption
                     animations:^{
                         
                         CGRect barFrame = self.inputToolBarNode.frame;
                         CGFloat riseHeight = CGRectGetHeight([UIScreen mainScreen].bounds) - barFrame.origin.y - CGRectGetHeight(barFrame);
                         CGFloat increaseHeight = riseHeight - kbSize.height;
                         barFrame.origin.y = barFrame.origin.y + increaseHeight;
                         self.inputToolBarNode.frame = barFrame;
                         self.inputToolBarRiseFrame = self.inputToolBarNode.frame;
                         self.inputToolBarNode.inputToolBarRiseFrame = self.inputToolBarNode.frame;

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
                         
                         CGFloat barY = CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(self.inputToolBarNode.frame);
                         
                         CGRect barFrame = self.inputToolBarNode.frame;
                         barFrame.origin.y = barY;
                         self.inputToolBarNode.frame = barFrame;
                     } completion:nil];
}

#pragma mark - BLMessageInputToolBarNodeDelegate


- (void)inputToolBarTextNodeDidUpdateText:(ASEditableTextNode *)editableTextNode
                           textNumberLine:(NSInteger)textNumberLine
                                barHeight:(CGFloat)barHeight {
    
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
