//
//  PickerView.m
//  CarSeller
//
//  Created by jenson.zuo on 31/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "PickerView.h"

#define PickerToobarHeight 40

@interface PickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,copy)NSString *plistName;
@property(nonatomic,strong)NSArray *plistArray;
@property(nonatomic,assign)BOOL isLevelArray;
@property(nonatomic,assign)BOOL isLevelString;
@property(nonatomic,assign)BOOL isLevelDic;
@property(nonatomic,strong)NSDictionary *levelTwoDic;
@property(nonatomic,strong)UIToolbar *toolbar;
@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,assign)NSDate *defaulDate;
@property(nonatomic,assign)BOOL isHaveNavControler;
@property(nonatomic,assign)NSInteger pickeviewHeight;
@property(nonatomic,copy)NSString *resultString;
@property(nonatomic,strong)NSMutableArray *componentArray;
@property(nonatomic,strong)NSMutableArray *dicKeyArray;
@property(nonatomic,copy)NSMutableArray *state;
@property(nonatomic,copy)NSMutableArray *city;
@end

@implementation PickerView

-(NSArray *)plistArray{
    if (_plistArray == nil) {
        _plistArray = [[NSArray alloc] init];
    }
    return _plistArray;
}

-(NSArray *)componentArray{
    
    if (_componentArray == nil) {
        _componentArray = [[NSMutableArray alloc] init];
    }
    return _componentArray;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpToolBar];
        
    }
    return self;
}


-(instancetype)initPickviewWithPlistName:(NSString *)plistName isHaveNavControler:(BOOL)isHaveNavControler{
    self = [super init];
    if (self) {
        _plistName = plistName;
        self.plistArray = [self getPlistArrayByplistName:plistName];
        [self setUpPickView];
        [self setFrameWith:isHaveNavControler];
        
    }
    return self;
}
-(instancetype)initPickviewWithArray:(NSArray *)array isHaveNavControler:(BOOL)isHaveNavControler{
    self = [super init];
    if (self) {
        self.plistArray = array;
        [self setArrayClass:array];
        [self setUpPickView];
        [self setFrameWith:isHaveNavControler];
    }
    return self;
}

-(instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler{
    
    self = [super init];
    if (self) {
        _defaulDate = defaulDate;
        [self setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode];
        [self setFrameWith:isHaveNavControler];
    }
    return self;
}


-(NSArray *)getPlistArrayByplistName:(NSString *)plistName{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray * array = [[NSArray alloc] initWithContentsOfFile:path];
    [self setArrayClass:array];
    return array;
}

-(void)setArrayClass:(NSArray *)array{
    _dicKeyArray = [[NSMutableArray alloc] init];
    for (id levelTwo in array) {
        if ([levelTwo isKindOfClass:[NSArray class]]) {
            _isLevelArray = YES;
            _isLevelString = NO;
            _isLevelDic = NO;
        } else if ([levelTwo isKindOfClass:[NSString class]]) {
            _isLevelString = YES;
            _isLevelArray = NO;
            _isLevelDic = NO;
        } else if ([levelTwo isKindOfClass:[NSDictionary class]]) {
            _isLevelDic = YES;
            _isLevelString = NO;
            _isLevelArray = NO;
            _levelTwoDic = levelTwo;
            [_dicKeyArray addObject:[_levelTwoDic allKeys] ];
        }
    }
}

-(void)setFrameWith:(BOOL)isHaveNavControler{
    CGFloat toolViewX = 0;
    CGFloat toolViewH = self.pickeviewHeight + PickerToobarHeight;
    CGFloat toolViewY ;
    if (isHaveNavControler) {
        toolViewY = [UIScreen mainScreen].bounds.size.height - toolViewH - 50.f;
    }else {
        toolViewY = [UIScreen mainScreen].bounds.size.height - toolViewH;
    }
    CGFloat toolViewW = [UIScreen mainScreen].bounds.size.width;
    self.frame = CGRectMake(toolViewX, toolViewY, toolViewW, toolViewH);
}


-(void)setUpPickView{
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.frame = CGRectMake(0, PickerToobarHeight, [UIScreen mainScreen].bounds.size.width, 150.f);
    self.pickeviewHeight = self.pickerView.frame.size.height;
    [self addSubview:self.pickerView];
}

-(void)setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode{
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    self.datePicker.datePickerMode = datePickerMode;
    self.datePicker.backgroundColor = [UIColor whiteColor];
    if (_defaulDate) {
        [self.datePicker setDate:_defaulDate];
    }
    self.datePicker.frame = CGRectMake(0, PickerToobarHeight, [UIScreen mainScreen].bounds.size.width, 150.f);
    self.pickeviewHeight = self.datePicker.frame.size.height;
    [self addSubview:self.datePicker];
}

-(void)setUpToolBar{
    _toolbar = [self setToolbarStyle];
    [self setToolbarWithPickViewFrame];
    [self addSubview:_toolbar];
}

-(UIToolbar *)setToolbarStyle{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    UIBarButtonItem *lefttem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(removeBtnClick)];
    
    UIBarButtonItem *centerSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnClick)];
    toolbar.items = @[lefttem,centerSpace,right];
    return toolbar;
}

