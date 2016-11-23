ios视频开发
一、iOS系统自带播放器



　　要了解iOS视频开发，首先我们从系统自带的播放器说起，一、我们可以直接播放视频，看到效果，不然搞了半天还播放不了视频，会让大家失去兴趣。二、其实对于很多需求来说，系统的播放器就能够胜任。简单介绍下

1.MPMoviePlayerController

在iOS中播放视频可以使用MPMoviePlayerController类来完成，具备一般的播放器控制功能，例如播放、暂停、停止等。但是MPMediaPlayerController自身并不是一个完整的视图控制器，如果要在UI中展示视频需要将view属性添加到界面中

2.MPMoviePlayerViewController

MPMoviePlayerController继承于UIViewController，默认是全屏模式展示、弹出后自动播放、作为模态窗口展示时如果点击“Done”按钮会自动退出模态窗口等

3.AVPlayer

MPMoviePlayerController足够强大和复。自定义播放器的样式，使用MPMoviePlayerController就不合适了，只能用AVPlayer.

AVPlayer本身并不能显示视频，而且它也不像MPMoviePlayerController有一个view属性。如果AVPlayer要显示必须创建一个播放器层AVPlayerLayer用于展示，播放器层继承于CALayer，有了AVPlayerLayer之添加到控制器视图的layer中即可。

4.AVFoundation

深入学习音视频播放，需要对AVFoundation框架进行深入学习



但是无论是MPMoviePlayerController还是AVPlayer支持的视频编码格式很有限：H.264、MPEG-4，扩展名（压缩格式）：.mp4、.mov、.m4v、.m2v、.3gp、.3g2等。



二、使用第三方Kxmovie



1.配置Kxmovie

git clonehttps://github.com/kolyvan/kxmovie.git

cdkxmovie

gitsubmoduleupdate--init

sudo rake //会出现错误，见错误1



2.遇到的问题及解决办法：

a.执行sudo rake 时abort

在kxmovie目录下

执行vim Rakefile

找到SDK_VERSION、XCODE_PATH两行，改为下面

SDK_VERSION='9.2'

XCODE_PATH='/Applications/Xcode.app/Contents/Developer/Platforms'



解释：SDK_VERSION=‘9.2’中9.2是你现在的sdk版本可以执行

cd/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/developer/SDKs/

去查看目前的sdk的版本，改为对应的版本



b.Undefined symbols for architecture x86_64

Kxmovie应该是不支持64为模拟器上运行，不可以在iPhone5s以上模拟器上运行。可以在5上运行。



三、视频基础知识介绍



1.视频播放器原理

通过流媒体协议如RTSP+RTP、HTTP、MMS等下载的数据通过解协议获得封装格式数据，何为封装格式的数据。如AVI、MP4、FLV等； 对于封装格式的数据进行解封装，提取视频流、音频流、字幕流进行分离待下一步准备处理， 分离后获得音视频文件编码文件（音视频文件过大需要进行压缩进行传输，即编码），常见的编码如H.264编码的视频码流和AAC编码的音频码流。压缩编码的视频数据输出成为非压缩的颜色数据，例如YUV420P，RGB等等；压缩编码的音频数据输出成为非压缩的音频抽样数据，例如PCM数据。 视音频同步，视频流、音频流、字幕流等进行同步播放。

2.流媒体传输协议

一般点播采用HTTP ,而直播的话，大部分还是采用RTMP或者私有协议，原因是延时会比较小，RTMP本身也是为了直播设计的

RSVP：资源预留协议 RTP：实时传输协议 RTCP：实时传输控制协议 MMS：微软流媒体服务协议 RTSP：实时流传输协议 MIME：多目因特网电子邮件扩展协议 RTMP(RTMPE/RTMPS/RTMPT)：Adobe实时消息协议簇 RTMFP：Adobe实施消息流协议（P2P协议） HLS(Http Live Streaming)

流媒体协议介绍（rtp/rtcp/rtsp/rtmp/mms/hls）http://blog.csdn.net/tttyd/article/details/12032357

视频流传输协议RTP/RTCP/RTSP/HTTP的区别 http://blog.csdn.net/yangxt/article/details/7467457

3.封装格式

封装格式（也叫容器）主要作用是把视频码流和音频码流按照一定的格式存储在一个文件中。

常见格式

