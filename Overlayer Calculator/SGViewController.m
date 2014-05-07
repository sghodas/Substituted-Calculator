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

@end

@implementation SGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.operation = SGOperationNone;
    self.resetInputOnNextInput = NO;
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
}

- (IBAction)selectNumber:(UIButton *)numberButton
{
    if (self.resetInputOnNextInput) {
        [self resetInput];
        self.resetInputOnNextInput = NO;
    }
    self.displayLabel.text = [self.displayLabel.text stringByAppendingString:numberButton.titleLabel.text];
}

- (IBAction)selectOperation:(UIButton *)operationButton
{
    SGOperation previousOperation = self.operation;
    
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
        self.displayLabel.text = [@(log10f([self currentInput])) stringValue];
    } else if ([operationButton.titleLabel.text isEqualToString:@"ln"]) {
        self.operation = SGOperationNaturalLog;
        self.displayLabel.text = [@(logf([self currentInput])) stringValue];
    } else if ([operationButton.titleLabel.text isEqualToString:@"x^y"]) {
        self.operation = SGOperationExponent;
    } else if ([operationButton.titleLabel.text isEqualToString:@"y√x"]) {
        self.operation = SGOperationRoot;
    }
    
    switch (self.operation) {
        case SGOperationAdd:
        case SGOperationSubstract:
        case SGOperationMultiply:
        case SGOperationDivide:
        case SGOperationExponent:
        case SGOperationRoot:
            if (self.originalInput == 0 && previousOperation == SGOperationNone) {
                self.originalInput = [self currentInput];
                self.resetInputOnNextInput = YES;
            } else {
                [self evaluate:nil];
            }
            break;
            
        case SGOperationNone:
        case SGOperationLog:
        case SGOperationNaturalLog:
            break;
    }
}

- (IBAction)selectDecimalPoint:(UIButton *)decimalPointButton
{
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
    //  Read and clear the current input
    double currentInput = [self currentInput];
    
    double result = 0;
    switch (self.operation) {
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
            result = powf(self.originalInput, powf(currentInput, -1));
            break;
            
        case SGOperationLog:
        case SGOperationNaturalLog:
        case SGOperationNone:
            break;
    }
    
    self.displayLabel.text = [@(result) stringValue];
    
    //  Reset state
    self.operation = SGOperationNone;
    self.originalInput = result;
    self.resetInputOnNextInput = YES;
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
