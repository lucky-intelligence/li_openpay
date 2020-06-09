#import "LiOpenpayPlugin.h"
#if __has_include(<li_openpay/li_openpay-Swift.h>)
#import <li_openpay/li_openpay-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "li_openpay-Swift.h"
#endif

@implementation LiOpenpayPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLiOpenpayPlugin registerWithRegistrar:registrar];
}
@end
