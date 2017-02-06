//
//  BLFaceBoardNode.h
//  BLChat
//
//  Created by HZQ on 17/2/6.
//  Copyright © 2017年 HZQ. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "FaceBoard.h"


@interface BLFaceBoardNode : ASDisplayNode
- (instancetype)initWithDelegate:(id<FaceBoardDelegate>)delegate;
@end
