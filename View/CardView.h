//
//  CardView.h
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/26/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "Card.h"

@interface CardView : UIControl
- (void)setup;
- (void)drawCardBackground;
- (CGFloat)cornerScaleFactor;
- (CGFloat)cornerOffset;
@end;