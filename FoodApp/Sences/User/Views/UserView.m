//
//  UserView.m
//  FoodApp
//


#import "UserView.h"
#import "UIView+WLFrame.h"
@interface UserView()
@property (nonatomic, assign) CGFloat selfWidth;
@property (nonatomic, assign) CGFloat selfHeight;
@end

@implementation UserView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selfHeight = frame.size.height;
        _selfWidth = frame.size.width;
        [self addSubview];
    }
    return self;
}

//添加子视图
-(void)addSubview{
    self.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    //添加用户按钮
     [self addUserInfoButton];
    //添加我的活动   按钮
    [self addmyButton];
    //添加我的活动分类
    [self addMyCollectionView];
    //三个按钮所在背景
    _bgThreeBtmView = [[UIView alloc]initWithFrame:CGRectMake(0, _myButton.bottom + 7, _selfWidth, _selfHeight - _myButton.bottom - 7)];
    _bgThreeBtmView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [self addSubview:_bgThreeBtmView];
    //添加三个其他功能按钮
    [self addThreeButton];
    

}

#pragma mark - 添加用户按钮
- (void)addUserInfoButton
{
    _bgUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _bgUserButton.frame = CGRectMake(-_selfWidth*0.1, - 20, _selfWidth*1.2, 200 * 1.2);
    UIImage *aView = [UIImage imageNamed:@"head_pic.jpeg"];

    [_bgUserButton setImage:aView forState:UIControlStateNormal];
    [self addSubview:_bgUserButton];
    
    _userImgV = [[UIImageView alloc] initWithFrame:CGRectMake((_bgUserButton.frame.size.width - 80)/2, 20 + 40, 80, 80)];
    _userImgV.image = [UIImage imageNamed:@"DefaultAvatar"];
    _userImgV.layer.cornerRadius = _userImgV.frame.size.width / 2;
    _userImgV.layer.masksToBounds = YES;
    [_bgUserButton addSubview:_userImgV];
    
    _userNameLb = [[UILabel alloc] initWithFrame:CGRectMake((_bgUserButton.frame.size.width - 200)/2, _userImgV.frame.size.height + 80, 200, 30)];
    _userNameLb.textAlignment = NSTextAlignmentCenter;
    //    _userNameLb.backgroundColor = [UIColor yellowColor];
    _userNameLb.text = @"未登录";
    _userNameLb.textColor = [UIColor redColor];
    [_bgUserButton addSubview:_userNameLb];
}

#pragma mark 添加我的分类按钮
-(void)addmyButton{
    _myButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _myButton.frame = CGRectMake(0, 200, _selfWidth, 43);
    _myButton.backgroundColor = [UIColor whiteColor];
    [self addSubview:_myButton];
    
    _bgMyBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, _myButton.frame.size.height)];
    _bgMyBtnView.userInteractionEnabled = NO;
    [_myButton addSubview:_bgMyBtnView];
    
    UIImageView *imageV = [[UIImageView alloc ] initWithFrame:CGRectMake(20, 5, 33, 33)];
    imageV.image = [UIImage imageNamed:@"11.jpg"];
    [_bgMyBtnView addSubview:imageV];
    
    UILabel *textLB = [[UILabel alloc]initWithFrame:CGRectMake(imageV.right + 20, 0, _bgMyBtnView.width - (imageV.right + 20), _myButton.height)];
    textLB.text = @"我的收藏";
    [_bgMyBtnView addSubview:textLB];
    
    _markView = [[UIImageView alloc]initWithFrame:CGRectMake(_myButton.width - 35, (_myButton.height - 16)/2, 16, 16)];
    _markView.image = [UIImage imageNamed:@"mark"];
    [_myButton addSubview:_markView];
    
}

#pragma mark 添加三个按钮
-(void)addThreeButton{
    NSArray *textArr = @[@"分享美食", @"Setting", @"关于我们"];
    NSArray *imgArr = @[[UIImage imageNamed:@"11.jpg"], [UIImage imageNamed:@"11.jpg"], [UIImage imageNamed:@"11.jpg"]];

    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 45*i, _selfWidth, 43);
        button.backgroundColor = [UIColor whiteColor];
        button.tag = 10 + i;
        [_bgThreeBtmView addSubview:button];
        
        UIImageView *imageV = [[UIImageView alloc ] initWithFrame:CGRectMake(20, 5, 33, 33)];
        imageV.image =  imgArr[i];
        [button addSubview:imageV];
        
        UILabel *textLb = [[UILabel alloc] initWithFrame:CGRectMake(imageV.right + 20, 0, 100, button.height)];
        textLb.text = textArr[i];
        [button addSubview:textLb];
        
        UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(button.width - 35, (button.height - 16)/2, 16, 16)];
        rightImg.image = [UIImage imageNamed:@"mine_rightjiantou"];
        [button addSubview:rightImg];
    
    }
    _ideaButton = (UIButton *)[self viewWithTag:10];
    _setButton = (UIButton *)[self viewWithTag:11];
    _aboutButton = (UIButton *)[self viewWithTag:12];
    
}


#pragma mark - 心愿详情
- (void)addMyCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    layout.itemSize = CGSizeMake((kScreenWidth - 44) / 3, 100);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20,20);
    
    // 初始化集合视图
    _myCollection= [[UICollectionView alloc] initWithFrame:CGRectMake(0, _myButton.bottom + 7, _selfWidth, _selfHeight - _myButton.bottom - 7) collectionViewLayout:layout];
    _myCollection.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    
    //    _wishCollection.backgroundColor = [UIColor yellowColor];
    
    [self addSubview:_myCollection];
    
    //    _wishCollection.hidden = YES;
    
}











@end
