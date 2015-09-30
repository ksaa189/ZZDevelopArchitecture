//
//  ZZKeyboardHelper.h
//  ZZDevelopArchitecture
//
//  Created by Zhouzheng on 15/8/7.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "ZZDevelopPreDefine.h"

#define ZZKeyboardHelper_DefaultDistance 10.0


@interface ZZKeyboardHelper : NSObject __AS_SINGLETON

@property(nonatomic, assign) CGFloat keyboardDistanceFromTextField; // can't be less than zero. Default is 10.0
@property(nonatomic, assign) BOOL isEnabled;

//Enable keyboard Helper.
- (void)enableKeyboardHelper;    /*default enabled*/

//Desable keyboard Helper.
- (void)disableKeyboardHelper;

@end


/*****************UITextField***********************/
@interface UITextField (ToolbarOnKeyboard)

//Helper functions to add Done button on keyboard.
- (void)addDoneOnKeyboardWithTarget:(id)target action:(SEL)action;

//Helper function to add SegmentedNextPrevious and Done button on keyboard.
- (void)addPreviousNextDoneOnKeyboardWithTarget:(id)target previousAction:(SEL)previousAction nextAction:(SEL)nextAction doneAction:(SEL)doneAction;

//Helper methods to enable and desable previous next buttons.
- (void)setEnablePrevious:(BOOL)isPreviousEnabled next:(BOOL)isNextEnabled;

@end

/*****************UITextView***********************/
@interface UITextView (ToolbarOnKeyboard)

//Helper functions to add Done button on keyboard.
- (void)addDoneOnKeyboardWithTarget:(id)target action:(SEL)action;

//Helper function to add SegmentedNextPrevious and Done button on keyboard.
- (void)addPreviousNextDoneOnKeyboardWithTarget:(id)target previousAction:(SEL)previousAction nextAction:(SEL)nextAction doneAction:(SEL)doneAction;

//Helper methods to enable and desable previous next buttons.
- (void)setEnablePrevious:(BOOL)isPreviousEnabled next:(BOOL)isNextEnabled;

@end


/*****************ZZSegmentedNextPrevious***********************/
@interface ZZSegmentedNextPrevious : UISegmentedControl
{
    __weak id buttonTarget;
    SEL previousSelector;
    SEL nextSelector;
}

- (id)initWithTarget:(id)target previousSelector:(SEL)pSelector nextSelector:(SEL)nSelector;

@end