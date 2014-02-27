//
//  PlayingCardView.h
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/26/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "CardView.h"

@interface PlayingCardView : CardView
@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;
@end
