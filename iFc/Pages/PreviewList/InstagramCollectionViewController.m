//
//  InstagramCollectionViewController.m
//  InstagramThumbnail
//
//  Created by 曾 宪华 on 14-2-23.
//  Copyright (c) 2014年 HUAJIE. All rights reserved.
//

#import "InstagramCollectionViewController.h"
#import "UICollectionViewController+ADFlipTransition.h"
#import "FSEditorViewController.h"
#import <Parse/Parse.h>


static NSString * const kXHInstagramFooter = @"InstagramFooter";

@interface InstagramCollectionViewController (){

    PFImageView *imageView;

}

@property(nonatomic,assign) NSUInteger curPage;

@end

@implementation InstagramCollectionViewController

#pragma mark - Propertys

- (NSMutableArray *)mediaArray {
    if (!_mediaArray) {
        _mediaArray = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _mediaArray;
}

- (XHInstagramStoreManager *)instagramStoreManager {
    if (!_instagramStoreManager) {
        _instagramStoreManager = [[XHInstagramStoreManager alloc] initWithObjectId:_objectId];
    }
    return _instagramStoreManager;
}

#pragma mark - Life cycle

- (void)_baseSetup {
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityIndicator startAnimating];
    self.downloading = YES;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout{
    if ((self = [super initWithCollectionViewLayout:layout])) {
        [self _baseSetup];
    }
    return self;
}

+ (instancetype)sharedInstagramCollectionViewControllerWithObjectId:(NSString *)objectId {
    return nil;
}

- (id)init {
    self = [super init];
    if (self) {
        [self _baseSetup];
        imageView = [[PFImageView alloc] init];
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self downloadDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)_setupCollectionView {
    [self.collectionView registerClass:[InstagramCell class] forCellWithReuseIdentifier:kXHInstagramCell];
    [self.collectionView setBackgroundColor:[UIColor mainBgColor]];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kXHInstagramFooter];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Instagram";
    self.curPage = 0;
    
    [self _setupCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DataSource manager 

- (void)downloadDataSource {
    self.downloading = YES;
    if ([self.mediaArray count] == 0) {
        [self.instagramStoreManager mediaWithPage:self.curPage localDownloadDataSourceCompled:^(NSArray *mediaArray, NSError *error) {
            if (error || mediaArray.count == 0) {
                showAlert(@"Instagram", @"No results found", @"OK");
            }else{
                [self.mediaArray addObjectsFromArray:mediaArray];
                [self.collectionView reloadData];
            }
            self.downloading = NO;
            self.curPage ++;
            
            [self.activityIndicator stopAnimating];
        }];
    }else{
        [self.instagramStoreManager mediaWithPage:self.curPage localDownloadDataSourceCompled:^(NSArray *mediaArray, NSError *error) {
            self.curPage ++;
            NSUInteger a = [self.mediaArray count];
            [self.mediaArray addObjectsFromArray:mediaArray];
            
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            [mediaArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSUInteger b = a+idx;
                NSIndexPath *path = [NSIndexPath indexPathForItem:b inSection:0];
                [arr addObject:path];
            }];
            
            [self.collectionView performBatchUpdates:^{
                [self.collectionView insertItemsAtIndexPaths:arr];
            } completion:nil];
            
            self.downloading = NO;
            
            if (mediaArray.count == 0) {
                self.activityIndicator.hidden = YES;
                self.hideFooter = YES;
                [self.collectionView reloadData];
            }
            
            [self.activityIndicator stopAnimating];
        }];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.mediaArray count];
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    InstagramCell *instagramCell =  [collectionView dequeueReusableCellWithReuseIdentifier:kXHInstagramCell forIndexPath:indexPath];
    
    if ([self.mediaArray count] > 0) {
         PFObject* entity = [self.mediaArray objectAtIndex:indexPath.row];
        [instagramCell setEntity:entity andIndexPath:indexPath];

        
    }
    
    if (indexPath.row == [self.mediaArray count] - 1 && !self.downloading) {
        [self downloadDataSource];
    }
    
    return instagramCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (self.hideFooter) {
        return CGSizeZero;
    }
    return CGSizeMake(CGRectGetWidth(self.view.frame), 40);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind != UICollectionElementKindSectionFooter || self.hideFooter) {
        return nil;
    }
    
    UICollectionReusableView *foot = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kXHInstagramFooter forIndexPath:indexPath];
    
    CGPoint center = self.activityIndicator.center;
    center.x = foot.center.x;
    center.y = 20;
    self.activityIndicator.center = center;
    
    [foot addSubview:self.activityIndicator];
    
    return foot;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    InstagramCell *cell = (InstagramCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    FSEditorViewController *editorVC = [[FSEditorViewController alloc] init];
    editorVC.bgImg = cell.imageView.image;
    [SinglePicManager manager].entity = cell.entity;
    [self flipToViewController:editorVC fromItemAtIndexPath:indexPath withSourceSnapshotImage:cell.imageView.image andDestinationSnapshot:cell.imageView.image withCompletion:^{
         [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
      }];
    
}

@end
