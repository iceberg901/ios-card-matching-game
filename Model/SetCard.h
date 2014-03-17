//
//  SetCard.h
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/19/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "Card.h"

// the different shapes a set card can have
typedef NS_ENUM(NSInteger, SetCardShape) {
    SetCardShapeDiamond,
    SetCardShapeSquiggle,
    SetCardShapeOval,

    SetCardShapeLast //placeholder for terminating an iteration of all values
};

// the different colors a set card can have
typedef NS_ENUM(NSInteger, SetCardColor) {
    SetCardColorRed,
    SetCardColorGreen,
    SetCardColorPurple,

    SetCardColorLast //placeholder for terminating an iteration of all values
};

// the different shadings a set card can have
typedef NS_ENUM(NSInteger, SetCardShading) {
    SetCardShadingSolid,
    SetCardShadingStriped,
    SetCardShadingOpen,

    SetCardShadingLast //placeholder for terminating an iteration of all values
};

@interface SetCard : Card
@property(nonatomic) SetCardShape shape;
@property(nonatomic) NSUInteger count;
@property(nonatomic) SetCardColor color;
@property(nonatomic) SetCardShading shading;

+ (NSUInteger)maxCount;
@end
