//
//  SKSNLUViewController.m
//  SpeechKitSample
//
//  This Controller is built to demonstrate how to perform NLU (Natural Language Understanding).
// 
//  This Controller is very similar to SKSASRViewController. Much of the code is duplicated for clarity.
// 
//  NLU is the transformation of text into meaning.
// 
//  When performing speech recognition with SpeechKit, you have a variety of options. Here we demonstrate
//  Detection Type and Language.
//
//  The Context Tag is assigned in the system configuration upon deployment of an NLU model.
//  Combined with the App ID, it will be used to find the correct NLU version to query.
// 
//  Languages can also be configured. Supported languages can be found here:
//  http://dragonmobile.nuancemobiledeveloper.com/public/index.php?task=supportedLanguages
//
//  Copyright (c) 2015 Nuance Communications. All rights reserved.
//

#import "SKSNLUViewController.h"
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


@interface SKSNLUViewController () <SKTransactionDelegate, SKAudioDelegate, SKAudioPlayerDelegate> {
    SKSession* _skSession;
    id<SKTransaction> _skTransaction;
    
    SKSState _state;
    
    NSTimer *_volumePollTimer;
    
    SKAudioFile *_startEarcon;
    SKAudioFile *_stopEarcon;
    SKAudioFile *_errorEarcon;
  //  - (double *)testPrice:(NSDictionary*) arr;
}

@end

@implementation SKSNLUViewController

@synthesize toggleRecogButton = _toggleRecogButton;
@synthesize contextTag = _contextTag;
@synthesize language = _language;
@synthesize endpointer = _endpointer;
@synthesize volumeLevelProgressView = _volumeLevelProgressView;
@synthesize myDate = _myDate;
//@synthesize myItem = _myItem;

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
    
    NSLog(@"%@",_myDate);
    //NSLog(@"%@",_myItem);
    //NSLog(@"%@", _myItem.date);
    //_endpointer = SKTransactionEndOfSpeechDetectionShort;
    _endpointer = SKTransactionEndOfSpeechDetectionLong;
    _language = @"eng-USA";
    _contextTag = SKSNLUContextTag;
    [self.contextTagTextView setText:_contextTag];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Reco Actions

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

# pragma mark - Volume level

- (void)startPollingVolume
{
    // Every 50 milliseconds we should update the volume meter in our UI.
    _volumePollTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                        target:self
                                                      selector:@selector(pollVolume)
                                                      userInfo:nil repeats:YES];
}

- (void) pollVolume
{
    float volumeLevel = [_skTransaction audioLevel];
    [self.volumeLevelProgressView setProgress:volumeLevel/100.0];
}

- (void) stopPollingVolume
{
    [_volumePollTimer invalidate];
    _volumePollTimer = nil;
    [self.volumeLevelProgressView setProgress:0.f];
}

# pragma mark - SKTransactionDelegate

- (void)transactionDidBeginRecording:(id<SKTransaction>)transaction
{
    //[self log:@"transactionDidBeginRecording"];
    //NSLog(@"transactionDidBeginRecording");
    _state = SKSListening;
    [self startPollingVolume];
    [_toggleRecogButton setTitle:@"Listening.." forState:UIControlStateNormal];
}

- (void)transactionDidFinishRecording:(id<SKTransaction>)transaction
{
    //[self log:@"transactionDidFinishRecording"];
    //NSLog(@"transactionDidFinishRecording");
    _state = SKSProcessing;
    [self stopPollingVolume];
    [_toggleRecogButton setTitle:@"Processing.." forState:UIControlStateNormal];
    
    [[_skSession audioPlayer] playAudio:_stopEarcon];
}

- (void)transaction:(id<SKTransaction>)transaction didReceiveRecognition:(SKRecognition *)recognition
{
    //[self log:[NSString stringWithFormat:@"didReceiveRecognition: %@", recognition.text]];
    
    _state = SKSIdle;
}

- (void)transaction:(id<SKTransaction>)transaction didReceiveServiceResponse:(NSDictionary *)response
{
    //[self log:[NSString stringWithFormat:@"didReceiveServiceResponse: %@", [response description]]];
    
    _state = SKSIdle;
    [self resetTransaction];
}

- (void)transaction:(id<SKTransaction>)transaction didReceiveInterpretation:(SKInterpretation *)interpretation
{
    NSLog(@"didReceiveInterpretation: %@", interpretation.result);
   // [self log:[NSString stringWithFormat:@"didReceiveInterpretation: %@", interpretation.result]];
   
    NSString *literal = @"";
    
    NSArray *interpretations = interpretation.result[@"interpretations"];
    if (interpretations == nil || interpretations.count == 0) {
        NSLog(@"No intepretation received");
        return;
    }
    
    NSDictionary *result = interpretations[0];
    literal = result[@"literal"];
    if (literal == nil) {
        NSLog(@"Literal not found in interpretation");
        return;
    }
    
    if (result[@"action"] == nil ||
        result[@"action"][@"intent"] == nil ||
        result[@"action"][@"intent"][@"value"] == nil ||
        [result[@"action"][@"intent"][@"value"] isEqualToString:@"NO_MATCH"] ||
        [result[@"action"][@"intent"][@"value"] isEqualToString:@"NO_INTENT"]) {
        NSLog(@"Intent not found in interpretation");
    } else {
        NSString *verb = result[@"action"][@"intent"][@"value"];
       // [self log:[NSString stringWithFormat:@"%@", verb]];
        if([verb isEqualToString:@"Order"])
        {
           // [self log:[NSString stringWithFormat:@"%d",price]];
      //      double price = testprice(result);
      //      [self log:[NSString stringWithFormat:@"%d",price]];
        }
        if (result[@"literal"] != nil); { [self log:[NSString stringWithFormat:@"%@",result[@"literal"]]];}
        //testprice(result);
    }
    _state = SKSIdle;
    [self resetTransaction];
}

/*-(double)testprice:(NSDictionary *)arr{
    float price = 0;
    NSString * dr = arr[@"concepts"][@"Drink"];
    if([dr isEqualToString:(@"coffee")]){
        price += 1.75;
    }else{
        price += 2.75;
    }
    NSString* size = arr[@"concepts"][@"size"][@"ranges"][1];
    NSLog(@"%a", size);
    /*if(size >5){}
    
 
}
*/
- (void)transaction:(SKTransaction *)transaction didFinishWithSuggestion:(NSString *)suggestion
{
    //[self log:@"didFinishWithSuggestion"];
}

- (void)transaction:(SKTransaction *)transaction didFailWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    //[self log:[NSString stringWithFormat:@"didFailWithError: %@. %@", [error description], suggestion]];
    
    _state = SKSIdle;
    [self resetTransaction];
    
    [[_skSession audioPlayer] playAudio:_errorEarcon];
}

#pragma mark - SKAudioDelegate

- (void)audio:(id <SKAudio>)audio didFinishLoadingFromURL:(NSURL*)url {}

- (void)audio:(id <SKAudio>)audio didFinishSavingToURL:(NSURL*)url {}

- (void)audio:(id <SKAudio>)audio didFailWithError:(NSError*)error {}

#pragma mark - Other Actions
- (IBAction)useNLUModel:(UITextField *)sender {
    _contextTag = sender.text;
}

- (IBAction) useLanguage:(UITextField *)sender
{
    _language = sender.text;
}

- (IBAction)clearLogs:(UIButton *)sender
{
    self.logTextView.text = @"";
}

#pragma mark - Helpers

- (void)log:(NSString *)message
{
    self.logTextView.text = [self.logTextView.text stringByAppendingFormat:@"%@\n", message];
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
