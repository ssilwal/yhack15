//
//  CoffeeRunDoc.m
//  intern1
//
//  Created by Sneha Silwal on 11/7/15.
//  Copyright (c) 2015 Sneha Silwal. All rights reserved.
//

#import "CoffeeRunDoc.h"
#import "CoffeeRunData.h"

@implementation CoffeeRunDoc;
@synthesize data = _data;
@synthesize thumbImage = _thumbImage;
@synthesize date = _date;

- (id)initWithTitle:(NSString*)title price:(float)price thumbImage:(UIImage *)thumbImage withDate:(NSString *)date {
    if((self = [super init])){
        self.data = [[CoffeeRunData alloc] initWithTitle:title price:price];
        self.thumbImage = thumbImage;
        self.date = date;
    }
    return self;
}

@end
