//
//  SetCardView.h
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/26/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "CardView.h"
#import "SetCard.h"

@interface SetCardView : CardView
@property (nonatomic) SetCardShape shape;
@property (nonatomic) NSUInteger count;
@property (nonatomic) SetCardColor color;
@property (nonatomic) SetCardShading shading;
@property (nonatomic) BOOL disabled;
@end
