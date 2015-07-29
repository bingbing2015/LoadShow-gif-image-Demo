//
//  ViewController.m
//  SmileGifLoadShowTest
//
//  Created by jtbapple on 14/11/24.
//  Copyright (c) 2014年 jtbapple. All rights reserved.
//

#import "ViewController.h"
#import "LoadGifImage.h"
#define MAINVIEW_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define MAINVIEW_WIDHT ([[UIScreen mainScreen] bounds].size.width)
#define SMILEVIEW_HEIGHT ((float)216.0)
#define SMILEGIFSIZE_HEIGHT ((float)40.0)
#define SMILEGIFSIZE_WIDTH ((float)40.0)
#define MAINVIEW_BUNDLEPATH ([[NSBundle mainBundle] bundlePath])

@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView* g_smileView01;//表情界面
@property (nonatomic, strong) UIView* g_smileView02;//表情界面
@property (nonatomic, strong) UIView* g_smileView03;//表情界面
@property (nonatomic, strong) UIScrollView* g_smileScrollView;//表情加载控件
@property (nonatomic, strong) UIPageControl* g_smilePagesControl;//表情页面切换控制器
@property (nonatomic) NSMutableDictionary* g_smileImageDic;//表情字典，key=从1开始的数字，keyVal=图片名称

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor blueColor];

    self.g_smileImageDic=[[NSMutableDictionary alloc] init];
    
    for (int i=1; i<31; i++) {
        NSString* key=[NSString stringWithFormat:@"%d",i];
        NSString* keyVal=[NSString stringWithFormat:@"%d.gif",i];
        [self.g_smileImageDic setObject:keyVal forKey:key];
    }
    
    [self initSmileView];

    [self initLoadSmileGif];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


#pragma mark - 初始化表情列表显示界面
-(void)initSmileView{
    //表情界面
    
    //[self.view addSubview:self.g_smileView];
    
    //分页滚动
    NSInteger smileCount=([self.g_smileImageDic count]/12);//计算表情页数
    if (([self.g_smileImageDic count]%12)!=0) {
        smileCount+=1;
    }
    self.g_smileScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, MAINVIEW_HEIGHT-SMILEVIEW_HEIGHT, MAINVIEW_WIDHT, SMILEVIEW_HEIGHT-55)];
    self.g_smileScrollView.showsVerticalScrollIndicator=NO;
    self.g_smileScrollView.showsHorizontalScrollIndicator=NO;
    self.g_smileScrollView.delegate=self;
    self.g_smileScrollView.pagingEnabled=YES;
    [self.view addSubview:self.g_smileScrollView];
    
    self.g_smileView01 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINVIEW_WIDHT, SMILEVIEW_HEIGHT-55)];
    [self.g_smileView01 setBackgroundColor:[UIColor greenColor]];
    [self loadGifImage:1 view:self.g_smileView01];
    
    self.g_smileView02 = [[UIView alloc] initWithFrame:CGRectMake(MAINVIEW_WIDHT, 0, MAINVIEW_WIDHT, SMILEVIEW_HEIGHT-55)];
    [self.g_smileView02 setBackgroundColor:[UIColor redColor]];
    [self loadGifImage:2 view:self.g_smileView01];
    
    self.g_smileView03 = [[UIView alloc] initWithFrame:CGRectMake(2*MAINVIEW_WIDHT, 0, MAINVIEW_WIDHT, SMILEVIEW_HEIGHT-55)];
    [self.g_smileView03 setBackgroundColor:[UIColor brownColor]];
    [self loadGifImage:3 view:self.g_smileView01];
    
    [self.g_smileScrollView addSubview:self.g_smileView01];
    [self.g_smileScrollView addSubview:self.g_smileView02];
    [self.g_smileScrollView addSubview:self.g_smileView03];
    
    self.g_smileScrollView.contentSize=CGSizeMake(MAINVIEW_WIDHT*smileCount, SMILEVIEW_HEIGHT-55);
    
    //页面滚动控制器
    self.g_smilePagesControl=[[UIPageControl alloc] initWithFrame:CGRectMake(0, SMILEVIEW_HEIGHT-92, MAINVIEW_WIDHT, 37)];
    self.g_smilePagesControl.numberOfPages=smileCount;
    self.g_smilePagesControl.currentPage=0;
    [self.view addSubview:self.g_smilePagesControl];
}

