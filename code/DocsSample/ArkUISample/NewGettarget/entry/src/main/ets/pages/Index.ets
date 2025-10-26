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
import { router } from '@kit.ArkUI';
@Entry
@Component
struct Index {
  build() {
    Column() {
      // $r('app.string.arkts_new_gettarget1') 需要替换为开发者所需的资源文件
      Button($r('app.string.arkts_new_gettarget1'))
        .onClick(()=>{
          this.getUIContext().getRouter().pushUrl({
            url:'View/Page1'
          })
        })
      // $r('app.string.arkts_new_gettarget4') 需要替换为开发者所需的资源文件
      Button($r('app.string.arkts_new_gettarget4'))
        .onClick(()=>{
          this.getUIContext().getRouter().pushUrl({
            url:'View/Page2'
          })
        })
      // $r('app.string.arkts_new_gettarget5') 需要替换为开发者所需的资源文件
      Button($r('app.string.arkts_new_gettarget5'))
        .onClick(()=>{
          this.getUIContext().getRouter().pushUrl({
            url:'View/Page3'
          })
        })
      // $r('app.string.arkts_new_gettarget6') 需要替换为开发者所需的资源文件
      Button($r('app.string.arkts_new_gettarget6'))
        .onClick(()=>{
          this.getUIContext().getRouter().pushUrl({
            url:'View/Page4'
          })
        })
      // $r('app.string.arkts_new_gettarget7') 需要替换为开发者所需的资源文件
      Button($r('app.string.arkts_new_gettarget7'))
        .onClick(()=>{
          this.getUIContext().getRouter().pushUrl({
            url:'View/Page5'
          })
        })
    }
  }
}