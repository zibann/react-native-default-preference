
#import "RNDefaultPreference.h"

@implementation RNDefaultPreference

NSString* defaultSuiteName = nil;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

- (NSUserDefaults *) getDefaultUser{
    if(defaultSuiteName == nil){
        NSLog(@"No prefer suite for userDefaults. Using standard one.");
        return [NSUserDefaults standardUserDefaults];
    } else {
        NSLog(@"Using %@ suite for userDefaults", defaultSuiteName);
        return [[NSUserDefaults alloc] initWithSuiteName:defaultSuiteName];
    }
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(setName:(NSString *)name
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(__unused RCTPromiseRejectBlock)reject)
{
    defaultSuiteName = name;
    resolve([NSNull null]);
}

RCT_EXPORT_METHOD(getName:(RCTPromiseResolveBlock)resolve
                  reject:(__unused RCTPromiseRejectBlock)reject)
{
    resolve(defaultSuiteName);
}

RCT_EXPORT_METHOD(
  get:(NSString *)_unused
  key: (NSString *)key
  resolve:(RCTPromiseResolveBlock)resolve
  reject:(__unused RCTPromiseRejectBlock)reject)
{
    resolve([[self getDefaultUser] stringForKey:key]);
}

RCT_EXPORT_METHOD(
  getInt:(NSString *)_unused
  key: (NSString *)key
  resolve:(RCTPromiseResolveBlock)resolve
  reject:(__unused RCTPromiseRejectBlock)reject)
{
  resolve([NSNumber numberWithInteger: [[self getDefaultUser] integerForKey:key]]);
}


RCT_EXPORT_METHOD(
  set:(NSString *)_unused
  key: (NSString *)key
  value:(NSString *)value
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(__unused RCTPromiseRejectBlock)reject)
{
    [[self getDefaultUser] setObject:value forKey:key];
    resolve([NSNull null]);
}

RCT_EXPORT_METHOD(
  clear:(NSString *)_unused
  key: (NSString *)key
  resolve:(RCTPromiseResolveBlock)resolve
  reject:(__unused RCTPromiseRejectBlock)reject)
{
    [[self getDefaultUser] removeObjectForKey:key];
    resolve([NSNull null]);
}

RCT_EXPORT_METHOD(
  getMultiple: (NSString *)_unused
  key:(NSArray *)keys
  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(__unused RCTPromiseRejectBlock)reject)
{
    NSMutableArray *result = [NSMutableArray array];
    for(NSString *key in keys) {
        NSString *value = [[self getDefaultUser] stringForKey:key];
        [result addObject: value == nil ? [NSNull null] : value];
    }
    resolve(result);
}

RCT_EXPORT_METHOD(setMultiple:(NSString *)_unused
  data: (NSDictionary*)data
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(__unused RCTPromiseRejectBlock)reject)
{
    for (id key in data) {
        [[self getDefaultUser] setObject:[data objectForKey:key] forKey:key];
    }
    resolve([NSNull null]);
}

RCT_EXPORT_METHOD(
  clearMultiple:(NSString *)_unused
  keys: (NSArray *)keys
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(__unused RCTPromiseRejectBlock)reject)
{
    for(NSString *key in keys) {
        [[self getDefaultUser] removeObjectForKey:key];
    }
    resolve([NSNull null]);
}

RCT_EXPORT_METHOD(getAll:(NSString *)_unused
  resolve:(RCTPromiseResolveBlock)resolve
  reject:(__unused RCTPromiseRejectBlock)reject)
{
    NSArray *keys = [[[self getDefaultUser] dictionaryRepresentation] allKeys];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for(NSString *key in keys) {
        NSString *value = [[self getDefaultUser] stringForKey:key];
        result[key] = value == nil ? [NSNull null] : value;
    }
    resolve(result);
}

RCT_EXPORT_METHOD(clearAll:(NSString *)_unused
  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    NSArray *keys = [[[self getDefaultUser] dictionaryRepresentation] allKeys];
    [self clearMultiple:@"" keys:keys resolve:resolve reject:reject];
}

@end
