//
//  DSUserInfo.h
//  DanceSpirit
//
//  Created by 沙琪玛 on 2018/1/10.
//  Copyright © 2018年 zj－db0737. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface DSUserInfo : NSObject
singleton_interface(DSUserInfo)
@property (nonatomic, copy) NSString *userName; //用户名

@end
