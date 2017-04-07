//
//  ReadDB.m
//  CarSeller
//
//  Created by jenson.zuo on 15/1/2016.
//  Copyright © 2016 CloudStone Tech. All rights reserved.
//

#import "ReadDB.h"
#include "FMDB.h"

static NSString* TABLENAME = @"reads";

@interface ReadDB ()
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation ReadDB
-(id)init{
    if (self = [super init]) {
        NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                                    , NSUserDomainMask
                                                                    , YES);
        NSString *databaseFilePath=[[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:@"readdb"];
        self.db = [[FMDatabase alloc]initWithPath:databaseFilePath];
        if ([self.db open]) {
            NSString *createSql = [NSString stringWithFormat: @"create table if not exists %@ (id text)", TABLENAME];
            BOOL result = [self.db executeStatements:createSql];
            if (!result) {
                NSLog(@"create false.");
            }
        }
    }
    return self;
}
-(void)dealloc{
    [self.db close];
}

-(BOOL)save:(NSString*)idValue{
    NSString *sql = [NSString stringWithFormat:@"insert or replace into %@ (id) values ('%@')",TABLENAME,idValue ];
    if ([self.db executeUpdate:sql]){
        NSLog(@"insert ok.");
        return true;
    }
    return false;
}

-(void)isExistById:(NSArray*)objs{
    if(objs == nil){
        return;
    }
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"select id from %@ where",TABLENAME];
    for(int i = 0; i < [objs count]; ++i){
        id<ReadModel> obj = [objs objectAtIndex:i];
        if ([obj isKindOfClass:[NSArray class]]) {
            continue;
        }
        if(i == 0){
            [sql appendFormat:@" id='%@' ",[obj id]];
        }else{
            [sql appendFormat:@" or id='%@' ",[obj id]];
        }
    }
    FMResultSet *result = [self.db executeQuery:sql];
    while ([result next]) {
        NSString *fieldString = [result stringForColumnIndex:0];
        for(int i = 0; i < [objs count]; ++i){
            id<ReadModel> obj = [objs objectAtIndex:i];
            if ([obj isKindOfClass:[NSArray class]]) {
                continue;
            }
            if([[obj id] isEqualToString:fieldString]){
                [obj setRead:TRUE];
                break;
            }
        }
    }
}
@end
