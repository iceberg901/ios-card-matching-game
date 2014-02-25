//
//  CardMatchingGameHistoryItemStatusMessageGenerator.m
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/24/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "CardMatchingGameHistoryItemStatusMessageGenerator.h"
#import "SetCard.h"

@implementation CardMatchingGameHistoryItemStatusMessageGenerator
+ (NSAttributedString *)statusMessageForHistoryItem:(CardMatchingGameHistoryItem *)item
{

    NSAttributedString *cardMessage;

    switch (item.result) {
        case CardMatchingGameResultMatch:
        case CardMatchingGameResultNoMatch: {
            NSMutableAttributedString *mutableCardMessage = [[NSMutableAttributedString alloc] initWithAttributedString:[self statusMessageForChosenCards:item.cardsConsidered]];
            NSString *scoreMessage = [@" " stringByAppendingString:[self statusMesageForScoreDelta:item.scoreDelta]];
            [mutableCardMessage appendAttributedString:[[NSAttributedString alloc] initWithString:scoreMessage]];
            cardMessage = mutableCardMessage;
            break;
        }

        default:
            cardMessage = [self statusMessageForChosenCards:item.cardsConsidered];
    }

    return cardMessage;
}

+ (NSString *)statusMesageForScoreDelta:(NSInteger)delta
{
    if (delta > 0) {
        return [NSString stringWithFormat:@"matched for %d points", delta];
    } else if (delta < 0) {
        return [NSString stringWithFormat:@"don't match! %d point penalty!", -delta];
    } else {
        return @"";
    }
}

// ABSTRACT METHODS
+ (NSAttributedString *)statusMessageForChosenCards:(NSArray *)cards
{
    //SHOULD I ASSERT HERE?
    return nil;
}

@end