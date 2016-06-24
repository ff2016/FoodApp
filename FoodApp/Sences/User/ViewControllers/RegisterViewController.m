//
//  RegisterViewController.m
//  FoodApp
//


#import "RegisterViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <Reachability.h>


@interface RegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *againPasswordTF;

@property (nonatomic,strong)  NSMutableArray *mealArray;//  美食
@property (nonatomic,strong)  NSMutableArray *collectArray;//  收藏
@property (nonatomic,strong)  NSMutableArray *socialArray;//  社区
@property (nonatomic,strong)  NSMutableArray *readingArray;//  美文

@end

@implementation RegisterViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置代理
    self.userNameTF.delegate = self;
    self.passwordTF.delegate = self;
    self.againPasswordTF.delegate = self;
    self.phoneNumTF.delegate = self;

    
}

#pragma mark - 设置页面
//键盘回收事件
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.phoneNumTF) {
        [textField resignFirstResponder];
        return YES;
    } else {
        NSInteger nextTag = textField.tag + 1;
        UITextField *nextTF = (UITextField *)[self.view viewWithTag:nextTag];
        [nextTF becomeFirstResponder];
    }
    return YES;

}

//点击空白收取键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];

}


//返回按钮
- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 注册
//注册按钮
- (IBAction)registerAction:(UIButton *)sender {
    //判断用户名,密码等
    if (self.userNameTF.text.length == 0) {
        [self showAlertViewWithMessage:@"用户名不能为空"];
    } else if (self.passwordTF.text.length == 0 || self.againPasswordTF.text.length == 0) {
        [self showAlertViewWithMessage:@"密码不能为空"];
    } else if (![self.passwordTF.text isEqualToString:self.againPasswordTF.text]) {
        [self showAlertViewWithMessage:@"两个输入的密码不一致"];
    } else {
        // 验证注册
        [self registerUserInfo];
    }
    
}
-(void)registerUserInfo{
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    if ([conn isReachable]) {
        AVUser *user = [AVUser user];
        user.username = self.userNameTF.text;
        user.password = self.passwordTF.text;
        user.mobilePhoneNumber = self.phoneNumTF.text;
        //注册
        __weak RegisterViewController *mySelf = self;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                //若注册成功,取出登录用户
                AVUser *currentUser = [AVUser currentUser];
                AVFile *image = [AVFile fileWithName:@"DefaultAvatar" contentsAtPath:[[NSBundle mainBundle] pathForResource:@"DefaultAvatar" ofType:@"png"]];
                [currentUser setObject:image forKey:@"image"];
                
                _mealArray = [NSMutableArray array];
                _collectArray = [NSMutableArray array];
                _socialArray = [NSMutableArray array];
                _readingArray = [NSMutableArray array];
                
                [currentUser setObject:_mealArray forKey:@"meal"];
                [currentUser setObject:_collectArray forKey:@"collect"];
                [currentUser setObject:_socialArray forKey:@"social"];
                [currentUser setObject:_readingArray forKey:@"reading"];
                
            
                [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    //发送通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"USERISLOGIN" object:nil userInfo:nil];
                }];
                [self dismissViewControllerAnimated:YES completion:nil];
                [self showAlertViewWithMessage:@"注册成功请登录"];
                
            }else{
            //注册失败
                NSInteger codeNum = [[error.userInfo valueForKey:@"code"] integerValue];
                switch (codeNum) {
                        
                    case 202:
                        [mySelf showAlertViewWithMessage:@"该用户名已经注册,可以直接登录!"];
                        break;
                    case 203:
                        [mySelf showAlertViewWithMessage:@"您输入的邮箱已经被占用!"];
                        break;
                    case 125:
                        [mySelf showAlertViewWithMessage:@"请输入正确的邮箱!"];
                        break;
                    case 127:
                        [mySelf showAlertViewWithMessage:@"请输入正确的手机号码!"];
                        break;
                    case 214:
                        [mySelf showAlertViewWithMessage:@"您输入的手机号码已经被占用!"];
                        break;
                    default:
                        break;
                }
//                NSLog(@"注册失败");
               
            }
        }];
    }else{
        [self showAlertViewWithMessage:@"网络错误,注册失败"];
    }

}

#pragma mark - alertView
-(void)showAlertViewWithMessage:(NSString *)message{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:1];
    [self presentViewController:alertView animated:YES completion:nil];

}
-(void)dismissAlertView:(UIAlertController *)alertView{
    [alertView dismissViewControllerAnimated:YES completion:nil];
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
