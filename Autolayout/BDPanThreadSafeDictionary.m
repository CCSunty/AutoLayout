//
//  BDPanThreadSafeDictionary.m
//  BusinessLayer
//
//  Created by Ducky on 2019/11/16.
//

#import "BDPanThreadSafeDictionary.h"

@interface BDPanThreadSafeDictionary ()

@property (nonatomic, strong) NSMutableDictionary *mDictionary;

@property (nonatomic, strong) dispatch_semaphore_t sema;

@end

@implementation BDPanThreadSafeDictionary

- (instancetype)initWithCapacity:(NSUInteger)numItems {
    if (self = [super init]) {
        self.mDictionary = [NSMutableDictionary dictionaryWithCapacity:numItems];
        self.sema = dispatch_semaphore_create(1);
    }
    return self;
}

- (instancetype)init {
    if (self = [self initWithCapacity:10]) {
    }
    return self;
}

- (instancetype)initWithMutableDictionary:(NSMutableDictionary *)dictionary {
    if (self = [self init]) {
        [self.mDictionary setDictionary:dictionary];
    }
    return self;
}

+ (instancetype)dictionary {
    return [self dictionaryWithMutableDictionary:nil];
}

+ (instancetype)dictionaryWithMutableDictionary:(NSMutableDictionary *)dictionary {
    id threadSafeDictionary = [[self alloc] initWithMutableDictionary:dictionary];
    return threadSafeDictionary;
}

+ (instancetype)dictionaryWithCapacity:(NSUInteger)numItems {
    id threadSafeDictionary = [[self alloc] initWithCapacity:numItems];
    return threadSafeDictionary;
}

- (id)objectForKey:(id)aKey {
    dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
    id obj = [_mDictionary objectForKey:aKey];
    dispatch_semaphore_signal(self.sema);
    return obj;
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
    [_mDictionary setObject:anObject forKey:aKey];
    dispatch_semaphore_signal(self.sema);
}

- (void)removeObjectForKey:(id)aKey {
    dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
    [_mDictionary removeObjectForKey:aKey];
    dispatch_semaphore_signal(self.sema);
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if (key == nil || value == nil) {
        return;
    }
    dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
    [_mDictionary setValue:value forKey:key];
    dispatch_semaphore_signal(self.sema);
}

- (id)valueForKey:(NSString *)key {
    if (key == nil) {
        return nil;
    }
    dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
    id obj = [_mDictionary valueForKey:key];
    dispatch_semaphore_signal(self.sema);
    return obj;
}

- (NSArray *)allKeys {
    dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
    NSArray *keys = [_mDictionary allKeys];
    dispatch_semaphore_signal(self.sema);
    return keys;
}

- (NSArray *)allValues {
    dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
    NSArray *values = [_mDictionary allValues];
    dispatch_semaphore_signal(self.sema);
    return values;
}

- (NSArray *)allKeysForObject:(id)object {
    dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *keys = [_mDictionary allKeysForObject:object];
    [arr addObjectsFromArray:keys];
    dispatch_semaphore_signal(self.sema);
    return  arr;
}

- (void)setDictionary:(NSMutableDictionary*)dictionary {
    dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
    _mDictionary = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    dispatch_semaphore_signal(self.sema);
}

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary {
    if (!otherDictionary) {
        return;
    }
    dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
    [_mDictionary addEntriesFromDictionary:otherDictionary];
    dispatch_semaphore_signal(self.sema);
}

- (void)removeAllObjects {
    dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
    [_mDictionary removeAllObjects];
    dispatch_semaphore_signal(self.sema);
}

- (void)removeObjectsForKeys:(NSArray *)keys {
    if (keys == nil) {
        return;
    }
    dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
    [_mDictionary removeObjectsForKeys:keys];
    dispatch_semaphore_signal(self.sema);
}

- (NSUInteger)count {
    dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
    NSUInteger count = [_mDictionary count];
    dispatch_semaphore_signal(self.sema);
    return count;
}

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile {
    NSDictionary *dic = [self fetchDictionary];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
    dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    BOOL b = [dic writeToFile:path atomically:useAuxiliaryFile];
    if (!b) {}
    return b;
}

- (NSDictionary *)fetchDictionary {
    dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:_mDictionary];
    dispatch_semaphore_signal(self.sema);
    return dict;
}

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block {
    if (!block) return;
    dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
    [_mDictionary enumerateKeysAndObjectsUsingBlock:block];
    dispatch_semaphore_signal(self.sema);
}

@end
