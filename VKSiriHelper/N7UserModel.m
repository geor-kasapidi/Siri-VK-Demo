//
//  N7UserModel.m
//  VKSiri
//
//  Created by Георгий Касапиди on 20.06.16.
//  Copyright © 2016 N7. All rights reserved.
//

#import "N7UserModel.h"

@implementation N7UserModel

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        self.userId = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(userId))];
        self.firstName = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(firstName))];
        self.lastName = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(lastName))];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userId forKey:NSStringFromSelector(@selector(userId))];
    [aCoder encodeObject:self.firstName forKey:NSStringFromSelector(@selector(firstName))];
    [aCoder encodeObject:self.lastName forKey:NSStringFromSelector(@selector(lastName))];
}

@end
