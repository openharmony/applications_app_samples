/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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


@CustomDialog
struct CustomDialogExample {
  controller: CustomDialogController
  @StorageLink('lazy_for_each') lazy_for_each: boolean = AppStorage.get('lazy_for_each')
  @StorageLink('reusable') reusable: boolean = AppStorage.get('reusable')
  @StorageLink('img_syncLoad') img_syncLoad: boolean = AppStorage.get('img_syncLoad')
  @StorageLink('page_layout') page_layout: boolean = AppStorage.get('page_layout')
  @StorageLink('list_cachedCount') list_cachedCount: boolean = AppStorage.get('list_cachedCount')
  private promptArr = [
    { img: $r('app.media.pic1'), text: $r('app.string.add_friends') },
    { img: $r('app.media.pic2'), text: $r('app.string.group_chat') },
    { img: $r('app.media.pic3'), text: $r('app.string.scan') },
    { img: $r('app.media.pic4'), text: $r('app.string.collection_payment') }]

  build() {
    Column() {
      List({ space: 2, initialIndex: 0 }) {
        ForEach(this.promptArr, (item, index) => {
          ListItem() {
            Prompt({ img: item.img, text: item.text, controller: this.controller })
          }
        }, item => JSON.stringify(item))
      }
      .friction(0.4)
      .listDirection(Axis.Vertical) // 排列方向
      .divider({ strokeWidth: 0.5, color: '#888888', startMargin: 40, endMargin: 0 }) // 每行之间的分界线

      diaLogDivider()
      ToggleComponent({ text_option: $r('app.string.prop_lazy_for_each'), isOn: $lazy_for_each })
      diaLogDivider()
      ToggleComponent({ text_option: $r('app.string.prop_reusable'), isOn: $reusable })
      diaLogDivider()
      ToggleComponent({ text_option: $r('app.string.prop_syncLoad'), isOn: $img_syncLoad })
      diaLogDivider()
      ToggleComponent({ text_option: $r('app.string.prop_layout'), isOn: $page_layout })
      diaLogDivider()
      ToggleComponent({ text_option: $r('app.string.prop_cachedCount'), isOn: $list_cachedCount })
    }
    .backgroundColor("#2E363E")
    .borderRadius(5)
    .padding({ left: 5, bottom: 5 })
    .width(135)
  }
}

@Component
struct Prompt {
  @State img: Resource = $r("app.media.empresa")
  text: string | Resource
  controller: CustomDialogController

  build() {
    Row() {
      Image(this.img)
        .height(20)
        .width(20)
        .margin({ top: 1, right: 10 })
      Text(this.text)
        .fontSize(14)
        .fontColor("#ffffff")
        .margin({ top: 1 })
    }
    .width('100%')
    .padding(8)
    .justifyContent(FlexAlign.Start)
    .onClick(() => {
      this.controller.close()
      AlertDialog.show(
        {
          message: $r('app.string.alert_dialog'),
        }
      )
    })
  }
}

@Component
struct diaLogDivider {
  build() {
    Column(){
      Divider().strokeWidth(0.5).color('#888888').margin({left:40})
    }
  }
}

@Component
struct ToggleComponent {
  text_option: string | Resource
  @Link isOn: boolean

  build() {
    Column() {
      Row() {
        Toggle({ type: ToggleType.Switch, isOn: this.isOn })
          .selectedColor('#007DFF')
          .width(25)
          .switchPointColor('#FFFFFF')
          .onChange((isOn: boolean) => {
            this.isOn = isOn
          })
        Text(this.text_option)
          .fontSize(14)
          .fontColor("#ffffff")
          .margin({ left: 5 })
      }
      .width('100%')
      .padding(5)
      .justifyContent(FlexAlign.Start)
    }
  }
}

export { CustomDialogExample }