AVI：微软在90年代初创立的封装标准，是当时为对抗quicktime格式（mov）而推出的，只能支持固定CBR恒定比特率编码的声音文件。

FLV：针对于h.263家族的格式。

MKV：万能封装器，有良好的兼容和跨平台性、纠错性，可带 外挂字幕。

MOV：MOV是Quicktime封装。

MP4：主要应用于mpeg4的封装 。

RM/RMVB：Real Video，由RealNetworks开发的应用于rmvb和rm 。

TS/PS：PS封装只能在HDDVD原版。

WMV：微软推出的，作为市场竞争。

4.编码标准

视频编码的主要作用是将视频像素数据（RGB，YUV等）压缩成为视频码流，从而降低视频的数据量。如果视频不经过压缩编码的话，体积通常是非常大的，一部电影可能就要上百G的空间。

![][foryou]


iOS视频开发实例浅谈

视频编码标准汇总及比较 http://blog.csdn.net/leixiaohua1020/article/details/12031631

视音频编解码技术零基础学习方法 http://blog.csdn.net/leixiaohua1020/article/details/18893769

5.播放方式

视频直播,是对视频源的实时的观看，不能快进等操作，注重实时性，对网络延迟要求比较高，相当于视频的广播

视频点播，是对以往的视频源进行回放，可以执行快进后退等操作

6.FFmpeg

http://ffmpeg.org/doxygen/2.8/examples.html官网介绍

http://blog.csdn.net/leixiaohua1020/article/details/44084321博客地址

http://blog.csdn.net/beitiandijun/article/details/8280448 FFmpeg的基本概念

多媒体视频处理工具FFmpeg有非常强大的功能包括视频采集功能、视频格式转换、视频抓图、给视频加水印等。

FFmpeg的基本概念:

容器（container）：就是文件格式,在FFMPEG中，用来抽象文件格式的容器就是AVFormatContext；

数据流（stream）：数据流就是我们平时看到的多媒体数据流，它包含几种基本的数据流，包括：视频流、音频流、字幕流；按照我的理解，数据流在FFMPEG中的抽象为AVStream。

解复用器或者说分流器（demuxer）：FFMPEG将要处理的多媒体文件看成多媒体数据流，先把多媒体数据流放入容器（AVFormatContext），然后将数据流送入解复用器（demuxer），demuxer在FFMPEG中的抽象为AVInputFormat，我更愿意把demuxer称为分流器，因为demuxer就是把交错的各种基本数据流识别然后分开处理，将分开的数据流分别送到视频、音频、字幕编解码器处理。

数据包（packet）当然分开的数据流在送往编解码器处理之前，要先放于缓存中，同时添加一些附属信息例如打上时间戳，以便后面处理，那么这个缓存空间就是数据包；由于数据流是在时间轴上交错放置，所以所有的视频、音频、字幕都被分割成一段一段的数据，这些一段段的数据从数据流中解析出来之后，就是存放在各自的packet，那么在这里要说明一下，单纯的视频数据包来说，一个视频数据包可以存放一个视频帧，对于单纯的音频帧来说，如果抽样率（sample-rate）是固定不变的，一个音频数据包可以存放几个音频帧，若是抽样率是可变的，则一个数据包就只能存放一个音频帧。



四、Kxmovie源码分析简易分析



整体思路是KxMovieDecoder通过视频文件或者网络地址使用FFmpeg解码，将视频文件解码为YUV或者RGB文件(图像文件)。然后KxMovieGLView呈现YUV或者RGB文件。KxAudioManager进行播放管理，例如paly,pause等，KxMovieViewController使用以上API，构建播放器界面

1.KxMovieDecoder文件

KxMovieDecoder提供解码的API，在vedio解码为YUV或者RGB文件。

从公共API入手,进行分析。以下分析只是提取了vedio的操作。

a.打开文件，进行如下操作

+ (id) movieDecoderWithContentPath: (NSString *) patherror: (NSError **) perror

