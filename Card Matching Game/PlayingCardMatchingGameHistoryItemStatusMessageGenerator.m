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
+ (instancetype)sharedInstance
{
    static PlayingCardMatchingGameHistoryItemStatusMessageGenerator *generator;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        generator = [[PlayingCardMatchingGameHistoryItemStatusMessageGenerator alloc] init];
    });

    return generator;
}

- (NSAttributedString *)statusMessageForChosenCards:(NSArray *)cards
{
    NSString *message = @"";

    for (Card *card in cards) {
        message = [message stringByAppendingString:card.contents];
    }

    return [[NSAttributedString alloc] initWithString:message];
}

@end
