//
//  WaveView.h
//  AudioDemo
//
//  Created by hanyutong on 2018/7/4.
//  Copyright © 2018年 Hanne. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFSFrequencyPlotViewMaxCount 64

@interface WaveView : UIView
{
  float _levels;
  BOOL _drawing;
}
-(void)frequenceLevel:(float *)levels;
- (void)reset;
@end
