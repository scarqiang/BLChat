//
//  BLFaceBoardNode.m
//  BLChat
//
//  Created by HZQ on 17/2/6.
//  Copyright © 2017年 HZQ. All rights reserved.
//

#import <YYKit/UIImage+YYAdd.h>
#import <YYKit/UIColor+YYAdd.h>
#import "BLFaceBoardNode.h"
#import <libextobjc/extobjc.h>

CGFloat const kBLFaceBoardHeight = 169.f;
CGFloat const kBLFaceBoardButtonHeight = 40.f;
CGFloat const kBLFaceBoardButtonWidth = 63.f;
CGFloat const kBLFaceBoardSendButtonWidth = 80.f;
CGFloat const kBLFaceBoardTitleFontSize = 18.f;

@interface BLFaceBoardNode ()<FaceBoardDelegate>
@property (nonatomic, strong) FaceBoard *faceBoard;
@property (nonatomic, strong) ASDisplayNode *faceBoardNode;
@property (nonatomic, strong) ASButtonNode *recentButtonNode;
@property (nonatomic, strong) ASButtonNode *emojiButtonNode;
@property (nonatomic, strong) ASButtonNode *sendButtonNode;
@property (nonatomic, weak) id<BLFaceBoardNodeDelegate> delegate;
@end

@implementation BLFaceBoardNode

#pragma mark - view Lifecycle

- (instancetype)initWithDelegate:(id <BLFaceBoardNodeDelegate>)delegate textViewNode:(ASEditableTextNode *)textViewNode {
    
    self = [super init];

    if (self) {
        _delegate = delegate;
        [self setupSubNodesWithTextViewNode:textViewNode];
    }
    return self;
}

- (void)setupSubNodesWithTextViewNode:(ASEditableTextNode *)textNode {

    self.automaticallyManagesSubnodes = YES;
    self.backgroundColor = [UIColor colorWithHexString:@"efeeec"];

    _faceBoard = [[FaceBoard alloc] init];
    _faceBoard.delegate = self;
    _faceBoard.backgroundColor = [UIColor whiteColor];
    _faceBoard.inputTextView = textNode.textView;

    @weakify(self);
    _faceBoard.emojiClicked = ^(NSString *key,NSString *value){
        @strongify(self);
        [self writeRecentEmojiDataWithKey:key value:value];
    };

    _faceBoardNode = ({
       ASDisplayNode *node = [[ASDisplayNode alloc] initWithViewBlock:^UIView * {
           return _faceBoard;
       }];
        node.style.preferredSize = CGSizeMake( CGRectGetWidth([UIScreen mainScreen].bounds), kBLFaceBoardHeight);
        node;
    });

    UIImage *buttonBackNormalImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"efeeec"]];

    UIImage *buttonBackSelectImage = [UIImage imageWithColor:[UIColor whiteColor]];

    UIImage *sendButtonBackNormalImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"ff6003"]];

    _recentButtonNode = ({
        ASButtonNode *buttonNode = [ASButtonNode new];
        buttonNode.style.preferredSize = CGSizeMake(kBLFaceBoardButtonWidth, kBLFaceBoardButtonHeight);
        [buttonNode setImage:[UIImage imageNamed:@"emojiRecent_n"] forState:ASControlStateNormal];
        [buttonNode setImage:[UIImage imageNamed:@"emojiRecent_h"] forState:ASControlStateHighlighted];
        [buttonNode setBackgroundImage:buttonBackNormalImage forState:ASControlStateNormal];
        [buttonNode setBackgroundImage:buttonBackSelectImage forState:ASControlStateSelected];
        buttonNode;
    });

    _emojiButtonNode = ({
        ASButtonNode *buttonNode = [ASButtonNode new];
        buttonNode.style.preferredSize = CGSizeMake(kBLFaceBoardButtonWidth, kBLFaceBoardButtonHeight);
        [buttonNode setBackgroundImage:buttonBackNormalImage forState:ASControlStateNormal];
        [buttonNode setBackgroundImage:buttonBackSelectImage forState:ASControlStateSelected];
        [buttonNode setTitle:@"贝贝"
                    withFont:[UIFont systemFontOfSize:kBLFaceBoardTitleFontSize]
                   withColor:[UIColor colorWithHexString:@"666666"]
                    forState:ASControlStateNormal];
        buttonNode.selected = YES;
        buttonNode;
    });

    _sendButtonNode = ({
        ASButtonNode *buttonNode = [ASButtonNode new];
        buttonNode.style.preferredSize = CGSizeMake(kBLFaceBoardSendButtonWidth, kBLFaceBoardButtonHeight);
        [buttonNode setTitle:@"发送"
                    withFont:[UIFont systemFontOfSize:kBLFaceBoardTitleFontSize]
                   withColor:[UIColor whiteColor]
                    forState:ASControlStateNormal];
        [buttonNode setBackgroundImage:sendButtonBackNormalImage forState:ASControlStateNormal];
        buttonNode;
    });
}

