
#import "YACallableCenter.h"

@interface YACallableCenter()

@property(nonatomic, strong) NSMutableDictionary *callableList;

@end

@implementation YACallableCenter

static YACallableCenter *_center;

//+ (instancetype)allocWithZone:(struct _NSZone *)zone {
//
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _center = [super allocWithZone:zone];
//    });
//    return _center;
//}

+ (instancetype)defaultCenter {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _center = [[self alloc] init];
    });
    return _center;
}
//
//- (instancetype)copyWithZone:(NSZone *)zone
//{
//    return _center;
//}


- (NSMutableDictionary *)callableList{
    if (!_callableList) {
        _callableList = [[NSMutableDictionary alloc]init];
    }
    return _callableList;
}

- (void)addCallable:(CallableBlock)callable tag:(NSString *)tag{
    @synchronized(self.callableList){
        NSMutableArray *callableItemList = [self.callableList objectForKey:tag];
        if (!callableItemList) {
            callableItemList = [NSMutableArray array];
            [self.callableList setObject:callableItemList forKey:tag];
        }
        [callableItemList addObject:callable];
    }
}

- (void)removeCallable:(CallableBlock)callable{
    @synchronized (self.callableList) {
        for (NSString *key in [self.callableList allKeys]) {
            NSMutableArray *callableItemList = [self.callableList objectForKey:key];
            if (callableItemList && [callableItemList containsObject:callable]) {
//                DebugLog(@"remove %@", callable);
                [callableItemList removeObject:callable];
            }
        }
    }
}

- (void)removeCallable:(CallableBlock)callable tag:(NSString *)tag{
    @synchronized (self.callableList) {
        NSMutableArray *callableItemList = [self.callableList objectForKey:tag];
        if (callableItemList && [callableItemList containsObject:callable]) {
            [callableItemList removeObject:callable];
        }
    }
}

- (void)removeAllCallables{
    @synchronized (self.callableList) {
        [self.callableList removeAllObjects];

    }
}

- (void)removeCallablesWithKey:(NSString *)key{
    @synchronized (self.callableList) {
        [self.callableList removeObjectForKey:key];
    }
}

// 根据名称获取数据
- (NSArray *)getEach:(NSString *)tag data:(id)data{
    
    NSMutableArray *array = [NSMutableArray array];
    @synchronized (self.callableList) {
        NSMutableArray *callableItemList = [self.callableList objectForKey:tag];
        if (callableItemList) {
            for (CallableBlock callable in callableItemList) {
                [array addObject:callable(data)];
            }
        }
    }
    return array;
}

- (id)getFirst:(NSString *)tag data:(id)data{
    @synchronized (self.callableList) {
        NSMutableArray *callableItemList = [self.callableList objectForKey:tag];
        if (callableItemList) {
            CallableBlock callable = [callableItemList objectAtIndex:0];
            return callable(data);
        }
    }
    return nil;
}

@end