//
//  HMTDatabaseManager.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/7.
//

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMTDatabaseManager : NSObject

/// 单例
+ (instancetype)sharedManager;

@property (strong, nonatomic) WCTDatabase *database;

@end

NS_ASSUME_NONNULL_END
