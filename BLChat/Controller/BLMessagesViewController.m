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

@interface BLMessagesViewController () <BLChatViewControllerDataSourceDelegate, BLMessagesCollectionNodeDelegate, ASCollectionDataSource, ASCollectionViewDelegateFlowLayout>
//model
@property (nonatomic, strong) BLMessagesViewControllerDataSource *dataSource;

//views
@property (nonatomic, strong) BLMessagesCollectionNode *collectionNode;
@end
@implementation BLMessagesViewController
#pragma mark - lifecycle
- (void)dealloc {
    
}

- (instancetype)init {
    self = [super initWithNode:[ASDisplayNode new]];
    if (self) {
        _dataSource = [[BLMessagesViewControllerDataSource alloc] init];
        _dataSource.delegate = self;
        
        [self configureCollectionNode];

    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.node.backgroundColor = [UIColor whiteColor];
    self.collectionNode.view.alwaysBounceVertical = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionNode.frame = self.node.bounds;
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
#pragma mark - collection node data source / delegate
- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    return 1;
}

- (ASCellNode *)collectionNode:(ASCollectionNode *)collectionNode nodeForItemAtIndexPath:(NSIndexPath *)indexPath {
    BLMessage *message = [BLMessage randomSampleMessage];
    BLMessagesCollectionNodeCell *cell = [[BLMessagesCollectionNodeCell alloc] initWithMessageDisplayType:BLMessageDisplayTypeLeft];
    cell.shouldDisplayName = YES;
    cell.contentNode = message.contentNode;
    cell.senderName = message.senderName;
    cell.avatarNode.image = message.avatarImage;
    cell.formattedTime = @"13: 43";
    cell.backgroundColor = [UIColor redColor];
    return cell;

}


- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGSize minItemSize = CGSizeMake(CGRectGetWidth(self.view.frame), 0);
    CGSize maxItemSize = CGSizeMake(CGRectGetWidth(self.view.frame), INFINITY);

    return ASSizeRangeMake(minItemSize, maxItemSize);
}

#pragma mark - chat view controller data source delegate
#pragma mark - collection cell delegate
@end
