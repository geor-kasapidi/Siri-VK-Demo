//
//  N7UserModel.h
//  VKSiri
//
//  Created by Георгий Касапиди on 20.06.16.
//  Copyright © 2016 N7. All rights reserved.
//

@import Foundation;

@interface N7UserModel : NSObject <NSSecureCoding>

@property (copy, nonatomic) NSNumber *userId;
@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *lastName;

@end
