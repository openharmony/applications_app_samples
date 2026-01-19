/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
import { GotoButton } from '../utils/MyButton'

@Entry
@Component
struct Index {
  @State message: number = 0;
  @State returnMessage: string = 'No';

  build() {
    Row() {
      Column() {
        List() {

          ListItem() {
            GotoButton({ text: '跳转到TaskPool指定任务并发度场景', dstUri: 'pages/TaskpoolAsyncLevel'})
          }

          ListItem() {
            GotoButton({ text: '跳转到ArkUI瀑布流渲染场景', dstUri: 'pages/TaskpoolWaterFlow'})
          }

          ListItem() {
            GotoButton({ text: '跳转到获取最近访问列表场景', dstUri: 'pages/GetRecentList'})
          }

          ListItem() {
            GotoButton({ text: '跳转到多线程取消TaskPool任务场景', dstUri: 'pages/TaskpoolCancel'})
          }

          ListItem() {
            GotoButton({ text: '跳转到Worker常驻线程并发处理场景', dstUri: 'pages/workerAndTaskpool'})
          }
        }
        .width('%100')
        .height('%100')
      }
    }
  }
}
