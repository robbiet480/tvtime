/******************************************************************************
 *
 * UIView+Constraints.h
 *
 ******************************************************************************/

#import <UIKit/UIKit.h>

@interface UIView (Constraints)

/**
 *  Adds a subview inside a container view
 */
- (void)addSubviewToView:(UIView *)containerView withTopConstraint:(NSNumber *)topConstraint bottomConstraint:(NSNumber *)bottomConstraint leadingConstraint:(NSNumber *)leadingConstraint trailingConstraint:(NSNumber *)trailingConstraint;

/**
 *  Adds bottom border to passed view
 *  @param color Border color
 *  @param width Border width
 */
- (void)addBottomBorderOfColor:(UIColor *)color width:(CGFloat)width;

/**
 *  Adds a view center aligned to container view
 */
- (void)addSubviewToCenterOfView:(UIView *)containerView;

/**
 * Find the view that is currently firstResponder
 */
- (UIResponder *)firstResponder;

//------------------------------------------------------------------------------
// MARK: - Find Constraints

/**
 Return constraint in self.constraint with attribute, if it exists.
 */
- (NSLayoutConstraint *)myConstraintWithAttribute:(NSLayoutAttribute)attribute;

/**
 Return constraint in self.superview.constraint with attribute, if it exists.
 */
- (NSLayoutConstraint *)superviewConstraintWithAttribute:(NSLayoutAttribute)attribute;

/**
 Return constraint in self.constraint and self.superview.constraints with attribute, if it exists.
 */
- (NSLayoutConstraint *)constraintWithAttribute:(NSLayoutAttribute)attribute;

/**
 Removed the constraint from superview or self with attribute
 */
- (BOOL)removeConstraintWithAttribute:(NSLayoutAttribute)attribute;


//------------------------------------------------------------------------------
// MARK: - Remove Constraints

/**
 Call this method if you need to delete all constraints from a view and don't want to remove it from it's superview.
 E.g. needed for animations with constraints
 */
- (void)removeMyConstraints;

/**
 Returns an array of constraints form self.superview.constraints, that are about self
 */
- (NSArray *)mySuperviewConstraints;

/**
 Returns an array of self.constraints which are only about me, not my subviews
 */
- (NSArray *)myConstraints;

/**
 Removes all my constraints, but ensure it keeps my subviews positioned correctly
 */
- (void)removeMyConstraintsButKeepMySubviewConstraints;



//------------------------------------------------------------------------------
// MARK: - Size Constraints

/**
 Add a specific width constraint to myself
 */
- (void)addWidthConstraint:(CGFloat)width;

/**
 Add a width based on the text and font of a label with offset
 */
- (void)addWidthConstraintFromLabel:(UILabel *)label
                         withOffset:(CGFloat)offset;

/**
 Add a specific height constraint to myself
 */
- (void)addHeightConstraint:(CGFloat)height;

/**
 Add a maximum height constraint to myself
 */
- (void)addMaximumHeightConstraint:(CGFloat)maxHeight;

/**
 Add a specific width constraint to myself based on image width
 */
- (void)addWidthConstraintFromImage:(UIImage *)image;


/**
 Add a specific height constraint to myself based on image height
 */
- (void)addHeightConstraintFromImage:(UIImage *)image;


//------------------------------------------------------------------------------
// MARK: - Center Contraints

/**
 Add constraint that aligns self to the x center of view
 */
- (void)addCenterXConstraint:(UIView *)view;

/**
 Add constraint that aligns self to the y center of view
 */
- (void)addCenterYConstraint:(UIView *)view;

/**
 Add constraint that aligns self to the x center of view. Negative offset moves right.
 */
- (void)addCenterXConstraint:(UIView *)view
                      offset:(CGFloat)offset;

/**
 Add constraint that aligns self to the y center of view. Negative offset moves up.
 */
- (void)addCenterYConstraint:(UIView *)view
                      offset:(CGFloat)offset;


//------------------------------------------------------------------------------
// MARK: - Layout Guide Attach Constraints

/**
 Attaches self to top layout guide. If view is nil self.superview is used.
 */
- (void)addTopLayoutGuideConstraint:(UILayoutGuide *)layoutGuide offset:(CGFloat)offset;
-(void)addBottomLayoutGuideConstraint:(UILayoutGuide *)layoutGuide offset:(CGFloat)offset;

//------------------------------------------------------------------------------
// MARK: - Edge Attach Constraints

/**
 Attaches self to views leading edge. If view is nil self.superview is used.
 */