-(void)setToolbarWithPickViewFrame{
    _toolbar.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, PickerToobarHeight);
}

#pragma mark piackView 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    NSInteger component;
    if (_isLevelArray) {
        component=_plistArray.count;
    } else if (_isLevelString){
        component=1;
    }else if(_isLevelDic){
        component=[_levelTwoDic allKeys].count*2;
    }
    return component;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *rowArray=[[NSArray alloc] init];
    if (_isLevelArray) {
        rowArray=_plistArray[component];
    }else if (_isLevelString){
        rowArray=_plistArray;
    }else if (_isLevelDic){
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic=_plistArray[pIndex];
        for (id dicValue in [dic allValues]) {
            if ([dicValue isKindOfClass:[NSArray class]]) {
                if (component%2==1) {
                    rowArray=dicValue;
                }else{
                    rowArray=_plistArray;
                }
            }
        }
    }
    return rowArray.count;
}

#pragma mark UIPickerViewdelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *rowTitle=nil;
    if (_isLevelArray) {
        rowTitle=_plistArray[component][row];
    }else if (_isLevelString){
        rowTitle=_plistArray[row];
    }else if (_isLevelDic){
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic=_plistArray[pIndex];
        if(component%2==0)
        {
            rowTitle=_dicKeyArray[row][component];
        }
        for (id aa in [dic allValues]) {
            if ([aa isKindOfClass:[NSArray class]]&&component%2==1){
                NSArray *bb=aa;
                if (bb.count>row) {
                    rowTitle=aa[row];
                }
                
            }
        }
    }
    return rowTitle;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (_isLevelDic&&component%2==0) {
        
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    if (_isLevelString) {
        _resultString=_plistArray[row];
        
    }else if (_isLevelArray){
        _resultString=@"";
        if (![self.componentArray containsObject:@(component)]) {
            [self.componentArray addObject:@(component)];
        }
        for (int i=0; i<_plistArray.count;i++) {
            if ([self.componentArray containsObject:@(i)]) {
                NSInteger cIndex = [pickerView selectedRowInComponent:i];
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][cIndex]];
            }else{
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
            }
        }
    }else if (_isLevelDic){
        if (component==0) {
            _state =_dicKeyArray[row][0];
        }else{
            NSInteger cIndex = [pickerView selectedRowInComponent:0];
            NSDictionary *dicValueDic=_plistArray[cIndex];
            NSArray *dicValueArray=[dicValueDic allValues][0];
            if (dicValueArray.count>row) {
                _city =dicValueArray[row];
            }
        }
    }
}

-(void)removeBtnClick{
    [self removeFromSuperview];
}
-(void)show{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
}
-(void)doneBtnClick {
    if (_pickerView) {
        if (_resultString) {
        }else{
            if (_isLevelString) {
                _resultString=[NSString stringWithFormat:@"%@",_plistArray[0]];
            }else if (_isLevelArray){
                _resultString=@"";
                for (int i=0; i<_plistArray.count;i++) {
                    _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
                }
            }else if (_isLevelDic){
                
                if (_state==nil) {
                    _state =_dicKeyArray[0][0];
                    NSDictionary *dicValueDic=_plistArray[0];
                    _city=[dicValueDic allValues][0][0];
                }
                if (_city==nil){
                    NSInteger cIndex = [_pickerView selectedRowInComponent:0];
                    NSDictionary *dicValueDic=_plistArray[cIndex];
                    _city=[dicValueDic allValues][0][0];
                    
                }
                _resultString=[NSString stringWithFormat:@"%@%@",_state,_city];
            }
        }
    }else if (_datePicker) {
        
        _resultString=[NSString stringWithFormat:@"%@",_datePicker.date];
    }
    if ([self.delegate respondsToSelector:@selector(pickerViewDone:result:)]) {
        [self.delegate pickerViewDone:self result:_resultString];
    }
    [self removeFromSuperview];
}
-(void)setPickViewColer:(UIColor *)color{
    _pickerView.backgroundColor = color;
}
-(void)setTintColor:(UIColor *)color{
    _toolbar.tintColor = color;
}
-(void)setToolbarTintColor:(UIColor *)color{
    _toolbar.barTintColor = color;
}
@end
