//
//  CarInfoRepository.h
//  CarUser
//
//  Created by huozj on 1/20/15.
//  Copyright (c) 2015 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarInfoRepository : NSObject

+ (CarInfoRepository *)instance;
- (void)reload;
- (void)addItem:(id)model;
- (void)removeItem:(NSInteger)index;
- (NSInteger) count;
- (id )itemAtIndex:(NSInteger)index;
- (BOOL)flush;
- (void)setMaxItems:(NSInteger)val;


@end
