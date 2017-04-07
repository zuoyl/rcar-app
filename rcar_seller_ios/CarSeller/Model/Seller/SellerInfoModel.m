//
//  SellerInfoModel.m
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerInfoModel.h"

@implementation SellerInfoModel

@end

@implementation SellerDetailInfoModel

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.images = [[NSMutableArray alloc]init];
        self.services = [[NSMutableArray alloc]init];
        self.commodities = [[NSMutableArray alloc]init];
        self.activities = [[NSMutableArray alloc]init];
        self.comments = [[NSMutableArray alloc]init];
    }
    return self;
}

- (SellerInfoModel *)sellerInfoModel {
    SellerInfoModel *model = [[SellerInfoModel alloc]init];
    model.seller_id = self.seller_id;
    model.telephone = self.telephone;
    model.name = self.name;
    model.address = self.address;
    model.intro = self.intro;
    model.rate = self.rate;
    model.image = [self.images objectAtIndex:0];
    return model;
}


@end



