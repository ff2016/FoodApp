//
//  AppDelegate.m
//  FoodApp
//
//  Created by lanou3g on 16/6/13.
//  Copyright © 2016年 me. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "UMSocial.h"
#import "UMSocialSnsService.h"
#import "UMSocialSinaSSOHandler.h"


// 服务器的AppID和Key
#define kAVOSCloudAppID @"JfPVyt8IdkXJiVWD0GeLsmtu-gzGzoHsz"
#define kAVOSCloudKey @"nMyweoTBoGf8KdmCe54z0ksd"
//master key v0A5KSB8bPh7ddncDyoAxpEUf3naXY4ja82pUhI05QI6d00F-gzGzoHsz

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    RootViewController *RootVC = [[RootViewController alloc]init];
    self.window.rootViewController = RootVC;
    [self.window makeKeyAndVisible];
    
    // 服务器
    [AVOSCloud setApplicationId:kAVOSCloudAppID clientKey:kAVOSCloudKey];
    // 跟踪统计应用的打开情况
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    //友盟设置
    [self setUM];
    

    AVUser *currentUser = [AVUser currentUser];
    //判断用户登录
    if (currentUser != nil) {
        //直接显示首页了
    }else{
        //添加引导页
        [self helpScroll];//一直显示引导页
    }

    return YES;
}

-(void)setUM{
    //设置友盟的APPKey
    [UMSocialData setAppKey:@"570dc12767e58e7025001c2f"];
    //设置新浪微博相关内容
    //把在新浪微博注册的应用的APPKey redirectURl 替换为下面的参数,并在 info中添加对应的 wb+APPKey
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"570dc12767e58e7025001c2f" secret:@"04b48b094faeb16683c32669824ebdad" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    
}

//系统回调方法
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //做其他操作或者调用其他SDK
    }
    return result;
}
-(UIButton*)buttonPhoto:(NSString*)photo hilPhoto:(NSString*)Hphoto rect:(CGRect)rect  title:(NSString*)title select:(SEL)sel Tag:(int)tag View:(UIView*)ViewA textColor:(UIColor*)textcolor{
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    [button setBackgroundImage:[UIImage imageNamed:Hphoto] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:photo] forState:UIControlStateHighlighted];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    button.tag=tag;
    [button setTitleColor:textcolor forState:UIControlStateNormal];
    [ViewA addSubview:button];
    return button;
}
-(UIImageView*)addSubviewImage:(NSString*)imageName  rect:(CGRect)rect{
    UIImageView*view=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    view.frame=rect;
    return view;
}
-(void)helpScroll{
    
    _scrVl=[[UIScrollView alloc] init];
    _scrVl.pagingEnabled = YES;
    _scrVl.delegate=self;
    _scrVl.frame=CGRectMake(0, 0,self.window.frame.size.width, self.window.frame.size.height);
    _scrVl.bounces = NO;
    _scrVl.contentSize=CGSizeMake(self.window.frame.size.width*4, self.window.frame.size.height);
    [self.window addSubview:_scrVl];
    
    
    
    
    
    for (int i=0; i<4; i++) {
        [_scrVl addSubview:[self addSubviewImage:[NSString stringWithFormat:@"help%d.jpg",i+1] rect:CGRectMake(self.window.frame.size.width*i, 0,self.window.frame.size.width ,self.window.frame.size.height)]];
    }
    
    
    [self buttonPhoto:nil hilPhoto:@"helpBtn.png" rect:CGRectMake(self.window.frame.size.width*3+130,self.window.frame.size.height-80, 294/2,67/2) title:@"开始学习烹饪" select:@selector(hiddenScroller:) Tag:1 View:_scrVl textColor:[UIColor whiteColor]];
    
    
    _thePGLeft=[[PageControl alloc] initWithFrame:CGRectMake(170, 700, 90, 30)];
    
    
    _thePGLeft.dotColorCurrentPage=[UIColor redColor];
    
    //    thePGLeft.center=CGPointMake(160,50);
    
    _thePGLeft.numberOfPages=4;
    [self.window addSubview:_thePGLeft];
    
}
-(void)hiddenScroller:(id)sender
{
    
    
    
    [UIView animateWithDuration:2.0
                     animations:^{
                         _scrVl.alpha = 0.0;
                         _thePGLeft.alpha=0.0;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }
     ];
}

#pragma UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [_thePGLeft setCurrentPage:offset.x / bounds.size.width];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
