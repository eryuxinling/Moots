//
//  FWPortsInfoCollectionData.m
//  FirewallaUI
//
//  Created by 流年划过颜夕 on 2016/11/3.
//  Copyright © 2016年 Firewalla LLC. All rights reserved.
//

#import "FWPortsInfoCollectionData.h"

@implementation FWPortsInfoCollectionData
-(id) init {
    if (self = [super init]) {
        self.identifier = @"FWPortsInfoCollectionCell";
    }
    return self;
}

-(int) zw_height {
    return 50;
}

-(int) zw_width {
    return [UIScreen mainScreen].bounds.size.width;
}

-(int) zw_Ygap {
    return 0;
}

-(int) zw_Xgap {
    return 0;
}

@end
