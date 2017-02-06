/******************************************************************************
 *
 * UIView+Constraints.m
 *
 ******************************************************************************/

#import "UIView+Constraints.h"

@implementation UIView (Constraints)

- (void)addSubviewToView:(UIView *)containerView withTopConstraint:(NSNumber *)topConstraint bottomConstraint:(NSNumber *)bottomConstraint leadingConstraint:(NSNumber *)leadingConstraint trailingConstraint:(NSNumber *)trailingConstraint {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [containerView addSubview:self];
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-leadingConstraint-[self]-trailingConstraint-|" options:0 metrics:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:leadingConstraint, trailingConstraint, nil] forKeys:[NSArray arrayWithObjects:@"leadingConstraint", @"trailingConstraint", nil]] views:NSDictionaryOfVariableBindings(self)];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topConstraint-[self]-bottomConstraint-|" options:0 metrics:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:topConstraint, bottomConstraint, nil] forKeys:[NSArray arrayWithObjects:@"topConstraint", @"bottomConstraint", nil]] views:NSDictionaryOfVariableBindings(self)];
    [containerView addConstraints:horizontalConstraints];
    [containerView addConstraints:verticalConstraints];
    [containerView layoutIfNeeded];
}

- (void)addSubviewToCenterOfView:(UIView *)containerView {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [containerView addSubview:self];
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:containerView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0];
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:containerView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.0
                                                                          constant:0];
    [containerView addConstraint:centerXConstraint];
    [containerView addConstraint:centerYConstraint];
    [containerView layoutIfNeeded];
}


- (void)addBottomBorderOfColor:(UIColor *)color width:(CGFloat)width {
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - width, self.frame.size.width, width);
    bottomBorder.backgroundColor = color.CGColor;
    [self.layer addSublayer:bottomBorder];
}

- (UIResponder *)firstResponder
{
    return firstResponderFromView([UIApplication sharedApplication].keyWindow);
}

UIResponder *firstResponderFromResponderChain (UIResponder *responder)
{
    while ((responder = [responder nextResponder]))
    {
        if ([responder isKindOfClass:[UIView class]])
            // don't check UIViews, as firstResponderFromView() does all that
            break;
        
        if ([responder isFirstResponder])
            return responder;
    }
    
    return nil;
}

UIResponder *firstResponderFromView (UIView *view)
{
    if ([view isFirstResponder])
        return view;
    
    UIResponder *responder = nil;
    if ((responder = firstResponderFromResponderChain(view)))
        return responder;
    
    NSArray *subviews = view.subviews;
    for (UIView *subview in subviews)
    {
        if ((responder = firstResponderFromView(subview)))
            break;
    }
    
    return responder;
}

- (NSLayoutConstraint *)myConstraintWithAttribute:(NSLayoutAttribute)attribute
{
    /* Find constraint with attribute in my constraints */
    __block NSLayoutConstraint *resultConstraint;
    [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop)
     {
         //  DebugLog(@"constraint %@", constraint);
         if ([NSStringFromClass([NSLayoutConstraint class]) isEqualToString:NSStringFromClass([constraint class])])
         {
             if (constraint.firstAttribute == attribute || constraint.secondAttribute == attribute)
             {
                 resultConstraint = constraint;
                 *stop = YES;
             }
         }
     }];

    return resultConstraint;
}


- (NSLayoutConstraint *)superviewConstraintWithAttribute:(NSLayoutAttribute)attribute
{
    /* Find constraint with attribute in my superview's constraints */
    __block NSLayoutConstraint *resultConstraint;
    [self.superview.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop)
     {
         if (constraint.firstItem == self && constraint.firstAttribute == attribute)
             //|| (constraint.secondItem == self && constraint.secondAttribute == attribute))
         {
             resultConstraint = constraint;
             *stop = YES;
         }
     }];

    return resultConstraint;
}


- (NSLayoutConstraint *)constraintWithAttribute:(NSLayoutAttribute)attribute
{
    /* Find constraint with attribute in my constraints */
    NSLayoutConstraint *resultConstraint = [self myConstraintWithAttribute:attribute];

    /* Find constraint with attribute in my superview's constraints */
    if (!resultConstraint)
    {
        resultConstraint = [self superviewConstraintWithAttribute:attribute];
    }
    return resultConstraint;
}


