//
//  UITests.m
//  solanum
//
//  Created by Adam Johns on 12/22/14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

#import "UITests.h"

@implementation UITests

- (void)beforeAll {
    [tester tapViewWithAccessibilityLabel:@"Settings"];
    
    [tester setOn:YES forSwitchWithAccessibilityLabel:@"Debug Mode"];
    
    [tester tapViewWithAccessibilityLabel:@"Clear History"];
    [tester tapViewWithAccessibilityLabel:@"Clear"];
}

- (void)test00TabBarButtons {
    // 1
    [tester tapViewWithAccessibilityLabel:@"History"];
    [tester waitForViewWithAccessibilityLabel:@"History List"];
    
    // 2
    [tester tapViewWithAccessibilityLabel:@"Timer"];
    [tester waitForViewWithAccessibilityLabel:@"Task Name"];
    
    // 3
    [tester tapViewWithAccessibilityLabel:@"Settings"];
    [tester waitForViewWithAccessibilityLabel:@"Debug Mode"];
}

- (void)test10PresetTimer {
    // 1
    [tester tapViewWithAccessibilityLabel:@"Timer"];
    
    // 2
    [tester enterText:@"Set up a test" intoViewWithAccessibilityLabel:@"Task Name"];
    [tester tapViewWithAccessibilityLabel:@"done"];
    
    // 3
    [self selectPresetAtIndex:1];
    
    // 4
    UISlider *slider = (UISlider *)[tester waitForViewWithAccessibilityLabel:@"Work Time Slider"];
    XCTAssertEqualWithAccuracy([slider value], 15.0f, 0.1, @"Work time slider was not set!");
}

- (void)test20StartTimerAndWaitForFinish {
    [tester tapViewWithAccessibilityLabel:@"Timer"];
    
    [tester clearTextFromAndThenEnterText:@"Test the timer"
           intoViewWithAccessibilityLabel:@"Task Name"];
    [tester tapViewWithAccessibilityLabel:@"done"];
    
    [tester setValue:1 forSliderWithAccessibilityLabel:@"Work Time Slider"];
    [tester setValue:50 forSliderWithAccessibilityLabel:@"Work Time Slider"];
    [tester setValue:1 forSliderWithAccessibilityLabel:@"Work Time Slider"];
    [tester setValue:8 forSliderWithAccessibilityLabel:@"Work Time Slider"];
    
    [tester setValue:1 forSliderWithAccessibilityLabel:@"Break Time Slider"];
    [tester setValue:25 forSliderWithAccessibilityLabel:@"Break Time Slider"];
    [tester setValue:2 forSliderWithAccessibilityLabel:@"Break Time Slider"];
    
    for (int i = 0; i < 20; i++) {
        [self decrementRepetitions];
    }
    
    [self incrementRepetitions];
    [tester waitForTimeInterval:1];
    [self incrementRepetitions];
    [tester waitForTimeInterval:1];
    
    [tester tapViewWithAccessibilityLabel:@"Start Working"];
    [[tester usingTimeout:60] waitForViewWithAccessibilityLabel:@"Start Working"];
}

- (void)test30GiveUp {
    [tester tapViewWithAccessibilityLabel:@"Timer"];
    
    [tester clearTextFromAndThenEnterText:@"Test Give Up" intoViewWithAccessibilityLabel:@"Task Name"];
    [tester tapViewWithAccessibilityLabel:@"done"];
    
    [tester tapViewWithAccessibilityLabel:@"Start Working"];
    [tester waitForTimeInterval:4];
    [tester tapViewWithAccessibilityLabel:@"Give Up"];
    [tester waitForViewWithAccessibilityLabel:@"Start Working"];
}

- (void)test40SwipeToDeleteHistoryItem
{
    // 1
    [tester tapViewWithAccessibilityLabel:@"History"];
    
    // 2
    UITableView *tableView = (UITableView *)[tester waitForViewWithAccessibilityLabel:@"History List"];
    NSInteger originalHistoryCount = [tableView numberOfRowsInSection:0];
    XCTAssertTrue(originalHistoryCount > 0, @"There should be at least 1 history item!");
    
    // 3
    [tester swipeViewWithAccessibilityLabel:@"Section 0 Row 0" inDirection:KIFSwipeDirectionLeft];
    [tester tapViewWithAccessibilityLabel:@"Delete"];
    
    // 4
    [tester waitForTimeInterval:1];
    NSInteger currentHistoryCount = [tableView numberOfRowsInSection:0];
    XCTAssertTrue(currentHistoryCount == originalHistoryCount - 1, @"The history item was not deleted :[");
}

- (void)incrementRepetitions {
    UIStepper *repetitionStepper = (UIStepper *)[tester waitForViewWithAccessibilityLabel:@"Reps Stepper"];
    
    CGFloat xVal = repetitionStepper.frame.origin.x + repetitionStepper.frame.size.width - repetitionStepper.frame.size.width/4;
    CGFloat yVal = repetitionStepper.frame.origin.y + repetitionStepper.frame.size.height/2;
    CGPoint touchPoint = CGPointMake(xVal, yVal);
    
    [tester tapScreenAtPoint:touchPoint];
}

- (void)decrementRepetitions {
    UIStepper *repetitionStepper = (UIStepper *)[tester waitForViewWithAccessibilityLabel:@"Reps Stepper"];
    
    CGFloat xVal = repetitionStepper.frame.origin.x + repetitionStepper.frame.size.width/4;
    CGFloat yVal = repetitionStepper.frame.origin.y + repetitionStepper.frame.size.height/2;
    CGPoint touchPoint = CGPointMake(xVal, yVal);
    
    [tester tapScreenAtPoint:touchPoint];
}

- (void)selectPresetAtIndex:(NSInteger)index {
    [tester tapViewWithAccessibilityLabel:@"Timer"];
    
    [tester tapViewWithAccessibilityLabel:@"Presets"];
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] inTableViewWithAccessibilityIdentifier:@"Presets List"];
    
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Presets List"];
}

@end