- (void)addLeadingEdgeAttachConstraint:(UIView *)view
                                offset:(CGFloat)offset;

/**
 Attaches self to views left edge with offset. If view is nil self.superview is used.
 */
- (void)addLeftEdgeAttachConstraint:(UIView *)view
                             offset:(CGFloat)offset;

/**
 Attaches self to views right edge with offset. If view is nil self.superview is used.
 */
- (void)addRightEdgeAttachConstraint:(UIView *)view
                              offset:(CGFloat)offset;

/**
 Attaches self to views trailing edge. If view is nil self.superview is used.
 */
- (void)addTrailingEdgeAttachConstraint:(UIView *)view
                                 offset:(CGFloat)offset;

/**
 Attaches self to views top edge with offset. If view is nil self.superview is used.
 */
- (void)addTopEdgeAttachConstraint:(UIView *)view
                            offset:(CGFloat)offset;

/**
 Attaches self to views bottom edge with offset. If view is nil self.superview is used.
 */
- (void)addBottomEdgeAttachConstraint:(UIView *)view
                               offset:(CGFloat)offset;

/**
 Attaches self to views leading edge. If view is nil self.superview is used.
 */
- (void)addLeadingEdgeAttachConstraint:(UIView *)view;

/**
 Attaches self to views left edge. If view is nil self.superview is used.
 */
- (void)addLeftEdgeAttachConstraint:(UIView *)view;

/**
 Attaches self to views right edge. If view is nil self.superview is used.
 */
- (void)addRightEdgeAttachConstraint:(UIView *)view;

/**
 Attaches self to views trailing edge. If view is nil self.superview is used.
 */
- (void)addTrailingEdgeAttachConstraint:(UIView *)view;

/**
 Attaches self to views top edge. If view is nil self.superview is used.
 */
- (void)addTopEdgeAttachConstraint:(UIView *)view;

/**
 Attaches self to views bottom edge. If view is nil self.superview is used.
 */
- (void)addBottomEdgeAttachConstraint:(UIView *)view;


/**
 Attaches self to all edges of view with offset for each edge. If view is nil self.superview is used.
 */
- (void)addEdgeAttachConstraints:(UIView *)view
                      leftOffset:(CGFloat)leftOffset
                     rightOffset:(CGFloat)rightOffset
                       topOffset:(CGFloat)topOffset
                    bottomOffset:(CGFloat)bottomOffset;

/**
 Attaches self to all edges of view. If view is nil self.superview is used.
 */
- (void)addEdgeAttachConstraints:(UIView *)view;



//------------------------------------------------------------------------------
// MARK: - Edge Constraint To Different Edge

/**
 Same as addLeftEdgeAttachConstraint:offset, but you can choose a different super view edge
 */
- (void)addLeftEdgeAttachConstraint:(UIView *)view
                           viewEdge:(NSLayoutAttribute)viewLayoutAttribute
                             offset:(CGFloat)offset;

/**
 Same as addRightEdgeAttachConstraint:offset, but you can choose a different super view edge
 */
- (void)addRightEdgeAttachConstraint:(UIView *)view
                            viewEdge:(NSLayoutAttribute)viewLayoutAttribute
                              offset:(CGFloat)offset;

/**
 Same as addTopEdgeAttachConstraint:offset, but you can choose a different super view edge
 */
- (void)addTopEdgeAttachConstraint:(UIView *)view
                          viewEdge:(NSLayoutAttribute)viewLayoutAttribute
                            offset:(CGFloat)offset;

/**
 Same as addBottomEdgeAttachConstraint:offset, but you can choose a different super view edge
 */
- (void)addBottomEdgeAttachConstraint:(UIView *)view
                             viewEdge:(NSLayoutAttribute)viewLayoutAttribute
                               offset:(CGFloat)offset;



//------------------------------------------------------------------------------
// MARK: - Size Attach Constaints

/**
 Attaches self to superview with left and right offset.
 widthConstraint will be put in between the brackets e.g. can be something like @"20" => view(20)
 */
- (void)addWidthAndSuperviewAttachConstraints:(NSString *)widthConstraint
                                   leftOffset:(CGFloat)leftOffset
                                  rightOffset:(CGFloat)rightOffset;

/**
 Attaches self to superview with top and bottom offset.
 heightConstraint will be put in between the brackets e.g. can be something like @"20" => button(20)
 */
- (void)addHeightAndSuperviewAttachConstraints:(NSString *)heightConstraint
                                     topOffset:(CGFloat)topOffset
                                  bottomOffset:(CGFloat)bottomOffset;




@end
