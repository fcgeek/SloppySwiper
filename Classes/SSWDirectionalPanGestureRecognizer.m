//
//  SSWDirectionalPanGestureRecognizer.m
//
//  Created by Arkadiusz Holko http://holko.pl on 01-06-14.
//

#import "SSWDirectionalPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import <UIKit/UIScreen.h>

@interface SSWDirectionalPanGestureRecognizer()
@end

@implementation SSWDirectionalPanGestureRecognizer

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];

    UITouch* touch = [touches anyObject];
    CGPoint beginPoint = [touch locationInView:self.view];
    if (beginPoint.x > UIScreen.mainScreen.bounds.size.width/6) {
        return;
    }
    if (self.state == UIGestureRecognizerStateFailed) return;

    CGPoint velocity = [self velocityInView:self.view];
    // check direction only on the first move
    if (!self.dragging && !CGPointEqualToPoint(velocity, CGPointZero)) {
        NSDictionary *velocities = @{
                                     @(SSWPanDirectionRight) : @(velocity.x),
                                     @(SSWPanDirectionDown) : @(velocity.y),
                                     @(SSWPanDirectionLeft) : @(-velocity.x),
                                     @(SSWPanDirectionUp) : @(-velocity.y)
                                     };
        NSArray *keysSorted = [velocities keysSortedByValueUsingSelector:@selector(compare:)];

        // Fails the gesture if the highest velocity isn't in the same direction as `direction` property.
        if ([[keysSorted lastObject] integerValue] != self.direction) {
            self.state = UIGestureRecognizerStateFailed;
        }

        self.dragging = YES;
    }
}

- (void)reset
{
    [super reset];

    self.dragging = NO;
}

@end
