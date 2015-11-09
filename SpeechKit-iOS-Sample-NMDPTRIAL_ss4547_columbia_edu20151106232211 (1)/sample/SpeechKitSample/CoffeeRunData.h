//
//  CoffeeRunData.h
//  intern1
//
//  Created by Sneha Silwal on 11/7/15.
//  Copyright (c) 2015 Sneha Silwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoffeeRunData : NSObject

@property (strong) NSString *title;
@property(assign) float price;

-(id)initWithTitle:(NSString*)title price:(float)price;

@end
