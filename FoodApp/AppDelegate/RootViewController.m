//
//  RootViewController.m
//  FoodApp
//

#import "RootViewController.h"
#import "ShowViewController.h"
#import "VideoTableViewController.h"
#import "UserViewController.h"
#import "UIImage+ImageContentWithColor.h"
#import "Color_macro.h"




@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置主题颜色
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:THEME_COLOR] forBarMetrics:UIBarMetricsDefault];
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:THEME_COLOR]];
    //设置 Tabbar 文本的颜色
    [self setTabBarTextAttribute];
    //添加子视图控制器
    [self CreateChildViewController];

    
   
}

//设置 tabbar的文本颜色
-(void)setTabBarTextAttribute{
    //普通状态下的颜色
    NSMutableDictionary *normalDic = [NSMutableDictionary dictionary];
    normalDic[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    //选中状态的颜色
    NSMutableDictionary *selectDic = [NSMutableDictionary dictionary];
    selectDic[NSForegroundColorAttributeName ] = [UIColor blackColor];
    
    //文本属性
    UITabBarItem *buttonItem = [UITabBarItem appearance];
    [buttonItem setTitleTextAttributes:normalDic forState:UIControlStateNormal];
    [buttonItem setTitleTextAttributes:selectDic forState:UIControlStateSelected];
}


//创建子界面
-(void)CreateChildViewController{
    //展示
    ShowViewController *SVC = [[ShowViewController alloc]init];
    [self addOneChildViewController:[[UINavigationController alloc] initWithRootViewController:SVC] Title:@"首页" Normalimage:@"person" SelectImg:@""];
    
    //视频展示
    VideoTableViewController *VideoVC = [[VideoTableViewController alloc]init];
    [self addOneChildViewController:[[UINavigationController alloc] initWithRootViewController:VideoVC]  Title:@"学做菜" Normalimage:@"person" SelectImg:@""];
    
    //用户界面
    UserViewController *UVC = [[UserViewController alloc]init];
    [self addOneChildViewController:[[UINavigationController alloc] initWithRootViewController:UVC] Title:@"个人" Normalimage:@"person" SelectImg:@"personH"];
}
//添加子视图控制器的方法
-(void)addOneChildViewController:(UIViewController *)viewController Title:(NSString *)title Normalimage:(NSString *)normalImage SelectImg:(NSString *)selectImg{
    //给子视图控制器赋值
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.image = [UIImage imageNamed:normalImage];
    
    UIImage *image = [UIImage imageNamed:selectImg];
    //设置渲染模式
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = image;
    
    //添加子视图控制器
    [self addChildViewController:viewController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
