//
//  UserViewController.m
//  FoodApp


#import "UserViewController.h"
#import "LoginViewController.h"
#import "UserView.h"
#import "MyViewCell.h"
#import "UIImageView+WebCache.h"
#import <AVOSCloud/AVOSCloud.h>
#import <Reachability.h>
#import "UserInfoViewController.h"
#import "SetViewController.h"
#import "IdeaViewController.h"
#import "AboutViewController.h"
#import "ShareTableViewController.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface UserViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)  UserView *mainView;//  用户视图

@property (nonatomic,assign) BOOL  isShowMyTable;//  mark

@property (nonatomic,strong)  NSArray *myImageArr;//
@property (nonatomic,strong)  NSArray *myTextArr;//

@end

@implementation UserViewController

- (void)dealloc
{
    // 销毁通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"USERISLOGIN" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setValue];

}
-(void)setValue{
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser) {
        self.mainView.userNameLb.text = currentUser.username;
        AVFile *image = [currentUser objectForKey:@"image"];
        [self.mainView.userImgV sd_setImageWithURL:[NSURL URLWithString:image.url] placeholderImage:[UIImage imageNamed:@"user_img"]];
        
    } else {
        self.mainView.userNameLb.text = @"未登录";
        self.mainView.userImgV.image = [UIImage imageNamed:@"user_img"];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人";
     self.view.backgroundColor = [UIColor whiteColor];
    
    _myImageArr = @[@"11.jpg",@"11.jpg",@"11.jpg",@"11.jpg"];
    _myTextArr = @[@"美食",@"视频",@"分享",@"美文"];
    
   
    //添加子视图
    [self addSubViews];
    
    
}


#pragma mark - 接收通知
- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionUserIsLogin:) name:@"USERISLOGIN" object:nil];
}
- (void)actionUserIsLogin:(NSNotification *)notification{
    // 当前用户
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser) {
        self.mainView.userNameLb.text = currentUser.username;
        AVFile *image = [currentUser objectForKey:@"image"];
        [self.mainView.userImgV sd_setImageWithURL:[NSURL URLWithString:image.url] placeholderImage:[UIImage imageNamed:@"user_img"]];
        
    } else {
        self.mainView.userNameLb.text = @"未登录";
        self.mainView.userImgV.image = [UIImage imageNamed:@"user_img"];
    }


}
#pragma mark 添加子视图
-(void)addSubViews{
    //添加用户视图
    [self addUserHeadView];
    //添加n个功能按钮
    [self addButtons];
    // 当前用户
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser) {
        self.mainView.userNameLb.text = currentUser.username;
        AVFile *image = [currentUser objectForKey:@"image"];
        [self.mainView.userImgV sd_setImageWithURL:[NSURL URLWithString:image.url] placeholderImage:[UIImage imageNamed:@"DefaultAvatar"]];
        NSLog(@"%@",[currentUser objectForKey:@"image"]);
    }
}

-(void)addUserHeadView{
    _mainView = [[UserView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.tabBarController.tabBar.frame.size.height)];
    _mainView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [self.view addSubview:_mainView];
    
    //子视图上的按钮添加事件
    [self.mainView.bgUserButton addTarget:self action:@selector(actionUserInfo) forControlEvents:(UIControlEventTouchUpInside)];

}