- (BOOL)removeConstraintWithAttribute:(NSLayoutAttribute)attribute
{
    NSLayoutConstraint *constraint = [self superviewConstraintWithAttribute:attribute];
    if (constraint)
    {
        [self.superview removeConstraint:constraint];
        return YES;
    }
    constraint = [self myConstraintWithAttribute:attribute];
    if (constraint)
    {
        [self removeConstraint:constraint];
        return YES;
    }
    return NO;
}




//------------------------------------------------------------------------------
// MARK: - Remove Constraints
//------------------------------------------------------------------------------


- (void)removeMyConstraints
{
    /* Remove all my constraitns from superview */
    [self.superview removeConstraints:[self mySuperviewConstraints]];

    /* Remove my constraitns */

    [self removeConstraints:self.constraints];
}


- (NSArray *)mySuperviewConstraints
{
    NSMutableArray *mySuperviewConstraints = [NSMutableArray array];
    [self.superview.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop)
     {
         if (constraint.firstItem == self || constraint.secondItem == self)
         {
             [mySuperviewConstraints addObject:constraint];
         }
     }];
    return mySuperviewConstraints;
}


- (void)removeMyConstraintsButKeepMySubviewConstraints
{
    /* Remove all my constraitns from superview */
    [self.superview removeConstraints:[self mySuperviewConstraints]];

    /* Remove my constraitns */

    [self removeConstraints:[self myConstraints]];
}


- (NSArray *)myConstraints
{
    NSMutableArray *myConstraints = [NSMutableArray array];
    [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop)
     {
         if (constraint.firstItem == self && constraint.secondItem == nil)
         {
             [myConstraints addObject:constraint];
         }
     }];
    return myConstraints;
}




//------------------------------------------------------------------------------
// MARK: - Size Constraints
//------------------------------------------------------------------------------


- (void)addWidthConstraint:(CGFloat)width
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:0
                                                                 multiplier:1
                                                                   constant:width];
    [self addConstraint:constraint];
}

- (void)addWidthConstraintFromLabel:(UILabel *)label
                         withOffset:(CGFloat)offset
{
    return [self addWidthConstraint:[label.text sizeWithAttributes:@{NSFontAttributeName : label.font}].width + offset];
}

- (void)addHeightConstraint:(CGFloat)height
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:0
                                                                 multiplier:1
                                                                   constant:height];
    [self addConstraint:constraint];
}

- (void)addMaximumHeightConstraint:(CGFloat)maxHeight
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                                                     toItem:nil
                                                                  attribute:0
                                                                 multiplier:1
                                                                   constant:maxHeight];
    [self addConstraint:constraint];

}


- (void)addWidthConstraintFromImage:(UIImage *)image
{
    [self addWidthConstraint:image.size.width];
}


- (void)addHeightConstraintFromImage:(UIImage *)image
{
    [self addHeightConstraint:image.size.height];
}




//------------------------------------------------------------------------------
// MARK: - Center Contraints
//------------------------------------------------------------------------------


- (void)addCenterConstraint:(UIView *)view
            centerDirection:(NSLayoutAttribute)centerDirection
                     offset:(CGFloat)offset
{
    UIView *viewItem = (view) ? view : self.superview;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:centerDirection
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:viewItem
                                                                  attribute:centerDirection
                                                                 multiplier:1
                                                                   constant:offset];
    [self.superview addConstraint:constraint];
}


- (void)addCenterXConstraint:(UIView *)view
{
    [self addCenterConstraint:view
              centerDirection:NSLayoutAttributeCenterX
                       offset:0];
}


- (void)addCenterYConstraint:(UIView *)view
{
    [self addCenterConstraint:view
              centerDirection:NSLayoutAttributeCenterY
                       offset:0];
}


- (void)addCenterXConstraint:(UIView *)view
                      offset:(CGFloat)offset
{
    [self addCenterConstraint:view
              centerDirection:NSLayoutAttributeCenterX
                       offset:offset];
}


