/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import ShowToast from '../../../../util/ShowToast';
import { TitleBar } from '../../../../common/TitleBar';
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';
import web_webview from '@ohos.web.webview';


@Extend(Column) function cardStyle(){
  .backgroundColor($r('app.color.white'))
  .borderRadius(16)
  .width('100%')
  .padding(12)
}

@Entry
@Component
struct WebSample {
  controller: web_webview.WebviewController = new web_webview.WebviewController();

  build() {
    Column() {
      TitleBar({ title: $r('app.string.web_title') })
      Scroll(){
        Column(){
          IntroductionTitle({introduction:$r('app.string.web_show')})
          Column(){
            Web({ src: 'www.baidu.com', controller: this.controller })
              .size({width:'100%',height:'100%'})
              .domStorageAccess(true)
              .onPageBegin(()=>{
                ShowToast.shortToast('onPageBegin')
              })
              .onPageEnd(()=>{
                ShowToast.shortToast('onPageEnd')
              })
              .onRefreshAccessedHistory(()=>{
                ShowToast.shortToast('The web is opening!')
              })
              .onScaleChange(()=>{
                ShowToast.shortToast('scaleChange')
              })
          }.cardStyle()
        }
      }.padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
      .margin({ bottom: 100 })
    }
    .height('100%')
    .backgroundColor(($r('app.color.background_grey')))
  }
}