-(void)loadGifImage:(NSInteger)numberPage view:(UIView*)smileView{
    UIImage* defaultImage=[UIImage imageNamed:@"defaultImage.gif"];
    CGFloat defaultImage_height = defaultImage.size.height/2;
    CGFloat defaultImage_width = defaultImage.size.width/2;
    
    NSInteger smileCout=1;//显示的表情计数
    
    /*40*40大小图片*/
    if (defaultImage_height==SMILEGIFSIZE_HEIGHT && defaultImage_width==SMILEGIFSIZE_WIDTH) {
        for (int j=1; j<=12; j++) {
            NSString* imageName = [self.g_smileImageDic objectForKey:[NSString stringWithFormat:@"%ld",smileCout]];
            if (imageName) {
                UIButton* button_smile=[UIButton buttonWithType:UIButtonTypeCustom];
                [button_smile setBackgroundColor:[UIColor clearColor]];
                if (j<7) {//第一行
                    [button_smile setFrame:CGRectMake(((numberPage-1)*MAINVIEW_WIDHT)+10+((j-1)*52), 16, 40, 40)];
                }else{//第二行
                    [button_smile setFrame:CGRectMake(((numberPage-1)*MAINVIEW_WIDHT)+10+((j-7)*52), 16+54, 40, 40)];
                }
                [button_smile setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                [button_smile setTag:smileCout];//按钮标签
                [button_smile addTarget:self action:@selector(smileClickAction:) forControlEvents:UIControlEventTouchUpInside];
                [smileView addSubview:button_smile];
                smileCout++;
            }else{
                break;
            }
        }
    }
    /*END*/
}

#pragma mark - 加载表情图片
-(void)initLoadSmileGif{
    UIImage* defaultImage=[UIImage imageNamed:@"defaultImage.gif"];
    CGFloat defaultImage_height = defaultImage.size.height/2;
    CGFloat defaultImage_width = defaultImage.size.width/2;
    
    NSInteger totalPageNumber=0;//计算表情页数
    NSInteger totalSmileCount=0;//表情个数
    NSInteger pageSmileCount=0;//每页表情个数
    NSInteger curPageCount=1;//加载图片显示的时候计算页数
    NSInteger smileCout=1;//显示的表情计数
    
    /*40*40大小图片*/
    if (defaultImage_height==SMILEGIFSIZE_HEIGHT && defaultImage_width==SMILEGIFSIZE_WIDTH) {
        pageSmileCount=12;//固定每页12个
        totalPageNumber=([self.g_smileImageDic count]/pageSmileCount);//存在多少页
        if (([self.g_smileImageDic count]%pageSmileCount)!=0) {
            totalPageNumber+=1;
        }
        
        totalSmileCount= [self.g_smileImageDic count];//表情总数
        
        for (int index=1; index<=totalPageNumber; index++) {
            //按页添加，固定两行，每行6个
            for (int j=1; j<=pageSmileCount; j++) {
                NSString* imageName = [self.g_smileImageDic objectForKey:[NSString stringWithFormat:@"%ld",smileCout]];
                if (imageName) {
                    UIButton* button_smile=[UIButton buttonWithType:UIButtonTypeCustom];
                    [button_smile setBackgroundColor:[UIColor clearColor]];
                    if (j<7) {//第一行
                        [button_smile setFrame:CGRectMake(((curPageCount-1)*MAINVIEW_WIDHT)+10+((j-1)*52), 16, 40, 40)];
                    }else{//第二行
                        [button_smile setFrame:CGRectMake(((curPageCount-1)*MAINVIEW_WIDHT)+10+((j-7)*52), 16+54, 40, 40)];
                    }
                    [button_smile setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                    [button_smile setTag:smileCout];//按钮标签
                    [button_smile addTarget:self action:@selector(smileClickAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self.g_smileScrollView addSubview:button_smile];
                    smileCout++;
                }else{
                    break;
                }
            }
            curPageCount++;
        }
    }
    /*END*/
}
-(void)smileClickAction:(UIButton*)sender{
    UIButton* button_smile=(UIButton*)sender;
    NSLog(@"点击的图片序号为：%ld",button_smile.tag);
    NSString* imageName=[self.g_smileImageDic objectForKey:[NSString stringWithFormat:@"%ld",button_smile.tag]];
    
    NSString* filepath=[NSString stringWithFormat:@"%@/%@",MAINVIEW_BUNDLEPATH,imageName];
    CGRect rec = CGRectMake(0, 0, 0, 0);
    if (button_smile.tag<7) {
        rec=CGRectMake(10+((button_smile.tag-1)*52), 16, 40, 40);
    }else{
        rec=CGRectMake(10+((button_smile.tag-7)*52), 16+40+14, 40, 40);
    }
    LoadGifImage* gifimage=[[LoadGifImage alloc] initCustomImageView:rec filepath:filepath];
    [self.view addSubview:gifimage];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset=scrollView.contentOffset;
    self.g_smilePagesControl.currentPage=offset.x/MAINVIEW_WIDHT;
}

@end
