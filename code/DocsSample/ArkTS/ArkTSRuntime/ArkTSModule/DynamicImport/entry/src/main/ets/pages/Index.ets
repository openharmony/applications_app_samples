/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import hilog from '@ohos.hilog';

function resourceToString(resource: Resource) {
  return getContext().resourceManager.getStringSync(resource);
}
// [Start await_for_dynamic_import]
// 可使用 await 处理动态import (必须在 async 函数内使用)
async function asyncDynamicImport() {
  let ns = await import('myhar');
  console.info('DynamicImport ns.add(3, 5) = %d', ns.add(3, 5));
}
// [End await_for_dynamic_import]

@Entry
@Component
struct Index {
  @State message: string = 'DynamicImport';
  private items: string[] = [
    resourceToString($r('app.string.business_expansion_scenario')),
    resourceToString($r('app.string.dynamic_import_HAR_name')),
    resourceToString($r('app.string.dynamic_import_HAR_path')),
    resourceToString($r('app.string.dynamic_import_HSP_name')),
    resourceToString($r('app.string.dynamic_import_HSP_path')),
    resourceToString($r('app.string.dynamic_import_remote_HAR_name')),
    resourceToString($r('app.string.dynamic_import_ohpm')),
    resourceToString($r('app.string.dynamic_import_file')),
    resourceToString($r('app.string.dynamic_import_native')),
    resourceToString($r('app.string.dynamic_import_system_app')),
    resourceToString($r('app.string.dynamic_import_ohos_curves')),
    resourceToString($r('app.string.dynamic_import_ohos_matrix4')),
    resourceToString($r('app.string.dynamic_import_ohos_hilog')),
    resourceToString($r('app.string.dynamic_import_module_myhar')),
    resourceToString($r('app.string.dynamic_import_module_file')),
    resourceToString($r('app.string.dynamic_import_HAR_name_variable')),
    resourceToString($r('app.string.dynamic_import_HSP_name_variable')),
    resourceToString($r('app.string.dynamic_import_remote_HAR_name_variable')),
    resourceToString($r('app.string.dynamic_import_ohpm_variable')),
    resourceToString($r('app.string.dynamic_import_file_variable')),
    resourceToString($r('app.string.dynamic_import_native_variable')),
    resourceToString($r('app.string.dynamic_import_system_app_variable')),
    resourceToString($r('app.string.dynamic_import_ohos_curves_variable')),
    resourceToString($r('app.string.dynamic_import_ohos_matrix4_variable')),
    resourceToString($r('app.string.dynamic_import_ohos_hilog_variable')),
    resourceToString($r('app.string.dynamic_import_HAR'))
  ]

