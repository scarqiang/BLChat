//
//  FaceBoard.m
//
//  Created by blue on 12-9-26.
//  Copyright (c) 2012年 blue. All rights reserved.
//  Email - 360511404@qq.com
//  http://github.com/bluemood

#import "FaceBoard.h"

@implementation FaceBoard
@synthesize inputTextField = _inputTextField;
@synthesize inputTextView = _inputTextView;

- (void)dealloc
{
//    [_faceMap release];
//    [_inputTextField release];
//    [_inputTextView release];
//    [faceView release];
//    [facePageControl release];
//    [super dealloc];
}

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 216 - 47)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _btnWidth = ([UIScreen mainScreen].bounds.size.width - 6*2) /7.0f ;
        
        _faceMap = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"faceMap_ch"
                                                                                              ofType:@"plist"]];
        
        //表情盘
        faceView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 190-47)];
        faceView.pagingEnabled = YES;
        faceView.backgroundColor = [UIColor whiteColor];
        faceView.contentSize = CGSizeMake((60/20)*[UIScreen mainScreen].bounds.size.width, 190 - 47);
        faceView.showsHorizontalScrollIndicator = NO;
        faceView.showsVerticalScrollIndicator = NO;
        faceView.delegate = self;
        
        for (int i = 1; i<=60; i++) {
            FaceButton *faceButton = [FaceButton buttonWithType:UIButtonTypeCustom];
            faceButton.buttonIndex = i;
            
            [faceButton addTarget:self
                           action:@selector(faceButton:)
                 forControlEvents:UIControlEventTouchUpInside];
            
            //计算每一个表情按钮的坐标和在哪一屏
            
            faceButton.frame = CGRectMake((((i-1)%20)%7)* _btnWidth + 6+((i-1)/20*[UIScreen mainScreen].bounds.size.width), (((i-1)%20)/7)*44+8, _btnWidth, _btnWidth);

            [faceButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%03d",i]] forState:UIControlStateNormal];
            [faceView addSubview:faceButton];
        }
        
        //添加PageControl
        facePageControl = [[GrayPageControl alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 100)/2.0f, 190-47, 100, 20)];
        [facePageControl addTarget:self
                            action:@selector(pageChange:)
                  forControlEvents:UIControlEventValueChanged];
        
        facePageControl.numberOfPages = 60/20;
        facePageControl.currentPage = 0;
        [self addSubview:facePageControl];
        
        //添加键盘View
        [self addSubview:faceView];
        
        //删除键
        
        for (int i=0; i<3; i++)
        {
            UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
//            [back setTitle:@"删除" forState:UIControlStateNormal];
            [back setImage:[UIImage imageNamed:@"backFace"] forState:UIControlStateNormal];
            [back setImage:[UIImage imageNamed:@"backFaceSelect"] forState:UIControlStateSelected];
            [back addTarget:self action:@selector(backFace) forControlEvents:UIControlEventTouchUpInside];
            back.frame = CGRectMake(6 + 6 *_btnWidth + i * [UIScreen mainScreen].bounds.size.width, 96, _btnWidth, _btnWidth);
            [faceView addSubview:back];
        }
    }
    return self;
}


