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

@Entry
@Component
struct LoginSuccessPage {
  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Text($r('app.string.loginSuccess'))
          .fontSize(24)
          .fontWeight(500)
          .fontFamily('HarmonyHeiTi-Medium')
          .fontColor($r('app.color.user'))
      }.margin({ top: '32.3%' }).width('35%').height('4.1%')
    }.backgroundColor($r('app.color.pageBackColor')).height('100%').width('100%')
  }
}

