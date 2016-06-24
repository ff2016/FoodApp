//
//  UserInfoViewController.m
//  FoodApp


#import "UserInfoViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <Reachability.h>
#import <UIImageView+WebCache.h>
@interface UserInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *userNameLb;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UILabel *emailLb;
// 保存更改前头像
@property (nonatomic, strong) AVFile *lastImg;

@end

@implementation UserInfoViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的资料";
    [self setBackAction];
    [self setValue];
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
//赋值
-(void)setValue{
    AVUser *currentUser = [AVUser currentUser];
    self.userNameLb.text = currentUser.username;
    self.phoneNum.text = currentUser.mobilePhoneNumber;
    self.emailLb.text = currentUser.email;
    
    
    AVFile *image = [currentUser objectForKey:@"image"];
    
    [self.userImg sd_setImageWithURL:[NSURL URLWithString:image.url] placeholderImage:[UIImage imageNamed:@"DefaultAvatar"]];

}

//选取用户头像
- (IBAction)chooseUserImageAction:(UITapGestureRecognizer *)sender {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 检测设备是否支持系统相册
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIAlertAction *xiangCe = [UIAlertAction actionWithTitle:@"相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self chooseImageWith:UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        [alertC addAction:xiangCe];
    }
    
    // 检测设备是否支持图片库
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIAlertAction *photoKu = [UIAlertAction actionWithTitle:@"图片库选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self chooseImageWith:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }];
        [alertC addAction:photoKu];
    }
    
    // 检测设备是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"摄像头拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self chooseImageWith:UIImagePickerControllerSourceTypeCamera];
        }];
        [alertC addAction:camera];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:cancel];
    
    [self presentViewController:alertC animated:YES completion:nil];
    
    
    
}
#pragma mark - 选取图片
- (void)chooseImageWith:(UIImagePickerControllerSourceType)actionStyle
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = actionStyle;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - 头像选取完成后的事件
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage]; // 修改后的头像
    AVUser *currentUser = [AVUser currentUser];
    NSData* imageData = UIImagePNGRepresentation(image);
    __weak UserInfoViewController *mySelf = self;
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    if ([conn isReachable]) { // 有网
        mySelf.lastImg = [currentUser objectForKey:@"image"];
        [currentUser setObject:[AVFile fileWithData:imageData] forKey:@"image"];
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self dismissViewControllerAnimated:YES completion:nil];
//            _bgView.hidden = YES;
//            [_loadingView stopAnimating];
            if (succeeded) {
                self.userImg.image = image;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"USERISLOGIN" object:nil userInfo:nil];
                [self showAlertViewWithMessage:@"更换头像成功!"];
            } else {
                [self showAlertViewWithMessage:@"上传头像失败!"];
                [currentUser setObject:mySelf.lastImg forKey:@"image"];
            }
        }];
    } else {
//        _bgView.hidden = YES;
//        [_loadingView stopAnimating];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self showAlertViewWithMessage:@"网络未连接,更换头像失败!"];
    }


}

#pragma mark - alertView
- (void)showAlertViewWithMessage:(NSString *)message
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    // 1秒后回收
    [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:1.5];
    [self presentViewController:alertView animated:YES completion:nil];
}
- (void)dismissAlertView:(UIAlertController *)alertView
{
    [alertView dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 退出登录
//退出登录
- (IBAction)outAction:(UIButton *)sender {
    [AVUser logOut];
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"USERISLOGIN" object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
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
