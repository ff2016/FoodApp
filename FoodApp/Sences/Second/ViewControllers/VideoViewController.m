//
//  VideoViewController.m
//  FoodApp
//

#import <MASConstraint.h>
#import "VideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import  <AVKit/AVKit.h>
#import "UMSocial.h"
#import "UMSocialSnsService.h"

#import <AVOSCloud/AVOSCloud.h>
#import <Reachability.h>
#import "LoginViewController.h"

#define KWIDTH [UIScreen mainScreen].bounds.size.width
#define KHEIGHT [UIScreen mainScreen].bounds.size.height

@interface VideoViewController ()
@property (strong, nonatomic) IBOutlet UIView *playerView;
@property(nonatomic,strong)AVPlayer *avPlayer;//播放器
@property(nonatomic, strong)AVPlayerLayer *playerLayer;
@property(nonatomic, strong)AVPlayerItem *playerItem;
@property(nonatomic, assign)BOOL isPlaying;//播放状态
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIButton *fullScreenBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actIndiacator;//菊花
@property(nonatomic, strong)UIView *nView;
@property (nonatomic, strong)NSTimer *timer;//视频时间计时
@property(nonatomic, strong)NSTimer *hideTimer;//自动隐藏控制按钮(bottomView)
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    //给页面标题赋值
    self.titlelabel.text = self.model.foodtitle;
    //初始化音量控件
    self.processSlider.value = 0;
    //slider 美化
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"movieTicketsPayType_select"] forState:UIControlStateNormal];
    [self.processSlider setThumbImage:[UIImage imageNamed:@"movieTicketsPayType_select@2x"] forState:UIControlStateNormal];
    //加载AVPlayer
    [self createPlayerView];
      [self.actIndiacator stopAnimating];
}

- (IBAction)collectionAction:(UIButton *)sender {
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    if ([conn currentReachabilityStatus] != NotReachable) {
        //
        AVUser *currentUser = [AVUser currentUser];
        if (currentUser != nil) {
            //查看是否收藏
            if ([self isCollect]) {
                //
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已经收藏过了" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertController animated:YES completion:nil];
                [self performSelector:@selector(dismiss:) withObject:alertController afterDelay:0.5];
                
            }else{
                //收藏
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: self.model.foodtitle, @"title",self.model.src,@"src", nil];
                [currentUser addObject:dic forKey:@"collect"];
                [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [currentUser saveInBackground];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"收藏成功" preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self performSelector:@selector(dismiss:) withObject:alertController afterDelay:0.5];
                }];
                
                
            }
            
        }else{
            //去登录
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self.navigationController presentViewController:loginVC animated:YES completion:nil];
            
        }
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"收藏失败 请您检查是否为网络原因" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *say = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:say];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    

}
- (void)dismiss:(UIAlertController *)alertView
{
    [alertView dismissViewControllerAnimated:YES completion:nil];
}
//是否收藏
-(BOOL)isCollect{
    AVUser *currentUser = [AVUser currentUser];
    NSArray *title = [[currentUser objectForKey:@"collect"] valueForKey:@"title"];
    for (NSString *str in title) {
        if ([self.model.foodtitle isEqualToString:str]) {
            return YES;
        }
    }
    return NO;
    
}
- (IBAction)shareAction:(UIButton *)sender {
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"570dc12767e58e7025001c2f" shareText:self.model.foodtitle shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.model.titlepic]]]] shareToSnsNames:@[UMShareToQQ,UMShareToSina] delegate:nil];
}




//初始化播放器控件
-(void)createPlayerView{
    //初始化视频播放控件
    NSString *videoString = [NSString stringWithFormat:@"%@",self.model.src];
    NSURL *url = [NSURL URLWithString:videoString];
    //视频播放配置对象
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:url];
    self.playerItem = item;
    //初始化播放器对象
    self.avPlayer = [[AVPlayer alloc]initWithPlayerItem:item];
        [self.playerItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
    //用来显示AVPlayer的图形界面
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
     //self.playerLayer.frame = CGRectMake(0, (self.playerView.frame.size.height- 200)/2, self.playerView.frame.size.width, 200);
    self.playerLayer.frame = self.playerView.bounds;
    [self.playerView.layer addSublayer:self.playerLayer];
    [self.playerView bringSubviewToFront:self.actIndiacator];
   [self.view addSubview:self.playerView];
  
        //初始时间显示
    self.timeLabel.text = @"00:00 / 00:00";
   }

//进度条与时间自动改变
-(void)upDataProcess{
    //时间戳
    float time = (CGFloat)_playerItem.currentTime.value / _playerItem.currentTime.timescale;
    float totalTime = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
    NSString *totStr = [self stringFromTime:totalTime];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ / %@",[self stringFromTime:time],totStr];
    //进度条
    self.processSlider.value = time / totalTime;

}
//时间转换字符串
-(NSString*)stringFromTime:(float)time
{
    long videocurrent = ceil(time);
    
    NSString *str = @"";
    
    if (videocurrent < 3600)
    {
        str =  [NSString stringWithFormat:@"%02li:%02li",lround(floor(videocurrent/60.f)),lround(floor(videocurrent/1.f))%60];
    }
    else
    {
        str =  [NSString stringWithFormat:@"%02li:%02li:%02li",lround(floor(videocurrent/3600.f)),lround(floor(videocurrent%3600)/60.f),lround(floor(videocurrent/1.f))%60];
    }
    return str;
}

