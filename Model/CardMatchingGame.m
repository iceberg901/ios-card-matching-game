//
//  CardMatchingGame.m
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/14/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong, readwrite) NSArray *history;
@property (nonatomic, strong) NSMutableArray *cards;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSArray *)history
{
    if (!_history) {
        _history = [[NSArray alloc] init];
    }
    return _history;
}

static const unsigned int DEFAULT_CARDS_TO_MATCH = 2;

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
        self.cardsToMatch = DEFAULT_CARDS_TO_MATCH;
    }
    
    return self;
}

- (CardMatchingGameHistoryItem *)getLastResult;
{
    return [self.history lastObject];
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

// This method will choose or unchoose a card, then check
// the chosen cards to see if there are any matches. The score
// will then be updated accordingly.  If the card choice results in considering
// cards for a match, store a CardMatchingGameHistoryItem with information about
// what cards were considered, what the result was, and what was the impact on the score.
- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    if (!card.isMatched) {
        CardMatchingGameHistoryItem *historyItem = [[CardMatchingGameHistoryItem alloc] init];
        NSMutableArray *cardsConsidered = [NSMutableArray arrayWithArray:[self getChosenUnmatchedCards]];
        if (card.isChosen) {
            card.chosen = NO;
            [cardsConsidered removeObject:card];
            historyItem.result = CardMatchingGameResultUnchoose;
        } else {
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            // collect other chosen cards
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [otherCards addObject:otherCard];
                    if ([otherCards count] == self.cardsToMatch - 1) {
                        // if we've chosen the number of cards that we need to check for a match,
                        // check for a match and finish
                        int matchScore = [card match:otherCards];
                        if (matchScore > 0) {
                            historyItem.scoreDelta = matchScore * MATCH_BONUS;
                            self.score += historyItem.scoreDelta;

                            card.matched = YES;
                            for (Card *matchedCard in otherCards) {
                                matchedCard.matched = YES;
                            }
                            historyItem.result = CardMatchingGameResultMatch;
                        } else {
                            historyItem.scoreDelta = -MISMATCH_PENALTY;
                            self.score += historyItem.scoreDelta;
                            for (Card *matchedCard in otherCards) {
                                matchedCard.chosen = NO;
                            }
                            historyItem.result = CardMatchingGameResultNoMatch;
                        }
                        break;
                    }
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
            [cardsConsidered addObject:card];
        }
        historyItem.cardsConsidered = cardsConsidered;
        self.history = [self.history arrayByAddingObject:historyItem];
    }
}

- (NSArray *)getChosenUnmatchedCards
{
    NSMutableArray *chosenUnmatchedCards = [[NSMutableArray alloc] init];

    for (Card *card in self.cards) {
        if (card.isChosen && !card.isMatched) {
            [chosenUnmatchedCards addObject:card];
        }
    }

    return chosenUnmatchedCards;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    Card *card = nil;
    
    if (index < [self.cards count]) {
        card = self.cards[index];
    }
    
    return card;
}

- (void)setCardsToMatch:(NSUInteger) cardsToMatch
{
    if (cardsToMatch > 1) {
        _cardsToMatch = cardsToMatch;
    }
}

@end