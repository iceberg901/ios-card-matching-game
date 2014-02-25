//
//  CardMatchingGameHistoryItem.h
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/21/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CardMatchingGameResult) {
    CardMatchingGameResultChoose,
    CardMatchingGameResultUnchoose,
    CardMatchingGameResultNoMatch,
    CardMatchingGameResultMatch
};

@interface CardMatchingGameHistoryItem : NSObject
@property (nonatomic, strong) NSArray *cardsConsidered;
@property (nonatomic) NSInteger scoreDelta;
@property (nonatomic) CardMatchingGameResult result;
@end
