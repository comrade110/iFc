//
//  XHInstagramStoreManager.m
//  InstagramThumbnail
//
//  Created by 曾 宪华 on 14-2-23.
//  Copyright (c) 2014年 HUAJIE. All rights reserved.
//

#import "XHInstagramStoreManager.h"
#import "InstagramMediaModel+XHMediaControl.h"
#import <Parse/Parse.h>

@interface XHInstagramStoreManager ()

@property (nonatomic,  copy) NSString *objectId;

@end

@implementation XHInstagramStoreManager

- (id)initWithObjectId:(NSString*)objectId {
    self = [super init];
    if (self) {
        self.objectId = objectId;
    }
    return self;
}

- (void)mediaWithPage:(NSInteger)page localDownloadDataSourceCompled:(DownloadDataSourceCompled)downloadDataSourceCompled {
    PFQuery *query = [PFQuery queryWithClassName:@"ImageDB"];
    //按更新日期排序
    [query orderByDescending:@"updatedAt"];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [query whereKey:@"fid" equalTo:[PFObject objectWithoutDataWithClassName:@"Type" objectId:_objectId]];
    query.limit = 10;
    query.skip = 10*page;
//    if ((page+1)*10>query.countObjects && page!=0) {
//        return;
//    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        NSArray *instagramDataSources = objects;
        
        __block NSMutableArray *mediaArray = [NSMutableArray new];
        for (PFObject *mediaDictionary in instagramDataSources) {
            [mediaArray addObject:mediaDictionary];
        }
        instagramDataSources = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (downloadDataSourceCompled) {
                downloadDataSourceCompled(mediaArray, nil);
            }
            mediaArray = nil;
        });
    }];
}

@end
