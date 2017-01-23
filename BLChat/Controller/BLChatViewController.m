//
//  BLChatViewController.m
//  BLChat
//
//  Created by 黄泽宇 on 1/23/17.
//  Copyright © 2017 HZQ. All rights reserved.
//

#import "BLChatViewController.h"
#import "BLChatViewControllerDataSource.h"
#import "BLChatCollectionNode.h"

@interface BLChatViewController () <BLChatViewControllerDataSourceDelegate, BLChatCollectionNodeDelegate, ASCollectionDataSource>
//model
@property (nonatomic, strong) BLChatViewControllerDataSource *dataSource;

//views
@property (nonatomic, strong) BLChatCollectionNode *collectionNode;
@end
@implementation BLChatViewController
#pragma mark - lifecycle
- (instancetype)init {
    self = [super initWithNode:[ASDisplayNode new]];
    if (self) {
        _dataSource = [[BLChatViewControllerDataSource alloc] init];
        _dataSource.delegate = self;

        _collectionNode = [BLChatCollectionNode new];
        _collectionNode.delegate = self;
        _collectionNode.dataSource = self;
        [self.node addSubnode:_collectionNode];
    }

    return self;
}
#pragma mark - collection node data source
#pragma mark - collection node delegate
#pragma mark - chat view controller data source delegate
#pragma mark - collection cell delegate
@end
