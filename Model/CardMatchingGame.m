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
@property (nonatomic, readwrite) NSInteger lastScoreDelta;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) NSMutableArray *lastConsideredCards;
@property (nonatomic, readwrite) CardMatchingGameResult lastResult;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)lastConsideredCards
{
    if (!_lastConsideredCards) _lastConsideredCards = [[NSMutableArray alloc] init];
    return _lastConsideredCards;
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

- (NSArray *)getLastConsideredCards
{
    return self.lastConsideredCards;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

// This method will choose or unchoose a card, then check
// the chosen cards to see if there are any matches. The score
// will then be updated accordingly.  So that clients can have more
// information about what took place during the card choice and
// subsequent updating of game state, we also update lastConsideredCards
// and lastResult to keep track of what cards were considered and what
// was the resulting impact on the game, respectively.
- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    if (!card.isMatched) {
        [self initLastChoiceInfo];
        if (card.isChosen) {
            card.chosen = NO;
            [self.lastConsideredCards removeObject:card];
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
                            self.lastScoreDelta = matchScore * MATCH_BONUS;
                            self.score += self.lastScoreDelta;

                            card.matched = YES;
                            for (Card *matchedCard in otherCards) {
                                matchedCard.matched = YES;
                            }
                            self.lastResult = CardMatchingGameResultMatch;
                        } else {
                            self.lastScoreDelta = -MISMATCH_PENALTY;
                            self.score += self.lastScoreDelta;
                            for (Card *matchedCard in otherCards) {
                                matchedCard.chosen = NO;
                            }
                            self.lastResult = CardMatchingGameResultNoMatch;
                        }
                        break;
                    }
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
            [self.lastConsideredCards addObject:card];
        }
    }
}

- (void)initLastChoiceInfo
{
    self.lastScoreDelta = 0;
    self.lastResult = CardMatchingGameResultOther;
    // empty the set of considered cards and build it up again
    // out of all cards that will be considered in this turn, so that
    // even after we've modified the chosen settings of some cards,
    // a client can still find out which cards were considered
    [self.lastConsideredCards removeAllObjects];
    for (Card *card in self.cards) {
        if (card.isChosen && !card.isMatched) {
            [self.lastConsideredCards addObject:card];
        }
    }
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