//
//  RecentRepository.h
//  CarSeller
//
//  Created by jenson.zuo on 15/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentRepository : NSObject

+ (RecentRepository *)instance;
- (void)reload;
- (void)addItem:(id)model;
- (void)removeItem:(NSInteger)index;
- (NSInteger) count;
- (id )itemAtIndex:(NSInteger)index;
- (BOOL)flush;
- (void)setMaxItems:(NSInteger)val;

@end

