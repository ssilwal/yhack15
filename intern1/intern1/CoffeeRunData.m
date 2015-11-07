//
//  CoffeeRunData.m
//  intern1
//
//  Created by Sneha Silwal on 11/7/15.
//  Copyright (c) 2015 Sneha Silwal. All rights reserved.
//

#import "CoffeeRunData.h"
@implementation CoffeeRunData

@synthesize title = _title;
@synthesize price = _price;

-(id)initWithTitle:(NSString*)title price:(float)price {
    if((self = [super init])){
    self.title = title;
    self.price = price;
    }
    return self;
}

@end
