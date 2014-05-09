//
//  SGViewController.m
//  Overlayer Calculator
//
//  Created by Satyam Ghodasara on 5/5/14.
//  Copyright (c) 2014 Satyam Ghodasara. All rights reserved.
//

#import "SGViewController.h"


static NSString * const kSGFontGillSans = @"GillSans";
static NSString * const kSGFontGillSansCustom = @"Gill Sans Custom";

static CGFloat const kSGFontSize = 52.0f;

typedef NS_ENUM(NSInteger, SGOperation) {
    SGOperationNone,
    SGOperationAdd,
    SGOperationSubstract,
    SGOperationMultiply,
    SGOperationDivide,
    SGOperationExponent,
    SGOperationRoot,
    SGOperationLog,
    SGOperationNaturalLog
};


@interface SGViewController ()

@property (readwrite, weak, nonatomic) IBOutlet UILabel *displayLabel;

@property (readwrite, assign, nonatomic) double originalInput;
@property (readwrite, assign, nonatomic) SGOperation operation;
@property (readwrite, assign, nonatomic) BOOL resetInputOnNextInput;
@property (readwrite, assign, nonatomic) BOOL hasOriginalInput;
@property (readwrite, assign, nonatomic) BOOL hasNewInput;

@end

@implementation SGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self selectAllClear:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Actions

- (IBAction)switchFonts:(UITapGestureRecognizer *)tap
{
    if ([self.displayLabel.font.fontName isEqualToString:kSGFontGillSans]) {
        self.displayLabel.font = [UIFont fontWithName:kSGFontGillSansCustom size:kSGFontSize];
    } else {
        self.displayLabel.font = [UIFont fontWithName:kSGFontGillSans size:kSGFontSize];
    }
}

- (IBAction)selectAllClear:(UIButton *)allClearbutton
{
    self.displayLabel.text = @"";
    self.originalInput = 0;
    self.operation = SGOperationNone;
    self.hasOriginalInput = NO;
    self.hasNewInput = NO;
    self.resetInputOnNextInput = YES;
}

- (IBAction)selectNumber:(UIButton *)numberButton
{
    if (self.resetInputOnNextInput) {
        [self resetInput];
        self.resetInputOnNextInput = NO;
    }
    if (self.hasOriginalInput) {
        self.hasNewInput = YES;
    }
    self.displayLabel.text = [self.displayLabel.text stringByAppendingString:numberButton.titleLabel.text];
}

- (IBAction)selectOperation:(UIButton *)operationButton
{
    switch (self.operation) {
        case SGOperationAdd:
        case SGOperationSubstract:
        case SGOperationMultiply:
        case SGOperationDivide:
        case SGOperationExponent:
        case SGOperationRoot:
            if (self.hasOriginalInput && self.hasNewInput) {
                [self evaluate:nil];
            }
            break;
        case SGOperationLog:
        case SGOperationNaturalLog:
        case SGOperationNone:
            break;
    }

    if ([operationButton.titleLabel.text isEqualToString:@"+"]) {
        self.operation = SGOperationAdd;
    } else if ([operationButton.titleLabel.text isEqualToString:@"−"]) {
        self.operation = SGOperationSubstract;
    } else if ([operationButton.titleLabel.text isEqualToString:@"×"]) {
        self.operation = SGOperationMultiply;
    } else if ([operationButton.titleLabel.text isEqualToString:@"÷"]) {
        self.operation = SGOperationDivide;
    } else if ([operationButton.titleLabel.text isEqualToString:@"log"]) {
        self.operation = SGOperationLog;
        [self evaluate:nil];
    } else if ([operationButton.titleLabel.text isEqualToString:@"ln"]) {
        self.operation = SGOperationNaturalLog;
        [self evaluate:nil];
    } else if ([operationButton.titleLabel.text isEqualToString:@"x^y"]) {
        self.operation = SGOperationExponent;
    } else if ([operationButton.titleLabel.text isEqualToString:@"y√x"]) {
        self.operation = SGOperationRoot;
    }
    
    //  Now that an operation is set, the original input is finished
    self.resetInputOnNextInput = YES;
    self.originalInput = [self currentInput];
    self.hasOriginalInput = YES;
}

- (IBAction)selectDecimalPoint:(UIButton *)decimalPointButton
{
    if (self.resetInputOnNextInput) {
        [self resetInput];
        self.resetInputOnNextInput = NO;
    }
    if (self.hasOriginalInput) {
        self.hasNewInput = YES;
    }
    
    //  Only add a decimal point if there isn't one in the output already
    if ([self.displayLabel.text rangeOfString:@"."].location == NSNotFound) {
        if ([self.displayLabel.text isEqualToString:@""]) {
            self.displayLabel.text = @"0.";
        } else {
            self.displayLabel.text = [self.displayLabel.text stringByAppendingString:@"."];
        }
    }
}

- (IBAction)selectNegate:(UIButton *)negateButton
{
    double currentInput = [self.displayLabel.text doubleValue];
    if (currentInput != 0) {
        self.displayLabel.text = [@(currentInput*-1) stringValue];
    }
}

- (IBAction)evaluate:(UIButton *)evaluateButton
{
    double currentInput = [self currentInput];
    double result = 0;
    switch (self.operation) {
        case SGOperationNone:
            break;
        case SGOperationAdd:
            result = self.originalInput + currentInput;
            break;
        case SGOperationSubstract:
            result = self.originalInput - currentInput;
            break;
        case SGOperationMultiply:
            result = self.originalInput * currentInput;
            break;
        case SGOperationDivide:
            result = self.originalInput / currentInput;
            break;
        case SGOperationExponent:
            result = powf(self.originalInput, currentInput);
            break;
        case SGOperationRoot:
            result = powf(self.originalInput, 1/currentInput);
            break;
        case SGOperationLog:
            result = log10f(currentInput);
            break;
        case SGOperationNaturalLog:
            result = logf(currentInput);
            break;
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:6];
    self.displayLabel.text = [formatter stringFromNumber:@(result)];
    
    self.originalInput = result;
    self.hasOriginalInput = YES;
    self.operation = SGOperationNone;
    self.resetInputOnNextInput = YES;
    self.hasNewInput = NO;
}

#pragma mark - Helpers

- (double)currentInput
{
    if (![self.displayLabel.text isEqualToString:@""]) {
        return [self.displayLabel.text doubleValue];
    } else {
        return 0;
    }
}

- (void)resetInput
{
    self.displayLabel.text = @"";
}

@end
