//
//  ShowViewController.m
//  FoodApp
//
//  Created by 嘟嘟 on 16/6/17.
//  Copyright © 2016年 me. All rights reserved.
//

#import "ShowViewController.h"
#import "HeaderView.h"//头部滚动视图
#import "FirstHeaderView.h"


#define kScreenW   [UIScreen mainScreen].bounds.size.width

#define kScreenH   [UIScreen mainScreen].bounds.size.height
@interface ShowViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ChengShiVCDelegate>


//@property(nonatomic,strong)HeaderView *myHeaderView;

@property (nonatomic, retain)NSMutableArray *dataArray;
@end

@implementation ShowViewController

static NSString *const reuseIdentifierHeader = @"fristHeaderCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //设置导航栏内容
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chihuojinnang"]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [[firstFootManager shareManager] requestDataForReloadWithUrl:firstUrl Block:^(NSArray *array) {
        //类型强转
        self.dataArray =(NSMutableArray *) array;
        //页面刷新
        [self.tableView reloadData];
        [self addtableView];
        
    }];
    [self addBarButton];

    
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)addBarButton
{
    if (self.cityString == nil) {
        self.cityString = @"上海";
    }
    NSLog(@"---%@", self.cityString);
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:self.cityString style:(UIBarButtonItemStylePlain) target:self action:@selector(addBarButton:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)addBarButton:(UIBarButtonItem *)button
{
    ChengShiVC *vc = [[ChengShiVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.delegate = self;
}

- (void)string:(NSString *)str
{
    self.cityString = str;
    NSLog(@"------------%@", str);
    NSLog(@"***********%@", self.cityString);
    [self addBarButton];
}



#pragma  mark -- UIcollectionView
- (void)addtableView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    //设置滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    //设置每个分区边缘位置,上下左右
    layout.sectionInset = UIEdgeInsetsMake(5 * kWidth, 5 * kHeight, 5 * kWidth , 5 * kHeight );
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake (0, 0, kScreenWidth, (kScreenHeight - 108)  ) collectionViewLayout:layout];
    
    //设置item的大小
    layout.itemSize = CGSizeMake(100 * kWidth, 130 * kHeight);
   
   //设置代理
    collectionView.delegate = self;
    collectionView.dataSource = self;
    //collectionView.bounces = NO;
    [self.view addSubview:collectionView];
    collectionView.backgroundColor = [[UIColor orangeColor]colorWithAlphaComponent:0.5];
    
    //注册cell
    [collectionView registerClass:[fristCollectionViewCell class] forCellWithReuseIdentifier:@"myCell"];
    //注册header
    [collectionView registerNib:[UINib nibWithNibName:@"FirstHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHeader];
    //设置多选
    collectionView.allowsMultipleSelection = YES;
    
}
//设置item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        return 13;
}
//设置section分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}
//cell内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    fristCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];

        Model *model = [[firstFootManager shareManager] ModelArray:indexPath.row ];
        cell.titleLabel.text = model.category_name;
    
        NSArray *array = @[@"MeiShi.jpg",@"QinZi.jpg", @"JiaZhuang.jpg", @"JingPinGou.jpg", @"JieHun.jpg",@"JiuDian.jpg", @"XiuXianYuLe.jpg", @"ShengHuoFuWu.jpg", @"LiRen.jpg", @"YaChi.jpg", @"LvYou.jpg", @"GouWu.jpg", @"DianYing.jpg"];
        cell.imageV.image = [UIImage imageNamed:array[indexPath.row]];
        
        // cell.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0.3];
    
    return cell;
}
//item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(100 * kWidth, 130 * kHeight);
    
    
}
//增补视图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    FirstHeaderView   *headerReuseView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHeader forIndexPath:indexPath];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
                //返回数组中
       HeaderView * myHeaderView = [[[NSBundle mainBundle]loadNibNamed:@"HeadView" owner:self options:nil] lastObject];
        myHeaderView.frame = CGRectMake(0, 0, kScreenW, 414);

        [headerReuseView.myHeaderView addSubview:myHeaderView];
    }
    return headerReuseView;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreenW, 250);
}



//点击cell事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    fristVC *vc = [[fristVC alloc] init];
    
    Model *model = [[firstFootManager shareManager] ModelArray:indexPath.row ];
    vc.string = model.category_name;
    vc.cityStr = self.cityString;

    [self.navigationController pushViewController:vc animated:YES];
    
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
