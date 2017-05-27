//
//  ViewController.h
//  文字渐变色
//
//  Created by 王涛 on 16/10/14.
//  Copyright © 2016年 王涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end

@interface CFGradientLabel : UILabel

@property(nonatomic, strong) NSArray* colors;

@end
