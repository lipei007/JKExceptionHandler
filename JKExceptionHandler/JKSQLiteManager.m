//
//  JKSQLite3.m
//  JKSQlite3
//
//  Created by Jack on 8/2/16.
//  Copyright © 2016 mini1. All rights reserved.
//

#import "JKSQLiteManager.h"

@implementation JKSQLiteManager

+ (instancetype)sharedSQLManager {
    static JKSQLiteManager *manager = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[JKSQLiteManager alloc] init];
    });
    return manager;
}

#pragma mark - database

- (sqlite3 *)databaseAtPath:(NSString *)path {
    
    if (!path)
        return nil;
    
    sqlite3 *db = nil;
    
    if (sqlite3_open([path UTF8String],&db) != SQLITE_OK) {
        const char *msg = sqlite3_errmsg(db);
        perror(msg);
        sqlite3_close(db);
    }
    _db = db;
    
    [self execSql:@"pragma journal_mode = wal;"]; // 确保多线程读写不会导致lock
    
    return db;
}

- (BOOL)closeDatabase {
    
    if (!self.db)
        return NO;
    
    if (sqlite3_close(self.db) != SQLITE_OK)
        return NO;
    
    _db = nil;
    return YES;
}

- (BOOL)execSql:(NSString *)sql {
    
    if (!self.db) {
        return NO;
    }
    char *err;
    // 3rd argument: callback function
    // 4th argument: 1st argument of callback function
    if (sqlite3_exec(self.db,[sql UTF8String],NULL,NULL,&err) != SQLITE_OK) {
         NSLog(@"sqlite error:%s",err);
        return NO;
    }
    
    return YES;
}

#pragma mark - table

- (BOOL)createTable:(const char *)sql {
    
    if (!self.db) {
        return NO;
    }
    
    char *error = NULL;
    
    // 3rd argument: callback function
    // 4th argument: 1st argument of callback function
    if (sqlite3_exec(self.db,sql,NULL,NULL,&error) != SQLITE_OK) {
        NSLog(@"sqlite error:%s",error);
        return NO;
    }
    
    return YES;
}

- (BOOL)dropTable:(const char *)table {
    if (!self.db) {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"drop table %s;",table];
    
    return [self execSql:sql];
}

#pragma mark - query

- (NSMutableDictionary *)query:(NSString *)sql complete:(queryBlock)queryBlock {
    
    if (!self.db)
        return nil;
    
    sqlite3 *db = self.db;
    NSString *sqlQuery = sql;
    sqlite3_stmt * statement;
    
    __block NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        long count = 0;
        while (sqlite3_step(statement) == SQLITE_ROW) {
            queryBlock(statement,dic,&count);
        }
        
        sqlite3_finalize(statement);
    } else {
        NSLog(@"sqlite error:%s",sqlite3_errmsg(db));
    }
    
    return [dic copy];
}

- (NSString *)queryText:(NSString *)sql {
    if (!self.db)
        return nil;
    __block NSString *res = nil;
    [self query:sql complete:^(sqlite3_stmt *stmt, NSMutableDictionary *container, long *count) {
        
        char *resCh = (char *)sqlite3_column_text(stmt,0);
        if (resCh == NULL)
                resCh = "";
        
        res = [NSString stringWithUTF8String:resCh];
        
    }];
    return res;
}

#pragma mark - insert

- (BOOL)insertInto:(NSString *)table values:(NSString *)values {
    
    if (!self.db || (!values && !table))
        return NO;
    NSString *sql = [NSString stringWithFormat:@"insert into %@ values %@;",table,values];
    
    return [self execSql:sql];
}

- (BOOL)insertInto:(NSString *)table columns:(NSString *)col values:(NSString *)val {
    if (!self.db || (!table && !col && !val)) {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"insert into %@ %@ values %@;",table,col,val];
    
    return [self execSql:sql];
}

#pragma mark - update

- (BOOL)updateTable:(NSString *)table values:(NSString *)val condition:(NSString *)condition{
    
    NSString *sql = [NSString stringWithFormat:@"update %@ set %@ where %@;",table,val,condition];
    
    return [self execSql:sql];
}

#pragma mark - delete

- (BOOL)deleteFromTable:(const char *)table condition:(NSString *)condition{
    
    NSString *sql = [NSString stringWithFormat:@"delete from %s where %@;",table,condition];
    
    return [self execSql:sql];
}

@end
