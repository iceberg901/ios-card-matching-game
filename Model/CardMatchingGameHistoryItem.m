//
//  CardMatchingGameHistoryItem.m
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/21/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "CardMatchingGameHistoryItem.h"

@implementation CardMatchingGameHistoryItem
- (NSArray *)getCardsConsidered
{
    if (!_cardsConsidered) {
        _cardsConsidered = [[NSArray alloc] init];
    }

    return _cardsConsidered;
}
@end