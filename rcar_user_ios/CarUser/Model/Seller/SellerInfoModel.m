//
//  SellerInfoModel.m
//  CarSeller
//
//  Created by jenson.zuo on 1/12/14.
//  Copyright (c) 2014 CloudStone Tech. All rights reserved.
//

#import "SellerInfoModel.h"

@implementation SellerInfoModel

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self != nil) {
        self.seller_id = [decoder decodeObjectForKey:@"seller_id"];
        self.telephone = [decoder decodeObjectForKey:@"telephone"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.type = [decoder decodeObjectForKey:@"type"];
        self.lat = [decoder decodeObjectForKey:@"lat"];
        self.lng = [decoder decodeObjectForKey:@"lng"];
        self.address = [decoder decodeObjectForKey:@"address"];
        self.intro = [decoder decodeObjectForKey:@"intro"];
        self.rate = [decoder decodeObjectForKey:@"rate"];
        self.services = [decoder decodeObjectForKey:@"services"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.seller_id forKey:@"seller_id"];
    [coder encodeObject:self.telephone forKey:@"telephone"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.type forKey:@"type"];
    [coder encodeObject:self.lat forKey:@"lat"];
    [coder encodeObject:self.lng forKey:@"lng"];
    [coder encodeObject:self.address forKey:@"address"];
    [coder encodeObject:self.intro forKey:@"intro"];
    [coder encodeObject:self.rate forKey:@"rate"];
    [coder encodeObject:self.services forKey:@"services"];
}

@end

@implementation SellerDetailInfoModel

- (SellerInfoModel *)sellerInfoModel {
    SellerInfoModel *model = [[SellerInfoModel alloc]init];
    model.seller_id = self.seller_id;
    model.telephone = self.telephone;
    model.name = self.name;
    model.address = self.address;
    model.intro = self.intro;
    model.rate = self.rate;
    model.images = self.images;
    return model;
}




@end
