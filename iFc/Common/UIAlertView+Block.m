//
//  UIAlertView+Block.m
//  CMBH_Client_V2
//
//  Created by ma huajian on 13-3-13.
//  Copyright (c) 2013年 ma huajian. All rights reserved.
//

#import "UIAlertView+Block.h"
#import <objc/runtime.h>
@implementation UIAlertView (Block)
- (void)handleWithBlock:(void(^)(int))avb
{
    if(!avb)return;
    self.delegate=nil;
    self.delegate=self;
    objc_setAssociatedObject(self, &"alertVB", avb, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   void(^avb)(int) =objc_getAssociatedObject(self, &"alertVB");
   avb(buttonIndex);
}
//-(void)changeBackground
//{
//    [self show];
//    if(IOS7)return;
//    for(UIView *view in self.subviews)
//    {
////        NSLog(@" - - %@",view);
//        if([view isKindOfClass:NSClassFromString(@"UIImageView")])
//        {
//            UIImageView *alertBG=(UIImageView *)view;
////            alertBG.image=[UIImage imageNamed:@"alertView_bg"];
//            [alertBG setImage:[Tool createImageWithColor:[UIColor whiteColor] andWithSize:view.frame.size]];
//            alertBG.layer.cornerRadius=5.0f;
//            alertBG.layer.masksToBounds=YES;
//            continue;
//        }
//        if([view isKindOfClass:NSClassFromString(@"UIAlertButton")])
//        {
//            UIButton *but=(UIButton *)view;
//            but.layer.cornerRadius=5;
//            but.layer.masksToBounds=YES;
//            [but setTitleColor:[UIColor colorWithHexString:commonTextColor]
//                      forState:UIControlStateNormal];
//            [but setTitleColor:[UIColor whiteColor]
//                      forState:UIControlStateHighlighted];
//            [but setTitleShadowColor:[UIColor clearColor]
//                            forState:UIControlStateHighlighted];
//            [but setTitleShadowColor:[UIColor clearColor]
//                            forState:UIControlStateNormal];
//            [but setBackgroundImage:[Tool createImageWithColor:
//                                            [UIColor iOS7lightGrayColor]
//                                                   andWithSize:but.frame.size] forState:UIControlStateHighlighted];
//            continue;
//        }
//        if([view isKindOfClass:UILabel.class])
//        {
//            UILabel *label=(UILabel *)view;
//            label.shadowColor=[UIColor clearColor];
//            label.shadowOffset=CGSizeMake(0, 0);
//            label.layer.shadowOffset=CGSizeMake(0, 0);
//            label.layer.shadowColor=[UIColor clearColor].CGColor;
//            label.textColor=[UIColor colorWithHexString:commonTextColor];
//            continue;
//        }
//    }
//}

@end
