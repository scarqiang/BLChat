//
//  BLMessagesViewController.m
//  BLChat
//
//  Created by 黄泽宇 on 1/23/17.
//  Copyright © 2017 HZQ. All rights reserved.
//

#import "BLMessagesViewController.h"
#import "BLMessagesViewControllerDataSource.h"
#import "BLMessagesCollectionNode.h"
#import "BLDateFormatter.h"
#import "BLTextMessage.h"
#import "BLMessageInputToolBarViewController.h"

@interface BLMessagesViewController () <BLMessagesViewControllerDataSourceDelegate, BLMessagesCollectionNodeDelegate, BLMessagesCollectionNodeDataSource, ASCollectionViewDelegateFlowLayout, BLMessageInputToolBarViewControllerDelegate>
//model
@property (nonatomic, strong) BLMessagesViewControllerDataSource *dataSource;

//views
@property (nonatomic, strong) BLMessageInputToolBarViewController *inputToolBarViewController;
@property (nonatomic, strong) BLMessagesCollectionNode *collectionNode;
@end

@implementation BLMessagesViewController
#pragma mark - lifecycle
- (instancetype)init {
    self = [super initWithNode:[ASDisplayNode new]];
    if (self) {
        self.node.backgroundColor = [UIColor whiteColor];
        _dataSource = [[BLMessagesViewControllerDataSource alloc] init];
        _dataSource.delegate = self;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureCollectionNode];
    
    NSMutableArray<id<BLMessageData>> *messages = [NSMutableArray array];

    for (NSInteger i = 0; i < 200; i++) {
        [messages addObject:[BLMessage randomSampleMessage]];
    }
    self.dataSource.messages = messages;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.dataSource.didScrollToBottomWhenFirstLoading) {
        [self scrollToBottom:NO];
        self.dataSource.didScrollToBottomWhenFirstLoading = YES;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

}

#pragma mark - configure
- (void)configureCollectionNode {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    self.collectionNode = [[BLMessagesCollectionNode alloc] initWithCollectionViewLayout:flowLayout];
    self.collectionNode.delegate = self;
    self.collectionNode.dataSource = self;
    [self.node addSubnode:self.collectionNode];
    [self setupInputToolBarWithCollectionNode:self.collectionNode];
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat collectionNodeHeight = CGRectGetHeight(self.node.bounds) - self.inputToolBarViewController.inputToolBarHeight - navigationBarHeight - statusBarHeight;
    self.collectionNode.frame = CGRectMake(0, 0, CGRectGetWidth(self.node.bounds), collectionNodeHeight);
    self.inputToolBarViewController.collectionInitialFrame = self.collectionNode.frame;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignInputTextNodeFirstResponder:)];
    [self.collectionNode.view addGestureRecognizer:tap];
}

- (void)setupInputToolBarWithCollectionNode:(ASCollectionNode *)collectionNode {
    self.collectionNode.view.alwaysBounceVertical = YES;
    
    BLMessageInputToolBarViewController *viewController = [[BLMessageInputToolBarViewController alloc] initWithContentCollectionNode:collectionNode delegate:self];
    self.inputToolBarViewController = viewController;
    [self addChildViewController:viewController];
    [self.node addSubnode:viewController.node];
    [viewController didMoveToParentViewController:self];
    [self.node.view sendSubviewToBack:viewController.view];
}

- (void)resignInputTextNodeFirstResponder:(UITapGestureRecognizer *)tap {
    [self.inputToolBarViewController resignTextNodeFirstResponder];
}

#pragma mark - private method
- (void)scrollToBottom:(BOOL)animated {
    [self.collectionNode scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.dataSource.messages.count - 1 inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionBottom
                                        animated:animated];
}
#pragma mark - collection node data source
- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.messages.count;
}

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    return 1;
}

- (ASCellNode *)collectionNode:(BLMessagesCollectionNode *)collectionNode nodeForItemAtIndexPath:(NSIndexPath *)indexPath {
    BLMessage *message = [collectionNode.dataSource messageDataForCollectionNode:collectionNode atIndexPath:indexPath];
    BLMessagesCollectionNodeCell *cell = [[BLMessagesCollectionNodeCell alloc] initWithMessageDisplayType:message.messageDisplayType];
    cell.shouldDisplayName = NO;
    cell.contentNode = message.contentNode;
    cell.senderName = message.senderName;
    cell.avatarNode.image = message.avatarImage;
    cell.formattedTime = [collectionNode.dataSource formattedTimeForCollectionNode:collectionNode atIndexPath:indexPath];
    cell.messageLoadingStatus = message.messageLoadingStatus;
    cell.delegate = collectionNode;
    return cell;

}

