//
//  ZCPeriodTimePickView.m
//  AiyoyouCocoapods
//
//  Created by aiyoyou on 2019/06/12.
//  Copyright © 2019年 gulu. All rights reserved.
//

#import "ZCPeriodTimePickView.h"

#define DatePickViewH 216 //UIPickView在ios7下无法修改其高度
#define HourCount 24
#define MinuteCount 60
#define Components 5
#define RowH 44

@interface ZCPeriodTimePickView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) UIPickerView   *datePickView;
@property (nonatomic,strong) NSMutableArray *component0Array;
@property (nonatomic,strong) NSMutableArray *component1Array;
@property (nonatomic,strong) NSMutableArray *component2Array;
@property (nonatomic,strong) NSMutableArray *component3Array;
@property (nonatomic,strong) NSMutableArray *component4Array;
@property (nonatomic,copy) NSString         *startTime;
@property (nonatomic,copy) NSString         *endTime;

@property (nonatomic,strong) UIView         *magnifyView;
@end

@implementation ZCPeriodTimePickView


- (void)setFrame:(CGRect)frame {
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    frame.size.height = DatePickViewH;
    [super setFrame:frame];
    [self configInit];
}

- (void)configInit {
    
    //数据源初始化
    _component0Array = [[NSMutableArray alloc]init];
    _component1Array = [[NSMutableArray alloc]init];
    _component2Array = [[NSMutableArray alloc]init];
    _component3Array = [[NSMutableArray alloc]init];
    _component4Array = [[NSMutableArray alloc]init];
    for (int i=0; i<24; i++) {
        [_component0Array addObject:[NSString stringWithFormat:@"%02d",i]];
        [_component3Array addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    [_component2Array addObject:@"至"];
    for (int i=0; i<60; i++) {
        [_component1Array addObject:[NSString stringWithFormat:@"%02d",i]];
        [_component4Array addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    //pickView初始化
    if (!_datePickView) {
        _datePickView = [[UIPickerView alloc]init];
        _datePickView.dataSource = self;
        _datePickView.delegate = self;
        _datePickView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _datePickView.showsSelectionIndicator = YES;
        _datePickView.frame = self.bounds;
        _datePickView.backgroundColor = [UIColor clearColor];
        [self addSubview:_datePickView];
    }
    
    //默认时间选择
    [self selectStartTime:nil];
    [self selectEndTime:nil];
    
    //中间放大区域样式view
    if (!_magnifyView) {
        _magnifyView = [[UIView alloc] initWithFrame:CGRectMake(15,(DatePickViewH-RowH)/2.0,[UIScreen mainScreen].bounds.size.width-30,RowH)];
        _magnifyView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        _magnifyView.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1].CGColor;
        _magnifyView.layer.borderWidth = 0.5;
        _magnifyView.layer.cornerRadius = RowH/2.0;
        [self insertSubview:_magnifyView atIndex:0];
    }
}

#pragma mark -UIPickerViewDelegate

// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return Components;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0||component == 3) return HourCount;
    if (component == 2) return 1;
    return MinuteCount;
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return ([[UIScreen mainScreen] bounds].size.width-100)/Components;
}

//每行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return RowH;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSMutableArray *valueArray = [self valueForKeyPath:[NSString stringWithFormat:@"component%ldArray",(long)component]];
    NSString *value = valueArray[row];
    switch (component) {
        case 0:
            _startTime = [_startTime stringByReplacingCharactersInRange:NSMakeRange(0,2) withString:value];
            break;
        case 1:
            _startTime = [_startTime stringByReplacingCharactersInRange:NSMakeRange(3,2) withString:value];
            break;
        case 3:
            _endTime = [_endTime stringByReplacingCharactersInRange:NSMakeRange(0,2) withString:value];
            break;
        case 4:
            _endTime = [_endTime stringByReplacingCharactersInRange:NSMakeRange(3,2) withString:value];
            break;
        default:
            break;
    }
    if (self.didSelectDatePickView && component!=2) {
        [self handleTime:component];
    }
}

//自定义pickerView的行
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UILabel *)view {
    //隐藏两条黑线
    [[pickerView.subviews objectAtIndex:1] setHidden:YES];
    [[pickerView.subviews objectAtIndex:2] setHidden:YES];
    if (!view) {
        view = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, RowH, RowH)];
        view.textAlignment = NSTextAlignmentCenter;
        if (component!=2) {
            view.font = [UIFont boldSystemFontOfSize:20];
        }else {
            view.font = [UIFont systemFontOfSize:14];
        }
        
        view.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
        view.backgroundColor = [UIColor clearColor];
    }

    NSMutableArray *valueArray = [self valueForKeyPath:[NSString stringWithFormat:@"component%ldArray",(long)component]];
    NSString *value = valueArray[row];
    view.text = value;
    return view;
}


