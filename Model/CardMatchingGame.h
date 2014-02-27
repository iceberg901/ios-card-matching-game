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
#import "CardMatchingGameHistoryItem.h"

@interface CardMatchingGame : NSObject

//designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (NSUInteger)numCardsOnTable;
- (Card *)cardAtIndex:(NSUInteger)index;
- (CardMatchingGameHistoryItem *)getLastResult;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) NSUInteger cardsToMatch;
@property (nonatomic, strong, readonly) NSArray *history;

@end
