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

- (IBAction)switchFonts:(id)sender
{
    if ([self.outputLabel.font.fontName isEqualToString:kSGFontGillSans]) {
        self.outputLabel.font = [UIFont fontWithName:kSGFontGillSansCustom size:kSGFontSize];
    } else {
        self.outputLabel.font = [UIFont fontWithName:kSGFontGillSans size:kSGFontSize];
    }
}

@end
