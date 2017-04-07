//
//  FavoriteMOdel.h
//  CarSeller
//
//  Created by jenson.zuo on 12/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <APIResponseModel.h>


@interface FavoriteModel : APIResponseModel
@property (nonatomic, strong) NSArray *sellers;
@property (nonatomic, strong) NSArray *commodities;
@end

