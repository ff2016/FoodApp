//
//  ChengShiVC.m
//  HGY
//

//

#import "ChengShiVC.h"

@interface ChengShiVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, retain)NSMutableArray *dataArray;

// 热点城市
@property (nonatomic, retain)NSMutableArray *hotArray;
// 其他
@property (nonatomic, retain)NSMutableArray *otherArray;
@end

@implementation ChengShiVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray array];
    [self requestDataForReloadWithUrl:cithUrl Block:^(NSArray *array) {
        self.dataArray = (NSMutableArray *)array;
      [self.tableView reloadData];
        
        [self addTableViews];
    }];
    
    self.hotArray = [NSMutableArray array];
    self.otherArray = [NSMutableArray array];
    
   
   
}

- (void)addTableViews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 100 * kHeight) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return self.dataArray.count - 12;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 200;
    } else {
        return 50;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"热门城市";
    } else {
    return @"其他";
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ChengShiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
       if (cell == nil) {
          cell = [[ChengShiTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell"];
            
        }
        for (int i = 1; i < 13; i++) {
            NSString *string = self.dataArray[i];
            
            //  [self.hotArray addObject:string];
            UIButton *button = (UIButton *)[cell.contentView viewWithTag:100 + i];
            [button setTitle:string forState:(UIControlStateNormal)];
            [button addTarget:self action:@selector(actionButton:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            return cell;
    }else if (indexPath.section == 1)
        {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell1"];
        
        }
            for (int i = 13; i < self.dataArray.count; i++) {
                NSString *string = self.dataArray[i];
                
                
                [self.otherArray addObject:string];
            }
            cell.textLabel.text = self.otherArray[indexPath.row];
            
            return cell;

    }
    
    return nil;
}

// 代理方法

- (void)actionButton:(UIButton *)button
{
    NSLog(@"%@", button.titleLabel.text);
   // FirstViewController *vc = [[FirstViewController alloc] init];
    [self.navigationController popViewControllerAnimated:YES];
    
    [_delegate string:button.titleLabel.text];
    
   
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // FirstViewController *vc = [[FirstViewController alloc] init];

    for (int i = 13; i < self.dataArray.count; i++) {
        NSString *string = self.dataArray[i];
        
        
        [self.otherArray addObject:string];
    }
   NSString *str = self.otherArray[indexPath.row];
    [_delegate string:str];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

// 数据源
- (void)requestDataForReloadWithUrl:(NSString *)url Block:(void (^)(NSArray *))block
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:30.0];
        [request setHTTPMethod:@"GET"];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data == nil) {
                return ;
            }
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
            
            self.dataArray = dictionary[@"cities"];
            dispatch_async(dispatch_get_main_queue(), ^{
                block(self.dataArray);
            });
        }];
        [dataTask resume];
    });
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