- (void)addCenterYConstraint:(UIView *)view
                      offset:(CGFloat)offset
{
    [self addCenterConstraint:view
              centerDirection:NSLayoutAttributeCenterY
                       offset:offset];
}



-(void)addTopLayoutGuideConstraint:(UILayoutGuide *)layoutGuide offset:(CGFloat)offset
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:layoutGuide
                                                                  attribute:NSLayoutAttributeTop multiplier:0.0
                                                                   constant:offset];
    [self.superview addConstraint:constraint];
}

-(void)addBottomLayoutGuideConstraint:(UILayoutGuide *)layoutGuide offset:(CGFloat)offset
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:layoutGuide
                                                                  attribute:NSLayoutAttributeBottom multiplier:0.0
                                                                   constant:offset];
    [self.superview addConstraint:constraint];
}

//------------------------------------------------------------------------------
// MARK: - Edge Attach Constraints
//------------------------------------------------------------------------------


- (void)addEdgeAttachConstraint:(UIView *)view
                       viewEdge:(NSLayoutAttribute)viewLayoutAttribute
                         offset:(CGFloat)offset
                           edge:(NSLayoutAttribute)layoutAttribute
{
    UIView *viewItem = (view) ? view : self.superview;

    /* Reverse offset for right side and bottom */
    CGFloat fixedOffset = offset;
    if (layoutAttribute == NSLayoutAttributeRight
        || layoutAttribute == NSLayoutAttributeBottom
        || layoutAttribute == NSLayoutAttributeTrailing)
    {
        fixedOffset = -offset;
    }

    /* Add contraint */
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:layoutAttribute
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:viewItem
                                                                  attribute:viewLayoutAttribute
                                                                 multiplier:1
                                                                   constant:fixedOffset];
    [self.superview addConstraint:constraint];
}



- (void)addLeadingEdgeAttachConstraint:(UIView *)view
                                offset:(CGFloat)offset
{
    [self addEdgeAttachConstraint:view
                         viewEdge:NSLayoutAttributeLeading
                           offset:offset
                             edge:NSLayoutAttributeLeading];
}

-(void)addTrailingEdgeAttachConstraint:(UIView *)view offset:(CGFloat)offset
{
    [self addEdgeAttachConstraint:view
                         viewEdge:NSLayoutAttributeTrailing
                           offset:offset
                             edge:NSLayoutAttributeTrailing];
}

- (void)addLeftEdgeAttachConstraint:(UIView *)view
                             offset:(CGFloat)offset
{
    [self addEdgeAttachConstraint:view
                         viewEdge:NSLayoutAttributeLeft
                           offset:offset
                             edge:NSLayoutAttributeLeft];
}


- (void)addRightEdgeAttachConstraint:(UIView *)view
                              offset:(CGFloat)offset
{
    [self addEdgeAttachConstraint:view
                         viewEdge:NSLayoutAttributeRight
                           offset:offset
                             edge:NSLayoutAttributeRight];
}


- (void)addTopEdgeAttachConstraint:(UIView *)view
                            offset:(CGFloat)offset
{
    [self addEdgeAttachConstraint:view
                         viewEdge:NSLayoutAttributeTop
                           offset:offset
                             edge:NSLayoutAttributeTop];
}


- (void)addBottomEdgeAttachConstraint:(UIView *)view
                               offset:(CGFloat)offset
{
    [self addEdgeAttachConstraint:view
                         viewEdge:NSLayoutAttributeBottom
                           offset:offset
                             edge:NSLayoutAttributeBottom];
}


-(void)addLeadingEdgeAttachConstraint:(UIView *)view
{
    [self addLeadingEdgeAttachConstraint:view
                                  offset:0];
}

-(void)addTrailingEdgeAttachConstraint:(UIView *)view
{
    [self addTrailingEdgeAttachConstraint:view
                                   offset:0];
}

- (void)addLeftEdgeAttachConstraint:(UIView *)view
{
    [self addLeftEdgeAttachConstraint:view
                               offset:0];
}


- (void)addRightEdgeAttachConstraint:(UIView *)view
{
    [self addRightEdgeAttachConstraint:view
                                offset:0];
}


