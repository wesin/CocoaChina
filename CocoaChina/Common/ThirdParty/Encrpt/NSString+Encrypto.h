//
//  NSString+Encrypto.h
//  HeartBook
//
//  Created by 何文新 on 15/5/6.
//  Copyright (c) 2015年 wesin. All rights reserved.
//

#ifndef HeartBook_NSString_Encrypto_h
#define HeartBook_NSString_Encrypto_h


#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>


#endif

@interface NSString (Encrypto)

- (NSString *) md5;
- (NSString *) sha1;
- (NSString *) sha1_base64;
- (NSString *) md5_base64;
- (NSString *) base64;

@end