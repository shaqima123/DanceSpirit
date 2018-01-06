//
//  DanceSpiritDef.h
//  DanceSpirit
//
//  Created by zj－db0737 on 2017/12/6.
//  Copyright © 2017年 zj－db0737. All rights reserved.
//

#ifndef DanceSpiritDef_h
#define DanceSpiritDef_h

#define RGB(r,g,b)        [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:1.f]
#define RGBA(r,g,b,a)     [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:a]
#define RGBAHEX(hex,a)    RGBA((float)((hex & 0xFF0000) >> 16),(float)((hex & 0xFF00) >> 8),(float)(hex & 0xFF),a)
#define DSScreenWidth    [[UIScreen mainScreen] bounds].size.width;
#define DSScreenHeight   [[UIScreen mainScreen] bounds].size.height;

#endif /* DanceSpiritDef_h */
