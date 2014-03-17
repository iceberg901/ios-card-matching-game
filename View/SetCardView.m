//
//  SetCardView.m
//  Card Matching Game
//
//  Created by Joshua Samberg on 2/26/14.
//  Copyright (c) 2014 Joshua Samberg. All rights reserved.
//

#import "SetCardView.h"
#import <UIKit/UIKit.h>

@implementation SetCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//setters and getters
- (void)setShape:(SetCardShape)shape
{
    _shape = shape;
    [self setNeedsDisplay];
}

- (void)setCount:(NSUInteger)count
{
    _count = count;
    [self setNeedsDisplay];
}

- (void)setColor:(SetCardColor)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setShading:(SetCardShading)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}


- (void)setDisabled:(BOOL)disabled
{
    _disabled = disabled;
    [self setNeedsDisplay];
}

#define HORIZONTAL_INSET_PCT 0.2
#define VERTICAL_INSET_PCT 0.38

- (void)drawCardContents
{
    self.alpha = (self.disabled) ? 0.9 : 1.0;

    UIColor *fillColor;
    UIColor *strokeColor;
    switch (self.color) {
        case SetCardColorGreen:
            fillColor = strokeColor = [UIColor greenColor];
            break;
        case SetCardColorPurple:
            fillColor = strokeColor = [UIColor purpleColor];
            break;
        case SetCardColorRed:
            fillColor = strokeColor = [UIColor redColor];
            break;
        default:
            break;
    }

    if (self.shading == SetCardShadingStriped) {
        fillColor = [fillColor colorWithAlphaComponent:0.1];
    }

    [fillColor setFill];
    [strokeColor setStroke];

    CGRect pathBoundsAtCenter = CGRectInset(self.bounds, self.bounds.size.width * HORIZONTAL_INSET_PCT, self.bounds.size.height * VERTICAL_INSET_PCT);

    if (self.count == 1 || self.count == 3) {
        [self drawCardCharacterInRect:pathBoundsAtCenter];
    }

    if (self.count == 2 || self.count == 3) {
        CGFloat distanceFromCenter = self.bounds.size.height * (1.0 - VERTICAL_INSET_PCT) / 2.0;
        if (self.count == 2) {
            distanceFromCenter = distanceFromCenter * 0.5;
        }

        CGRect pathBoundsAboveCenter = CGRectOffset(pathBoundsAtCenter, 0.0, -(distanceFromCenter));
        [self drawCardCharacterInRect:pathBoundsAboveCenter];

        CGRect pathBoundsBelowCenter = CGRectOffset(pathBoundsAtCenter, 0.0, distanceFromCenter);
        [self drawCardCharacterInRect:pathBoundsBelowCenter];
    }
}

- (void)drawCardCharacterInRect:(CGRect)rect
{

    UIBezierPath *pathToDraw;

    switch (self.shape) {
        case SetCardShapeOval:
            pathToDraw = [UIBezierPath bezierPathWithOvalInRect:rect];;
            break;

        case SetCardShapeDiamond:
            pathToDraw = [[UIBezierPath alloc] init];
            [pathToDraw moveToPoint:CGPointMake(rect.origin.x, rect.origin.y + (rect.size.height / 2.0))];
            [pathToDraw addLineToPoint:CGPointMake(rect.origin.x + (rect.size.width / 2.0), rect.origin.y + rect.size.height)];
            [pathToDraw addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + (rect.size.height / 2.0))];
            [pathToDraw addLineToPoint:CGPointMake(rect.origin.x + (rect.size.width / 2.0), rect.origin.y)];
            [pathToDraw closePath];
            break;

        case SetCardShapeSquiggle:
            pathToDraw = [[UIBezierPath alloc] init];
            [pathToDraw moveToPoint:CGPointMake(rect.origin.x, rect.origin.y + (rect.size.height))];
            [pathToDraw addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y) controlPoint1:CGPointMake(rect.origin.x + (rect.size.width * 0.25), rect.origin.y) controlPoint2:CGPointMake(rect.origin.x + (rect.size.width * 0.75), rect.origin.y + (rect.size.height * 0.5))];
            [pathToDraw addCurveToPoint:CGPointMake(rect.origin.x, rect.origin.y + (rect.size.height))controlPoint1:CGPointMake(rect.origin.x + (rect.size.width * 0.75),rect.origin.y + rect.size.height) controlPoint2:CGPointMake(rect.origin.x + (rect.size.width * 0.25), rect.origin.y + (rect.size.height * 0.5))];
            [pathToDraw closePath];

        default:
            break;
    }

    switch (self.shading) {
        case SetCardShadingSolid:
            [pathToDraw fill];
            break;

        case SetCardShadingOpen:
            [pathToDraw stroke];
            break;

        case SetCardShadingStriped:
            [pathToDraw fill];
            [pathToDraw stroke];
            
        default:
            break;
    }

}
@end
