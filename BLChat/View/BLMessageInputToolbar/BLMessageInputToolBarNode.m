//
//  BLMessageInputToolBarNode.m
//  BLChat
//
//  Created by HZQ on 17/1/24.
//  Copyright © 2017年 HZQ. All rights reserved.
//

#import "BLMessageInputToolBarNode.h"

@interface BLMessageInputToolBarNode ()
@property (nonatomic, strong) ASEditableTextNode *inputTextNode;
@property (nonatomic, strong) ASButtonNode *voiceButtonNode;
@property (nonatomic, strong) ASButtonNode *expressionButtonNode;
@property (nonatomic, strong) ASButtonNode *additionalButtonNode;
@end

@implementation BLMessageInputToolBarNode
- (instancetype)init {
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)setupSubNode {
    _voiceButtonNode = ({
        ASButtonNode *buttonNode = [ASButtonNode new];
        
        buttonNode;
    });
}

@end
