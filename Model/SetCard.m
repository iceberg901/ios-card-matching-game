//
//  SetCard.m
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/19/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

@synthesize shape = _shape;

// setters and getters
- (void)setShape:(NSString *)shape
{
    if ([[SetCard validShapes] containsObject:shape]) {
        _shape = shape;
    }
}

- (NSString *)getShape
{
    return _shape ? _shape : @"?";
}

static const uint MAX_COUNT = 3;

- (void)setCount:(NSUInteger)count
{
    if (count <= MAX_COUNT) {
        _count = count;
    }
}

// Class methods
+ (NSArray *)validShapes
{
    return @[@"▲", @"●", @"■"];
}


+ (NSUInteger)maxCount
{
    return MAX_COUNT;
}

// Superclass Overrides
- (NSString *)contents
{
    return nil;
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;

    // have to compare this card with otherCards,
    // AND otherCards with EACH OTHER, so this is
    // a good old fashioned pick-2 combination problem
    // therefore put all the cards in an array together
    NSArray *cards = [otherCards arrayByAddingObject:self];

    uint shapeMatches = 0;
    uint countMatches = 0;
    uint colorMatches = 0;
    uint shadingMatches = 0;

    for (int i = 0; i < cards.count; i++) {
        for (int j = i + 1; j < cards.count; j++) {
            SetCard *card = cards[i];
            SetCard *otherCard = cards[j];
            if ([otherCard.shape isEqualToString:card.shape]) {
                shapeMatches++;
            }
            if (otherCard.count == card.count) {
                countMatches++;
            }
            if (otherCard.color == card.color) {
                colorMatches++;
            }
            if (otherCard.shading == card.shading) {
                shadingMatches++;
            }
        }
    }

    BOOL shapeSet = (!shapeMatches || shapeMatches == MAX_COUNT);
    BOOL countSet = (!countMatches || countMatches == MAX_COUNT);
    BOOL colorSet = (!colorMatches || colorMatches == MAX_COUNT);
    BOOL shadingSet = (!shadingMatches || shadingMatches == MAX_COUNT);

    if (shapeSet && countSet && colorSet && shadingSet) {
        score = 4;
    }

    return score;
}


@end