//
//  sqFenLei.m
//  HGY
//

//

#import "sqFenLei.h"

@implementation sqFenLei

+ (sqFenLei *)shareManager
{
    static sqFenLei *share = nil;
    if (share == nil) {
        share = [[sqFenLei alloc] init];
    }
    return share;
}

static sqlite3 *db = nil;
- (sqlite3 *)openDB
{
    if (db != nil) {
        return db;
    }
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"sqDeal.sqlite"];
    NSLog(@"%@", dbPath);
    int result = sqlite3_open(dbPath.UTF8String, &db);
    if (result == SQLITE_OK) {
        NSLog(@"创建成功");
    } else {
        NSLog(@"创建失败");
    }
    return db;
    
}
- (void)closeDB
{
    int result = sqlite3_close(db);
    if (result == SQLITE_OK ) {
        NSLog(@"关闭成功");
        db = nil;
    } else {
        NSLog(@"关闭失败");
    }
}
// 创建
- (void)createTable
{
    [self openDB];
    NSString *sql = @"create table IF NOT EXISTS sqModel(title text primary key not NULL, deal_h5_url text not NULL, s_image_url text not NULL, city text not NULL)";
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"创建表成功");
    } else {
        NSLog(@"创建失败");
    }
    [self closeDB];
    
    
}
- (void)insetWith:(sqModel *)model
{
    db = [self openDB];
    NSString *sql = [NSString stringWithFormat:@"insert into sqModel(title, deal_h5_url, s_image_url, city) values ('%@', '%@', '%@', '%@')", model.title, model.deal_h5_url, model.s_image_url, model.city];
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"插入成功");
    } else {
        NSLog(@"插入失败");
    }
    [self closeDB];
}
- (NSMutableArray *)queryAll
{
    [self openDB];
    NSString *sql = [NSString stringWithFormat:@"select * from sqModel"];
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSMutableArray *array = [NSMutableArray array];
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            char *title = (char *)sqlite3_column_text(stmt, 0);
            char *deal_h5_url = (char *)sqlite3_column_text(stmt, 1);
            char *s_image_url = (char *)sqlite3_column_text(stmt, 2);
            char *city = (char *)sqlite3_column_text(stmt, 3);
            sqModel *model = [[sqModel alloc] init];
            model.title = [NSString stringWithUTF8String:title];
            model.deal_h5_url = [NSString stringWithUTF8String:deal_h5_url];
            model.s_image_url = [NSString stringWithUTF8String:s_image_url];
            model.city = [NSString stringWithUTF8String:city];
            [array addObject:model];
        }
        sqlite3_finalize(stmt);
        [self closeDB];
        return array;
    } else {
        NSLog(@"查询所有失败");
    }
    [self closeDB];
    
    return nil;
}

- (void)deleteStudentWithString:(NSString *)string
{
    // 1.打开数据库
    [self openDB];
    // 2.写sql语句
    NSString *sql = [NSString stringWithFormat: @"delete from sqModel where title = '%@'", string ];
    // 3.执行语句
    int result = sqlite3_exec(db , sql.UTF8String, NULL, NULL, NULL);
    // 4.判断是否成功
    if (result == SQLITE_OK) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除不成功");
    }
    // 5.关闭数据库
    [self closeDB];



}


@end
