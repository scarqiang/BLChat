//
//  BLFaceBoardNode.h
//  BLChat
//
//  Created by HZQ on 17/2/6.
//  Copyright © 2017年 HZQ. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "FaceBoard.h"

@protocol BLFaceBoardNodeDelegate <NSObject>
@end

@interface BLFaceBoardNode : ASDisplayNode

- (instancetype)initWithDelegate:(id <BLFaceBoardNodeDelegate>)delegate textViewNode:(ASEditableTextNode *)textViewNode;
@end
