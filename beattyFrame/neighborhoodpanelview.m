//
//  neighborhoodpanelview.m
//  beattyFrame
//
//  Created by Evan Buxton on 4/20/16.
//  Copyright © 2016 Xiaohe Hu. All rights reserved.
//

#import "neighborhoodpanelview.h"
#import "Neighborhoodpanel.h"

@interface neighborhoodpanelview ()
@property (nonatomic, strong) NSString *pop;
@property (nonatomic, strong) NSString *inc;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *title;
@end

@implementation neighborhoodpanelview

-(id)initWithFrame:(CGRect)frame title:(NSString*)title pop:(NSString*)pop inc:(NSString*)inc age:(NSString*)age;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.pop = pop;
        self.inc = inc;
        self.age = age;
        self.title = title;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [Neighborhoodpanel drawMappanelWithPop:self.pop inc:self.inc age:self.age title:self.title];
}

@end