- (void)addTopEdgeAttachConstraint:(UIView *)view
{
    [self addTopEdgeAttachConstraint:view
                              offset:0];
}


- (void)addBottomEdgeAttachConstraint:(UIView *)view
{
    [self addBottomEdgeAttachConstraint:view
                                 offset:0];
}




- (void)addEdgeAttachConstraints:(UIView *)view
                      leftOffset:(CGFloat)leftOffset
                     rightOffset:(CGFloat)rightOffset
                       topOffset:(CGFloat)topOffset
                    bottomOffset:(CGFloat)bottomOffset
{
    [self addLeftEdgeAttachConstraint:view
                               offset:leftOffset];
    [self addRightEdgeAttachConstraint:view
                                offset:rightOffset];
    [self addTopEdgeAttachConstraint:view
                              offset:topOffset];
    [self addBottomEdgeAttachConstraint:view
                                 offset:bottomOffset];
}


- (void)addEdgeAttachConstraints:(UIView *)view
{
    [self addLeftEdgeAttachConstraint:view];
    [self addRightEdgeAttachConstraint:view];
    [self addTopEdgeAttachConstraint:view];
    [self addBottomEdgeAttachConstraint:view];
}




//------------------------------------------------------------------------------
// MARK: - Edge Constraint To Different Edge
//------------------------------------------------------------------------------


- (void)addLeftEdgeAttachConstraint:(UIView *)view
                           viewEdge:(NSLayoutAttribute)viewLayoutAttribute
                             offset:(CGFloat)offset
{
    [self addEdgeAttachConstraint:view
                         viewEdge:viewLayoutAttribute
                           offset:offset
                             edge:NSLayoutAttributeLeft];
}


- (void)addRightEdgeAttachConstraint:(UIView *)view
                            viewEdge:(NSLayoutAttribute)viewLayoutAttribute
                              offset:(CGFloat)offset
{
    [self addEdgeAttachConstraint:view
                         viewEdge:viewLayoutAttribute
                           offset:offset
                             edge:NSLayoutAttributeRight];
}


- (void)addTopEdgeAttachConstraint:(UIView *)view
                          viewEdge:(NSLayoutAttribute)viewLayoutAttribute
                            offset:(CGFloat)offset
{
    [self addEdgeAttachConstraint:view
                         viewEdge:viewLayoutAttribute
                           offset:offset
                             edge:NSLayoutAttributeTop];
}


- (void)addBottomEdgeAttachConstraint:(UIView *)view
                             viewEdge:(NSLayoutAttribute)viewLayoutAttribute
                               offset:(CGFloat)offset
{
    [self addEdgeAttachConstraint:view
                         viewEdge:viewLayoutAttribute
                           offset:offset
                             edge:NSLayoutAttributeBottom];
}






//------------------------------------------------------------------------------
// MARK: - Size Attach Constaints
//------------------------------------------------------------------------------


- (void)addSizeAndSuperviewAttachConstraints:(NSString *)sizeConstraint
                                 firstOffset:(CGFloat)firstOffset
                                secondOffset:(CGFloat)secondOffset
                                   direction:(NSString *)direction
{
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(self);
    NSString *visualFormatString;

    if (sizeConstraint)
    {
        visualFormatString = [NSString stringWithFormat:@"%@:|-%f-[self(%@)]-%f-|", direction, firstOffset, sizeConstraint, secondOffset];
    }
    else
    {
        visualFormatString = [NSString stringWithFormat:@"%@:|-%f-[self]-%f-|", direction, firstOffset, secondOffset];
    }

    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormatString
                                                                   options:0
                                                                   metrics:0
                                                                     views:viewDict];
    [self.superview addConstraints:constraints];
}


- (void)addWidthAndSuperviewAttachConstraints:(NSString *)widthConstraint
                                   leftOffset:(CGFloat)leftOffset
                                  rightOffset:(CGFloat)rightOffset
{
    [self addSizeAndSuperviewAttachConstraints:widthConstraint
                                   firstOffset:leftOffset
                                  secondOffset:rightOffset
                                     direction:@"H"];
}


