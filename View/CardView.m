//
//  CardView.m
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/26/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "CardView.h"

@interface CardView ()
@property (nonatomic, strong) UIColor *faceColor;
@end

@implementation CardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *cardBackground = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [cardBackground addClip];
    [self drawCardBackground];
    [self drawCardContents];
}

- (void)drawCardBackground
{
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
}

//Abstract methods
- (void)drawCardContents
{
    //should I assert here?
}

#define CORNER_FONT_STANDARD_HEIGHT 180.0;
#define CORNER_RADIUS 12.0;

- (CGFloat)cornerScaleFactor
{
    return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT;
}

- (CGFloat)cornerRadius
{
    return [self cornerScaleFactor] * CORNER_RADIUS;
}

- (CGFloat)cornerOffset
{
    return [self cornerRadius] / 3.0;
}

@end
