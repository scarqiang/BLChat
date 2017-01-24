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
#import "BLMessagesCollectionNode.h"
#import "BLMessagesCollectionNodeCellIncoming.h"

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
    BLMessagesCollectionNodeCellIncoming *cellIncoming = [BLMessagesCollectionNodeCellIncoming new];
    NSDictionary *attributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:12],
            NSForegroundColorAttributeName:[UIColor colorWithRed:53.f / 255.f green:53.f / 255.f blue:53.f / 255.f alpha:1.f]
    };

    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *formattedTimeAttributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:12.f],
            NSForegroundColorAttributeName:[UIColor colorWithRed:53.f / 255.f green:53.f / 255.f blue:53.f / 255.f alpha:1.f],
            NSParagraphStyleAttributeName: paragraphStyle
    };
    cellIncoming.timeSeparatorTextNode.attributedText = [[NSAttributedString alloc] initWithString:@"12:31"
                                                                             attributes:formattedTimeAttributes];
    cellIncoming.textMessageNode.attributedText = [[NSAttributedString alloc] initWithString:@"这是多么美好的一天"
                                                                                   attributes:attributes];
    cellIncoming.senderNameTextNode.attributedText = [[NSAttributedString alloc] initWithString:@"黄志强"
                                                                                   attributes:attributes];
    cellIncoming.avatarNode.image = [UIImage imageNamed:@"demo_avatar_cook"];
    cellIncoming.backgroundColor = [UIColor redColor];

    return cellIncoming;

}


- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGSize minItemSize = CGSizeMake(CGRectGetWidth(self.view.frame), 0);
    CGSize maxItemSize = CGSizeMake(CGRectGetWidth(self.view.frame), INFINITY);

    return ASSizeRangeMake(minItemSize, maxItemSize);
}

#pragma mark - chat view controller data source delegate
#pragma mark - collection cell delegate
@end
