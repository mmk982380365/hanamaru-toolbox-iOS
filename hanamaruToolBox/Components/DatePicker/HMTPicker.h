//
//  HMTPicker.h
//  hanamaruToolBox
//
//  Created by Yuuki on 2021/12/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HMTPickerViewType) {
    HMTPickerViewTypeDate = 0,
    HMTPickerViewTypeStringArray
};

typedef NS_ENUM(NSInteger, HMTPickerViewDateMode) {
    HMTPickerViewDateModeTime,           // Displays hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. 6 | 53 | PM)
    HMTPickerViewDateModeDate,           // Displays month, day, and year depending on the locale setting (e.g. November | 15 | 2007)
    HMTPickerViewDateModeDateAndTime,    // Displays date, hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. Wed Nov 15 | 6 | 53 | PM)
    HMTPickerViewDateModeCountDownTimer, // Displays hour and minute (e.g. 1 | 53)
};

@interface HMTPicker : UIViewController

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithType:(HMTPickerViewType)type;

@property (assign, nonatomic, readonly) HMTPickerViewType type;

- (void)show;

#pragma mark - Callback

@property (copy, nonatomic) void (^confirmCallback)(id _Nullable data);

@property (copy, nonatomic) void (^cancelCallback)(void);

#pragma mark - HMTPickerViewTypeDate Attribute

@property (assign, nonatomic) HMTPickerViewDateMode dateMode;

@property (nonatomic, strong) NSDate *date;

@property (nullable, nonatomic, strong) NSDate *minimumDate;

@property (nullable, nonatomic, strong) NSDate *maximumDate;

#pragma mark - HMTPickerViewTypeStringArray Attribute

@property (strong, nonatomic) NSArray *dataArray;

@property (assign, nonatomic) NSInteger dataSelectIndex;

@end

NS_ASSUME_NONNULL_END
