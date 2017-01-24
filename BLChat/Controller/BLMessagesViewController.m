//
//  BLMessagesViewController.m
//  BLMessagesCollectionNode
//
//  Created by 黄泽宇 on 1/23/17.
//  Copyright © 2017 HZQ. All rights reserved.
//

#import "BLMessagesViewController.h"
#import "BLMessagesViewControllerDataSource.h"
#import "BLChatCollectionNode.h"

@interface BLMessagesViewController () <BLChatViewControllerDataSourceDelegate, BLMessagesCollectionNodeDelegate, ASCollectionDataSource, ASCollectionViewDelegateFlowLayout>
//model
@property (nonatomic, strong) BLMessagesViewControllerDataSource *dataSource;

//views
@property (nonatomic, strong) BLChatCollectionNode *collectionNode;
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
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionNode.frame = self.node.bounds;
}
#pragma mark - configure
- (void)configureCollectionNode {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    _collectionNode = [[BLChatCollectionNode alloc] initWithCollectionViewLayout:flowLayout];
    _collectionNode.delegate = self;
    _collectionNode.dataSource = self;
    [self.node addSubnode:_collectionNode];
}
#pragma mark - collection node data source / delegate
- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    return 1;
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    return ^{
        ASCellNode *cell = [[ASCellNode alloc] init];
        cell.backgroundColor = [UIColor redColor];
        return cell;
    };
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGSize itemSize = CGSizeMake(CGRectGetWidth(self.view.frame), 200);
    return ASSizeRangeMake(itemSize, itemSize);
}

#pragma mark - chat view controller data source delegate
#pragma mark - collection cell delegate
@end
