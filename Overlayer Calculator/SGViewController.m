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

@property (readwrite, assign, nonatomic) double inputA, inputB;
@property (readwrite, assign, nonatomic) SGOperation operation;
@property (readwrite, assign, nonatomic) BOOL clearOnNextInput;

@end

@implementation SGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.operation = SGOperationNone;
    self.clearOnNextInput = NO;
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
    self.inputA = 0;
    self.inputB = 0;
}

- (IBAction)selectNumber:(UIButton *)numberButton
{
    if (self.clearOnNextInput) {
        [self resetInput];
        self.clearOnNextInput = NO;
    }
    self.displayLabel.text = [self.displayLabel.text stringByAppendingString:numberButton.titleLabel.text];
}

- (IBAction)selectOperation:(UIButton *)operationButton
{
    BOOL continousOperation = YES;
    if (self.operation == SGOperationNone) {
        //  Read and clear the current input
        self.inputA = [self currentInput];
        self.clearOnNextInput = YES;
        continousOperation = NO;
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
    } else if ([operationButton.titleLabel.text isEqualToString:@"ln"]) {
        self.operation = SGOperationNaturalLog;
    } else if ([operationButton.titleLabel.text isEqualToString:@"x^y"]) {
        self.operation = SGOperationExponent;
    } else if ([operationButton.titleLabel.text isEqualToString:@"y√x"]) {
        self.operation = SGOperationRoot;
    }
    
    if (continousOperation) {
        [self evaluate:nil];
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
    self.inputB = [self currentInput];
    [self resetInput];
    
    double result;
    switch (self.operation) {
        case SGOperationAdd:
            result = self.inputA + self.inputB;
            break;
            
        case SGOperationSubstract:
            break;
        
        case SGOperationMultiply:
            break;
        
        case SGOperationDivide:
            break;
            
        case SGOperationExponent:
            break;
        
        case SGOperationRoot:
            break;
            
        case SGOperationLog:
            break;
            
        case SGOperationNaturalLog:
            break;
            
        case SGOperationNone:
            break;
    }
    
    self.displayLabel.text = [@(result) stringValue];
    
    //  Reset state
    self.operation = SGOperationNone;
    self.inputA = result;
    self.inputB = 0;
}

#pragma mark - Helpers

- (double)currentInput
{
    return [self.displayLabel.text doubleValue];
}

- (void)resetInput
{
    self.displayLabel.text = @"";
}

@end
