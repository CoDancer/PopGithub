//
//  UIImage+Category.m
//  PopViewController
//
//  Created by onwer on 16/1/7.
//  Copyright © 2016年 onwer. All rights reserved.
//

#import "UIImage+Category.h"
#import "NSMutableArray+Category.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation UIImage (Category)

- (void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                customAlbumName:(NSString *)customAlbumName
                completionBlock:(void (^)(void))completionBlock
                   failureBlock:(void (^)(NSError *error))failureBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        NSMutableArray *groups=[[NSMutableArray alloc]init];
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
        {
            if (group)
            {
                [groups addObject:group];
            }
            
            else
            {
                BOOL haveHDRGroup = NO;
                
                for (ALAssetsGroup *gp in groups)
                {
                    NSString *name =[gp valueForProperty:ALAssetsGroupPropertyName];
                    
                    if ([name isEqualToString:customAlbumName])
                    {
                        haveHDRGroup = YES;
                    }
                }
                
                if (!haveHDRGroup)
                {
                    [assetsLibrary addAssetsGroupAlbumWithName:customAlbumName
                                                   resultBlock:^(ALAssetsGroup *group)
                     {
                         [groups addObjectIfNotNil:group];
                         
                     }
                                                  failureBlock:nil];
                    haveHDRGroup = YES;
                }
            }
            
        };
        //创建相簿
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:listGroupBlock failureBlock:nil];
        
        [self saveToAlbumWithMetadata:nil imageData:UIImagePNGRepresentation(self) customAlbumName:customAlbumName completionBlock:completionBlock failureBlock:failureBlock];
    });
    
}

- (void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                      imageData:(NSData *)imageData
                customAlbumName:(NSString *)customAlbumName
                completionBlock:(void (^)(void))completionBlock
                   failureBlock:(void (^)(NSError *error))failureBlock
{
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    void (^AddAsset)(ALAssetsLibrary *, NSURL *) = ^(ALAssetsLibrary *assetsLibrary, NSURL *assetURL) {
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                
                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:customAlbumName]) {
                    [group addAsset:asset];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completionBlock) {
                            completionBlock();
                        }
                    });
                }
            } failureBlock:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failureBlock) {
                        failureBlock(error);
                    }
                });
            }];
        } failureBlock:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failureBlock) {
                    failureBlock(error);
                }
            });
        }];
    };
    __weak typeof(assetsLibrary) weakassetsLibrary = assetsLibrary;
    [assetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        if (customAlbumName) {
            [assetsLibrary addAssetsGroupAlbumWithName:customAlbumName resultBlock:^(ALAssetsGroup *group) {
                if (group) {
                    [weakassetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [group addAsset:asset];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (completionBlock) {
                                completionBlock();
                            }
                        });
                    } failureBlock:^(NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (failureBlock) {
                                failureBlock(error);
                            }
                        });
                    }];
                } else {
                    AddAsset(weakassetsLibrary, assetURL);
                }
            } failureBlock:^(NSError *error) {
                AddAsset(weakassetsLibrary, assetURL);
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock();
                }
            });
        }
    }];
}

- (UIImage*)blurredImage
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:10.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return returnImage;
}

@end