- (void)addHeightAndSuperviewAttachConstraints:(NSString *)heightConstraint
                                     topOffset:(CGFloat)topOffset
                                  bottomOffset:(CGFloat)bottomOffset
{
    [self addSizeAndSuperviewAttachConstraints:heightConstraint
                                   firstOffset:topOffset
                                  secondOffset:bottomOffset
                                     direction:@"V"];
}




//------------------------------------------------------------------------------
// MARK: - Row & Column Layout Constraints
//------------------------------------------------------------------------------


- (void)addLayoutConstraintsForMySubviews:(NSArray *)views
                              firstOffset:(CGFloat)firstOffset
                             secondOffset:(CGFloat)secondOffset
                            betweenOffset:(NSString *)betweenOffset
                                direction:(NSString *)direction
                                equalSize:(BOOL)equalSize
{
    /* Create viewDict and visualFormatString */
    NSMutableString *visualFormatString = [[NSMutableString alloc] initWithFormat:@"%@:|-%.0f-", direction, firstOffset];
    NSMutableDictionary *viewDict = [[NSMutableDictionary alloc] init];
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop)
     {
         NSString *viewName = [NSString stringWithFormat:@"view%lu", (unsigned long)idx];
         [viewDict setObject:view
                      forKey:viewName];

         if (idx < [views count] - 1)
         {
             /* Add each view */
             if (betweenOffset) /* Add offset between view */
             {
                 /* Add equal size to prev view for all but index 0 */
                 if (equalSize && idx > 0)
                 {
                     NSString *prevViewName = [NSString stringWithFormat:@"view%tu", idx - 1];
                     [visualFormatString appendFormat:@"[%@(==%@)]-%@-", viewName, prevViewName, betweenOffset];
                 }
                 else
                 {
                     [visualFormatString appendFormat:@"[%@]-%@-", viewName, betweenOffset];
                 }
             }
             else /* No offset between views */
             {
                 /* Add equal size to prev view for all but index 0 */
                 if (equalSize && idx > 0)
                 {
                     NSString *prevViewName = [NSString stringWithFormat:@"view%tu", idx - 1];
                     [visualFormatString appendFormat:@"[%@(==%@)]", viewName, prevViewName];
                 }
                 else
                 {
                     [visualFormatString appendFormat:@"[%@]", viewName];
                 }
             }
         }
         else
         {
             /* Add equal size to prev view for all but index 0 */
             if (equalSize && idx > 0)
             {
                 NSString *prevViewName = [NSString stringWithFormat:@"view%tu", idx - 1];
                 [visualFormatString appendFormat:@"[%@(==%@)]-%.0f-|", viewName, prevViewName, secondOffset];
             }
             else
             {
                 [visualFormatString appendFormat:@"[%@]-%.0f-|", viewName, secondOffset];
             }
         }
     }];

    //    DebugLog(@"viewDict %@", viewDict);
    //    DebugLog(@"visualFormatString %@", visualFormatString);

    /* Add constraints */
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormatString
                                                                   options:0
                                                                   metrics:0
                                                                     views:viewDict];
    [self addConstraints:constraints];
}


- (void)addRowLayoutConstraintsForMySubviews:(NSArray *)subviews
                                  leftOffset:(CGFloat)leftOffset
                                 rightOffset:(CGFloat)rightOffset
                               betweenOffset:(NSString *)betweenOffset
                                  equalWidth:(BOOL)equalWidth
{
    [self addLayoutConstraintsForMySubviews:subviews
                                firstOffset:leftOffset
                               secondOffset:rightOffset
                              betweenOffset:betweenOffset
                                  direction:@"H"
                                  equalSize:equalWidth];
}


- (void)addColumnLayoutConstraintsForMySubviews:(NSArray *)subviews
                                      topOffset:(CGFloat)topOffset
                                   bottomOffset:(CGFloat)bottomOffset
                                  betweenOffset:(NSString *)betweenOffset
                                    equalHeight:(BOOL)equalHeight
{
    [self addLayoutConstraintsForMySubviews:subviews
                                firstOffset:topOffset
                               secondOffset:bottomOffset
                              betweenOffset:betweenOffset
                                  direction:@"V"
                                  equalSize:equalHeight];
}

@end
