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

// [Start createModuleContext_start]
import { common, application } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

let storageEventCall = new LocalStorage();

@Entry(storageEventCall)
@Component
struct Page_Context {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  build() {
    Column() {
      // [StartExclude createModuleContext_start]
      Text('top')
        .width('50vp')
      // [EndExclude createModuleContext_start]
      List({ initialIndex: 0 }) {
        ListItem() {
          Row() {
            // [StartExclude createModuleContext_start]
            Text('list')
              .width('50vp')
            // [EndExclude createModuleContext_start]
          }
          .onClick(() => {
            let moduleName2: string = 'entry';
            application.createModuleContext(this.context, moduleName2)
              .then((data: common.Context) => {
                console.info(`CreateModuleContext success, data: ${JSON.stringify(data)}`);
                if (data !== null) {
                  this.getUIContext().getPromptAction().showToast({
                    message: ('成功获取Context')
                  });
                }
              })
              .catch((err: BusinessError) => {
                console.error(`CreateModuleContext failed, err code:${err.code}, err msg: ${err.message}`);
              });
          })
        }
        // [StartExclude createModuleContext_start]
        .width('50vp')
        // [EndExclude createModuleContext_start]
      }
      // [StartExclude createModuleContext_start]
      .width('50vp')
      // [EndExclude createModuleContext_start]
    }
    // [StartExclude createModuleContext_start]
    .width('50vp')
    // [EndExclude createModuleContext_start]
  }
}
// [End createModuleContext_start]