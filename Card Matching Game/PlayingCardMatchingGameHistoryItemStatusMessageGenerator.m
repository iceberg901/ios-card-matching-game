//
//  PlayingCardMatchingGameHistoryItemStatusMessageGenerator.m
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/24/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "PlayingCardMatchingGameHistoryItemStatusMessageGenerator.h"
#import "Card.h"

@implementation PlayingCardMatchingGameHistoryItemStatusMessageGenerator
+ (NSAttributedString *)statusMessageForChosenCards:(NSArray *)cards
{
    NSString *message = @"";

    for (Card *card in cards) {
        message = [message stringByAppendingString:card.contents];
    }

    return [[NSAttributedString alloc] initWithString:message];
}

@end
