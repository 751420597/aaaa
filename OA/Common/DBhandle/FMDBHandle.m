//
//  FMDBHandle.m
//  DouBier
//
//  Created by lanou3g on 15-5-8.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "FMDBHandle.h"

@implementation FMDBHandle

static FMDBHandle *fmdbHandle=nil;

FMDatabase *db;
+(FMDBHandle *)shareHandle
{
    @synchronized(self){
        if(fmdbHandle == nil){
            fmdbHandle=[[FMDBHandle alloc]init];
            
            //沙河地址
            NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            NSString *dbPath=[cachePath stringByAppendingString:@"/MFBLibrary.sqlite"];
            
           //在沙盒里找
            BOOL isExist=[[NSFileManager defaultManager]fileExistsAtPath:dbPath];
            if(!isExist){
                
                NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                
                NSString * documentDirectory = [paths objectAtIndex:0];
                
                NSString * dbPath = [documentDirectory stringByAppendingPathComponent:@"MFBLibrary.sqlite"];
                NSLog(@"dbPath=%@",dbPath);
                
            }
            db = [FMDatabase databaseWithPath:dbPath];
            [db open];
            if (![db open]) {
                NSLog(@"不能打开数据库");
                return nil;
            }else{
                NSLog(@"成功打开数据库");
            }
            
            // NSString * sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS MFBdb ()"];
            NSString * sqlCreateTable = [NSString stringWithFormat:@"create table if not exists MFBdb (account text primary key not null,handlePassWord text,isHand text,isTouch text)"];
            BOOL res = [db executeUpdate:sqlCreateTable];
            /**
             *  增加表字段（不存在就增加该字段）第一版本是没有这个字段的，第二版本是有的，所以第一版本升级到第三版本指纹是需要重新设定的。
             */
            if (![db columnExists:@"isTouch" inTableWithName:@"MFBdb"]) {
                NSString *alertStr=[NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",@"MFBdb",@"isTouch"];
                res = [db executeUpdate:alertStr];
            }

            NSString *productStr = [NSString stringWithFormat:@"create table if not exists Product (id integer primary key autoincrement not null,content text,productType text)"];
            BOOL res2 = [db executeUpdate:productStr];
            
            NSString *myInvestStr = [NSString stringWithFormat:@"create table if not exists MyInvest (id integer primary key autoincrement not null,content text,user text,status text)"];
            BOOL res3 = [db executeUpdate:myInvestStr];
            
            if (!res) {
                NSLog(@"创建表时出错");
            } else {
                NSLog(@"成功创建表");
            }
            if (!res2) {
                NSLog(@"创建产品表时出错");
            } else {
                NSLog(@"成功创建产品表");
            }
            if (!res3) {
                NSLog(@"创建我的投资时出错");
            } else {
                NSLog(@"成功我的投资表");
            }
            
//                //在工程里找
//                NSString *path=[[NSBundle mainBundle]pathForResource:@"KLILI" ofType:@"sqlite"];
//               
//                //拷贝到沙河一份
//                [[NSFileManager defaultManager]copyItemAtPath:path toPath:dbPath error:nil];
            
            
            if (!db) {
               //根据路径创建数据库
                db=[FMDatabase databaseWithPath:dbPath];
            }
            NSLog(@"%@",dbPath);
            
        }
    }
    return fmdbHandle;
}

//存值
-(void)insertNumAccount:(NSString*)account HPassWord:(NSString*)handlePassWord IsHand:(NSString *)isHand IsTouch:(NSString *)isTouch
{
    
    [db open];
    if([db open]){
    
    NSString *sqlStr=@"INSERT OR REPLACE INTO MFBdb (account,handlePassWord,isHand,isTouch) values(?,?,?,?)";
   
    //执行语句
    [db executeUpdate:sqlStr withArgumentsInArray:@[account,handlePassWord,isHand,isTouch]];
    
    
    }
    [db close];
  
}
//根据用户名读取手势密码
-(NSMutableArray *)selectHandlePassWordWithAccount:(NSString*)account
{
    [db open];
    NSMutableArray *arr = [NSMutableArray array];
    if( [db open]){
    
    NSString *sqlStr=@"select handlePassWord from MFBdb where account = ?";
   
    //执行语句
    FMResultSet * result = [db executeQuery:sqlStr,account];
    while ([result next]) {
     
        for(int i = 0; i<[result columnCount]; i++)
            {
            
           NSString* str = [result objectForColumnName:@"handlePassWord"];
            
            [arr addObject:str];
            }
        
        }
    }
    [db close];
    return arr;
}

//根据用户名读取手势设置状态
-(NSMutableArray *)selectIsHandWithAccount:(NSString*)account
{
    [db open];
    NSMutableArray *arr = [NSMutableArray array];
    if( [db open]){
        
        NSString *sqlStr=@"select isHand from MFBdb where account = ?";
       
        //执行语句
        FMResultSet * result = [db executeQuery:sqlStr,account];
        while ([result next]) {
            
            for(int i = 0; i<[result columnCount]; i++)
            {
                
                NSString* str = [result objectForColumnName:@"isHand"];
                
                [arr addObject:str];
            }
            
        }
    }
    [db close];
    return arr;
}
-(NSMutableArray *)selectIsTouchWithAccount:(NSString*)account{
    [db open];
    NSMutableArray *arr = [NSMutableArray array];
    if( [db open]){
        
        NSString *sqlStr=@"select isTouch from MFBdb where account = ?";
        
        //执行语句
        FMResultSet * result = [db executeQuery:sqlStr,account];
        while ([result next]) {
            
            for(int i = 0; i<[result columnCount]; i++)
            {
                
                /**
                 *  判断新添加的字段对象类型不为空的时候才向数组添加
                 */
                if (![[result objectForColumnName:@"isTouch"]isKindOfClass:[NSNull class]])
                {
                    NSString* str = [result objectForColumnName:@"isTouch"];
                    
                    [arr addObject:str];
                }

            }
            
        }
    }
    [db close];
    return arr;
}
#pragma mark 根据账号删除手势密码
-(BOOL) deleteHandlePassWordWithAccount:(NSString *)account{
    BOOL mark=NO;
    [db open];
    if ([db open]) {//questionID text,type text,content text,username text,owner text
        NSString *sql;
        sql = [NSString stringWithFormat:@"delete from MFBdb where account ='%@'",account];
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"删除产品信息失败");
            mark = false;
        } else {
            mark = true;
            NSLog(@"删除产品信息成功");
        }
        [db close];
    }
    return mark;
}
//---------------------------------产品表---------------------------------

