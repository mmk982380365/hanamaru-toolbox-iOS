//
//  HMTSongEntity+WCTTableCoding.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/7.
//

#import "HMTSongEntity.h"
#import <WCDB/WCDB.h>

@interface HMTSongEntity (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(iid)
WCDB_PROPERTY(title)
WCDB_PROPERTY(date)
WCDB_PROPERTY(url_y)
WCDB_PROPERTY(url_b)
WCDB_PROPERTY(platform)
WCDB_PROPERTY(timestamp)
WCDB_PROPERTY(isMedleySong)
WCDB_PROPERTY(isMedleyTitle)

@end
