//
//  SKSMainViewController.m
//  SpeechKitSample
//
//  Initial screen.
//
//  Copyright (c) 2015 Nuance Communications. All rights reserved.
//

#import "SKSMainViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CoffeeRunDoc.h"
#import "CoffeeRunData.h"

@interface SKSMainViewController () {
    //NSArray* _actionItems;
    NSMutableArray *_objects;
}

@end



@implementation SKSMainViewController
@synthesize runs = _runs;

- (void)awakeFromNib
{
    [super awakeFromNib];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.title = @"Coffee Runs";

    // Audio system init
    // This will force the audio to be played from the bottom speakers
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    [avSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [avSession setActive:YES error:nil];
    [avSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    NSLog(@"volume=%f",[[AVAudioSession sharedInstance] outputVolume]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsIn:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _runs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBasicCell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyBasicCell"];
    }
    CoffeeRunDoc *run = [self.runs objectAtIndex:indexPath.row];
    cell.textLabel.text = run.data.title;
    cell.imageView.image = run.thumbImage;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"showDetail"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSDate *object = _objects[indexPath.row];
//     //   [[segue destinationViewController] setDetailItem:object];
//    }
//}



/*
 * UITableViewDataSource
 */

/*- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [[_actionItems objectAtIndex:section][@"values"] count];
    return [[_objects objectAtIndex:section][@"values"] count];
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   // return [_actionItems count];
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //return _actionItems[section][@"title"];
    return _objects[section][@"title"];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"SkActionCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    //NSArray* item = [[_actionItems objectAtIndex:indexPath.section][@"values"] objectAtIndex:indexPath.row];
    NSArray* item = [[_objects objectAtIndex:indexPath.section][@"values"] objectAtIndex:indexPath.row];
    cell.textLabel.text = item[0];
    [cell.detailTextLabel setText:item[1]];
    return cell;
}*/

/*
 * UITableViewDelegate
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"Segue0" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Segue0"]) {
        CoffeeRunDoc *item = [_runs objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        SKSNLUViewController *destViewController = segue.destinationViewController;
        destViewController.myDate = item.date;
        //destViewController.myItem = item;
    }
   // if ([segue.identifier isEqualToString:@"Segue1"])
}

@end
