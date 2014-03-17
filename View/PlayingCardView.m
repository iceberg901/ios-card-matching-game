//
//  PlayingCardView.m
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/26/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "PlayingCardView.h"

@implementation PlayingCardView

- (void)setup
{
    [super setup];
}

- (void)setRank:(NSUInteger)rank
{
    _rank = rank;
    [self setNeedsDisplay];
}

- (void)setSuit:(NSString *)suit
{
    _suit = suit;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp
{

    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (void)drawCornerContents
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;

    UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];

    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", [self rankAsString], self.suit] attributes:@{ NSFontAttributeName : cornerFont, NSParagraphStyleAttributeName : paragraphStyle}];

    CGRect textBounds;
    textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    textBounds.size = cornerText.size;

    [cornerText drawInRect:textBounds];
}

- (NSString *)rankAsString
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"][self.rank];
}

// Implement abstract methods
- (void)drawCardContents
{
    if (self.faceUp) {
        [self drawCornerContents];
    }
}


//Overrides
- (void)drawCardBackground
{
    if (self.faceUp) {
        [super drawCardBackground];
    } else {
        [[UIImage imageNamed:@"cardBack"] drawInRect:self.bounds];
    }
}

@end
