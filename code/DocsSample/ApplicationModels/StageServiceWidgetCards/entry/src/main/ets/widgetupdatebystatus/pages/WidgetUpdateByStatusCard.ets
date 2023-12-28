/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

let storageUpdateByStatus = new LocalStorage();

@Entry(storageUpdateByStatus)
@Component
struct WidgetUpdateByStatusCard {
  @LocalStorageProp('textA') textA: Resource = $r('app.string.to_be_refreshed');
  @LocalStorageProp('textB') textB: Resource = $r('app.string.to_be_refreshed');
  @State selectA: boolean = false;
  @State selectB: boolean = false;

  build() {
    Column() {
      Column() {
        Row() {
          Checkbox({ name: 'checkbox1', group: 'checkboxGroup' })
            .padding(0)
            .select(false)
            .margin({ left: 26 })
            .onChange((value: boolean) => {
              this.selectA = value;
              postCardAction(this, {
                action: 'message',
                params: {
                  selectA: JSON.stringify(value)
                }
              });
            })
          Text($r('app.string.status_a'))
            .fontColor('#000000')
            .opacity(0.9)
            .fontSize(14)
            .margin({ left: 8 })
        }
        .width('100%')
        .padding(0)
        .justifyContent(FlexAlign.Start)

        Row() {
          Checkbox({ name: 'checkbox2', group: 'checkboxGroup' })
            .padding(0)
            .select(false)
            .margin({ left: 26 })
            .onChange((value: boolean) => {
              this.selectB = value;
              postCardAction(this, {
                action: 'message',
                params: {
                  selectB: JSON.stringify(value)
                }
              });
            })
          Text($r('app.string.status_b'))
            .fontColor('#000000')
            .opacity(0.9)
            .fontSize(14)
            .margin({ left: 8 })
        }
        .width('100%')
        .position({ y: 32 })
        .padding(0)
        .justifyContent(FlexAlign.Start)
      }
      .position({ y: 12 })

      Column() {
        Row() { // 选中状态A才会进行刷新的内容
          Text($r('app.string.status_a'))
            .fontColor('#000000')
            .opacity(0.4)
            .fontSize(12)

          Text(this.textA)
            .fontColor('#000000')
            .opacity(0.4)
            .fontSize(12)
        }
        .margin({ top: '12px', left: 26, right: '26px' })

        Row() { // 选中状态B才会进行刷新的内容
          Text($r('app.string.status_b'))
            .fontColor('#000000')
            .opacity(0.4)
            .fontSize(12)
          Text(this.textB)
            .fontColor('#000000')
            .opacity(0.4)
            .fontSize(12)
        }.margin({ top: '12px', bottom: '21px', left: 26, right: '26px' })
      }
      .margin({ top: 80 })
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }.width('100%').height('100%')
    .backgroundImage($r('app.media.CardUpdateByStatus'))
    .backgroundImageSize(ImageSize.Cover)
  }
}