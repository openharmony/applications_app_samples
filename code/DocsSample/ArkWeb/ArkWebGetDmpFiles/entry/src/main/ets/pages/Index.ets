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
// [Start web_get_dmp_files]
import { fileIo as fs } from '@kit.CoreFileKit'
import { BusinessError} from '@kit.BasicServicesKit'
import { common } from '@kit.AbilityKit'

@Entry
@Component
struct Index {
  controller:WebController=new WebController();
  build() {
    RelativeContainer() {
      Web({src:'chrome://memory-exhaust/', controller:this.controller})
      Button('file')
        .onClick(() => {
          let context = getContext(this) as common.UIAbilityContext;
          let pathDir: string = context.filesDir;
          console.info("pathdir=" + pathDir);
          fs.copyDir("/data/storage/el2/log/crashpad/pending/", pathDir, 0)
            .then(()=>{
              console.info("copy files success");
            })
            .catch((err: BusinessError)=>{
              console.error("copy failed with error message: " + err.message + ", error code: " + err.code);
            })
        })
    }
    .height('100%')
    .width('100%')
  }
}
// [End web_get_dmp_files]