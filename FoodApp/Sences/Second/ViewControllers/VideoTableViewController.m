//
//  SecondTableViewController.m
//  FoodApp
//
//

#import "VideoTableViewController.h"
#import "SecondTableViewCell.h"
#import "SecondModel.h"
#import "VideoViewController.h"



#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
@interface VideoTableViewController ()
//存放菜谱
@property(nonatomic, strong)NSMutableArray *dataArray;

//播放功能
@property(nonatomic, strong)AVPlayer *player;
@property(nonatomic, strong)AVPlayerViewController *playerControl;

@end
static NSString *identfile = @"cell";
@implementation VideoTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学做菜";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"SecondTableViewCell" bundle:nil] forCellReuseIdentifier:identfile];
    
    //初始化数组
    self.dataArray = [NSMutableArray array];
    //解析数据
    [self parser];
    
    
    
}
//解析
-(void)parser{
    //模拟从网络上加载数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"food1" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    //使用系统提供的JSON解析
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *array = dic[@"data"];
    for (NSDictionary *dict in array) {
        SecondModel *model = [SecondModel new];
        [model setValuesForKeysWithDictionary:dict];
        [_dataArray addObject:model];
    }
    //更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfile forIndexPath:indexPath];
    SecondModel *model = self.dataArray[indexPath.row];
    cell.secondModel = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 162;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//[self setHidesBottomBarWhenPushed:YES];
    VideoViewController *VC = [[VideoViewController alloc]init];
   VC.model  = self.dataArray[indexPath.row];
    [self presentViewController:VC animated:YES completion:nil];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
