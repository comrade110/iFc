//
//  InstagramCell.m
//  InstagramThumbnail
//
//  Created by 曾 宪华 on 14-2-23.
//  Copyright (c) 2014年 HUAJIE. All rights reserved.
//

#import "InstagramCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+Curled.h"

@implementation InstagramCell

- (void)setEntity:(PFObject *)entity andIndexPath:(NSIndexPath *)index WithPurchased:(BOOL)isVIP {
    [self setupCellWith:isVIP];
    _entity = entity;
    if (_entity[@"previewData"]) {
        self.imageView.file = _entity[@"previewData"];
        UIActivityIndicatorView *indicatorView = nil;
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicatorView.center = self.imageView.center;
        [self.contentView addSubview:indicatorView];
        [indicatorView startAnimating];
        [self.imageView loadInBackground:^(UIImage *image, NSError *error) {
            if (error) {
                NSLog(@"caio");
            }else{
                [_imageView setImage:image borderWidth:5.0 shadowDepth:5.0 controlPointXOffset:10 controlPointYOffset:80];
            }
            [indicatorView stopAnimating];
            [indicatorView removeFromSuperview];
        }];
        
        
        UIImageView *imageVC = (UIImageView*)[self viewWithTag:9999];
        if ([_entity[@"isVIP"] boolValue]) {
            imageVC.hidden = NO;
        }else{
            imageVC.hidden = YES;
        }
    }
//    
//    if (_entity.photo) {
//        [self.thumbnailButton setBackgroundImage:_entity.photo forState:UIControlStateNormal];
//    } else {
//        [_entity downloadImageWithBlock:^(UIImage *image, NSError *error) {
//            if (self.indexPath.row == index.row) {
//                _entity.photo = image;
//                [self.thumbnailButton setBackgroundImage:image forState:UIControlStateNormal];
//            }
//        }];
//    }
//    
//    self.thumbnailButton.userInteractionEnabled = self.showThumbnail;
//    self.thumbnailButton.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
//    
//    if (!self.showThumbnail) {
//        self.userNameLabel.text = self.entity.userName;
//        [self.contentView addSubview:self.userNameLabel];
//        
//        self.pictureCaptionLabel.text = self.entity.caption;
//        [self.contentView addSubview:self.pictureCaptionLabel];
//        
//        [self.userProfileImageView setImage:[UIImage imageNamed:@"placeholder"]];
//        [self.contentView addSubview:self.userProfileImageView];
//        
//        [_entity downloadImageWithBlock:^(UIImage *image, NSError *error) {
//            if (image && !error && self.indexPath.row == index.row) {
//                [self.userProfileImageView setImage:image];
//            }
//        }];
//    }
}

#pragma mark - Action

- (void)selectedThumbnailImage:(UIButton *)sender {
    
}

- (void)setupCellWith:(BOOL)isVIP {
    
    self.backgroundColor = [UIColor clearColor];

    if (!_imageView) {
        _imageView = [[PFImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        _imageView.image = [UIImage imageNamed:@"placeholder"];
        [_imageView setContentMode:UIViewContentModeScaleToFill];
        
        [_imageView setImage:kXHISIPAD?[UIImage imageNamed:@"placeHolder3-hd"]:[UIImage imageNamed:@"placeHolder3"] borderWidth:5.0 shadowDepth:10.0 controlPointXOffset:30.0 controlPointYOffset:80.0];
        [self.contentView addSubview:_imageView];
        
        
        UIImageView *jiaobiaoView = [[UIImageView alloc] initWithFrame:CGRectMake(self.imageView.left-3, self.imageView.top-3, 151/2, 147/2)];
        jiaobiaoView.tag = 9999;
        NSString *curLang = [FSConfig getCurrentLanguage];
        if ([curLang isEqualToString:@"zh-Hans"]||[curLang isEqualToString:@"zh-Hant"]||[curLang isEqualToString:@"ja"]) {
            jiaobiaoView.image = [UIImage imageNamed:@"jiaobiao_cn"];
        }else{
            jiaobiaoView.image = [UIImage imageNamed:@"jiaobiao_en"];
        }
        jiaobiaoView.hidden = YES;
        [self addSubview:jiaobiaoView];
    }else{
        [_imageView setImage:kXHISIPAD?[UIImage imageNamed:@"placeHolder3-hd"]:[UIImage imageNamed:@"placeHolder3"] borderWidth:5.0 shadowDepth:10.0 controlPointXOffset:30.0 controlPointYOffset:80.0];
    }
}

#pragma mark - life cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
