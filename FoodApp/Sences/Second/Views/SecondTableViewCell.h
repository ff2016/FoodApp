//
//  SecondTableViewCell.h
//  FoodApp
//

#import <UIKit/UIKit.h>
#import "SecondModel.h"

@interface SecondTableViewCell : UITableViewCell<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *titlepic;
@property (weak, nonatomic) IBOutlet UILabel *foodTitle;
@property (weak, nonatomic) IBOutlet UILabel *kouwei;

@property(nonatomic, strong)SecondModel *secondModel;
@property (weak, nonatomic) IBOutlet UILabel *m;
@property (weak, nonatomic) IBOutlet UILabel *md;



@end
