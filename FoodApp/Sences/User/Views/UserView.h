//
//  UserView.h
//  FoodApp
//


#import <UIKit/UIKit.h>

@interface UserView : UIView

@property (nonatomic, strong) UIButton *bgUserButton;
@property (nonatomic, strong) UIImageView *userImgV;
@property (nonatomic, strong) UILabel *userNameLb;


@property (nonatomic,strong)  UIView *bgThreeBtmView;// 按钮背景
@property (nonatomic,strong)  UIView *bgMyBtnView;//
@property (nonatomic,strong)  UIButton *myButton;//
@property (nonatomic,strong)  UIImageView *markView;//  指向按钮
@property (nonatomic,strong)  UICollectionView *myCollection;//  我的分类


// 意见按钮
@property (nonatomic, strong) UIButton *ideaButton;
// 设置按钮
@property (nonatomic, strong) UIButton *setButton;
// 关于我们按钮
@property (nonatomic, strong) UIButton *aboutButton;





@end
