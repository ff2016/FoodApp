//
//  AppDelegate.h
//  FoodApp
//
//  Created by lanou3g on 16/6/13.
//  Copyright © 2016年 me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageControl.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,PageControlDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic)PageControl *thePGLeft;
@property (strong, nonatomic)UIScrollView *scrVl;
@end

