//
//  HorizontalScroller.m
//  IOS-Design-Patterns
//
//  Created by intern08 on 9/29/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import "HorizontalScroller.h"

#define VIEW_PADDING 10
#define VIEW_DIMENSIONS 100
#define VIEWS_OFFSET 100

@interface HorizontalScroller ()<UIScrollViewDelegate>
{
    
}

@end

@implementation HorizontalScroller
{
    UIScrollView *scroller;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scroller.delegate = self;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollerTapped:)];
        [scroller addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)scrollerTapped:(UITapGestureRecognizer*)gesture {
    CGPoint location = [gesture locationInView:gesture.view];
    for (int index=0; index<[self.delegate numberOfViewsForHorizontalScroller:self]; index++) {
        UIView *view = scroller.subviews[index];
        if (CGRectContainsPoint(view.frame, location)) {
            [self.delegate horizontalScroller:self clickedViewAtIndex:index];
            [scroller setContentOffset:CGPointMake(view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, 0) animated:YES];
            break;
        }
    }
}

- (void)reload {
    // 1 - nothing to load if there's no delegate
    if (self.delegate ==nil) return;
     // 2 - remove all subviews
    [scroller.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    // 3 - xValue is the starting point of the views inside the scroller
    CGFloat xValue = VIEWS_OFFSET;
    
}

@end
