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

import notificationManager from '@ohos.notificationManager';
import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { urlUtils } from '@ohos/uploaddownload';
import util from '@ohos.util';

@Styles
function itemStyle() {
  .width('100%')
  .height(56)
  .padding({ top: 17, bottom: 17, left: 12, right: 12 })
  .backgroundColor(Color.White)
  .borderRadius(24)
  .margin({ top: 20 })
}

@Extend(Text)
function textStyle() {
  .fontColor($r('app.color.text_normal'))
  .fontWeight(400)
  .fontFamily('HarmonyHeiTi')
  .fontSize(16)
}

@Entry
@Component
struct Index {
  @StorageLink('isBackground') isBackground: boolean = false;

  aboutToAppear() {
    notificationManager.requestEnableNotification();
  }

  build() {
    Navigation() {
      Scroll() {
        Column() {
          Row() {
            Text($r('app.string.background_tips'))
              .textStyle()
            Blank()
            Toggle({ type: ToggleType.Switch, isOn: this.isBackground })
              .width(40)
              .height(24)
              .onChange((isOn: boolean) => {
                this.isBackground = isOn;
                AppStorage.setOrCreate('isBackground', isOn);
              })
          }
          .itemStyle()
          .margin({ top: 20 })

          TextInput({ text: $r('app.string.downloadServer') })
            .visibility(Visibility.Hidden)
            .height(0)
            .onChange((downloadServer) =>  AppStorage.setOrCreate('downloadServer', downloadServer))          

          Row() {
            Text($r('app.string.HFS_tips'))
              .textStyle()
            Blank()
            TextInput()
              .width(250)
              .height(40)
              .margin({left : 20})
              .onChange((val) => urlUtils.saveUrl(getContext(this) as common.UIAbilityContext,val))
          }

          .itemStyle()
          .margin({ top: 15 })

          this.CapabilityView($r('app.media.ic_upload'), $r('app.string.upload'), 'btn_upload', () => {
            router.pushUrl({
              url: 'pages/Upload'
            })
          })
          this.CapabilityView($r('app.media.ic_download'), $r('app.string.download'), 'btn_download', () => {
            router.pushUrl({
              url: 'pages/Download'
              })
            })
          this.CapabilityView($r('app.media.ic_download'), $r('app.string.downloadToUser'), 'btn_downloadToUser',
            () => {

              router.pushUrl({
                url: 'pages/Download',
                params: {
                  action: 'ToUser'
                }
              })
            })
          this.CapabilityView($r('app.media.ic_certified'), $r('app.string.cert_lock'), 'btn_cert_lock', () => {
            router.pushUrl({
              url: 'pages/CertLock'
            })
          })
        }
        .width('100%')
        .margin({ left:-12 })
      }
      .padding({ left: 12, right: 6 })
      .height('100%')
      .align(Alignment.Top)
    }
    .width('100%')
    .height('100%')
    .hideBackButton(true)
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor($r('app.color.light_gray'))
    .title({
      main: this.getResourceString($r('app.string.EntryAbility_label')),
      sub: this.getResourceString($r('app.string.home_tips'))
    })
    .padding({ top:5 })
  }

  @Builder
  CapabilityView(image: Resource, text: Resource, id: string, onClick: () => void) {
    Row() {
      Image(image)
        .size({ width: 24, height: 24 })
        .objectFit(ImageFit.Cover)
      Text(text)
        .textStyle()
        .margin({ left: 12 })
    }
    .itemStyle()
    .id(id)
    .onClick(onClick)
  }

  getResourceString(resource: Resource) {
    let context = getContext(this) as common.UIAbilityContext;
    return context.resourceManager.getStringSync(resource.id);
  }
}