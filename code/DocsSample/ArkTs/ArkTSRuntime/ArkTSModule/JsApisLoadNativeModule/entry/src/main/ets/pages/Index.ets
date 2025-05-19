/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

@Entry
@Component
struct Index {
  @State message: string = 'LoadNativeModule';

  build() {
    Column() {
      Button('LoadSystemModule')
        .width('50%')
        .margin({ bottom: 3 })
        .onClick(() => {
          // [Start hap_load_system_module]
          //HAP加载系统库模块
          let hilog: ESObject = loadNativeModule('@ohos.hilog');
          hilog.info(0, 'testTag', 'loadNativeModule ohos.hilog success');
          // [End hap_load_system_module]
          this.message = 'loadNativeModule ohos.hilog success'
        })

      Button('LoadNativeModule')
        .width('50%')
        .margin({ bottom: 3 })
        .onClick(() => {
          // [Start load_native_module_libentry]
          //HAP加载Native库
          let module: ESObject = loadNativeModule('libentry.so');
          let sum: number = module.add(1, 2);
          // [End load_native_module_libentry]
          this.message = 'loadNativeModule libentry.so success result: ' + sum.toString();
        })
      Text(this.message)
        .id('HelloWorld1')
        .fontSize(20)
        .margin({ bottom: 3 })
    }.width('100%')
  }
}