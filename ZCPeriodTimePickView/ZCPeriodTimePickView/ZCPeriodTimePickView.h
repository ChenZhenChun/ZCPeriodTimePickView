//
//  ZCPeriodTimePickView.h
//  AiyoyouCocoapods
//
//  Created by aiyoyou on 2019/06/12.
//  Copyright © 2019年 gulu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZCPeriodTimePickView : UIView
@property (nonatomic,assign) BOOL               autoHandleTime;
@property (nonatomic,readonly) NSString         *startTime;
@property (nonatomic,readonly) NSString         *endTime;
@property (nonatomic,readonly) NSInteger        DValue;
@property (nonatomic,readonly) UIView           *magnifyView;

@property (nonatomic,copy) void(^didSelectDatePickView)(NSString *startTime,NSString *endTime,NSInteger DValue);


/**
 滚动至指定的时间

 @param startTime HH:mm
 */
- (void)selectStartTime:(NSString *)startTime;

/**
 滚动至指定的时间
 
 @param endTime HH:mm
 */
- (void)selectEndTime:(NSString *)endTime;

@end
