//
//  CoffeeRunDoc.h
//  intern1
//
//  Created by Sneha Silwal on 11/7/15.
//  Copyright (c) 2015 Sneha Silwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class CoffeeRunData;

@interface CoffeeRunDoc : NSObject

@property (strong, nonatomic) NSString *date;
@property (strong) CoffeeRunData *data;
@property (strong) UIImage *thumbImage;

- (id)initWithTitle:(NSString*)title price:(float)price thumbImage:(UIImage *)thumbImage withDate:(NSString *)date;

@end