- (id<BLMessageData>)messageDataForCollectionNode:(BLMessagesCollectionNode *)collectionNode atIndexPath:(NSIndexPath *)indexPath {
    return self.dataSource.messages[(NSUInteger) indexPath.row];
}

- (nullable NSString *)formattedTimeForCollectionNode:(BLMessagesCollectionNode *)collectionNode
                                          atIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath *previousIndexPath = indexPath.row == 0 ? nil : [NSIndexPath indexPathForItem:indexPath.row - 1 inSection:1];
    id<BLMessageData> previousMessageData = !previousIndexPath ? nil : [collectionNode.dataSource messageDataForCollectionNode:collectionNode
                                                                                                                   atIndexPath:previousIndexPath];
    id<BLMessageData> currentMessageData = [collectionNode.dataSource messageDataForCollectionNode:collectionNode
                                                                                       atIndexPath:indexPath];
    if (!previousMessageData) {
        return [[BLDateFormatter sharedInstance] formattedChatTime:currentMessageData.sendingTime];
    }

    NSTimeInterval timeDiff = currentMessageData.sendingTime - previousMessageData.sendingTime;
    if (timeDiff < 60) {
        return nil;
    } else {
        return [[BLDateFormatter sharedInstance] formattedChatTime:currentMessageData.sendingTime];
    }
}

#pragma mark - collection node delegate
- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize minItemSize = CGSizeMake(CGRectGetWidth(self.view.frame), 0);
    CGSize maxItemSize = CGSizeMake(CGRectGetWidth(self.view.frame), INFINITY);
    
    return ASSizeRangeMake(minItemSize, maxItemSize);
}

- (void)collectionNode:(ASCollectionNode *)collectionNode willDisplayItemWithNode:(ASCellNode *)node {
    BLMessagesCollectionNodeCell *nodeCell = (BLMessagesCollectionNodeCell *) node;
    [nodeCell checkMessageLoadingStatus];
}

- (void)didTapContentNode:(BLMessagesContentNode *)contentNode
           inMessagesCell:(BLMessagesCollectionNodeCell *)cell
         inCollectionNode:(BLMessagesCollectionNode *)collectionNode
 performContentNodeAction:(BLMessagesContentNodeAction)action {
    if (!action) {
        return;
    }

    action(self, collectionNode, cell);
}

- (void)didTapAccessoryButtonInCell:(BLMessagesCollectionNodeCell *)cell collectionNode:(BLMessagesCollectionNode *)collectionNode {
    cell.messageLoadingStatus = BLMessageLoadingStatusLoadingSuccess;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.inputToolBarViewController resignTextNodeFirstResponder];
}

#pragma mark - BLMessagesViewControllerDataSource

- (void)messagesViewControllerDataSource:(BLMessagesViewControllerDataSource *)dateSource
                    didReceiveNewMessage:(id <BLMessageData>)newMessage {
    NSIndexPath *indexPath = [self.dataSource indexPathOfMessage:newMessage];
    if (!indexPath) return;
    [self.collectionNode performBatchUpdates:^{
        [self.collectionNode insertItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self scrollToBottom:YES];
    }];
}

- (void)messagesViewControllerDataSource:(BLMessagesViewControllerDataSource *)dateSource
           messageDidChangeLoadingStatus:(id <BLMessageData>)message {
    NSIndexPath *indexPath = [self.dataSource indexPathOfMessage:message];
    if (!indexPath) return;
    BLMessagesCollectionNodeCell *nodeCell = [self.collectionNode nodeForItemAtIndexPath:indexPath];
    nodeCell.messageLoadingStatus = message.messageLoadingStatus;
}
#pragma mark - BLMessageInputToolBarViewControllerDelegate
- (void)barViewController:(BLMessageInputToolBarViewController *)viewController didClickInputBarSendButtonWithInputText:(NSString *)inputText {
    BLTextMessage *textMessage = [BLTextMessage textMessageWithText:inputText
                                                 messageDisplayType:BLMessageDisplayTypeRight];
    textMessage.messageLoadingStatus = BLMessageLoadingStatusLoading;
    [self.dataSource didReceiveNewMessage:textMessage];
}

@end
