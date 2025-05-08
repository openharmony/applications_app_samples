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

import { worker } from '@kit.ArkTS';
import { bundleManager } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

// 对abc文件进行校验，并拷贝到指定沙箱路径下
function sampleVerifyAbc(abcPaths: Array<string>, deleteOriginalFiles: boolean) {
  try {
    bundleManager.verifyAbc(abcPaths, deleteOriginalFiles, (err) => {
      if (err) {
        console.error('VerifyAbc failed, error message: ' + err.message);
      } else {
        console.info('VerifyAbc successfully.');
      }
    });
  } catch (err) {
    let message = (err as BusinessError).message;
    console.error('VerifyAbc failed, error message: ' + message);
  }
}

@Component
export struct Isolated {
  @State isShow: boolean = false;
  @State resourcePath: string = '';
  @State abcPath: string = '';
  @State entryPoint: string = '';
  // abc文件名
  private fileName: string = 'modules';
  // abc文件所属应用的bundleName
  private bundleName: string = 'com.example.isolateddemo';
  // 受限worker
  private worker ?: worker.RestrictedWorker = new worker.RestrictedWorker('entry/ets/workers/OhCardWorker.ets');

  build() {
    NavDestination() {
      Row() {
        Column({ space: 20 }) {
          // 1.调用verifyAbc接口校验abc文件
          Button('verifyAbc').onClick(() => {
            let abcFilePath = `${getContext(this).filesDir}/${this.fileName}.abc`;
            console.log('abcFilePath: ' + abcFilePath);
            sampleVerifyAbc([abcFilePath], false);
          }).height(100).width(200)

          // 2.显示IsolatedComponent
          Button('showIsolatedComponent').onClick(() => {
            if (!this.isShow) {
              // 资源路径
              this.resourcePath = `${getContext(this).filesDir}/${this.fileName}.hap`;
              // abc文件校验后的沙箱路径
              this.abcPath = `/abcs${getContext(this).filesDir}/${this.fileName}`;
              // 需要显示页面的入口路径
              this.entryPoint = `${this.bundleName}/entry/ets/pages/IsolatedComponent/Extension`;
              this.isShow = true;
            }
          }).height(100).width(200)

          if (this.isShow) {
            IsolatedComponent({
              want: {
                'parameters': {
                  'resourcePath': this.resourcePath,
                  'abcPath': this.abcPath,
                  'entryPoint': this.entryPoint
                }
              },
              worker: this.worker
            })
              .width(300)
              .height(300)
              .onError((err) => {
                console.info('onError : ' + JSON.stringify(err));
              })
          }
        }
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Isolated_Component_title'))
  }
}