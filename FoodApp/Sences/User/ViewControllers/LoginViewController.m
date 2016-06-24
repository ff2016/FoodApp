//
//  LoginViewController.m
//  FoodApp
//


#import "LoginViewController.h"
#import "RegisterViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <Reachability.h>
@interface LoginViewController ()
//用户名及密码
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation LoginViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//返回按钮
- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -- 登录
//登录按钮
- (IBAction)loginAction:(UIButton *)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    if ([conn isReachable]) { // 有网
        __weak LoginViewController *mySelf = self;
        // 判断用户名,密码
        [AVUser logInWithUsernameInBackground:self.userNameTF.text password:self.passwordTF.text block:^(AVUser *user, NSError *error) {
            if (error) {
                NSInteger codeNum = [[error.userInfo valueForKey:@"code"] integerValue];
                if (codeNum == 210) {
                    [mySelf showAlertViewWithMessage:@"用户名或密码错误"];
                } else if (codeNum == 211) {
                    [mySelf showAlertViewWithMessage:@"该用户名还未注册"];
                }
            } else {
                // 发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"USERISLOGIN" object:nil userInfo:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    
    } else {
        [self showAlertViewWithMessage:@"当前网络未连接,注册失败!"];
    }

}
#pragma mark - AlertView
-(void)showAlertViewWithMessage:(NSString *)message{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    // 1秒后回收
    [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:1];
    [self presentViewController:alertView animated:YES completion:nil];

}
- (void)dismissAlertView:(UIAlertController *)alertView
{
    [alertView dismissViewControllerAnimated:YES completion:nil];
}

//去注册按钮
- (IBAction)passAction:(UIButton *)sender {
    RegisterViewController *regiserVC = [[RegisterViewController alloc]init];
    [self presentViewController:regiserVC animated:YES completion:nil];
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
