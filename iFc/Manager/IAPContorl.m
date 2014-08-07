//
//  IAPContorl.m
//  iFc
//
//  Created by xiang-chen on 14-7-30.
//  Copyright (c) 2014年 Fuleco studio. All rights reserved.
//

#import "IAPContorl.h"
#import <Parse/Parse.h>


@implementation IAPContorl


+(void)createProducts
{
    [PFPurchase addObserverForProduct:Product_NOiAd block:^(SKPaymentTransaction *transaction) {
        // Write business logic that should run once this product is purchased.
        if (transaction.transactionState == SKPaymentTransactionStateRestored) {
            
            NSLog(@"inter:");
        }
        [[CJPAdController sharedInstance] removeAdsAndMakePermanent:YES andRemember:YES];
        
    }];

}

+(void)showAlertByID:(NSString*)productId withCompletionBlock:(CompletionBlock)block{
    
    [PFPurchase buyProduct:productId block:^(NSError *error) {
        if (!error) {
            alert(NSLocalizedString(@"Purchase successfully. Enjoy!", nil));
        }else{
            alert(NSLocalizedString(@"Purchase failed", nil));
        }
        block();
    }];

    

}




@end
