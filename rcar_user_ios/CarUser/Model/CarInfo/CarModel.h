//
//  CarModel.h
//  CarSeller
//
//  Created by jenson.zuo on 31/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarModel : APIResponseModel

@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray  *cars;
@end



@interface CarTypeListModel : NSObject
@property (nonatomic, strong) NSMutableArray *cars;

+ (CarTypeListModel *)getInstance;
- (void)load;

@end
