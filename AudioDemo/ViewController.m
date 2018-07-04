//
//  ViewController.m
//  AudioDemo
//
//  Created by hanyutong on 2018/7/2.
//  Copyright © 2018年 Hanne. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

#import "WaveView.h"

@interface ViewController ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet WaveView *waveView;
@property (weak, nonatomic) IBOutlet UIButton *playerBtn;

@property (weak, nonatomic) IBOutlet UIButton *recoderBtn;
@property (nonatomic, strong) AVAudioRecorder * recorder;
@property (strong, nonatomic)AVAudioPlayer * player;
@property (nonatomic, strong) NSTimer * recoderTimer;
@property (nonatomic, strong) NSTimer * playerTimer;
@property (weak, nonatomic) IBOutlet UILabel *powerChannel;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}
-(AVAudioRecorder *)recorder
{
  if (!_recorder) {
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/record"];
    NSMutableDictionary * settingDic = [[NSMutableDictionary alloc] init];
    [settingDic setValue:[NSNumber numberWithInt:44100] forKey:AVSampleRateKey];
    [settingDic setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [settingDic setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    [settingDic setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:path] settings:settingDic error:nil];
    _recorder.meteringEnabled = YES;

    [_recorder prepareToRecord];

  }
  return _recorder;
}

-(AVAudioPlayer *)player
{
  if (!_player) {
//    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/record"];
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];

    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    _player.meteringEnabled = YES;
    _player.delegate = self;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
    [_player prepareToPlay];
  }
  return _player;
}


- (IBAction)record:(UIButton*)sender {
  if (sender.isSelected == NO) {
    [self.recorder record];
    sender.selected = YES;
    [_recoderTimer invalidate];
    _recoderTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(recoderLevelTimerCallback:) userInfo:nil repeats:YES];

  }else
  {
    [self.recorder stop];
    sender.selected = NO;
    [_recoderTimer invalidate];
  }


}
- (IBAction)play:(UIButton *)sender {

  if (sender.isSelected == NO) {
    [self.player play];
    sender.selected = YES;
   [_playerTimer invalidate];
    _playerTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playerLevelTimerCallback:) userInfo:nil repeats:YES];

  }else
  {
    [self.player stop];
    self.player = nil;
    sender.selected = NO;
    [_playerTimer invalidate];
  }
}

- (void)recoderLevelTimerCallback:(NSTimer *)timer {
  [self.recorder updateMeters];
  float  decibels = [self.recorder averagePowerForChannel:0];
  [self levelWithDecibels:decibels];
}

-(void)playerLevelTimerCallback:(NSTimer*)timer
{
  [self.player updateMeters];
  float   decibels = [self.player averagePowerForChannel:0];
  [self levelWithDecibels:decibels];
}

-(float)levelWithDecibels:(float)decibels
{

  
  float   level;                // The linear 0.0 .. 1.0 value we need.
  float   minDecibels = -80.0f; // Or use -60dB, which I measured in a silent room.
  if (decibels < minDecibels)
  {
    level = 0.0f;
  }
  else if (decibels >= 0.0f)
  {
    level = 1.0f;
  }
  else
  {
    float   root            = 2.0f;
    float   minAmp          = powf(10.0f, 0.05f * minDecibels);
    float   inverseAmpRange = 1.0f / (1.0f - minAmp);
    float   amp             = powf(10.0f, 0.05f * decibels);
    float   adjAmp          = (amp - minAmp) * inverseAmpRange;
    level = powf(adjAmp, 1.0f / root);
  }
  NSLog(@"平均值 %f", level );
  self.powerChannel.text = [NSString stringWithFormat:@"%f",level*120];
  float levels = level*120;
  [self.waveView frequenceLevel:&levels];

  return level*120;
}








#pragma mark -AVAudioPlayerDelegate

/* AVAudioPlayer INTERRUPTION NOTIFICATIONS ARE DEPRECATED - Use AVAudioSession instead. */

/* audioPlayerBeginInterruption: is called when the audio session has been interrupted while the player was playing. The player will have been paused. */
//- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player NS_DEPRECATED_IOS(2_2, 8_0);
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
   [self.player stop];
  self.playerBtn.selected  =NO;
  self.player = nil;
  [_playerTimer invalidate];
}




- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


@end
