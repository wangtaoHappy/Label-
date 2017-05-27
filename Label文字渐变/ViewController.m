//
//  ViewController.m
//  文字渐变色
//
//  Created by 王涛 on 16/10/14.
//  Copyright © 2016年 王涛. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor redColor];
    [self addGradientRampWithColors:@[(id)[UIColor blueColor].CGColor,(id)[UIColor blackColor].CGColor] text:@"渐变色咯,哈哈哈哈哈哈哈哈哈哈"];
    [self addGradientLabelWithFrame:self.view.center gradientText:@"我是小仙女，小仙女不需要良心" infoText:@"" colors:@[(id)[UIColor blueColor].CGColor,(id)[UIColor blackColor].CGColor] font:[UIFont systemFontOfSize:18]];
}

- (void)addGradientRampWithColors:(NSArray *)colors text:(NSString *)text {
    //label在父视图上的（x，y）的值不是中心点
    CGPoint point = CGPointMake(30, 500);
    UILabel *lable = [[UILabel alloc]init];
    lable.text = text;
    lable.font = [UIFont systemFontOfSize:20];
   // lable.textAlignment = NSTextAlignmentCenter;
    [lable sizeToFit];
    //lable的中心和想象的一样啦！！
    lable.center = CGPointMake(point.x + CGRectGetWidth(lable.bounds)/2, point.y -  CGRectGetHeight(lable.bounds)/2);
    [self.view addSubview:lable];
    
    //这个label是和上面的label是对齐的哦，之前都不好对齐，用这样的方法设置frame就好了
//    UILabel *infoTextLabel = [[UILabel alloc] init];
//    infoTextLabel.frame = CGRectMake(lable.center.x - CGRectGetWidth(lable.bounds)/2 ,point.y + 30, 220, 50);
//    infoTextLabel.text = @"你说的是哦";
//    infoTextLabel.font = [UIFont systemFontOfSize:20];
//    infoTextLabel.backgroundColor  =[UIColor redColor];
//    infoTextLabel.numberOfLines = 0;
//    infoTextLabel.textAlignment = NSTextAlignmentLeft;
//    infoTextLabel.textColor = [UIColor blueColor];
//    [infoTextLabel sizeToFit];
//    [self.view addSubview:infoTextLabel];
    //在后面添加渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame  = lable.frame;
    gradientLayer.colors = colors;
    //渐变的方向（0，0） （0，1） （1，0）（1，1）为四个顶点方向
    //(I.e. [0,0] is the bottom-left
    // corner of the layer, [1,1] is the top-right corner.) The default values
    // are [.5,0] and [.5,1]
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint = CGPointMake(1, 1);
    
    [self.view.layer addSublayer:gradientLayer];
    gradientLayer.mask = lable.layer;
    lable.frame = gradientLayer.bounds;
}

- (void)addGradientLabelWithFrame:(CGPoint)point gradientText:(NSString *)text infoText:(NSString *)infoText colors:(NSArray *)colors font:(UIFont *)font {
    
    static NSInteger labelTag = 200;
    CFGradientLabel *lable = [[CFGradientLabel alloc] init];
    lable.text = text;
    lable.font = font;
    lable.tag = labelTag;
    lable.textAlignment = NSTextAlignmentCenter;
    [lable sizeToFit];
    //之前项目的时候设置了为0，忘了注释，所以有的小伙伴用的时候就不显示了……(^-^)
//    lable.alpha = 0;
    lable.center = point;
    lable.colors = colors;
    [self.view addSubview:lable];
}

@end

@implementation CFGradientLabel

- (void)drawRect:(CGRect)rect {
    
    CGSize textSize = [self.text sizeWithAttributes:@{NSFontAttributeName : self.font}];
    CGRect textRect = (CGRect){0, 0, textSize};
    
    // 画文字(不做显示用, 主要作用是设置 layer 的 mask)
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.textColor set];
    [self.text drawWithRect:rect options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:NULL];
    
    // 坐标(只对设置后的画到 context 起作用, 之前画的文字不起作用)
    CGContextTranslateCTM(context, 0.0f, rect.size.height - (rect.size.height - textSize.height) * 0.5);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    CGImageRef alphaMask = CGBitmapContextCreateImage(context);
    CGContextClearRect(context, rect); // 清除之前画的文字
    
    // 设置mask
    CGContextClipToMask(context, rect, alphaMask);
    
    // 画渐变色
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)self.colors, NULL);
    CGPoint startPoint = CGPointMake(textRect.origin.x,
                                     textRect.origin.y);
    CGPoint endPoint = CGPointMake(textRect.origin.x + textRect.size.width,
                                   textRect.origin.y + textRect.size.height);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    // 释放内存
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    CFRelease(alphaMask);
}
@end
