//
//  CoffeeRunDoc.h
//  intern1
//
//  Created by Sneha Silwal on 11/7/15.
//  Copyright (c) 2015 Sneha Silwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CoffeeRunData;

@interface CoffeeRunDoc : NSObject

@property (strong) CoffeeRunData *data;
@property (strong) UIImage *thumbImage;

- (id)initWithTitle:(NSString*)title price:(float)price thumbImage:(UIImage *)thumbImage;

@end
