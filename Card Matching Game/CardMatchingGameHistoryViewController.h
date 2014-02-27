//
//  CardMatchingGameHistoryViewController.h
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/24/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"

@class CardMatchingGameHistoryItemStatusMessageGenerator;

@interface CardMatchingGameHistoryViewController : UIViewController
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) CardMatchingGameHistoryItemStatusMessageGenerator *messageGenerator;
@end
