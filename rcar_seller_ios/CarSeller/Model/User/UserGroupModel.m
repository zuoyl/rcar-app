//
//  UserGroupModel.m
//  CarSeller
//
//  Created by jenson.zuo on 24/12/14.
//  Copyright (c) 2014 Cloud Stone Technology. All rights reserved.
//

#import "UserGroupModel.h"
#import "UserModel.h"

@implementation UserGroupModel

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.users = [[NSMutableArray alloc]init];
        self.opened = false;
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.group_id forKey:@"group_id"];
    [coder encodeObject:self.users forKey:@"users"];
    [coder encodeObject:self.name forKey:@"name"];
}

-(id) initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.group_id = [decoder decodeObjectForKey:@"group_id"];
        self.users = [decoder decodeObjectForKey:@"users"];
        self.name = [decoder decodeObjectForKey:@"name"];
    }
    return self;
}
@end


@implementation UserGroupItemModel

-(void) encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.user_id forKey:@"user_id"];
    [coder encodeObject:self.image forKey:@"image"];
    [coder encodeObject:self.name forKey:@"name"];
}

-(id) initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.user_id = [decoder decodeObjectForKey:@"user_id"];
        self.image = [decoder decodeObjectForKey:@"image"];
        self.name = [decoder decodeObjectForKey:@"name"];
    }
    return self;
}

@end
