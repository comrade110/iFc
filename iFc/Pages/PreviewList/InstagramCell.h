//
//  InstagramCell.h
//  InstagramThumbnail
//
//  Created by 曾 宪华 on 14-2-23.
//  Copyright (c) 2014年 HUAJIE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstagramMediaModel+XHMediaControl.h"
#import <Parse/Parse.h>

@interface InstagramCell : UICollectionViewCell


@property (nonatomic, assign) PFObject *entity;
@property (nonatomic, strong) PFImageView *imageView;
@property (nonatomic, assign) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL showThumbnail;

- (void)setEntity:(PFObject *)entity andIndexPath:(NSIndexPath *)index WithPurchased:(BOOL)isVIP;

@end
