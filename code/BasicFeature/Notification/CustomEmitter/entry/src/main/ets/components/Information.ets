/*
* Copyright (c) 2022 Huawei Device Co., Ltd.
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

import router from '@ohos.router'

@Component
export struct Information {
  @State collected: boolean = false
  private data: any[] = router.getParams()['goodItem']
  @State recommend: string = ''
  @State commodity: string = ''

  aboutToAppear() {
    let context: Context = getContext(this)
    this.recommend = context.resourceManager.getStringSync($r('app.string.recommend').id)
    this.commodity = context.resourceManager.getStringSync($r('app.string.commodity').id)
  }

  // 分享弹框
  controller: TabsController = new TabsController()
  shareDialog: CustomDialogController

  build() {
    Column() {
      Text() {
        Span(this.data['price'])
          .fontSize(20)
          .fontColor($r('app.color.pink'))
      }
      .fontWeight(500)

      Text(this.data['title'])
        .fontSize(16)
        .margin({ top: 4 })
    }
    .padding({ top: 16, bottom: 16, right: 12, left: 12 })
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .backgroundColor($r('app.color.white'))
    .borderRadius(16)
  }
}