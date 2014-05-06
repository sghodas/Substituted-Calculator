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


@interface SGViewController ()

@property (readwrite, weak, nonatomic) IBOutlet UILabel *outputLabel;

@property (readwrite, assign, nonatomic) double inputA, inputB;

@end

@implementation SGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Actions

- (IBAction)switchFonts:(UITapGestureRecognizer *)tap
{
    if ([self.outputLabel.font.fontName isEqualToString:kSGFontGillSans]) {
        self.outputLabel.font = [UIFont fontWithName:kSGFontGillSansCustom size:kSGFontSize];
    } else {
        self.outputLabel.font = [UIFont fontWithName:kSGFontGillSans size:kSGFontSize];
    }
}

- (IBAction)selectAllClear:(UIButton *)allClearbutton
{
    self.outputLabel.text = @"";
    self.inputA = 0;
    self.inputB = 0;
}

- (IBAction)selectNumber:(UIButton *)numberButton
{
    self.outputLabel.text = [self.outputLabel.text stringByAppendingString:numberButton.titleLabel.text];
}

- (IBAction)selectDecimalPoint:(UIButton *)decimalPointButton
{
    //  Only add a decimal point if there isn't one in the output already
    if ([self.outputLabel.text rangeOfString:@"."].location == NSNotFound) {
        if ([self.outputLabel.text isEqualToString:@""]) {
            self.outputLabel.text = @"0.";
        } else {
            self.outputLabel.text = [self.outputLabel.text stringByAppendingString:@"."];
        }
    }
}

@end
