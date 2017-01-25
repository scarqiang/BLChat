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
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 100, 50)];
    [self.view addSubview:textView];
}

- (void)setupSubNode {
    _inputToolBarNode = [[BLMessageInputToolBarNode alloc] initWithDelegate:self];
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    _inputToolBarNode.frame = CGRectMake(0, screenFrame.size.height - BLInputToolBarNodeHeight, CGRectGetWidth(screenFrame), BLInputToolBarNodeHeight);
    [self.view addSubnode:self.inputToolBarNode];
    
}

#pragma mark - notification action

- (void)addNotificationAction {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
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
                         barFrame.origin.y = barFrame.origin.y - kbSize.height;
                         self.inputToolBarNode.frame = barFrame;
                         
                     } completion:nil];
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
