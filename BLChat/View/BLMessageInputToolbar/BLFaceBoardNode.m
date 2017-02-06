//
//  BLFaceBoardNode.m
//  BLChat
//
//  Created by HZQ on 17/2/6.
//  Copyright © 2017年 HZQ. All rights reserved.
//

#import "BLFaceBoardNode.h"

@implementation BLFaceBoardNode
- (instancetype)initWithDelegate:(id<FaceBoardDelegate>)delegate {
    self = [super initWithViewBlock:^UIView * _Nonnull{
        
        return [[FaceBoard alloc] init];
    }];
    
    return self;
}
@end
