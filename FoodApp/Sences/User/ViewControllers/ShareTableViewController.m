//
//  ShareTableViewController.m
//  FoodApp
//


#import "ShareTableViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <Reachability.h>
#import "SecondModel.h"
#import "VideoViewController.h"
@interface ShareTableViewController ()
@end

@implementation ShareTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    //注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    //设置导航栏  添加(编辑按钮)
    [self setNavigation];
    self.isChange = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [self collect];

}
-(void)collect{
    
    AVUser *currentUser = [AVUser currentUser];
    switch (self.keyWordNumber) {
        case 0:
            [currentUser setObject:self.collectionArray forKey:@"meal"];
            //从网络数据库中编辑 (此处删除了数据)
            [currentUser saveEventually:^(BOOL succeeded, NSError *error) {
                
            }];
            break;
        case 1:
            [currentUser setObject:self.collectionArray forKey:@"collect"];
            [currentUser saveEventually:^(BOOL succeeded, NSError *error) {
                
            }];
            break;
        case 2:
            [currentUser setObject:self.collectionArray forKey:@"social"];
            break;
        case 3:
            [currentUser setObject:self.collectionArray forKey:@"reading"];
            break;

        default:
            break;
    }


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.collectionArray == nil) {
        return 0;
    } else {
        return [self.collectionArray count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    if (self.collectionArray != nil) {
        NSDictionary *dic = self.collectionArray[indexPath.row];
        cell.textLabel.text = [dic valueForKey:@"title"];
    }
    
    
    
    return cell;
}
#pragma mark -- tableView 编辑
//设置导航栏
-(void)setNavigation{
    [self setBackAction];
    [self addRightButton];
}

//设置返回按钮
-(void)setBackAction{
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(actionLeftButton)];
    [leftButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    
}
- (void)actionLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addRightButton
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStylePlain) target:self action:@selector(actionButton:)];
    rightButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)actionButton:(UIBarButtonItem *)button
{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if (self.tableView.editing == YES) {
        self.navigationItem.rightBarButtonItem.title = @"完成";
    } else {
        self.navigationItem.rightBarButtonItem.title = @"编辑";
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.collectionArray != nil) {
        NSDictionary *dic = self.collectionArray[indexPath.row];
        [self.collectionArray removeObject:dic];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
        self.isChange = YES;
    }
}


#pragma mark --  点击进入收藏
//点击进入收藏
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.collectionArray[indexPath.row];
    if (self.collectionArray) {
        if (self.keyWordNumber == 1) {
            //

            VideoViewController *videoVC = [[VideoViewController alloc]init];
            NSString  *str = [dic valueForKey:@"title"];
            NSString *src = [dic valueForKey:@"src"];
            //videoVC.titleID = str;
            videoVC.model = [[SecondModel alloc]init];
            videoVC.model.foodtitle = str;
            videoVC.model.src = src;
            
            [self.navigationController pushViewController:videoVC animated:YES];
        }
    }

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
