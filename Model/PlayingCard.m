//
//  PlayingCard.m
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/13/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    return@[@"♠️",@"♥️",@"♣️",@"♦️"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSUInteger)maxRank { return [[PlayingCard rankStrings] count] - 1; }

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    // have to compare this card with otherCards,
    // AND otherCards with EACH OTHER, so this is
    // a good old fashioned pick-2 combination problem
    // therefore put all the cards in an array together
    NSArray *cards = [otherCards arrayByAddingObject:self];

    for (int i = 0; i < cards.count; i++) {
        for (int j = i + 1; j < cards.count; j++) {
            PlayingCard *card = cards[i];
            PlayingCard *otherCard = cards[j];
            if (otherCard.rank == card.rank) {
                score += 4;
            } else if ([otherCard.suit isEqualToString:card.suit]) {
                score += 1;
            }
        }
    }
    
    return score;
}

@end