  build() {
    Column() {
      Text(this.message)
        .fontSize(30)
      List({ space: '10vp' }) {
        ForEach(this.items, (item: ResourceStr) => {
          ListItem() {
            Text(item)
              .width('100%')
              .margin({ bottom: 2 })
              .height(60)
              .textAlign(TextAlign.Center)
              .backgroundColor(Color.White)
              .fontWeight(FontWeight.Bold)
              .borderRadius(30)
              .fontSize(16)
              .onClick(() => {
                if (item === resourceToString($r('app.string.business_expansion_scenario'))) {
                  // [Start dynamic_load_har_module_reflect_call]
                  // HAP's src/main/ets/pages/Index.ets
                  import('harlibrary').then((ns: ESObject) => {
                    ns.Calc.staticAdd(8, 9); // 调用静态成员函数staticAdd()
                    let calc: ESObject = new ns.Calc(); // 实例化类Calc
                    calc.instanceAdd(10, 11); // 调用成员函数instanceAdd()
                    ns.addHarlibrary(6, 7); // 调用全局方法addHarlibrary()

                    // 使用类、成员函数和方法的字符串名字进行反射调用
                    let className = 'Calc';
                    let methodName = 'instanceAdd';
                    let staticMethod = 'staticAdd';
                    let functionName = 'addHarlibrary';
                    ns[className][staticMethod](12, 13); // 调用静态成员函数staticAdd()
                    let calc1: ESObject = new ns[className](); // 实例化类Calc
                    calc1[methodName](14, 15); // 调用成员函数instanceAdd()
                    ns[functionName](16, 17); // 调用全局方法addHarlibrary()
                  })
                  // [End dynamic_load_har_module_reflect_call]
                } else if (item === resourceToString($r('app.string.dynamic_import_HAR_name'))) {
                  // HAP常量动态import HAR模块名
                  // [Start const_dynamic_import_har_name]
                  // HAP's src/main/ets/pages/Index.ets
                  import('myhar').then((ns: ESObject) => {
                    console.info(ns.add(3, 5));
                  })
                  // [End const_dynamic_import_har_name]
                } else if (item === resourceToString($r('app.string.dynamic_import_HAR_path'))) {
                  // HAP常量动态import HAR模块文件路径
                  // [Start const_dynamic_import_har_path]
                  // HAP's src/main/ets/pages/Index.ets
                  import('myhar/Index').then((ns: ESObject) => {
                    console.info(ns.add(3, 5));
                  });
                  // [End const_dynamic_import_har_path]
                } else if (item === resourceToString($r('app.string.dynamic_import_HSP_name'))) {
                  // HAP常量动态import HSP模块名
                  // [Start const_dynamic_import_hsp_name]
                  // HAP's src/main/ets/pages/Index.ets
                  import('myhsp').then((ns: ESObject) => {
                    console.info(ns.add(3, 5));
                  });
                  // [End const_dynamic_import_hsp_name]
                } else if (item === resourceToString($r('app.string.dynamic_import_HSP_path'))) {
                  // HAP常量动态import HSP模块名文件路径
                  // [Start const_dynamic_import_hsp_path]
                  // HAP's src/main/ets/pages/Index.ets
                  import('myhsp/Index').then((ns: ESObject) => {
                    console.info(ns.add(3, 5));
                  });
                  // [End const_dynamic_import_hsp_path]
                } else if (item === resourceToString($r('app.string.dynamic_import_remote_HAR_name'))) {
                  // HAP常量动态import远程HAR模块名
                  // [Start const_dynamic_import_crypto]
                  // HAP's src/main/ets/pages/Index.ets
                  import('@ohos/crypto-js').then((ns: ESObject) => {
                    console.info('DynamicImport @ohos/crypto-js: ' + ns.CryptoJS.src);
                  });
                  // [End const_dynamic_import_crypto]
                } else if (item === resourceToString($r('app.string.dynamic_import_ohpm'))) {
                  // HAP常量动态import ohpm包
                  // [Start const_dynamic_import_ohpm]
                  // HAP's src/main/ets/pages/Index.ets
                  import('@ohos/hypium').then((ns: ESObject) => {
                    console.info('DynamicImport @ohos/hypium: ', ns.TestType.FUNCTION.toString());
                  });
                  // [End const_dynamic_import_ohpm]
                } else if (item === resourceToString($r('app.string.dynamic_import_file'))) {
                  // HAP常量动态import自己的单文件
                  // [Start hap_const_dynamic_import]
                  // HAP's src/main/ets/pages/Index.ets
                  import('../Calc').then((ns: ESObject) => {
                    console.info(ns.add(3, 5));
                  })
                  // [End hap_const_dynamic_import]
                } else if (item === resourceToString($r('app.string.dynamic_import_native'))) {
                  // HAP常量动态import自己的Native库
                  // [Start hap_const_dynamic_import_native_index]
                  // HAP's src/main/ets/pages/Index.ets
                  import('libentry.so').then((ns: ESObject) => {
                    console.info('DynamicImport libnativeapi.so: ' + ns.default.add(2, 3));
                  });
                  // [End hap_const_dynamic_import_native_index]
                } else if (item === resourceToString($r('app.string.dynamic_import_system_app'))) {
                  // HAP常量动态import加载API
                  // [Start hap_const_dynamic_import_api]
                  // HAP's src/main/ets/pages/Index.ets
                  import('@system.app').then((ns: ESObject) => {
                    ns.default.getInfo();
                  });
                  // [StartExclude hap_const_dynamic_import_api]
                } else if (item === resourceToString($r('app.string.dynamic_import_ohos_curves'))) {
                  // HAP常量动态import加载API
                  // [EndExclude hap_const_dynamic_import_api]
                  import('@ohos.curves').then((ns: ESObject) => {
                    ns.default.springMotion(0.555, 0.75, 0.001).interpolate(1);
                  });
                  // [StartExclude hap_const_dynamic_import_api]
                } else if (item === resourceToString($r('app.string.dynamic_import_ohos_matrix4'))) {
                  // HAP常量动态import加载API
                  // [EndExclude hap_const_dynamic_import_api]
                  import('@ohos.matrix4').then((ns: ESObject) => {
                    ns.default.identity().transformPoint([1, 2])[0];
                  });
                  // [StartExclude hap_const_dynamic_import_api]
                } else if (item === resourceToString($r('app.string.dynamic_import_ohos_hilog'))) {
                  // HAP常量动态import加载API
                  // [EndExclude hap_const_dynamic_import_api]
                  import('@ohos.hilog').then((ns: ESObject) => {
                    ns.default.info(0x0000, 'testTag', '%{public}s', 'DynamicImport @ohos.hilog.');
                    hilog.info(0x000, 'testTag', '%{public}s', ns.default.LogLevel.DEBUG);
                  });
                  // [End hap_const_dynamic_import_api]
                } else if (item === resourceToString($r('app.string.dynamic_import_module_myhar'))) {
                  // [Start variable_dynamic_import]
                  // HAP's src/main/ets/pages/Index.ets
                  // 变量动态import其他模块myHar
                  let harName = 'myhar';
                  import(harName).then((ns: ESObject) => {
                    console.info(ns.add(3, 5));
                  });
                  // [StartExclude variable_dynamic_import]
                } else if (item === resourceToString($r('app.string.dynamic_import_module_file'))) {
                  // [EndExclude variable_dynamic_import]

                  // 变量动态import本模块自己的单文件
                  let filePath = '../utils/Calc';
                  import(filePath).then((ns: ESObject) => {
                    console.info(ns.add(3, 5));
                  });
                  // [End variable_dynamic_import]
                } else if (item === resourceToString($r('app.string.dynamic_import_HAR_name_variable'))) {
                  // HAP变量动态import HAR模块名
                  // [Start hap_variable_dynamic_import_har]
                  // HAP's src/main/ets/pages/Index.ets
                  let harPackageName = 'myhar';
                  import(harPackageName).then((ns: ESObject) => {
                    console.info(ns.add(3, 5));
                  });
                  // [End hap_variable_dynamic_import_har]
                } else if (item === resourceToString($r('app.string.dynamic_import_HSP_name_variable'))) {
                  // HAP变量动态import HSP模块名
                  // [Start hap_variable_dynamic_import_hsp]
                  // HAP's src/main/ets/pages/Index.ets
                  let hspPackageName = 'myhsp';
                  import(hspPackageName).then((ns: ESObject) => {
                    console.info(ns.add(3, 5));
                  });
                  // [End hap_variable_dynamic_import_hsp]
                } else if (item === resourceToString($r('app.string.dynamic_import_remote_HAR_name_variable'))) {
                  // HAP变量动态import远程HAR模块名
                  // [Start hap_variable_dynamic_import_har_crypto]
                  // HAP's src/main/ets/pages/Index.ets
                  let remoteHarPackageName = '@ohos/crypto-js';
                  import(remoteHarPackageName).then((ns: ESObject) => {
                    console.info('DynamicImport @ohos/crypto-js: ' + ns.CryptoJS.src);
                  });
                  // [End hap_variable_dynamic_import_har_crypto]
                } else if (item === resourceToString($r('app.string.dynamic_import_ohpm_variable'))) {
                  // HAP变量动态import ohpm包
                  // [Start hap_variable_dynamic_import_ohpm]
                  // HAP's src/main/ets/pages/Index.ets
                  let ohpmPackageName = '@ohos/hypium';
                  import(ohpmPackageName).then((ns: ESObject) => {
                    console.info('DynamicImport @ohos/hypium: ', ns.TestType.FUNCTION.toString());
                  });
                  // [End hap_variable_dynamic_import_ohpm]
                } else if (item === resourceToString($r('app.string.dynamic_import_file_variable'))) {
                  // HAP变量动态import自己的单文件
                  // [Start hap_variable_dynamic_import_calc]
                  // HAP's src/main/ets/pages/Index.ets
                  let calcFilePath = '../Calc';
                  import(calcFilePath).then((ns: ESObject) => {
                    console.info(ns.add(3, 5));
                  });
                  // [End hap_variable_dynamic_import_calc]
                } else if (item === resourceToString($r('app.string.dynamic_import_native_variable'))) {
                  // HAP变量动态import自己的Native库
                  // [Start hap_variable_dynamic_import_native]
                  // HAP's src/main/ets/pages/Index.ets
                  let soName = 'libentry.so';
                  import(soName).then((ns: ESObject) => {
                    console.info('DynamicImport libnativeapi.so: ' + ns.default.add(2, 3));
                  });
                  // [End hap_variable_dynamic_import_native]
                } else if (item === resourceToString($r('app.string.dynamic_import_system_app_variable'))) {
                  // HAP变量动态import加载API
                  // [Start hap_variable_dynamic_import_api]
                  // HAP's src/main/ets/pages/Index.ets
                  let packageName = '@system.app';
                  import(packageName).then((ns: ESObject) => {
                    ns.default.getInfo();
                  });
                  // [StartExclude hap_variable_dynamic_import_api]
                } else if (item === resourceToString($r('app.string.dynamic_import_ohos_curves_variable'))) {
                  // HAP变量动态import加载API
                  // [EndExclude hap_variable_dynamic_import_api]
                  let packageName = '@ohos.curves';
                  import(packageName).then((ns: ESObject) => {
                    ns.default.springMotion(0.555, 0.75, 0.001).interpolate(1);
                  });
                  // [StartExclude hap_variable_dynamic_import_api]
                } else if (item === resourceToString($r('app.string.dynamic_import_ohos_matrix4_variable'))) {
                  // HAP变量动态import加载API
                  // [EndExclude hap_variable_dynamic_import_api]
                  let packageName = '@ohos.matrix4';
                  import(packageName).then((ns: ESObject) => {
                    ns.default.identity().transformPoint([1, 2])[0];
                  });
                  // [StartExclude hap_variable_dynamic_import_api]
                } else if (item === resourceToString($r('app.string.dynamic_import_ohos_hilog_variable'))) {
                  // HAP变量动态import加载API
                  // [EndExclude hap_variable_dynamic_import_api]
                  let packageName = '@ohos.hilog';
                  import(packageName).then((ns: ESObject) => {
                    ns.default.info(0x0000, 'testTag', '%{public}s', 'DynamicImport @ohos.hilog.');
                  })
                  // [End hap_variable_dynamic_import_api]
                } else if (item === resourceToString($r('app.string.dynamic_import_HAR'))) {
                  // [Start hap_variable_dynamic_import_har1]
                  // HAP's src/main/ets/pages/Index.ets
                  let harName = 'har1'
                  import(harName).then((ns: ESObject) => {
                    console.info('[DynamicImport] hap -> har1, 0 + 1 = ' + ns.ClassHar1.add(0, 1));
                  })
                  // [End hap_variable_dynamic_import_har1]
                }
              })
          }
        })
      }.scrollBar(BarState.Off)
      .width('90%')
      .id('List')
    }.width('100%')
    .height('100%')
    .backgroundColor(0xDCDCDC)
    .padding({ top: 5 })
  }
}
