//
//  CarInfoRepository.m
//  CarUser
//
//  Created by huozj on 1/20/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import "CarInfoRepository.h"
#import "CarInfoModel.h"


#define CAR_MAX_ITEMS  5


@implementation CarInfoRepository {
    NSString *_archiveFilePath;
    NSMutableArray *_entries;
    NSInteger _max;
}

+ (CarInfoRepository *)instance {
    static CarInfoRepository *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[CarInfoRepository alloc] init];
        
    });
    return _sharedClient;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _entries = [[NSMutableArray alloc]init];
        _max = CAR_MAX_ITEMS;
        //_archiveFilePath = [CommonUtil getHomeFilePath:@"carInfoArchive"];
        _archiveFilePath = @"carInfoArchive";
    }
    return self;
}

- (void) addItem:(id)item {
    if (_entries.count > _max) {
        // delete old recent items
        [_entries removeObjectAtIndex:0];
    }
    // check wether the item is already in repository
    CarInfoModel *detail = item;
    for (int index = 0; index < _entries.count; index++) {
        CarInfoModel *model = [_entries objectAtIndex:index];
        if ([model.platenumber isEqualToString:detail.platenumber]){
            [_entries replaceObjectAtIndex:index withObject:detail];
            return;
        }
    }
    [_entries addObject:item];
}

- (void)removeItem:(NSInteger)index {
    [_entries removeObjectAtIndex:index];
}

- (NSInteger) count {
    return _entries.count;
}

- (id)itemAtIndex:(NSInteger)index {
    return [_entries objectAtIndex:index];
}

- (void)setMaxItems:(NSInteger)val {
    _max = val;
}

- (void)reload {
    NSMutableArray *entries = [NSKeyedUnarchiver unarchiveObjectWithFile:_archiveFilePath];
    if (entries == nil)
        return;
    _entries = entries;
    _max = CAR_MAX_ITEMS;
}

- (BOOL)flush {
    if (_entries.count > 0)
        return [NSKeyedArchiver archiveRootObject:[_entries objectAtIndex:0] toFile:_archiveFilePath];
    else
        return true;
}


@end
