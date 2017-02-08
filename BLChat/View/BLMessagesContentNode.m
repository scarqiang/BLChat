//
// Created by 黄泽宇 on 1/24/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//

#import "BLMessagesContentNode.h"

@interface BLMessagesContentNode ()
@property (nonatomic, weak) UIMenuController *menuController;
@property (nonatomic) UIMenuItem *theCopyMenuItem;
@property (nonatomic) UIMenuItem *deleteMenuItem;
@property (nonatomic) UIMenuItem *forwardMenuItem;

@end

@implementation BLMessagesContentNode
- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willHideMenu)
                                                     name:UIMenuControllerWillHideMenuNotification
                                                   object:nil];
    }

    return self;
}

- (void)willHideMenu {
    [self setHighlighted:NO];
}

- (void)didLoad {
    [super didLoad];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapContentNode)];
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressContentNode)];
    [self.view addGestureRecognizer:tapGR];
    [self.view addGestureRecognizer:longPressGestureRecognizer];
}

- (void)didLongPressContentNode {
    if (!self.menuController) {
        self.menuController = [UIMenuController sharedMenuController];
    }

    if (!self.theCopyMenuItem) {
        self.theCopyMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMenuAction:)];
    }

    if (!self.deleteMenuItem) {
        self.deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMenuAction:)];
    }

    if (!self.forwardMenuItem) {
        self.forwardMenuItem = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(forwardMenuAction:)];
    }

    [self.menuController setMenuItems:[self menuItemsForMenuController:self.menuController]];
    NSLog(@"%@", NSStringFromCGRect(self.frame));
    [self.menuController setTargetRect:self.frame inView:self.view.superview];
    [self becomeFirstResponder];
    [self.menuController setMenuVisible:YES animated:YES];
    [self setHighlighted:YES];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return YES;
}

- (void)forwardMenuAction:(id)forwardMenuAction {

}

- (void)deleteMenuAction:(id)deleteMenuAction {
    [self.delegate deleteMessageActionDidHappenInContentNode:self];
}

- (void)copyMenuAction:(id)copyMenuAction {

}

- (void)didTapContentNode {
    [self.menuController setMenuVisible:NO animated:YES];
}

- (void)setHighlighted:(BOOL)highlighted {
    NSAssert(NO, @"子类必需重写");
}

- (UIImage *)resizableBubbleImageForMessageDisplayType:(BLMessageDisplayType)displayType highlighted:(BOOL)highlighted {
    switch (displayType) {
        case BLMessageDisplayTypeLeft: {
            UIEdgeInsets capInsets = UIEdgeInsetsMake(
                    kBLMessagesIncomingBubbleCapTop,
                    kBLMessagesIncomingBubbleCapLeft,
                    kBLMessagesIncomingBubbleCapBottom,
                    kBLMessagesIncomingBubbleCapRight);
            NSString *imageName = highlighted ? kBLMessagesIncomingBubbleHighlightedImageName : kBLMessagesIncomingBubbleImageName;
            UIImage *image = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:capInsets
                                                                            resizingMode:UIImageResizingModeStretch];
            return image;
        }

        case BLMessageDisplayTypeCenter: {
            return nil;
        }

        case BLMessageDisplayTypeRight: {
            UIEdgeInsets capInsets = UIEdgeInsetsMake(
                    kBLMessagesIncomingBubbleCapTop,
                    kBLMessagesIncomingBubbleCapRight,
                    kBLMessagesIncomingBubbleCapBottom,
                    kBLMessagesIncomingBubbleCapLeft);
            NSString *imageName = highlighted ? kBLMessagesOutgoingBubbleHighlightedImageName : kBLMessagesOutgoingBubbleImageName;
            return [[UIImage imageNamed:imageName] resizableImageWithCapInsets:capInsets
                                                                  resizingMode:UIImageResizingModeStretch];
        }
    }

    NSAssert(NO, @"unexpected message display type");
    return nil;
}

- (ASLayoutSpec *)preferredLayoutSpec {
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) child:self];
}

- (void)addConstrainWithCollectionNodeCellConstrainedSize:(ASSizeRange)constrainedSize {

}

- (NSArray<UIMenuItem *> *)menuItemsForMenuController:(UIMenuController *)menuController {
    return @[self.theCopyMenuItem, self.deleteMenuItem, self.forwardMenuItem];
}
@end
