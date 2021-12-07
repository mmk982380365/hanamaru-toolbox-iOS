//
//  HMTDatabaseManager.m
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/7.
//

#import "HMTDatabaseManager.h"

@implementation HMTDatabaseManager

+ (instancetype)sharedManager {
    static HMTDatabaseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HMTDatabaseManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *databasePath = [HMTDatabaseManager databasePath];
        _database = [[WCTDatabase alloc] initWithPath:databasePath];
        
//        [WCTStatistics SetGlobalSQLTrace:^(NSString *sql) {
//            NSLog(@"%@", sql);
//        }];
    }
    return self;
}

- (BOOL)createDatabase:(Class)objectClass {
    if ([_database canOpen]) {
        return [_database createTableAndIndexesOfName:NSStringFromClass(objectClass) withClass:objectClass];
    }
    return NO;
}

+ (NSString *)databasePath {
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    return [cachePath stringByAppendingPathComponent:@"data.db"];
}

@end
