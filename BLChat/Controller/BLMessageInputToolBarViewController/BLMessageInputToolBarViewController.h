//
//  BLMessageInputToolBarViewController.h
//  BLChat
//
//  Created by HZQ on 17/1/24.
//  Copyright © 2017年 HZQ. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class BLMessageInputToolBarViewController;

@protocol BLMessageInputToolBarViewControllerDelegate <NSObject>

- (void)barViewController:(BLMessageInputToolBarViewController *)viewController
didClickInputBarSendButtonWithInputText:(NSString *)inputText;

@end

@interface BLMessageInputToolBarViewController : ASViewController
@property (nonatomic, readonly) CGFloat inputToolBarHeight;
@property (nonatomic) CGRect collectionInitialFrame;

- (instancetype)initWithContentCollectionNode:(ASCollectionNode *)collectionNode delegate:(id<BLMessageInputToolBarViewControllerDelegate>)delegate;

- (void)resignTextNodeFirstResponder;

@end
