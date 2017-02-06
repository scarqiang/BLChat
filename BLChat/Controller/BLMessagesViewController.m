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
#import "BLMessage.h"
#import "BLMessagesCollectionNodeCell.h"
#import "BLMessageInputToolBarViewController.h"

@interface BLMessagesViewController () <BLChatViewControllerDataSourceDelegate, BLMessagesCollectionNodeDelegate, BLMessagesCollectionNodeDataSource, ASCollectionViewDelegateFlowLayout>
//model
@property (nonatomic, strong) BLMessagesViewControllerDataSource *dataSource;
@property (nonatomic, strong) BLMessageInputToolBarViewController *inputToolBarViewController;
//views
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
        [self setupInputToolBar];
        [self configureCollectionNode];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSMutableArray<id<BLMessageData>> *messages = [NSMutableArray array];
    for (NSInteger i = 0; i < 2000; i++) {
        [messages addObject:[BLMessage randomSampleMessage]];
    }
    self.dataSource.messages = messages;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat collectionNodeHeight = CGRectGetHeight(self.node.bounds) - self.inputToolBarViewController.inputToolBarHeight;
    self.collectionNode.frame = CGRectMake(0, 0, CGRectGetWidth(self.node.bounds), collectionNodeHeight);
}

#pragma mark - setup input tool bar

- (void)setupInputToolBar {
    self.collectionNode.view.alwaysBounceVertical = YES;
    
    BLMessageInputToolBarViewController *viewController = [[BLMessageInputToolBarViewController alloc] init];
    _inputToolBarViewController = viewController;
    [self addChildViewController:viewController];
    [self.view addSubnode:viewController.node];
    [viewController didMoveToParentViewController:self];
}

#pragma mark - configure
- (void)configureCollectionNode {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 2;
    flowLayout.minimumInteritemSpacing = 0;
    _collectionNode = [[BLMessagesCollectionNode alloc] initWithCollectionViewLayout:flowLayout];
    _collectionNode.delegate = self;
    _collectionNode.dataSource = self;
    [self.node addSubnode:_collectionNode];
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
    cell.backgroundColor = [UIColor redColor];

    cell.delegate = collectionNode;
    return cell;

}

- (id<BLMessageData>)messageDataForCollectionNode:(BLMessagesCollectionNode *)collectionNode atIndexPath:(NSIndexPath *)indexPath {
    return self.dataSource.messages[(NSUInteger) indexPath.row];
}

- (nullable NSString *)formattedTimeForCollectionNode:(BLMessagesCollectionNode *)collectionNode
                                          atIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *previousIndexPath = indexPath.row == 0 ? nil : [NSIndexPath indexPathForItem:indexPath.row - 1 inSection:1];
    id<BLMessageData> currentMessageData = [collectionNode.dataSource messageDataForCollectionNode:collectionNode
                                                                                       atIndexPath:indexPath];
    id<BLMessageData> previousMessageData = !previousIndexPath ? nil : [collectionNode.dataSource messageDataForCollectionNode:collectionNode
                                                                                                                   atIndexPath:previousIndexPath];
    return @"12:33";
}

#pragma mark - collection node delegate
- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize minItemSize = CGSizeMake(CGRectGetWidth(self.view.frame), 0);
    CGSize maxItemSize = CGSizeMake(CGRectGetWidth(self.view.frame), INFINITY);
    
    return ASSizeRangeMake(minItemSize, maxItemSize);
}

- (void)  didTapContentNode:(BLMessagesContentNode *)contentNode
             inMessagesCell:(BLMessagesCollectionNodeCell *)cell
           inCollectionNode:(BLMessagesCollectionNode *)collectionNode
 preferredContentNodeAction:(BLMessagesContentNodeAction)action {
    if (!action) {
        return;
    }
    
    action(self, collectionNode, cell);
}
#pragma mark - chat view controller data source delegate
@end
