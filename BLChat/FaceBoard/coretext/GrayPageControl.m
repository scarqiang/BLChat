//
//  GrayPageControl.m
//
//  Created by blue on 12-9-28.
//  Copyright (c) 2012年 blue. All rights reserved.
//  Email - 360511404@qq.com
//  http://github.com/bluemood
//

#import "GrayPageControl.h"
@implementation GrayPageControl
-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    activeImage = [UIImage imageNamed:@"active_page_image"];
    inactiveImage = [UIImage imageNamed:@"inactive_page_image"];
    [self setCurrentPage:1];
    return self;
}

- (id)initWithFrame:(CGRect)aFrame {
    
    if (self = [super initWithFrame:aFrame]) {
        activeImage = [UIImage imageNamed:@"active_page_image"];
        inactiveImage = [UIImage imageNamed:@"inactive_page_image"];
        [self setCurrentPage:1];
        self.currentPageIndicatorTintColor = [UIColor colorWithRed:99.0/255.0 green:109.0/255.0 blue:119.0/255.0 alpha:1];
        self.pageIndicatorTintColor = [UIColor colorWithRed:219.0/255.0 green:220.0/255.0 blue:223.0/255.0 alpha:1];
    }
    return self;
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
}
-(void)dealloc
{
//    [activeImage release];
//    [inactiveImage release];
//    [super dealloc];
}
@end
