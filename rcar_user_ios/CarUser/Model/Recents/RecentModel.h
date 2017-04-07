//
//  RecentModel.h
//  CarSeller
//
//  Created by jenson.zuo on 15/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentModel : NSObject <NSCoding>
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSDate *date;

- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)coder;
@end

