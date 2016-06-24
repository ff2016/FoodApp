//
//  Header.h
//  HGY
//

//

#ifndef HGY_Header_h
#define HGY_Header_h


#define kScreenWidth [UIScreen mainScreen].bounds.size.width 
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kWidth (kScreenWidth / 414)



#define kHeight (kScreenHeight / 736)



#import "UIView+WLFrame.h"
// 第一页
#import "fristCollectionViewCell.h"
#import "Model.h"
#import "firstFootManager.h"
#import "fristVC.h"
#import "SignatrueEncryption.h"
#import "MeiShiTableViewCell.h"
#import "dealModel.h"
#import "UIImageView+WebCache.h"
#import "ChengShiVC.h"
#import "ChengShiTableViewCell.h"
#import "ShowViewController.h"
#import "sqFenLei.h"
#import "sqModel.h"
#import "UMSocial.h"


#define firstUrl @"http://api.dianping.com/v1/metadata/get_categories_with_deals?appkey=42960815&sign=6AFD15FED56B37F265210060C38B776D55EF8148"
// 城市
#define cithUrl @"http://api.dianping.com/v1/metadata/get_cities_with_deals?appkey=42960815&sign=6AFD15FED56B37F265210060C38B776D55EF8148"




#endif
