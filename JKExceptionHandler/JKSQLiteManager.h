//
//  JKSQLite3.h
//  JKSQlite3
//
//  Created by Jack on 8/2/16.
//  Copyright © 2016 mini1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

//typedef void(^complete)(sqlite3_stmt *stmt);
typedef void(^queryBlock)(sqlite3_stmt *stmt,NSMutableDictionary *container,long *count);


@interface JKSQLiteManager : NSObject


@property (nonatomic,assign,readonly) sqlite3 *db;


+ (instancetype)sharedSQLManager;

/**
 *  @author Jack, 16-08-03 08:08:41
 *
 *  创建／打开数据库
 *
 *  @param path 数据库路径
 *
 *  @return sqlite3 数据库对象
 */
- (sqlite3 *)databaseAtPath:(NSString *)path;

/**
 *  @author Jack, 16-08-03 09:08:55
 *
 *  关闭数据库
 *
 *  @return 是否关闭成功
 */
- (BOOL)closeDatabase;

/**
 *  @author Jack, 16-08-03 08:08:33
 *
 *  创建表
 *
 *  @param sql 建表sql语句
 *
 *  @return 建表是否成功
 */
- (BOOL)createTable:(const char *)sql;

/**
 *  @author Jack, 16-08-03 08:08:22
 *
 *  销毁表
 *
 *  @param table 需要销毁的表名
 *
 *  @return 是否销毁成功
 */
- (BOOL)dropTable:(const char *)table;

- (BOOL)execSql:(NSString *)sql;

#pragma mark - query

/**
 *  @author Jack, 16-08-03 10:08:58
 *
 *  查询
 *
 *  @param sql        查询语句
 *  @param completion 查询成功block，block中取值操作形如：char *name = (char *) sqlite3_column_text(statement, 1);
 */
- (NSMutableDictionary *)query:(NSString *)sql complete:(queryBlock)queryBlock;

- (NSString *)queryText:(NSString *)sql;

#pragma mark - insert

/**
 *  @author Jack, 16-08-03 10:08:37
 *
 *  向表中插入数据
 *
 *  @param table 待插入数据的表名
 *  @param values 待插入的数据,形如：(10,'dd','fk')
 *
 *  @return 是否插入成功
 */
- (BOOL)insertInto:(NSString *)table values:(NSString *)values;
/**(name,sno,age)   ('li',7,18)*/
- (BOOL)insertInto:(NSString *)table columns:(NSString *)col values:(NSString *)val;

#pragma mark - update
/** val:    name = 'andy',age = 12,sno = 45 */
- (BOOL)updateTable:(NSString *)table values:(NSString *)val condition:(NSString *)condition;

#pragma mark - delete

- (BOOL)deleteFromTable:(const char *)table condition:(NSString *)condition;

@end