-(void)setKeyBoard:(BOOL)isRecentlyUsed{
    
    if (isRecentlyUsed) {
        
        _btnWidth = ([UIScreen mainScreen].bounds.size.width - 6*2) /7.0f ;
        
        if (_recentFaceView == nil) {
            
            
            _recentFaceMap = [[NSUserDefaults standardUserDefaults]valueForKey:EmojiRecent];
            //表情盘
            _recentFaceView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 190 - 47)];
            _recentFaceView.pagingEnabled = YES;
            _recentFaceView.showsHorizontalScrollIndicator = NO;
            _recentFaceView.showsVerticalScrollIndicator = NO;
            _recentFaceView.delegate = self;
            _recentFaceView.backgroundColor = [UIColor whiteColor];
           
            _noHisHint = [[UILabel alloc]init];
            _noHisHint.backgroundColor = [UIColor clearColor];
//            _noHisHint.textColor = [@"666666" getColor];
            _noHisHint.text = @"用表情跟大家打个招呼吧，我都空好久了~";
            _noHisHint.textAlignment = NSTextAlignmentCenter;
            _noHisHint.frame = CGRectZero;
            _noHisHint.font = [UIFont systemFontOfSize:14];
            _noHisHint.hidden = YES;
            [_recentFaceView addSubview:_noHisHint];
            
            _recentFacePageControl = [[GrayPageControl alloc]initWithFrame:CGRectMake(0, 190-47, [UIScreen mainScreen].bounds.size.width, 20)];
            [_recentFacePageControl addTarget:self
                                       action:@selector(pageChange:)
                             forControlEvents:UIControlEventValueChanged];
            _recentFacePageControl.backgroundColor = [UIColor whiteColor];
            
            [self addSubview:_recentFacePageControl];
            [self addSubview:_recentFaceView];
        }
        
 ////////////

        _recentFaceMap = [[NSUserDefaults standardUserDefaults]valueForKey:EmojiRecent];

        int pages=0;
        BOOL hasRecent=NO;
        
        int remainder = [_recentFaceMap count]%20;
        int result = (int)[_recentFaceMap count]/20;
        
        if (remainder == 0) {
            pages = result;
        } else {
            pages = result+1;
        }
        if (pages == 0)  {
            hasRecent = NO;
            pages = 1;
        } else {
            hasRecent = YES;
        }
        
        _recentFaceView.contentSize = CGSizeMake(pages*[UIScreen mainScreen].bounds.size.width, 190-47);
        if (hasRecent) {
            
            _noHisHint.hidden = YES;
            
            _recentFacePageControl.numberOfPages = pages;
            _recentFacePageControl.currentPage = 0;
        
            for (int i = 1; i <= [_recentFaceMap  count]; i++) {
                int index = [[[_recentFaceMap  objectAtIndex:i-1] allKeys][0] intValue];
    
                FaceButton *faceButton = (FaceButton *)[_recentFaceView viewWithTag:100+i];
                if (faceButton==nil){
                    faceButton = [FaceButton buttonWithType:UIButtonTypeCustom];
                    faceButton.tag = 100+i;
                    [_recentFaceView addSubview:faceButton];
                }
                
                faceButton.buttonIndex = index;
                [faceButton addTarget:self
                               action:@selector(faceButton:)
                     forControlEvents:UIControlEventTouchUpInside];
                
                //计算每一个表情按钮的坐标和在哪一屏
                faceButton.frame = CGRectMake((((i-1)%20)%7)*_btnWidth+6+((i-1)/20*[UIScreen mainScreen].bounds.size.width), (((i-1)%20)/7)*44+8, _btnWidth, _btnWidth);
                
                [faceButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%03d",index]] forState:UIControlStateNormal];
            }

            for (int i = 0; i < pages; i++)
            {
                UIButton *back = (UIButton *)[_recentFaceView viewWithTag:1000+i];
                if (back == nil) {
                    back = [UIButton buttonWithType:UIButtonTypeCustom];
                    back.tag=1000+i;
                }
                
//                [back setTitle:@"删除" forState:UIControlStateNormal];
                [back setImage:[UIImage imageNamed:@"backFace"] forState:UIControlStateNormal];
                [back setImage:[UIImage imageNamed:@"backFaceSelect"] forState:UIControlStateSelected];
                [back addTarget:self action:@selector(backFace) forControlEvents:UIControlEventTouchUpInside];
                back.frame = CGRectMake(6 + 6 *_btnWidth + i * [UIScreen mainScreen].bounds.size.width, 96, _btnWidth, _btnWidth);
                [_recentFaceView addSubview:back];
            }

        }
        else  {
            _recentFacePageControl.numberOfPages = 0;
            _noHisHint.hidden = NO;
            _noHisHint.frame = CGRectMake(0, 56, [UIScreen mainScreen].bounds.size.width, 30);
        }
        
//MARK:
        
        _recentFaceView.hidden = NO;
        _recentFacePageControl.hidden = NO;
        _recentFaceView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 190 - 47);
        
        facePageControl.hidden = YES;
        faceView.hidden = YES;
        faceView.frame = CGRectZero;
        
        [self bringSubviewToFront:_recentFaceView];
        [self bringSubviewToFront:_recentFacePageControl];
        