-(void)addButtons{

    self.mainView.myCollection.dataSource = self;
    self.mainView.myCollection.delegate = self;
    [self.mainView.myCollection registerNib:[UINib nibWithNibName:@"MyViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    
    [self.mainView.myButton addTarget:self action:@selector(actionMyTable) forControlEvents:(UIControlEventTouchUpInside)];
        [self.mainView.ideaButton addTarget:self action:@selector(actionIdea) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView.setButton addTarget:self action:@selector(actionSet) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView.aboutButton addTarget:self action:@selector(actionAboutMyTeam) forControlEvents:UIControlEventTouchUpInside];

}
#pragma mark - myCollection 的代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return 4;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageV.image = [UIImage imageNamed:self.myImageArr[indexPath.row]];
    cell.textLB.text = self.myTextArr[indexPath.row];
    return cell;

}
#pragma mark 点击集合视图cell的方法
//点击cell的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AVUser *currentUser = [AVUser currentUser];
    ShareTableViewController *shareVC =  [[ShareTableViewController alloc]init];
    //shareVC.hidesBottomBarWhenPushed = YES;
    shareVC.keyWordNumber = indexPath.row;
    switch (indexPath.row) {
        case 0:
            shareVC.collectionArray = [NSMutableArray arrayWithArray:[currentUser objectForKey:@"meal"]];
            [self.navigationController pushViewController:shareVC animated:YES];
            break;
        case 1:
            shareVC.collectionArray = [NSMutableArray arrayWithArray:[currentUser objectForKey:@"collect"]];
            [self.navigationController pushViewController:shareVC animated:YES];
            break;

        case 2:
            shareVC.collectionArray = [NSMutableArray arrayWithArray:[currentUser objectForKey:@"social"]];
            [self.navigationController pushViewController:shareVC animated:YES];
            break;

        case 3:
            shareVC.collectionArray = [NSMutableArray arrayWithArray:[currentUser objectForKey:@"reading"]];
            [self.navigationController pushViewController:shareVC animated:YES];
            break;

        default:
            break;
    }

}

#pragma mark 点击按钮 对应的事件

//点击头像
-(void)actionUserInfo{
    
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        
        UserInfoViewController *userVC = [[UserInfoViewController alloc] init];
        userVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userVC animated:YES];
    } else {
        //进登录页面
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self presentViewController:loginVC animated:YES completion:nil];
        
    }

}
//点击我的收藏
- (void)actionMyTable
{
    [self myTableAnimation];
}
// 意见反馈
- (void)actionIdea{
    IdeaViewController *ideaVC = [[IdeaViewController alloc]init];
    [self.navigationController presentViewController:ideaVC animated:YES completion:nil];
}
// 设置
- (void)actionSet{
    SetViewController *setVC = [[SetViewController alloc]init];
    [self.navigationController pushViewController:setVC animated:YES];
}
// 关于我们
- (void)actionAboutMyTeam{
    AboutViewController *aboutVC = [[AboutViewController alloc]init];
    [self.navigationController pushViewController:aboutVC animated:YES];
    
}

#pragma mark - 点击实现我的收藏动画
-(void)myTableAnimation{
    self.mainView.myButton.userInteractionEnabled = NO;
    __weak UserViewController *mySelf = self;
    if (!_isShowMyTable) {
        [UIView animateWithDuration:0.7 animations:^{
            //用户头像变小
            mySelf.mainView.bgUserButton.transform = CGAffineTransformScale(mySelf.mainView.bgUserButton.transform, 1/1.2, 1/1.2);
            //三个按钮下滑出屏幕
            mySelf.mainView.bgThreeBtmView.transform = CGAffineTransformTranslate(mySelf.mainView.bgThreeBtmView.transform, 0, mySelf.mainView.frame.size.height - 150);
            //mark标记图片旋转
            mySelf.mainView.markView.transform = CGAffineTransformRotate(mySelf.mainView.markView.transform, M_PI_2);

            
        }completion:^(BOOL finished) {
            mySelf.mainView.myButton.userInteractionEnabled = YES;
            _isShowMyTable = !_isShowMyTable;
        }];
    }else{
        //恢复原状
        [self regainMyTableAnimation];
    }

}
-(void)regainMyTableAnimation{
     __weak UserViewController *mySelf = self;
    [UIView animateWithDuration:0.7 animations:^{
        
        mySelf.mainView.bgUserButton.transform = CGAffineTransformScale(mySelf.mainView.bgUserButton.transform, 1.2, 1.2);
        
        mySelf.mainView.bgThreeBtmView.transform = CGAffineTransformTranslate(mySelf.mainView.bgThreeBtmView.transform, 0, -mySelf.mainView.frame.size.height + 150);
        //mark动画
        mySelf.mainView.markView.transform = CGAffineTransformRotate(mySelf.mainView.markView.transform, M_PI_2 *3);
        
    } completion:^(BOOL finished) {
        //
        mySelf.mainView.myButton.userInteractionEnabled = YES;
        _isShowMyTable = !_isShowMyTable;
    }];
    
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
