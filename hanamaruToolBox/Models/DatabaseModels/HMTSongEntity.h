//
//  HMTSongEntity.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/7.
//

#import <Foundation/Foundation.h>

typedef BOOL (^WCTTransactionBlock)(void);

@interface HMTSongEntity : NSObject

@property(nonatomic, assign) NSInteger iid;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *date;
@property(nonatomic, strong) NSString *url_y;
@property(nonatomic, strong) NSString *url_b;
@property(nonatomic, strong) NSString *platform;
@property(nonatomic, strong) NSString *timestamp;
@property(nonatomic, assign) BOOL isMedleySong;
@property(nonatomic, assign) BOOL isMedleyTitle;

@property(nonatomic, assign) BOOL isAutoIncrement;

+ (BOOL)createDatabase;

+ (BOOL)runTransaction:(WCTTransactionBlock)inTransaction;

+ (BOOL)saveObjects:(NSArray<HMTSongEntity *> *)objects;

+ (BOOL)deleteAllObjects;

+ (NSArray *)allObjects;

+ (NSArray *)objectsWhereIsMedley:(BOOL)isMedley;

@end
