//
//  ViewController.m
//  VedeoPlayer
//
//  Created by intern08 on 11/18/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

@interface ViewController ()

- (IBAction)play:(id)sender;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerViewController *playerVC;
@property (nonatomic, strong) MPMoviePlayerController *mpMovieplayer;
@property (nonatomic, strong) MPMoviePlayerViewController *mpMovieViewplayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


//    //1.AVPlayer,最简单的视频播放器
//    AVPlayer *player = self.player;

     //2.AVPlayerViewController，有基本的播放控件
//    AVPlayerViewController *playerVC = self.playerVC;
//    playerVC.view.frame = CGRectMake(50, 50, 300, 350);
//    [self.view addSubview:playerVC.view];
//     playerVC.player.externalPlaybackVideoGravity = AVLayerVideoGravityResizeAspectFill;//这个属性和图片填充试图的属性类似，也可以设置为自适应试图大小。

    //3.MPMoviePlayerController,已弃用
    //  MPMoviePlayerController *player = self.mpMovieplayer;
    
    //4.MPMoviePlayerViewController，已弃用
    // [self presentMoviePlayerViewControllerAnimated:self.mpMovieViewplayer];
    
//    [player play];

    
}

- (IBAction)play:(id)sender {
    NSString *url = @"http://120.25.226.186:32812/resources/videos/minion_01.mp4";
    AVURLAsset *videoURLAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:url] options:nil];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:videoURLAsset];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    layer.frame = CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height-44);
    [self.view.layer addSublayer:layer];
    [player play];
}

- (AVPlayer *)player {
    if (_player == nil) {
        // 1.获取URL(远程/本地)
        NSURL *url = [NSURL URLWithString:@"http://v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4"];
        // 2.创建AVPlayerItem
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
        
        //    duration   当前播放元素的总时长
        //    status  加载的状态          AVPlayerItemStatusUnknown,  未知状态
        //    AVPlayerItemStatusReadyToPlay,  准备播放的状态
        //    AVPlayerItemStatusFailed   失败的状态
        
        //    时间控制的类目
        //    current
        //    forwordPlaybackEndTime   跳到结束位置
        //    reversePlaybackEndTime    跳到开始位置
        //    seekToTime   跳到指定位置
        
        // 3.创建AVPlayer
        //也可以直接WithURL来获得一个地址的视频文件
        //    externalPlaybackVideoGravity    视频播放的样式
        //AVLayerVideoGravityResizeAspect   普通的
        //    AVLayerVideoGravityResizeAspectFill   充满的
        //    currentItem  获得当前播放的视频元素
        
        [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        
        _player = [AVPlayer playerWithPlayerItem:item];
        // 4.添加AVPlayerLayer
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
//        layer.frame = CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.width* 9 / 16);
        // 显示播放视频的视图层要添加到self.view的视图层上面
        [self.view.layer addSublayer:layer];
        
    }
    return _player;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    switch ([change[@"new"]integerValue]) {
        case 0:
             NSLog(@"未知状态");
            break;
        case 1:{
            NSLog(@"获得视频总时长  %f",CMTimeGetSeconds(self.player.currentItem.duration));//CMTime在下面会介绍
            break;
        }
        case 2:{
            NSLog(@"加载失败");
            break;
        }
        default:
            break;
    }
}

- (AVPlayerViewController *)playerVC {
    if (_playerVC == nil) {
         //创建一个视频播放控制器
        _playerVC = [[AVPlayerViewController alloc]init];
        //获取视频URL（远程、本地视频URL都可以）
//           NSURL *url = [NSURL URLWithString:@"http://v1.mukewang.com/19954d8f-e2c2-4c0a-b8c1-a4c826b5ca8b/L.mp4"];
//        //根据URL创建播放曲目
//        AVPlayerItem * item = [AVPlayerItem playerItemWithURL:url];
//        //创建一个视频播放器
//        AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
//        //创建一个视频播放图层
//        AVPlayerLayer *playLayer = [AVPlayerLayer playerLayerWithPlayer:player];
//         //将视频播放图层添加到父控件图层
//        [_playerVC.view.layer addSublayer:playLayer];
        //设置视频播放控制器的播放器为player
        _playerVC.player = self.player;

    }
    return _playerVC;
}




//9.0后弃用
- (MPMoviePlayerController *)mpMovieplayer {
    if (_mpMovieplayer == nil) {
        // 1.获取视频的URL
        NSURL *url = [NSURL URLWithString:@"http://v1.mukewang.com/19954d8f-e2c2-4c0a-b8c1-a4c826b5ca8b/L.mp4"];
        // 2.创建控制器
        _mpMovieplayer = [[MPMoviePlayerController alloc]initWithContentURL:url];
        // 3.设置控制器的View的位置
        _mpMovieplayer.view.frame =  CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16);
        // 4.将View添加到控制器上
        [self.view addSubview:_mpMovieplayer.view];
        // 5.设置属性
        _mpMovieplayer.controlStyle = MPMovieControlStyleNone;
    }
    return _mpMovieplayer;
}

//已弃用
- (MPMoviePlayerViewController *)mpMovieViewplayer {
    if (_mpMovieViewplayer == nil) {
        NSURL *url = [NSURL URLWithString:@"http://v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4"];
        _mpMovieViewplayer = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    }
    return _mpMovieViewplayer;
}

@end
