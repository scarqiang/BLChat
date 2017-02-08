//
//  BLMessageInputToolBarViewController.h
//  BLChat
//
//  Created by HZQ on 17/1/24.
//  Copyright © 2017年 HZQ. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "BLMessageInputToolBarNode.h"

@class BLMessageInputToolBarViewController;

@protocol BLMessageInputToolBarViewControllerDelegate <NSObject>

- (void)barViewController:(BLMessageInputToolBarViewController *)viewController
didClickInputBarSendButtonWithInputText:(NSString *)inputText;

- (void)         barViewController:(BLMessageInputToolBarViewController *)viewController
didUpdateContentNodeWihtRiseHeight:(CGFloat)riseHeight;

@end

@interface BLMessageInputToolBarViewController : ASViewController
@property (nonatomic, readonly) CGFloat inputToolBarHeight;
@property (nonatomic, readonly) BLInputToolBarState inputToolBarState;

- (instancetype)initWithDelegate:(id <BLMessageInputToolBarViewControllerDelegate>)delegate;

- (void)resignTextNodeFirstResponder;

@end
