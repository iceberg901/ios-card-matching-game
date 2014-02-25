//
//  SetCard.h
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/19/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "Card.h"

// the different colors a set card can have
typedef NS_ENUM(NSInteger, SetCardColor) {
    SetCardColorRed,
    SetCardColorGreen,
    SetCardColorPurple,

    SetCardColorAllColors //placeholder for terminating an iteration of all values
};

// the different shadings a set card can have
typedef NS_ENUM(NSInteger, SetCardShading) {
    SetCardShadingSolid,
    SetCardShadingStriped,
    SetCardShadingOpen,

    SetCardShadingAllShadings //placeholder for terminating an iteration of all values
};

@interface SetCard : Card
@property(strong, nonatomic) NSString *shape;
@property(nonatomic) NSUInteger count;
@property(nonatomic) SetCardColor color;
@property(nonatomic) SetCardShading shading;

+ (NSArray *)validShapes;
+ (NSUInteger)maxCount;
@end
