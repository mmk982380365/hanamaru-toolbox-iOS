//
//  HMTSongEntity.mm
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/7.
//

#import "HMTSongEntity+WCTTableCoding.h"
#import "HMTSongEntity.h"
#import "HMTDatabaseManager.h"

#import <WCDB/WCDB.h>

@implementation HMTSongEntity

WCDB_IMPLEMENTATION(HMTSongEntity)

WCDB_SYNTHESIZE(HMTSongEntity, iid)
WCDB_SYNTHESIZE(HMTSongEntity, title)
WCDB_SYNTHESIZE(HMTSongEntity, date)
WCDB_SYNTHESIZE(HMTSongEntity, url_y)
WCDB_SYNTHESIZE(HMTSongEntity, url_b)
WCDB_SYNTHESIZE(HMTSongEntity, platform)
WCDB_SYNTHESIZE(HMTSongEntity, timestamp)
WCDB_SYNTHESIZE(HMTSongEntity, isMedleySong)
WCDB_SYNTHESIZE(HMTSongEntity, isMedleyTitle)

WCDB_PRIMARY_ASC_AUTO_INCREMENT(HMTSongEntity, iid)

+ (BOOL)createDatabase {
    return [[HMTDatabaseManager sharedManager].database createTableAndIndexesOfName:NSStringFromClass(HMTSongEntity.class) withClass:HMTSongEntity.class];
}

+ (BOOL)runTransaction:(WCTTransactionBlock)inTransaction {
    return [[HMTDatabaseManager sharedManager].database runTransaction:inTransaction];
}

+ (BOOL)saveObjects:(NSArray<HMTSongEntity *> *)objects {
    WCTDatabase *db = [HMTDatabaseManager sharedManager].database;
    return [db insertOrReplaceObjects:objects into:NSStringFromClass(HMTSongEntity.class)];
}

+ (BOOL)deleteAllObjects {
    WCTDatabase *db = [HMTDatabaseManager sharedManager].database;
    return [db deleteAllObjectsFromTable:NSStringFromClass(HMTSongEntity.class)];
}

+ (NSArray *)allObjects {
    WCTDatabase *db = [HMTDatabaseManager sharedManager].database;
    
    WCTSelect *select = [db prepareSelectObjectsOfClass:HMTSongEntity.class fromTable:NSStringFromClass(HMTSongEntity.class)];
    
    
    return select.allObjects;
}

+ (NSArray *)objectsWhereIsMedley:(BOOL)isMedley {
    WCTDatabase *db = [HMTDatabaseManager sharedManager].database;
    
    WCTSelect *select = [db prepareSelectObjectsOfClass:HMTSongEntity.class fromTable:NSStringFromClass(HMTSongEntity.class)];
    
    
    select = [select where:HMTSongEntity.isMedleySong == isMedley];
    
    return select.allObjects;
}

@end
