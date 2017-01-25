//
//  FaceBoard.h
//
//  Created by blue on 12-9-26.
//  Copyright (c) 2012年 blue. All rights reserved.
//  Email - 360511404@qq.com
//  http://github.com/bluemood

#define EmojiRecent @"EmojiRecent"

typedef void  (^EmojiClicked)(NSString *key,NSString *value);

#import <UIKit/UIKit.h>
#import "FaceButton.h"
#import "GrayPageControl.h"
@protocol FaceBoardDelegate <NSObject>

@optional

-(void)checkString;

@end

@interface FaceBoard : UIView<UIScrollViewDelegate>{
    UIScrollView *faceView;
    GrayPageControl *facePageControl;
    NSDictionary *_faceMap;
    
    UIScrollView        *_recentFaceView;
    GrayPageControl     *_recentFacePageControl;
    NSArray             *_recentFaceMap;
    UILabel             *_noHisHint;
    
    float               _btnWidth;
}
@property (nonatomic, retain) UITextField *inputTextField;
@property (nonatomic, retain) UITextView *inputTextView;
@property(nonatomic,assign)id <FaceBoardDelegate>delegate;
@property(nonatomic,copy)EmojiClicked  emojiClicked;//聊天时emoji被点过的blocks
-(void)setKeyBoard:(BOOL)isRecentlyUsed;

@end