#pragma mark 添加产品缓存数据
-(BOOL)addProduct:(NSString *)content withProductType:(NSString *)productType
{
    BOOL mark=NO;
    [db open];
    if ([db open]) {
        NSString * sql = @"insert into product (content,productType) values(?,?) ";
        BOOL res = [db executeUpdate:sql, content,productType];
        if (!res) {
            NSLog(@"插入失败");
            mark = false;
        } else {
            mark = true;
            NSLog(@"插入成功");
        }
        [db close];
    }
    return mark;
}
#pragma mark 得到产品缓存数据
-(NSString *)getProductCacheData:(NSString *)productType
{
    [db open];
    NSString *dataStr;
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"select * from product where productType='%@'",productType];
        FMResultSet * rs = [db executeQuery:sql];
        
        while ([rs next]) {
            dataStr = [rs stringForColumn:@"content"];
        }
        [db close];
    }
    return dataStr;
}
#pragma mark 删除数据
-(BOOL) deleteProduct:(NSString *)productType
{
    BOOL mark=NO;
    [db open];
    if ([db open]) {//questionID text,type text,content text,username text,owner text
        NSString *sql;
        sql = [NSString stringWithFormat:@"delete from product where productType ='%@'",productType];
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"删除产品信息失败");
            mark = false;
        } else {
            mark = true;
            NSLog(@"删除产品信息成功");
        }
        [db close];
    }
    return mark;
}

//---------------------------------我的投资---------------------------------

#pragma mark 添加我的投资缓存数据
-(BOOL)addMyInvestWithContent:(NSString *)content withUser:(NSString *)user withStatus:(NSString *)status
{
    BOOL mark=NO;
    [db open];
    if ([db open]) {
        NSString * sql = @"insert into MyInvest (content,user,status) values(?,?,?) ";
        BOOL res = [db executeUpdate:sql, content,user,status];
        if (!res) {
            NSLog(@"插入我的投资失败");
            mark = false;
        } else {
            mark = true;
            NSLog(@"插入我的投资成功");
        }
        [db close];
    }
    return mark;
}

#pragma mark 得到我的投资缓存数据
-(NSString *)getMyInvestWithUser:(NSString *)user  withStatus:(NSString *)status
{
    [db open];
    NSString *dataStr;
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"select * from MyInvest where user ='%@' and status ='%@'",user,status];
        FMResultSet * rs = [db executeQuery:sql];
        
        while ([rs next]) {
            dataStr = [rs stringForColumn:@"content"];
        }
        [db close];
    }
    return dataStr;
}

#pragma mark 删除数据
-(BOOL) deleteMyInvestWithUser:(NSString *)user  withStatus:(NSString *)status
{
    BOOL mark=NO;
    [db open];
    if ([db open]) {//questionID text,type text,content text,username text,owner text
        NSString *sql;
        sql = [NSString stringWithFormat:@"delete from MyInvest where user='%@' and status ='%@'",user,status];
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            NSLog(@"删除我的投资失败");
            mark = false;
        } else {
            mark = true;
            NSLog(@"删除我的投资成功");
        }
        [db close];
    }
    return mark;
}
@end
