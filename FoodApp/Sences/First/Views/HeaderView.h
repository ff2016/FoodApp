//
//  headerView.h
//  Mtime
//


#import <UIKit/UIKit.h>
#import "PBScrollView.h"

@interface HeaderView : UIView

@property (nonatomic, copy)NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet PBScrollView *scrollView;

//@property (nonatomic, weak)IBOutlet PBScrollView *scrollView;



@end
