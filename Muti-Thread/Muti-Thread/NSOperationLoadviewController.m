//
//  NSOperationLoadviewController.m
//  Muti-Thread
//
//  Created by intern08 on 10/9/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import "NSOperationLoadviewController.h"
#import "LoadImageOperation.h"

@interface NSOperationLoadviewController ()<LoadImageDelegate> 
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *loadingLb;
- (IBAction)loadImage:(id)sender;

@end


@implementation NSOperationLoadviewController
{
     NSString *imgUrl;
}

-(void)viewDidLoad{
    [super viewDidLoad];
     [self.loadingLb setHidden:YES];
    imgUrl = @"https://d262ilb51hltx0.cloudfront.net/fit/t/880/264/1*kE8-X3OjeiiSPQFyhL2Tdg.jpeg";
    
}

- (IBAction)loadImage:(id)sender {
    [self.loadingLb setHidden:NO];
    
    [self.imageView setImage:nil];
    
    int index = (int)((UIButton *)sender).tag;
    
    switch (index) {
        case 1:
            [self useInvocationOperation];
            break;
        case 2:
            [self useBlockOperation];
            break;
        case 3:
            [self useSubclassOperation];
            break;
            
        default:
            break;
    }

}
//使用子类NSInvocationOperation
-(void)useInvocationOperation{
    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(loadImageSource:)  object:imgUrl];
//    [invocationOperation start];//直接会在当前线程主线程执行
//
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:invocationOperation];
    
}

//使用子类NSBlockOperation
-(void)useBlockOperation {
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        [self loadImageSource:imgUrl];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:blockOperation];
}

//使用继承NSOperation
-(void)useSubclassOperation{
    LoadImageOperation *imageOperation = [LoadImageOperation new];
    imageOperation.loadDelegate = self;
    imageOperation.imgUrl = imgUrl;
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:imageOperation];
}

-(void) loadImageFinish:(UIImage *)image{
    [self.loadingLb setHidden:YES];
    [self.imageView setImage:image];
}

-(void)loadImageSource:(NSString *)url{
    NSLog(@"current thread=%@",[NSThread currentThread]);
    
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [UIImage imageWithData:imgData];
    if (imgData!=nil) {
        [self performSelectorOnMainThread:@selector(refreshImageView1:) withObject:image waitUntilDone:YES];
    }else{
        NSLog(@"there no image data");
    }
    
}

-(void)refreshImageView1:(UIImage *)image{
    [self.loadingLb setHidden:YES];
    [self.imageView setImage:image];
}

@end
