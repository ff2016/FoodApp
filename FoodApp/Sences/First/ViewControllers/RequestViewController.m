//
//  RequestViewController.m
//  HGY
//


#import "RequestViewController.h"


@interface RequestViewController ()<UIWebViewDelegate, UMSocialUIDelegate>

@property (nonatomic, retain)UIActivityIndicatorView *actiView;
@property (nonatomic, strong) NSString *html;

@property (nonatomic, retain)UIView *view1;
@property (nonatomic, assign)BOOL isBool;

@property (nonatomic, retain)UIWebView *webView;

@end

typedef enum : NSUInteger {
    Fade = 1, // 淡入淡出
    CameraIrisHollowOpen,   // 推挤
   
} AnimationType;

@implementation RequestViewController

- (void)viewWillAppear:(BOOL)animated
{
    // 隐藏tabBar
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44 * kHeight)];
    label.text = self.model.title;
    label.textAlignment = NSTextAlignmentCenter;
    [self.webView addSubview:label];
    label.backgroundColor = [UIColor whiteColor];
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
   self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.delegate = self;
    // 禁止下拉
    self.webView.scrollView.bounces = NO;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]];
    
     [self.webView loadRequest:request];
    
    
    
    self.view1 = [[UIView alloc] initWithFrame:CGRectMake(((kScreenWidth - 100) / 2) , 100 * kHeight, 150 * kWidth, 100 * kHeight)];
    self.view1.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.6];
    [self.webView  addSubview:self.view1];
    // 将view1的透明度变为0
    self.view1.alpha = 0;
    [self.view addSubview:self.webView];
    self.actiView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 50 * kWidth, kScreenHeight / 2 - 50 * kHeight, 100 * kWidth, 100 * kHeight)];
    [_actiView setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyleGray)];
    _actiView.hidesWhenStopped = YES;
    [self.view addSubview:_actiView];
    [self addBarButton];
    [self addViewButton];
}

- (void)loadHtML:(UIWebView *)webView
{
     [webView loadHTMLString:self.html baseURL:nil];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_actiView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_actiView stopAnimating];
}


#pragma mark -- 将self.view1的上面加个分享, 收藏

- (void)addViewButton
{
    UIButton *enjoyButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    enjoyButton.frame = CGRectMake(20 * kWidth, 20 * kHeight, 100 * kWidth, 30 * kHeight);
    [self.view1 addSubview:enjoyButton];
    [enjoyButton setTitle:@"分享" forState:(UIControlStateNormal)];
    [enjoyButton addTarget:self action:@selector(actionEnjoy) forControlEvents:(UIControlEventTouchUpInside)];
    enjoyButton.backgroundColor = [[UIColor brownColor]colorWithAlphaComponent:0.6];
    UIButton *shoucangButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    shoucangButton.frame = CGRectMake(20 * kWidth, enjoyButton.bottom + 10 *kHeight, 100 * kWidth, 30 * kHeight);
    [self.view1 addSubview:shoucangButton];
    [shoucangButton setTitle:@"收藏" forState:(UIControlStateNormal)];
    [shoucangButton addTarget:self action:@selector(shoucangButton) forControlEvents:(UIControlEventTouchUpInside)];
    shoucangButton.backgroundColor = [[UIColor brownColor]colorWithAlphaComponent:0.6];
    
   }

- (void)actionEnjoy
{

   [UMSocialSnsService presentSnsIconSheetView:self appKey:@"56348f4a67e58e704c0017b2" shareText:nil shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ, UMShareToLine, UMShareToSina, UMShareToDouban, UMShareToEmail, nil] delegate:nil];
}

- (void)shoucangButton
{
#pragma  mark -- 插入数据库
    [[sqFenLei shareManager] createTable];
    sqModel *model = [[sqModel alloc] init];
    model.title = self.model.title;
   
    model.deal_h5_url = self.model.deal_h5_url;
    model.s_image_url = self.model.s_image_url;
    model.city = self.model.city;
    
    
    NSMutableArray *array = [[sqFenLei shareManager] queryAll];
    for (sqModel *model1 in array) {
        if ([model1.title isEqualToString:self.model.title]) {
            _isBool = YES;
        }
        
    }
    
    if (_isBool == YES) {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经收藏过了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [view show];
        self.view1.alpha = 0;
        return;
        
        
    } else {
        [[sqFenLei  shareManager] insetWith:model];
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [view show];
        self.view1.alpha = 0;
        return;
    }
    

    
}


// 添加UIBarButton
- (void)addBarButton
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:(UIBarButtonItemStylePlain) target:self action:@selector(actionRightButton:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

- (void)actionRightButton:(UIButton *)button
{
#pragma  mark -- 插入数据库
   
        self.view1.alpha = 1;
        [self bgViewAppearAnimation];
    
    
}

// 动画效果实现
- (void)bgViewAppearAnimation
{
    
    NSLog(@"ss");
    CATransition *animation = [CATransition animation];
    animation.duration = 1.5;
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromTop;
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    [self.view1.layer addAnimation:animation forKey:@"animation"];
   }



@end
