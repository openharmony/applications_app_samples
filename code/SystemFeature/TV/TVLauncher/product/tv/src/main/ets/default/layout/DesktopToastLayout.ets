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

const TAG: string = 'DesktopToastLayout'
const TOAST_DELAY: number = 1500

@Component
export default struct DesktopToastLayout {
  @StorageProp('toastTxt') @Watch('watchToastText') toastText: string = ''

  watchToastText() {
    console.log(TAG, 'watchToastText ' + this.toastText)
    if (this.toastText) {
      setTimeout(() => {
        AppStorage.setOrCreate('toastTxt', '')
      }, TOAST_DELAY)
    }
  }

  build() {
    Row() {
      Text(this.toastText)
        .padding({
          left: 15,
          right: 15,
          top: 5,
          bottom: 5
        })
        .fontSize('18lpx')
        .borderRadius(20)
        .backgroundColor(Color.Gray)
        .fontColor(Color.White)
    }.justifyContent(FlexAlign.Center).width('100%').visibility(this.toastText ? Visibility.Visible : Visibility.None)
  }
}