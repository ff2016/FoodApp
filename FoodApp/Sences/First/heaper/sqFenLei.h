//
//  sqFenLei.h
//  HGY
//

//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "sqModel.h"

@interface sqFenLei : NSObject

+ (sqFenLei *)shareManager;
- (sqlite3 *)openDB;
- (void)closeDB;
- (void)createTable;
- (void)insetWith:(sqModel *)model;
- (NSMutableArray *)queryAll;

- (void)deleteStudentWithString:(NSString *)string;

@end
