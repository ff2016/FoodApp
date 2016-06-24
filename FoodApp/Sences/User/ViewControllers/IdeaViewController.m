//
//  IdeaViewController.m
//  FoodApp
//


#import "IdeaViewController.h"
#import "ShareModel.h"
@interface IdeaViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *FoodFileTF;
@property (weak, nonatomic) IBOutlet UIImageView *shareOne;
@property (weak, nonatomic) IBOutlet UIImageView *shareTwo;
@property (weak, nonatomic) IBOutlet UIImageView *shareThree;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (nonatomic,assign) NSInteger  number;//  cishu
@end

@implementation IdeaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.number = 0;
}

//添加图片
- (IBAction)addPictureAction:(UIButton *)sender {
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
    self.number ++;
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
#pragma mark - tu像选取完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.number == 1) {
            //
            self.shareOne.image = [info objectForKey:UIImagePickerControllerEditedImage];
            
        }else if (self.number == 2){
            UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
            self.shareTwo.image = image;
        }else{
            UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
            self.shareThree.image = image;
            self.addButton.enabled = NO;
        }
        
    }];
}
//分享发布
- (IBAction)shareAction:(UIButton *)sender {
    if (self.FoodFileTF.text.length == 0 && self.shareOne.image == nil) {
        [self showAlertViewWithMessage:@"信息为空"];
    }
    ShareModel *share = [ShareModel objectWithClassName:@"Share"];
    share.shareIdea  =self.FoodFileTF.text;
    share.shareImageOne = self.shareOne.image;
    share.shareImageTwo  = self.shareTwo.image;
    share.shareImageThree = self.shareThree.image;
    [share saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self showAlertViewWithMessage:@"分享成功"];
            //            self.FoodFileTF.text = @"";
            //可以设置调回上个页面
            
        }else{
            [self showAlertViewWithMessage:@"分享失败,请重新上传"];
        }
    }];
}

#pragma mark - alertView
- (void)showAlertViewWithMessage:(NSString *)message
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    // 1秒后回收
    [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:1];
    if ([message isEqualToString:@"分享成功"]) {
        [self performSelector:@selector(returnAction:) withObject:alertView afterDelay:1];
    }
    [self presentViewController:alertView animated:YES completion:nil];
}
- (void)dismissAlertView:(UIAlertController *)alertView
{
    [alertView dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 点击页面空白出 收取键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
//返回
- (IBAction)returnAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
