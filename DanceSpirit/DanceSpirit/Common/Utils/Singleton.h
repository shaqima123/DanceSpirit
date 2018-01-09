//
//  Singleton.h
//  DanceSpirit
//
//  Created by 沙琪玛 on 2018/1/10.
//  Copyright © 2018年 zj－db0737. All rights reserved.
//

#ifndef Singleton_h
#define Singleton_h

//Singleton.h
#define singleton_interface(class) + (instancetype)shared##class;

//Singleton.m
#define singleton_implementation(class) \
static class *_instance; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken,^{ \
        _instance = [super allocWithZone:zone];\
    }); \
\
return _instance;\
} \
\
+ (instancetype)shared##class \
{ \
    if (_instance == nil) {\
        _instance = [[class alloc] init]; \
    } \
\
    return _instance; \
}

#endif /* Singleton_h */
