//
//  NSThreadLoadViewController.m
//  Muti-Thread
//
//  Created by intern08 on 10/9/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import "NSThreadLoadViewController.h"
@interface NSThreadLoadViewController ()
- (IBAction)loadImage:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *loadingLb;

@end

@implementation NSThreadLoadViewController
{
    NSString *imgUrl;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.loadingLb setHidden:YES];
    imgUrl = @"https://d262ilb51hltx0.cloudfront.net/fit/t/880/264/1*zF0J7XHubBjojgJdYRS0FA.jpeg";
}

- (IBAction)loadImage:(UIButton *)sender {
     [self.loadingLb setHidden:NO];
    [self.imageView setImage:nil];
    int index = (int)(sender.tag);
    switch (index) {
        case 1:
             [self dynamicCreateThread];
            break;
        case 2:
            [self staticCreateThread];
            break;
        case 3:
            [self implicitCreateThread];
            break;
            
        default:
            break;
    }
}
//第一种：动态创建线程,先创建NSThread的实例，然后再启动线程。这又称为动态创建方式
-(void)dynamicCreateThread{
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(loadImageSource:) object:imgUrl];
    [thread start];
}

//第二种：直接创建并启动线程。这个即OS X v10.5前支持的方式，又称静态创建方式。
-(void)staticCreateThread{
    [NSThread detachNewThreadSelector:@selector(loadImageSource:) toTarget:self withObject:imgUrl];
}

//第三种方式：隐式的创建并启动线程。本质是通过NSObject类的实例方法performSelectorInBackground: withObject:创建一个后台线程执行特定方法。
-(void)implicitCreateThread {
    [self performSelectorInBackground:@selector(loadImageSource:)  withObject:imgUrl];
}
-(void)loadImageSource:(NSString *)url{
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [UIImage imageWithData:imgData];
    if (imgData!=nil) {
//        若wait是YES，则等待当前线程执行完以后，主线程才会执行aSelector方法；若wait是NO，则不等待当前线程执行完，就在主线程上执行aSelector方法。另外，如果当前线程是主线程，则立即执行aSelector方法。
        [self performSelectorOnMainThread:@selector(refreshImageView:) withObject:image waitUntilDone:YES];
    }else{
        NSLog(@"there no image data");
    }
    
}

-(void)refreshImageView:(UIImage *)image{
    [self.loadingLb setHidden:YES];
    [self.imageView setImage:image];
}

@end
