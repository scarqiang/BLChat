//
// Created by 黄泽宇 on 1/25/17.
// Copyright (c) 2017 HZQ. All rights reserved.
//

#import "BLMessagesPhotoContentNode.h"
#import "BLMessagesConstant.h"

/**
 * 一个view中导入viewController、superview以及superview的superview，乖乖的，但这里只是为了在代理action中处理点击相关逻辑，无妨
 */
#import "BLMessagesViewController.h"
#import "BLMessagesCollectionNode.h"
#import "BLMessagesCollectionNodeCell.h"

@interface BLMessagesPhotoContentNode ()
@property (nonatomic) ASNetworkImageNode *photoNode;

@property (nonatomic, copy) NSURL *photoURL;
@property (nonatomic) BLMessageDisplayType messageDisplayType;
@property (nonatomic) UIImage *photoImage;
@end

@implementation BLMessagesPhotoContentNode
- (instancetype)initWithImage:(UIImage *)image messageDisplayType:(BLMessageDisplayType)displayType {
    NSParameterAssert(image);
    NSParameterAssert(displayType != BLMessageDisplayTypeCenter);
    self = [super init];
    if (self) {

        _photoImage = image;
        _messageDisplayType = displayType;

        _photoNode = ({
            ASNetworkImageNode *imageNode = [ASNetworkImageNode new];
            imageNode.image = image;
            imageNode.style.preferredSize = [self photoDisplaySizeWithPhotoSize:image.size];
            [self maskImageNode:imageNode withImage:[self resizableBubbleImageForMessageDisplayType:displayType]];

            imageNode;
        });
        
        
        [self addSubnode:_photoNode];

    }

    return self;
}

+ (instancetype)photoContentNodeWithImage:(UIImage *)image messageDisplayType:(BLMessageDisplayType)displayType {
    return [[self alloc] initWithImage:image messageDisplayType:displayType];
}

- (void)didTapContentNode {
    [self.delegate didTapMessagesContentNode:self preferredAction:^(BLMessagesViewController *messagesViewController,
            BLMessagesCollectionNode *collectionNode, BLMessagesCollectionNodeCell *collectionNodeCell) {
        NSLog(@"photo is tapped");
    }];
}

- (void)maskImageNode:(ASImageNode *)imageNode withImage:(UIImage *)image {
    NSParameterAssert(imageNode != nil);
    NSParameterAssert(image != nil);
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.contents = (id)image.CGImage;
    maskLayer.contentsScale = [UIScreen mainScreen].scale;
    maskLayer.contentsCenter = [self normalizedCapInsetsOfImage:image];
    maskLayer.frame = CGRectMake(0, 0, imageNode.style.preferredSize.width, imageNode.style.preferredSize.height);
    imageNode.layer.mask = maskLayer;
}

- (CGSize)photoDisplaySizeWithPhotoSize:(CGSize)size {
    
    if (size.width < 0.001 || size.height < 0.001) {
        return CGSizeZero;
    }
    
    if (size.width < kBLMessagesPhotoMessageMaxWidth && size.height < kBLMessagesPhotoMessageMaxHeight) {
        return size;
    }
    
    CGFloat photoRatio = size.height / size.width;
    CGFloat kBLMessagesPhotoMessageRatio = kBLMessagesPhotoMessageMaxHeight / kBLMessagesPhotoMessageMaxWidth;
    
    if (photoRatio > kBLMessagesPhotoMessageRatio) {
        return CGSizeMake(kBLMessagesPhotoMessageMaxHeight / photoRatio, kBLMessagesPhotoMessageMaxHeight);
    } else {
        return CGSizeMake(kBLMessagesPhotoMessageMaxWidth, kBLMessagesPhotoMessageMaxWidth * photoRatio);
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) child:self.photoNode];
}

- (CGRect)normalizedCapInsetsOfImage:(UIImage *)image {
    if (UIEdgeInsetsEqualToEdgeInsets(image.capInsets, UIEdgeInsetsZero) || image.size.height < 0.001 || image.size.width < 0.001) {
        return CGRectMake(0, 0, 1, 1);
    } else {
            return CGRectMake(image.capInsets.left / image.size.width,
                              image.capInsets.top / image.size.height,
                              (image.size.width - image.capInsets.right - image.capInsets.left) / image.size.width,
                              (image.size.height - image.capInsets.bottom - image.capInsets.top) / image.size.height);
    }
}
@end