//开始
- (IBAction)startAction:(UIButton *)sender {
    if(self.model.src == nil){
       // UIAlertController *alert = [[UIAlertController alloc]init];
    }
    if (self.isPlaying == NO) {
        [self.avPlayer play];
        self.isPlaying = YES;
        [self.playController setTitle:@"暂停" forState:UIControlStateNormal];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(upDataProcess) userInfo:nil repeats:YES];
        [UIView animateKeyframesWithDuration:1 delay:2 options:(UIViewKeyframeAnimationOptionBeginFromCurrentState) animations:^{
            [self.bottomView setAlpha:0];
        } completion:nil];
       

    }else{
        [self.playController setTitle:@"播放" forState:UIControlStateNormal];
        self.isPlaying = NO;
        [self.avPlayer pause];
        [self.timer invalidate];
    }
}

//全屏
- (IBAction)pauseAction:(UIButton *)sender {
    //横屏
    if ([UIDevice currentDevice].orientation != UIDeviceOrientationPortrait) {
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
      //布局bottomView
        [self constrainOfBottomView];
        //显示导航栏
        self.tabBarController.tabBar.hidden = NO;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.topView setHidden:NO];
           }else{
               //如果是竖屏
        //设备旋转

        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        //视图处理
               /*
//        self.playerView.translatesAutoresizingMaskIntoConstraints = YES;
//        self.playerView.frame = CGRectMake(0, 0, KWIDTH, KHEIGHT);
//        self.playerLayer.frame = self.playerView.bounds;
//        self.playerView.center = self.view.center;
        // [self.playerView setTransform:CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2)];
            */
               [self.playerView removeFromSuperview];
               [self.view addSubview:self.playerView];
               [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.centerX.mas_equalTo(self.view.mas_centerX);
                   make.centerY.mas_equalTo(self.view.mas_centerY);
                   make.width.mas_equalTo(self.view.mas_width);
                   make.height.mas_equalTo(self.view.mas_height);
                 //  make.size.mas_equalTo(CGSizeMake(KWIDTH, KHEIGHT));
               }];
               self.playerLayer.frame = self.view.bounds;
             
               
               self.tabBarController.tabBar.hidden = YES;
               [self.navigationController setNavigationBarHidden:YES animated:YES];
               self.topView.hidden = YES;
    }
}


//音量控制
- (IBAction)volumeAction:(UISlider *)sender {
    self.avPlayer.volume = self.volumeSlider.value;
}
//通过进度条控制视频播放进度
- (IBAction)processslider:(UISlider *)sender {
   CGFloat value = self.avPlayer.currentItem.duration.value/self.avPlayer.currentItem.duration.timescale;
    [self.avPlayer seekToTime:CMTimeMakeWithSeconds(value * self.processSlider.value, self.avPlayer.currentTime.timescale) completionHandler:^(BOOL finished) {
        [self.avPlayer play];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(upDataProcess) userInfo:nil repeats:YES];
        self.isPlaying = YES;
        [self.playController setTitle:@"暂停" forState:UIControlStateNormal];
    }];
    [UIView animateKeyframesWithDuration:1 delay:2 options:(UIViewKeyframeAnimationOptionBeginFromCurrentState) animations:^{
        [self.bottomView setAlpha:0];
    } completion:nil];
}

//手势
- (IBAction)tapaction:(UITapGestureRecognizer *)sender {

    if([[UIApplication sharedApplication]statusBarOrientation] == UIDeviceOrientationPortrait){
        //屏幕竖直放置
        [UIView animateWithDuration:1 animations:^{
            [self.bottomView setAlpha:1];
        }];
        _hideTimer = [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(bottomDismiss) userInfo:nil repeats:YES];
        return;
    }
   //屏幕横置

    [UIView animateWithDuration:1 animations:^{
        [self.bottomView setAlpha:1];
    }];
    [self.bottomView removeFromSuperview];
    [self.playerView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.playerView.mas_bottom);
        make.width.mas_equalTo(self.playerView.mas_width);
        make.height.mas_equalTo(70);
    }];
   
}

#pragma mark 布局bottomView
-(void)constrainOfBottomView{
    //约束  playerView
    [self.playerView removeFromSuperview];
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KWIDTH, 400));
        make.center.mas_equalTo(self.view);
    }];
    self.playerLayer.frame = CGRectMake(0, 0, KWIDTH, 400);

    //约束 bottomView
    [self.bottomView removeFromSuperview];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playerView.mas_bottom);
        make.width.mas_equalTo(self.playerView.mas_width);
        make.height.mas_equalTo(100);
    }];
    //全屏按钮
    [self.bottomView addSubview:self.fullScreenBtn];
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomView.mas_bottom).with.offset(-10);
        make.right.mas_equalTo(self.bottomView.mas_right).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    //时间label
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.fullScreenBtn.mas_left).with.offset(-10);
    }];
    //声音
    [self.volumeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.timeLabel.mas_left).with.offset(-10);
    }];
}
//bottomView 上的控件
-(void)btnOfBottomView{
    
}

#pragma mark 隐藏bottomView
-(void)bottomDismiss{
    [UIView animateWithDuration:1 animations:^{
        [self.bottomView setAlpha:0];
    }];
    [_hideTimer invalidate];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.timer invalidate];
    [self.playerItem removeObserver:self forKeyPath:@"status" context:nil];
    self.playerItem = nil;
    if ([UIDevice currentDevice].orientation != UIDeviceOrientationPortrait) {
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [UIView animateWithDuration:1 animations:^{
             [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        }];
       
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
 
    if ([keyPath isEqualToString:@"status"]) {
        if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
            [self.actIndiacator stopAnimating];
            self.actIndiacator.hidden = YES;
            NSLog(@"资源准备成功");
        }else if(self.playerItem.status == AVPlayerItemStatusFailed){
            self.actIndiacator.hidden = NO;
            [self.actIndiacator startAnimating];
            NSLog(@"资源加载失败");
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:YES];
//    self.tabBarController.tabBar.hidden = YES;

    [self setHidesBottomBarWhenPushed:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
