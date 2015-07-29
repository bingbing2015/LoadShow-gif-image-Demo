//
//  LoadGifImage.m
//  SmileGifLoadShowTest
//
//  Created by jtbapple on 14/11/25.
//  Copyright (c) 2014年 jtbapple. All rights reserved.
//

#import "LoadGifImage.h"
#import <ImageIO/ImageIO.h>
@implementation LoadGifImage

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initCustomImageView:(CGRect)frame filepath:(NSString*)gifPath{
    self=[super initWithFrame:frame];
    if (self) {
        
        //图片路径长度判断
        if ([gifPath length]<=4) {
            if (TARGET_IPHONE_SIMULATOR) {
                NSLog(@"图片路径长度错误");
            }
            return nil;
        }
        
        //判断图片是否携带gif后缀
        NSString* postfix=[gifPath substringFromIndex:([gifPath length]-4)];
        if ([postfix isEqualToString:@".gif"]==FALSE) {
            if (TARGET_IPHONE_SIMULATOR) {
                NSLog(@"图片名称为携带gif后缀，或者不是gif格式图片!");
            }
            return nil;
        }
        
        //图片是否存在判断
        NSFileManager* fileManager=[NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:gifPath]==FALSE) {
            if (TARGET_IPHONE_SIMULATOR) {
                NSLog(@"图片不存在！");
            }
            return nil;
        }
        
        //判断图片是否为gif格式
        if ([self isGifImage:gifPath]==FALSE) {
            if (TARGET_IPHONE_SIMULATOR) {
                NSLog(@"图片不是gif格式！");
            }
            return nil;
        }
        
        //加载GIF图片并将其拆分成若干个图片，然后存储在数组中
        NSURL *fileUrl = [NSURL fileURLWithPath:gifPath];
        CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)fileUrl, NULL);
        size_t frameCout=CGImageSourceGetCount(gifSource);
        NSMutableArray* frames=[[NSMutableArray alloc] init];
        for (size_t i=0; i<frameCout; ++i) {
            CGImageRef imageRef=CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
            UIImage* imageName=[UIImage imageWithCGImage:imageRef];
            [frames addObject:imageName];
            CGImageRelease(imageRef);
        }
        
        //将数组中得图片使用动画接口播放，无限循环
        UIImageView* imageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        imageview.animationImages=frames;
        imageview.animationDuration=10;//动画每次持续时长
        imageview.animationRepeatCount=0;//0-默认为无限循环
        [imageview startAnimating];
        [self addSubview:imageview];
    }
    return self;
}
#pragma mark - 获取图片格式
/*
 参数：图片的访问路径，图片名称必须携带后缀
 */
-(NSString*)typeForImageData:(NSString*)imagePath{
    NSData* data=[[NSData alloc] initWithContentsOfFile:imagePath];
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
            break;
        case 0x89:
            return @"image/png";
            break;
        case 0x47:
            return @"image/gif";
            break;
        case 0x49:
        case 0x4D:
            return @"image/tiff";
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark - 判断图片是否为gif格式图片
/*
 参数：图片访问路径，图片名称必须携带后缀
 */
-(BOOL)isGifImage:(NSString*)imagePath{
    NSData* data=[[NSData alloc] initWithContentsOfFile:imagePath];
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            //return @"image/jpeg";
            return FALSE;
            break;
        case 0x89:
            //return @"image/png";
            return FALSE;
            break;
        case 0x47:
            //return @"image/gif";
            return TRUE;
            break;
        case 0x49:
        case 0x4D:
            //return @"image/tiff";
            return FALSE;
            break;
        default:
            break;
    }
    return FALSE;
}

@end
