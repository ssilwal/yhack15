//
//  DetailViewController.h
//  intern1
//
//  Created by Sneha Silwal on 11/7/15.
//  Copyright (c) 2015 Sneha Silwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpeechKit/SKTransaction.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak,nonatomic) IBOutlet UIButton *toggleRecogButton;



@property (strong, nonatomic) NSString *contextTag;
@property (strong, nonatomic) NSString *language;
@property (assign, nonatomic) SKTransactionEndOfSpeechDetection endpointer;
//@property (weak,nonatomic)NSString *endpointer;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end