//
//  UIView+Extend.m
//  timeProfileUILagDemo
//
//  Created by binbinwang on 2021/7/31.
//

#import "UIView+Extend.h"

@implementation UIView (Extend)

- (void)removeAllSubViews {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
}

// Retrieve and set the size
- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)aSize {
    if (isnan(aSize.width) || isnan(aSize.height)) {
        return;
    }

    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

// Retrieve and set height, width, top, bottom, left, right
- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    if (isnan(x)) {
        return;
    }

    CGRect newframe = self.frame;
    newframe.origin.x = x;
    self.frame = newframe;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    if (isnan(y)) {
        return;
    }

    CGRect newframe = self.frame;
    newframe.origin.y = y;
    self.frame = newframe;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)newheight {
    if (isnan(newheight)) {
        return;
    }

    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)newwidth {
    if (isnan(newwidth)) {
        return;
    }

    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)newtop {
    if (isnan(newtop)) {
        return;
    }

    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)newleft {
    if (isnan(newleft)) {
        return;
    }

    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)newbottom {
    if (isnan(newbottom)) {
        return;
    }

    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)newright {
    if (isnan(newright)) {
        return;
    }

    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta;
    self.frame = newframe;
}



@end
