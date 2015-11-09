//
//  SKSMainViewController.h
//  SpeechKitSample
//
//  Copyright (c) 2015 Nuance Communications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSNLUViewController.h"
//original sample app
//@interface SKSMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
//@property (weak, nonatomic) IBOutlet UITableView *tableView;

@interface SKSMainViewController: UITableViewController;
@property(strong) NSMutableArray *runs;

@end