- (void)didLoad {
    [super didLoad];
    [self.recentButtonNode addTarget:self
                              action:@selector(didClickRecentButtonNode:)
                    forControlEvents:ASControlNodeEventTouchUpInside];

    [self.emojiButtonNode addTarget:self
                             action:@selector(didClickEmojiButtonNode:)
                   forControlEvents:ASControlNodeEventTouchUpInside];

    [self.sendButtonNode addTarget:self
                            action:@selector(didClickSendButtonNode:)
                  forControlEvents:ASControlNodeEventTouchUpInside];
}

#pragma mark - Layout calculation

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    ASLayoutSpec *emptySpec = [ASLayoutSpec new];
    emptySpec.style.flexGrow = 1.f;

    NSArray *bottomChildren = @[self.recentButtonNode, self.emojiButtonNode, emptySpec, self.sendButtonNode];

    ASStackLayoutSpec *bottomLayoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                  spacing:0.f
                                                                           justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                                               alignItems:ASStackLayoutAlignItemsStretch
                                                                                 children:bottomChildren];

    return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                   spacing:0.f
                                            justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                alignItems:ASStackLayoutAlignItemsStretch
                                                  children:@[self.faceBoardNode, bottomLayoutSpec]];

}

#pragma mark - button node target action

- (void)didClickRecentButtonNode:(ASButtonNode *)buttonNode {
    buttonNode.selected = YES;
    self.emojiButtonNode.selected = NO;

    [self.faceBoard setKeyBoard:YES];
}

- (void)didClickEmojiButtonNode:(ASButtonNode *)buttonNode {
    buttonNode.selected = YES;
    self.recentButtonNode.selected = NO;

    [self.faceBoard setKeyBoard:NO];
}

- (void)didClickSendButtonNode:(ASButtonNode *)buttonNode {

}

#pragma mark - private function

- (void)writeRecentEmojiDataWithKey:(NSString *)key value:(NSString *)value {

    NSParameterAssert(key);
    NSParameterAssert(value);

    if (!key || !value) {
        return;
    }

    NSArray<NSDictionary *> *dicSaved = [[NSUserDefaults standardUserDefaults]valueForKey:EmojiRecent];
    NSDictionary *dic = @{key:value};

    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSDictionary *dictionary = evaluatedObject;

        return ![[dictionary allKeys][0] isEqualToString:key];
    }];

    NSArray *filterArray = [dicSaved filteredArrayUsingPredicate:predicate];
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:filterArray];

    [resultArray  insertObject:dic atIndex:0];

    [[NSUserDefaults standardUserDefaults]setObject:[resultArray copy] forKey:EmojiRecent];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - FaceBoard delegate
-(void)checkString {
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification
                                                        object:nil
                                                      userInfo:nil];
}
@end