//        [self sendSubviewToBack:faceView];
//        [self sendSubviewToBack:facePageControl];
    }
    else {
        _recentFacePageControl.hidden = YES;
        _recentFaceView.hidden = YES;
        _recentFaceView.frame = CGRectZero;
        
        facePageControl.hidden = NO;
        faceView.hidden = NO;
        faceView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 190-47);

        [self bringSubviewToFront:faceView];
        [self bringSubviewToFront:facePageControl];
        
//        [self sendSubviewToBack:_recentFaceView];
//        [self sendSubviewToBack:_recentFacePageControl];
    }
}

//停止滚动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == _recentFaceView) {
        [_recentFacePageControl setCurrentPage:_recentFaceView.contentOffset.x/[UIScreen mainScreen].bounds.size.width];
        [_recentFacePageControl updateCurrentPageDisplay];
    }else{
        [facePageControl setCurrentPage:faceView.contentOffset.x/[UIScreen mainScreen].bounds.size.width];
        [facePageControl updateCurrentPageDisplay];
    }
}

- (void)pageChange:(id)sender {
    GrayPageControl *control=(GrayPageControl *)sender;

    [faceView setContentOffset:CGPointMake(facePageControl.currentPage*[UIScreen mainScreen].bounds.size.width, 0) animated:YES];
    [control setCurrentPage:facePageControl.currentPage];
}
//- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)aString
- (void)faceButton:(id)sender {
    int i = ((FaceButton*)sender).buttonIndex;
//   if (self.inputTextField) {
//        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextField.text];
//        [faceString appendString:[_faceMap objectForKey:[NSString stringWithFormat:@"%03d",i]]];
//        self.inputTextField.text = faceString;
//        [faceString release];
//    }
    if (self.inputTextView) {
        
        NSRange range=self.inputTextView.selectedRange;
        
        if (range.location>self.inputTextView.text.length) {
            range=NSMakeRange(0, 0);
        }
    
        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextView.text];
        [faceString replaceCharactersInRange:range withString:[_faceMap objectForKey:[NSString stringWithFormat:@"%03d",i]]];
        self.inputTextView.text = faceString;
//        [faceString release];
        self.inputTextView.selectedRange=NSMakeRange(range.location+[[_faceMap objectForKey:[NSString stringWithFormat:@"%03d",i]] length],0);
        if (self.emojiClicked) {
            self.emojiClicked([NSString stringWithFormat:@"%03d",i],[_faceMap objectForKey:[NSString stringWithFormat:@"%03d",i]]);
        }
    }
    [self.delegate checkString];
}

- (void)backFace{
    NSRange range=self.inputTextView.selectedRange;
    if (range.location==0) {
        return;
    }
    NSString *inputString;
    inputString = self.inputTextField.text ;
    if (self.inputTextView) {
        inputString =self.inputTextView.text;
    }
    NSString *beforeString=[inputString substringToIndex:range.location];
    NSString *afterString= [inputString  substringFromIndex:range.location];
    
    NSString *string = nil;
    NSInteger stringLength = beforeString.length;
    if (stringLength > 0) {
        if ([@"]" isEqualToString:[beforeString substringFromIndex:stringLength-1]]) {
            if ([inputString rangeOfString:@"["].location == NSNotFound){
                string = [beforeString substringToIndex:stringLength - 1];
            } else {
                string = [beforeString substringToIndex:[beforeString rangeOfString:@"[" options:NSBackwardsSearch].location];
            }
        } else {
            string = [beforeString substringToIndex:stringLength - 1];
        }
    }
    self.inputTextView.text = [NSString stringWithFormat:@"%@%@",string,afterString];
    self.inputTextView.selectedRange=NSMakeRange(string.length,0);
    
    CGSize size = self.inputTextView.contentSize;
    NSLog(@"size is %@",NSStringFromCGSize(size));
    
    [self.delegate checkString];
}

@end
