//
//  DetailViewController.m
//  intern1
//
//  Created by Sneha Silwal on 11/7/15.
//  Copyright (c) 2015 Sneha Silwal. All rights reserved.
//

#import "DetailViewController.h"
#import "SKSConfiguration.h"
#import <AVFoundation/AVFoundation.h>
#import <SpeechKit/SpeechKit.h>


// State Logic: IDLE -> LISTENING -> PROCESSING -> repeat
enum {
    SKSIdle = 1,
    SKSListening = 2,
    SKSProcessing = 3
};
typedef NSUInteger SKSState;



@interface DetailViewController ()<SKTransactionDelegate, SKAudioDelegate, SKAudioPlayerDelegate> {
    SKSession* _skSession;
    id<SKTransaction> _skTransaction;
    
    SKSState _state;
    
    NSTimer *_volumePollTimer;
    
    SKAudioFile *_startEarcon;
    SKAudioFile *_stopEarcon;
    SKAudioFile *_errorEarcon;
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

- (void)configureView;
@end

@implementation DetailViewController

@synthesize toggleRecogButton = _toggleRecogButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _endpointer = SKTransactionEndOfSpeechDetectionShort;
    _language = @"eng-USA";
    _contextTag = SKSNLUContextTag;
    _state = SKSIdle;
    _skTransaction = nil;
    
    // Create a session
    _skSession = [[SKSession alloc] initWithURL:[NSURL URLWithString:SKSServerUrl]
                                       appToken:[NSData dataWithBytesNoCopy:SKSAppKey length:64 freeWhenDone:NO]];
    
    if (!_skSession) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"SpeechKit"
                                                           message:@"Failed to initialize SpeechKit session."
                                                          delegate:nil cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    _skSession.audioPlayer.delegate = self;
    // Tell the AudioPlayer to start playing as soon as we enqueue an Audio .
    [_skSession.audioPlayer play];
    
    [self loadEarcons];
}

#pragma mark - SKAudioPlayerDelegate

- (void)audioPlayer:(SKAudioPlayer *)player willBeginPlaying:(id <SKAudio>)audio
{
    // No need to do anything here, but feel free to get creative and leverage this handler.
}

- (void)audioPlayer:(SKAudioPlayer *)player didFinishPlaying:(id <SKAudio>)audio
{
    // We should make sure to let the start earcon finish playing before we start to listen.
    // This will ensure that there are no earcon artifacts in the recording.
    if(audio == _startEarcon) {
        [self recognize];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing the detail item


- (IBAction)toggleRecognition:(UIButton *)sender
{
    switch (_state) {
        case SKSIdle:
            [[_skSession audioPlayer] enqueue:_startEarcon];
            break;
        case SKSListening:
            [self stopRecording];
            break;
        case SKSProcessing:
            [self cancel];
            break;
        default:
            break;
    }
}

- (void)recognize
{
    // Start listening to the user.
    [_toggleRecogButton setTitle:@"Stop" forState:UIControlStateNormal];
    _skTransaction = [_skSession recognizeWithService:_contextTag
                                            detection:self.endpointer
                                             language:self.language
                                                 data:nil
                                             delegate:self];
}

- (void)stopRecording
{
    // Stop recording the user.
    [_skTransaction stopRecording];
    // Disable the button until we received notification that the transaction is completed.
    [_toggleRecogButton setEnabled:NO];
}

- (void)cancel
{
    // Cancel the Reco transaction.
    // This will only cancel if we have not received a response from the server yet.
    [_skTransaction cancel];
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}
# pragma mark - SKTransactionDelegate

- (void)transactionDidBeginRecording:(id<SKTransaction>)transaction
{
    NSLog(@"transactionDidBeginRecording");
    
    _state = SKSListening;
    [_toggleRecogButton setTitle:@"Listening.." forState:UIControlStateNormal];
}

- (void)transactionDidFinishRecording:(id<SKTransaction>)transaction
{
    NSLog(@"transactionDidFinishRecording");
    
    _state = SKSProcessing;
    [_toggleRecogButton setTitle:@"Processing.." forState:UIControlStateNormal];
    
    [[_skSession audioPlayer] playAudio:_stopEarcon];
}

- (void)transaction:(id<SKTransaction>)transaction didReceiveRecognition:(SKRecognition *)recognition
{
    NSLog (@"didReceiveRecognition: %@", recognition.text);
    
    _state = SKSIdle;
}

- (void)transaction:(id<SKTransaction>)transaction didReceiveServiceResponse:(NSDictionary *)response
{
    NSLog(@"didReceiveServiceResponse: %@", [response description]);
    
    _state = SKSIdle;
    [self resetTransaction];
}

- (void)transaction:(id<SKTransaction>)transaction didReceiveInterpretation:(SKInterpretation *)interpretation
{
    NSLog(@"didReceiveInterpretation: %@", interpretation.result);
    
    _state = SKSIdle;
    [self resetTransaction];
}

- (void)transaction:(SKTransaction *)transaction didFinishWithSuggestion:(NSString *)suggestion
{
    NSLog(@"didFinishWithSuggestion");
}

- (void)transaction:(SKTransaction *)transaction didFailWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    NSLog(@"didFailWithError: %@. %@", [error description], suggestion);
    
    _state = SKSIdle;
    [self resetTransaction];
    
    [[_skSession audioPlayer] playAudio:_errorEarcon];
}

#pragma mark - SKAudioDelegate

- (void)audio:(id <SKAudio>)audio didFinishLoadingFromURL:(NSURL*)url {}

- (void)audio:(id <SKAudio>)audio didFinishSavingToURL:(NSURL*)url {}

- (void)audio:(id <SKAudio>)audio didFailWithError:(NSError*)error {}


#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


- (void)resetTransaction
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        _skTransaction = nil;
        [_toggleRecogButton setTitle:@"recognizeWithService" forState:UIControlStateNormal];
        [_toggleRecogButton setEnabled:YES];
    }];
}

- (void)loadEarcons
{
    // Load all of the earcons from disk
    
    NSString* startEarconPath = [[NSBundle mainBundle] pathForResource:@"sk_start" ofType:@"pcm"];
    NSString* stopEarconPath = [[NSBundle mainBundle] pathForResource:@"sk_stop" ofType:@"pcm"];
    NSString* errorEarconPath = [[NSBundle mainBundle] pathForResource:@"sk_error" ofType:@"pcm"];
    
    _startEarcon = [[SKAudioFile alloc] initWithURL:[NSURL fileURLWithPath:startEarconPath] delegate:self];
    [_startEarcon load];
    
    _stopEarcon = [[SKAudioFile alloc] initWithURL:[NSURL fileURLWithPath:stopEarconPath] delegate:self];
    [_stopEarcon load];
    
    _errorEarcon = [[SKAudioFile alloc] initWithURL:[NSURL fileURLWithPath:errorEarconPath] delegate:self];
    [_errorEarcon load];
}

@end