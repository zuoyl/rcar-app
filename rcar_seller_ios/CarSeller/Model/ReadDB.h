//
//  ReadDB.h
//  CarSeller
//
//  Created by jenson.zuo on 15/1/2016.
//  Copyright © 2016 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ReadModel <NSObject>
@property (nonatomic,strong) NSString *id;
@property (nonatomic,assign) BOOL read;
@end


@interface ReadDB : NSObject
-(BOOL)save:(NSString*)idValue;
-(void)isExistById:(NSArray*)objs;
@end
