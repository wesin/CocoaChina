//
//  OCCommonFunc.m
//  HupunErp
//
//  Created by 何文新 on 15/5/12.
//  Copyright (c) 2015年 wesin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sys/utsname.h"

#import "OCCommonFunc.h"

@implementation OCCommonFunc : NSObject 

+(NSString*)getMachineVersion {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * strModel = [NSString stringWithCString:systemInfo.machine
                                             encoding:NSUTF8StringEncoding];
    return strModel;
}

@end