//
//  LoadGifImage.h
//  SmileGifLoadShowTest
//
//  Created by jtbapple on 14/11/25.
//  Copyright (c) 2014年 jtbapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadGifImage : UIView

/*
 参数：第一个为控件位置；第二个为图片访问绝对路径，其中图片名称必须携带后缀
 */
-(id)initCustomImageView:(CGRect)frame filepath:(NSString*)gifPath;
@end
