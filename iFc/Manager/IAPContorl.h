//
//  IAPContorl.h
//  iFc
//
//  Created by xiang-chen on 14-7-30.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ CompletionBlock)();

#define Product_NOiAd @"com.chxstudio.product01"

@interface IAPContorl : NSObject<UIAlertViewDelegate>


+(void)createProducts;

+(void)showAlertByID:(NSString*)productId withCompletionBlock:(CompletionBlock)block;

@end