打开网络流的话，前面要加上函数avformat_network_init()。 AVFormatContext：统领全局的基本结构体。主要用于处理封装格式（FLV/MKV/RMVB等）。AVFormatContext初始化方法avformat_alloc_context() 打开输入流，四个参数分别是ps：AVFormatContext对象的地址,filename：输入流的文件名，fmt:如果非空,这个参数强制一个特定的输入格式。否则自动适应格式。int avformat_open_input(AVFormatContext **ps, const char *filename, AVInputFormat *fmt, AVDictionary **options); 读取数据包获取流媒体文件的信息，每个AVStream存储一个视频/音频流的相关数据；每个AVStream对应一个AVCodecContext，存储该视频/音频流使用解码方式的相关数据。int avformat_find_stream_info(AVFormatContext *ic, AVDictionary **options); 找到合适的解码器, AVCodecContext *codecCtx = _formatCtx->streams[videoStream]->codec;AVCodec *codec = avcodec_find_decoder(codecCtx->codec_id); Initialize the AVCodecContext to use the given AVCodec. return zero on success, a negative value on error avcodec_open2(codecCtx, codec, NULL);

b. - (BOOL) openFile: (NSString *) patherror: (NSError **) perror;

与方法a相比，方法a只是比此方法多了初始化方法 KxMovieDecoder *mp = [[KxMovieDecoder alloc] init];

c. - (void)closeFile;

结束

　av_frame_free(&pFrame);

avcodec_close(pCodecCtx);

avformat_close_input(&pFormatCtx);

d. - (BOOL) setupVideoFrameFormat: (KxVideoFrameFormat) format；

枚举设置为 KxVideoFrameFormatRGB或者KxVideoFrameFormatYUV,

e.- (NSArray *) decodeFrames: (CGFloat) minDuration;

通过AVFormatContext对象读取frames。需要方法a的操作做铺垫。

从 AVFormatContext读取下一个AVPacket。intav_read_frame(AVFormatContext*s,AVPacket*pkt) 解码从AVPacket*avpkt转化为AVFrame*picture。。intavcodec_decode_video2(AVCodecContext*avctx,AVFrame*picture,int*got_picture_ptr, constAVPacket*avpkt); 帧速控制attribute_deprecatedintavpicture_deinterlace(AVPicture*dst, constAVPicture*src, enumAVPixelFormatpix_fmt, intwidth, intheight) 返回frames的数组。

2.KxAudioManager

播放管理，例如paly,pause等，

3.KxMovieGLView

KxMovieDecoder提供解码的API，在vedio解码为YUV或者RGB文件。KxMovieGLView利用OpenGLES（绘图技术）呈现YUV文件。

4.KxMovieViewController

使用以上API，构建播放器界面



五、总结



我的学习步骤

1.先学会使用系统的播放器进行视频播放

2.学会使用第三方Kxmovie

学会这两个，可以应付基本的视频开发

3.深入学习AVFoundation框架 我买的这本书 AV Foundation开发秘籍：实践掌握iOS & OS X 应用的视听处理技术 我还没看完

4.需要深入的话，需要多FFmpeg框架。当然需要先学习音视频开发的基础如RGB、YUV像素数据处理、PCM音频采样数据处理、H.264视频码流解析等等。好多啊。



六、参考资料汇总———也是我自己总结的大家深入学习的一些资料吧



HTTP Live Streaming直播(iOS直播)技术分析与实现：http://www.cnblogs.com/haibindev/archive/2013/01/30/2880764.html

HTT Live Streaming官方文档：https://developer.apple.com/streaming/

FFmpeg深入分析之零-基础 http://blog.chinaunix.net/uid-26611383-id-3976154.html

一篇大学论文，很长但是能让小白了解iOS流媒体都需要什么http://www.doc88.com/p-7098896030363.html

流媒体协议介绍（rtp/rtcp/rtsp/rtmp/mms/hls）http://blog.csdn.net/tttyd/article/details/12032357

视频流传输协议RTP/RTCP/RTSP/HTTP的区别 http://blog.csdn.net/yangxt/article/details/7467457

ffmpeg框架解读http://blog.csdn.net/allen_young_yang/article/details/6576303

流媒体博客http://blog.csdn.net/leixiaohua1020/article/details/15811977

http://blog.csdn.net/beitiandijun/article/details/8280448 FFmpeg的基本概念

视频编码标准汇总及比较 http://blog.csdn.net/leixiaohua1020/article/details/12031631

视音频编解码技术零基础学习方法 http://blog.csdn.net/leixiaohua1020/article/details/18893769



书籍：AV Foundation开发秘籍：实践掌握iOS & OS X 应用的视听处理技术
[foryou]:./img/videoCode.png
