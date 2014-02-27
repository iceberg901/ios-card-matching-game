//
//  SetCardMatchingGameHistoryItemStatusMessageGenerator.h
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/24/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "CardMatchingGameHistoryItemStatusMessageGenerator.h"
#import "SetCard.h"

@interface SetCardMatchingGameHistoryItemStatusMessageGenerator : CardMatchingGameHistoryItemStatusMessageGenerator
- (NSAttributedString *)displayStringForCard:(SetCard *)card;
@end
