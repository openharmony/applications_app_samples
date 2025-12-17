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

// [Start modal_transition_with_if]
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct ModalTransitionWithIf {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  // $r('app.string.modal_transition_text29')需要替换为实际资源文件，在本示例中该资源文件的value值为“蓝牙”
  private listArr: ResourceStr[] = ['WLAN', $r('app.string.modal_transition_text29'),
    // $r('app.string.modal_transition_text30')需要替换为实际资源文件，在本示例中该资源文件的value值为“个人热点”
    $r('app.string.modal_transition_text30'),
    // $r('app.string.modal_transition_text31')需要替换为实际资源文件，在本示例中该资源文件的value值为“连接与共享”
    $r('app.string.modal_transition_text31')];
  // $r('app.string.modal_transition_text32')需要替换为实际资源文件，在本示例中该资源文件的value值为“投屏”
  private shareArr: ResourceStr[] = [$r('app.string.modal_transition_text32'),
    // $r('app.string.modal_transition_text33')需要替换为实际资源文件，在本示例中该资源文件的value值为“打印”
    $r('app.string.modal_transition_text33'), 'VPN',
    // $r('app.string.modal_transition_text34')需要替换为实际资源文件，在本示例中该资源文件的value值为“私人DNS”
    $r('app.string.modal_transition_text34'), 'NFC'];
  // 第一步：定义状态变量控制页面显示
  @State isShowShare: boolean = false;

  private shareFunc(): void {
    this.getUIContext()?.animateTo({ duration: 500 }, () => {
      this.isShowShare = !this.isShowShare;
    })
  }

  build() {
    // 第二步：定义Stack布局显示当前页面和模态页面
    Stack() {
      Column() {
        Column() {
          // $r('app.string.modal_transition_text35')需要替换为实际资源文件，在本示例中该资源文件的value值为“设置”
          Text($r('app.string.modal_transition_text35'))
            .fontSize(28)
            .fontColor(0x333333)
        }
        .width('90%')
        .padding({ top: 30, bottom: 15 })
        .alignItems(HorizontalAlign.Start)
        // $r('app.string.modal_transition_text36')需要替换为实际资源文件，在本示例中该资源文件的value值为“输入关键字搜索”
        TextInput({ placeholder: $r('app.string.modal_transition_text36') })
          .width('90%')
          .height(40)
          .margin({ bottom: 10 })
          .focusable(false)

        List({ space: 12, initialIndex: 0 }) {
          ForEach(this.listArr, (item: string, index: number) => {
            ListItem() {
              Row() {
                Row() {
                  Text(`${item.slice(0, 1)}`)
                    .fontColor(Color.White)
                    .fontSize(14)
                    .fontWeight(FontWeight.Bold)
                }
                .width(30)
                .height(30)
                .backgroundColor('#a8a8a8')
                .margin({ right: 12 })
                .borderRadius(20)
                .justifyContent(FlexAlign.Center)

                Column() {
                  Text(item)
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                }
                .alignItems(HorizontalAlign.Start)

                Blank()

                Row()
                  .width(12)
                  .height(12)
                  .margin({ right: 15 })
                  .border({
                    width: { top: 2, right: 2 },
                    color: 0xcccccc
                  })
                  .rotate({ angle: 45 })
              }
              .borderRadius(15)
              .shadow({ radius: 100, color: '#ededed' })
              .width('90%')
              .alignItems(VerticalAlign.Center)
              .padding({ left: 15, top: 15, bottom: 15 })
              .backgroundColor(Color.White)
            }
            .width('100%')
            .onClick(() => {
              // 第五步：改变状态变量，显示模态页面
              if (item.slice(-2) === this.context.resourceManager.getStringByNameSync('modal_transition_text37')) {
                this.shareFunc();
              }
            })
          }, (item: string): string => item)
        }
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .backgroundColor(0xfefefe)

      // 第三步：在if中定义模态页面，显示在最上层，通过if控制模态页面出现消失
      if (this.isShowShare) {
        Column() {
          Column() {
            Row() {
              Row() {
                Row()
                  .width(16)
                  .height(16)
                  .border({
                    width: { left: 2, top: 2 },
                    color: 0x333333
                  })
                  .rotate({ angle: -45 })
              }
              .padding({ left: 15, right: 10 })
              .onClick(() => {
                this.shareFunc();
              })
              // $r('app.string.modal_transition_text31')需要替换为实际资源文件，在本示例中该资源文件的value值为“连接与共享”
              Text($r('app.string.modal_transition_text31'))
                .fontSize(28)
                .fontColor(0x333333)
            }
            .padding({ top: 30 })
          }
          .width('90%')
          .padding({ bottom: 15 })
          .alignItems(HorizontalAlign.Start)

          List({ space: 12, initialIndex: 0 }) {
            ForEach(this.shareArr, (item: string) => {
              ListItem() {
                Row() {
                  Row() {
                    Text(`${item.slice(0, 1)}`)
                      .fontColor(Color.White)
                      .fontSize(14)
                      .fontWeight(FontWeight.Bold)
                  }
                  .width(30)
                  .height(30)
                  .backgroundColor('#a8a8a8')
                  .margin({ right: 12 })
                  .borderRadius(20)
                  .justifyContent(FlexAlign.Center)

                  Column() {
                    Text(item)
                      .fontSize(16)
                      .fontWeight(FontWeight.Medium)
                  }
                  .alignItems(HorizontalAlign.Start)

                  Blank()

                  Row()
                    .width(12)
                    .height(12)
                    .margin({ right: 15 })
                    .border({
                      width: { top: 2, right: 2 },
                      color: 0xcccccc
                    })
                    .rotate({ angle: 45 })
                }
                .borderRadius(15)
                .shadow({ radius: 100, color: '#ededed' })
                .width('90%')
                .alignItems(VerticalAlign.Center)
                .padding({ left: 15, top: 15, bottom: 15 })
                .backgroundColor(Color.White)
              }
              .width('100%')
            }, (item: string): string => item)
          }
          .width('100%')
        }
        .width('100%')
        .height('100%')
        .backgroundColor(0xffffff)
        // 第四步：定义模态页面出现消失转场方式
        .transition(TransitionEffect.OPACITY
          .combine(TransitionEffect.translate({ x: '100%' }))
          .combine(TransitionEffect.scale({ x: 0.95, y: 0.95 })))
      }
    }
  }
}

// [End modal_transition_with_if]