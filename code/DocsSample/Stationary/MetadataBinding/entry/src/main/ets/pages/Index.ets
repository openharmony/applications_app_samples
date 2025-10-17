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

// [Start import_the_metadata_binding_module]
import { metadataBinding } from '@kit.MultimodalAwarenessKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Callback } from '@kit.BasicServicesKit';
// [End import_the_metadata_binding_module]

// [Start metadata_binding_parameter]
let callback : Callback<number> = (event: number) => {};
let bundleName: string = '';
// [End metadata_binding_parameter]

@Entry
@Component
struct Index {
  @State message: string = 'metadataBinding';

  private subscribe() {
    // [Start metadata_binding_subscribe]
    try {
      metadataBinding.on('operationSubmitMetadata', bundleName, callback);
      console.info('on succeeded');
      // [StartExclude metadata_binding_subscribe]
      this.message = 'metadataBinding subscribe';
      // [EndExclude metadata_binding_subscribe]
    } catch (err) {
      let error = err as BusinessError;
      console.error('Register event error and err code is ' + error.code);
      // [StartExclude metadata_binding_subscribe]
      this.message = 'metadataBinding subscribe';
      // [EndExclude metadata_binding_subscribe]
    }
    // [End metadata_binding_subscribe]
  }

  private submitData() {
    // [Start metadata_binding_submit]
    let metadata: string = '';
    try {
      metadataBinding.submitMetadata(metadata);
      // [StartExclude metadata_binding_submit]
      this.message = 'metadataBinding submitData';
      // [EndExclude metadata_binding_submit]
    } catch (err) {
      let error = err as BusinessError;
      console.error('Submit metadata error and err code is ' + error.code);
      // [StartExclude metadata_binding_submit]
      this.message = 'metadataBinding submitData';
      // [EndExclude metadata_binding_submit]
    }
    // [End metadata_binding_submit]
  }

  private unsubscribe() {
    // [Start metadata_binding_unsubscribe]
    try {
      metadataBinding.off('operationSubmitMetadata', bundleName, callback);
      console.info('off succeeded');
      // [StartExclude metadata_binding_unsubscribe]
      this.message = 'metadataBinding unsubscribe';
      // [EndExclude metadata_binding_unsubscribe]
    } catch (err) {
      let error = err as BusinessError;
      console.error('Unregister event error and err code is ' + error.code);
      // [StartExclude metadata_binding_unsubscribe]
      this.message = 'metadataBinding unsubscribe';
      // [EndExclude metadata_binding_unsubscribe]
    }
    // [End metadata_binding_unsubscribe]
  }

  build() {
    Column() {
      Text(this.message)
        .fontSize(35)
        .fontWeight(FontWeight.Bold).margin({ bottom:10 })
        .height('20%')
        .id('show')
      Button('订阅')
        .margin(10)
        .id('button1')
        .width('30%')
        .onClick(() => this.subscribe())
      Button('连接')
        .margin(10)
        .id('button2')
        .width('30%')
        .onClick(() => this.submitData())
      Button('取消订阅')
        .margin(10)
        .id('button3')
        .width('30%')
        .onClick(() => this.unsubscribe())
    }
    .height('100%')
    .width('100%')
  }
}