//开始时间不能大于结束时间的处理
- (void)handleTime:(NSInteger)component {

    

    NSInteger startTimeInt = [[_startTime stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
    NSInteger endTimeInt = [[_endTime stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
    
    NSInteger startTimeHourInt = [[self.startTime componentsSeparatedByString:@":"][0]integerValue];
    NSInteger startTimeMinInt = [[_startTime componentsSeparatedByString:@":"][1]integerValue];
    
    NSInteger endTimeHourInt = [[self.endTime componentsSeparatedByString:@":"][0]integerValue];
    NSInteger endTimeMinInt = [[_endTime componentsSeparatedByString:@":"][1]integerValue];
    
    NSInteger dValue = (endTimeHourInt*60+endTimeMinInt)-(startTimeHourInt*60+startTimeMinInt);
    
    if (startTimeInt>endTimeInt) {
        if (!self.autoHandleTime) {
            self.didSelectDatePickView(_startTime,_endTime,dValue);
            return;
        }
        NSInteger row = 0;
        switch (component) {
            case 0:
                if (endTimeMinInt>=startTimeMinInt) {
                    row = endTimeHourInt;
                }else {
                    row = endTimeHourInt-1;
                }
                break;
            case 1:
                row = endTimeMinInt;
                break;
            case 3:
                if (endTimeMinInt>=startTimeMinInt) {
                    row = startTimeHourInt;
                }else {
                    row = startTimeHourInt+1;
                }
                break;
            case 4:
                row = startTimeMinInt;
                break;
            default:
                break;
        }
        [_datePickView selectRow:row inComponent:component animated:YES];
        [self pickerView:self.datePickView didSelectRow:row inComponent:component];
    }else {
        self.didSelectDatePickView(_startTime,_endTime,dValue);
    }
}


- (void)selectStartTime:(NSString *)startTime {
    //滚动至设置的默认时间
    _startTime = startTime;
    [_datePickView selectRow:[[self.startTime substringToIndex:2]integerValue] inComponent:0 animated:YES];
    [_datePickView selectRow:[[self.startTime substringFromIndex:3]integerValue] inComponent:1 animated:YES];
    
}

- (void)selectEndTime:(NSString *)endTime {
    _endTime = endTime;
    [_datePickView selectRow:[[self.endTime substringToIndex:2]integerValue] inComponent:3 animated:YES];
    [_datePickView selectRow:[[self.endTime substringFromIndex:3]integerValue] inComponent:4 animated:YES];
}

- (NSString *)startTime {
    if (!_startTime||[@""isEqualToString:_startTime]) _startTime = @"08:30";
    return _startTime;
    
}

- (NSString *)endTime {
    if (!_endTime||[@""isEqualToString:_endTime]) _endTime = @"08:50";
    return _endTime;
}

- (NSInteger)DValue {
    NSInteger startTimeHourInt = [[self.startTime componentsSeparatedByString:@":"][0]integerValue];
    NSInteger startTimeMinInt = [[_startTime componentsSeparatedByString:@":"][1]integerValue];
    
    NSInteger endTimeHourInt = [[self.endTime componentsSeparatedByString:@":"][0]integerValue];
    NSInteger endTimeMinInt = [[_endTime componentsSeparatedByString:@":"][1]integerValue];
    
    NSInteger dValue = (endTimeHourInt*60+endTimeMinInt)-(startTimeHourInt*60+startTimeMinInt);
    return dValue;
}


@end
