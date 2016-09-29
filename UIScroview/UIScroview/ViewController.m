//
//  ViewController.m
//  UIScroview
//
//  Created by intern08 on 9/29/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //建立内容视图,imageView的frame.origin以父scrollView为原点(0,0)，imageView.origin为(0,0).
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"splash"]];
    
    // 滚动条样式
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    // 是否显示水平滚动条
    self.scrollView.showsHorizontalScrollIndicator = YES;
    // 是否显示垂直滚动条
    self.scrollView.showsVerticalScrollIndicator =YES;
    
    //告诉UIScrollView所有内容的尺寸,也就是告诉它滚动的范围,包含当前scroview的大小。
    self.scrollView.contentSize = imageView.bounds.size;
    
    //contentOffset默认为(0,0)，即只显示图片左上角，contentOffset为偏离默认状态距离的度量。
    self.scrollView.contentOffset = CGPointMake(200, 200);
    //scroview的、frame.origin以父view为原点(0,0).
    [self.scrollView addSubview:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
