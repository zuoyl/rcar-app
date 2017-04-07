//
//  RecentRepository.m
//  CarSeller
//
//  Created by jenson.zuo on 15/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "RecentRepository.h"
#import "CommonUtil.h"
#import "SellerInfoModel.h"

#define RECENT_MAX_ITEMS  20

@implementation RecentRepository {
    NSString *_archiveFilePath;
    NSMutableArray *_entries;
    NSInteger _max;
}

+ (RecentRepository *)instance {
    static RecentRepository *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[RecentRepository alloc] init];
  
    });
    return _sharedClient;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _entries = [[NSMutableArray alloc]init];
        _max = RECENT_MAX_ITEMS;
        _archiveFilePath = @"recentArchive";
    }
    return self;
}

- (void) addItem:(id)item {
    if (_entries.count > _max) {
        // delete old recent items
        [_entries removeObjectAtIndex:0];
    }
    // check wether the item is already in repository
    SellerDetailInfoModel *detail = item;
    for (int index = 0; index < _entries.count; index++) {
        SellerDetailInfoModel *model = [_entries objectAtIndex:index];
        if ([model.seller_id isEqualToString:detail.seller_id])
            return;
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
    _max = RECENT_MAX_ITEMS;
}

- (BOOL)flush {
    if (_entries.count > 0)
        return [NSKeyedArchiver archiveRootObject:_entries toFile:_archiveFilePath];
    else
        return true;
}

@end
