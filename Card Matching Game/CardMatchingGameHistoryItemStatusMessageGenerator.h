//
//  CardMatchingGameHistoryItemStatusMessageGenerator.h
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/24/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardMatchingGameHistoryItem.h"

@interface CardMatchingGameHistoryItemStatusMessageGenerator : NSObject
+ (instancetype)sharedInstance;
- (NSAttributedString *)statusMessageForHistoryItem:(CardMatchingGameHistoryItem *)item;
@end
