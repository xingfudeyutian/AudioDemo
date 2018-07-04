//
//  WaveView.m
//  AudioDemo
//
//  Created by hanyutong on 2018/7/4.
//  Copyright © 2018年 Hanne. All rights reserved.
//

#import "WaveView.h"

@implementation WaveView

-(void)frequenceLevel:(float *)levels
{
  if (_drawing) {
    return;
  }
  _levels = *levels;

  NSLog(@"%f",_levels);
  [self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

  _drawing = YES;
  //每个柱子的高度
  CGFloat waveWidth = 2;
  //柱子的间距
  CGFloat margin = 2;
  //柱子的数量
  int count = [UIScreen mainScreen].bounds.size.width/(waveWidth+margin);

  for (int i = 0; i< count ; i++) {
    CGFloat from;
    CGFloat to;
   if (i>count*2/5 && i<count*3/5)
   {
      from = 0.6 ;
      to = 1;
   }else if((i<count *2/5 && i>count * 1/5)||(i<count *4/5 && i>count * 3/5))
   {
     from = 0.2 ;
     to = 0.6;
   }
   else
   {
      from = 0;
      to = 0.2;
   }
   int fromL = _levels * from;
   int toL = _levels * to;

    int radom = (fromL + (arc4random() % (toL - fromL + 1)));

    CGFloat x = waveWidth * i + (i -1)* waveWidth;
    CGFloat y = 98-radom;
    CGFloat w = waveWidth;
    CGFloat h = radom *2;

    CGMutablePathRef path = CGPathCreateMutable();
    CGRect rectangle = CGRectMake(x,y, w, h);

//    CGRect rectangle = CGRectMake(10.0f, 98-_levels, 5.0f, _levels*2);
    CGPathAddRect(path,NULL, rectangle);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextAddPath(currentContext, path);
    [[UIColor lightGrayColor] setFill];
    [[UIColor whiteColor] setStroke];
    CGContextSetLineWidth(currentContext,0.0f);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    CGPathRelease(path);

  }
  _drawing = NO;
}


-(instancetype)initWithFrame:(CGRect)frame
{
  if (self == [super initWithFrame:frame]) {
    [self setupUI];
  }
  return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
  if (self == [super initWithCoder:aDecoder]) {
    [self setupUI];
  }
  return self;
}

-(void)setupUI
{

}


-(void)layoutSubviews
{
  [super layoutSubviews];
}
- (void)reset
{
  [self setNeedsDisplay];
}



@end
