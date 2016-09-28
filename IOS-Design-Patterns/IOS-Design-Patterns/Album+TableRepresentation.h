//
//  Album+TableRepresentation.h
//  IOS-Design-Patterns
//
//  Created by intern08 on 9/28/16.
//  Copyright © 2016 snow. All rights reserved.
//

#import "Album.h"

@interface Album (TableRepresentation)

- (NSDictionary *)tr_tableRepresentation;

@end
