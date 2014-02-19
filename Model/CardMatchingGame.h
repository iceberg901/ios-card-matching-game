//
//  CardMatchingGame.h
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/14/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

typedef NS_ENUM(NSInteger, CardMatchingGameResult) {
    CardMatchingGameResultOther,
    CardMatchingGameResultNoMatch,
    CardMatchingGameResultMatch
};

@interface CardMatchingGame : NSObject

//designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (NSArray *)getLastConsideredCards;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) NSUInteger cardsToMatch;
@property (nonatomic, readonly) NSInteger lastScoreDelta;
@property (nonatomic,readonly) CardMatchingGameResult lastResult;
@end
