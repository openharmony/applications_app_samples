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

import logger from '../utils/Logger';
import { KeyCode } from '@kit.InputKit';
import { DistributedManagerDeviceInfo } from '../model/RemoteDeviceModel';
import { EventUtil } from './EventUtil';

const TAG: string = 'DeviceDialog';

@Component
export struct DeviceDialog {
  @Link deviceLists: Array<DistributedManagerDeviceInfo>;
  @Link selectedIndex: number;
  @Link isDevice: boolean;
  selectedIndexChange: (selectedIndex: number, device: DistributedManagerDeviceInfo) => void = () => {};
  private scrollerList: Scroller = new Scroller();

  aboutToAppear(): void {
    setTimeout(() => {
      let res = focusControl.requestFocus(this.selectedIndex.toString());
      console.log('DeviceDialog res:', res);
    }, 50)
  }

  build() {
    Column() {
      Text($r('app.string.choiceDevice'))
        .fontSize('36lpx')
        .height('90lpx')
        .width('100%')
        .fontColor('rgba(255,255,255,0.86)')
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Medium)

      Divider().strokeWidth(1).color('#ff47515d')

      List({ scroller: this.scrollerList }) {
        ForEach(this.deviceLists, (item: DistributedManagerDeviceInfo, index: number) => {
          ListItem() {
            Row() {
              Row() {
                Text(`${index + 1}`)
                  .margin({ left: '24lpx', right: '27lpx' })
                  .id(`${index}`)
                  .focusable(true)
                  .fontSize('30lpx')
                  .fontColor(this.selectedIndex == index ? 'rgba(0,0,0,0.86)' : 'rgba(255,255,255,0.86)')
                  .defaultFocus(this.selectedIndex == 0)
                  .onKeyEvent((e) => {
                    console.log(TAG, 'event' + JSON.stringify(e));
                    if (e.keyCode === KeyCode.KEYCODE_DPAD_DOWN && e.type === KeyType.Down) {
                      if (this.selectedIndex < this.deviceLists.length - 1) {
                        this.selectedIndex += 1;
                        let res = focusControl.requestFocus(this.selectedIndex.toString());
                        console.log(TAG, 'event requestFocus ', res);
                        this.scrollerList.scrollToIndex(this.selectedIndex, true, ScrollAlign.AUTO)
                      }
                    }
                    if (e.keyCode === KeyCode.KEYCODE_DPAD_UP && e.type === KeyType.Down) {
                      if (this.selectedIndex > 0) {
                        this.selectedIndex -= 1;
                        focusControl.requestFocus(this.selectedIndex.toString());
                        this.scrollerList.scrollToIndex(this.selectedIndex, true, ScrollAlign.AUTO)
                      }
                    }
                    if ((e.keyCode === KeyCode.KEYCODE_DPAD_CENTER || e.keyCode === KeyCode.KEYCODE_ENTER) &&
                      e.type === KeyType.Down) {
                      this.selectedIndexChange(this.selectedIndex, this.deviceLists[this.selectedIndex])
                    }
                  })
                  .onFocus(() => {
                    this.selectedIndex === index;
                    console.log('HmLog--> focus onFocus ', `${this.selectedIndex}`)
                  })
                  .onBlur(() => {
                    console.log('HmLog--> focus onBlur', `${this.selectedIndex}`)
                  })
                Text(item.deviceName)
                  .layoutWeight(1)
                  .fontSize('30lpx')
                  .fontColor(this.selectedIndex == index ? 'rgba(0,0,0,0.86)' : 'rgba(255,255,255,0.86)')
                  .textAlign(TextAlign.Start)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .ellipsisMode(EllipsisMode.CENTER)
                  .wordBreak(WordBreak.BREAK_ALL)
                  .maxLines(1)
              }.width('60%')
              .height('42lpx')
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Start)

              Row() {
                Blank()
                if (item.isTrust) {
                  if (item.isInTransfer) {
                    Text('流转中')
                      .fontSize('20lpx')
                      .textAlign(TextAlign.Start)
                      .fontColor(index == this.selectedIndex ? 'rgba(0,0,0,0.86)' :
                        'rgba(255,255,255,0.86)')
                      .width('200lpx')
                      .height('46lpx')
                      .padding({ right: '10lpx' })
                      .textAlign(TextAlign.End)
                      .maxLines(1)
                  } else {
                    Text('点击进行流转')
                      .fontSize('20lpx')
                      .textAlign(TextAlign.Start)
                      .fontColor(index == this.selectedIndex ? 'rgba(0,0,0,0.86)' :
                        'rgba(255,255,255,0.86)')
                      .width('180lpx')
                      .height('46lpx')
                      .padding({ right: '10lpx' })
                      .textAlign(TextAlign.End)
                      .maxLines(1)
                  }
                  if (item.transferLoading) {
                    LoadingProgress()
                      .color(index == this.selectedIndex ? 'rgba(0,0,0,0.86)' : 'rgba(255,255,255,0.86)')
                      .width('40lpx')
                      .height('40lpx')
                      .margin({ right: '10lpx' })
                  }
                } else if (item.isInAuth) {
                  Text('设备互信中...')
                    .fontSize('20lpx')
                    .textAlign(TextAlign.Start)
                    .fontColor(index == this.selectedIndex ? 'rgba(0,0,0,0.86)' :
                      'rgba(255,255,255,0.86)')
                    .width('180lpx')
                    .height('46lpx')
                    .padding({ right: '10lpx' })
                    .textAlign(TextAlign.End)
                    .maxLines(1)
                  LoadingProgress()
                    .color(index == this.selectedIndex ? 'rgba(0,0,0,0.86)' : 'rgba(255,255,255,0.86)')
                    .width('40lpx')
                    .height('40lpx')
                    .margin({ right: '10lpx' })
                } else {
                  Text('点击进行设备互信')
                    .fontSize('20lpx')
                    .textAlign(TextAlign.Start)
                    .fontColor(index == this.selectedIndex ? 'rgba(0,0,0,0.86)' :
                      'rgba(255,255,255,0.86)')
                    .width('200lpx')
                    .height('46lpx')
                    .padding({ right: '10lpx' })
                    .textAlign(TextAlign.End)
                    .maxLines(1)
                }
              }
              .layoutWeight(1)
              .height('42lpx')
              .border({
                radius: '12lpx',
                style: BorderStyle.Solid,
                color: '#00ffffff'
              })
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.End)
            }
            .backgroundColor(this.selectedIndex == index ? 'rgba(255,255,255,0.86)' : 'rgba(255,255,255,0.2)')
            .borderRadius('16lpx')
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.SpaceBetween)
            .height('100%')
          }
          .onAppear(() => {
            console.log('HmLog-->onAppear', `${index}`)
          })
          .onTouch((event) => {
            if (!EventUtil.isTouchEvent(event)) {
              return;
            }

            this.selectedIndex = index;
            this.selectedIndexChange(this.selectedIndex, this.deviceLists[this.selectedIndex])
          })
          .onHover(() => {
            this.selectedIndex = index;
          })
          .width('100%')
          .height('88lpx')
          .padding('8lpx')
          .border({
            width: '2lpx',
            color: this.selectedIndex == index ? Color.White : Color.Transparent,
            radius: '16lpx'
          })
        })
      }
      .scrollBar(BarState.Off)
      .padding({ left: '24lpx', right: '24lpx' })
      .width('100%')
      .height('342lpx')

      Divider().strokeWidth(1).color('#ff47515d')

      Text($r('app.string.exitText'))
        .fontSize('24lpx')
        .height('76lpx')
        .width('100%')
        .fontColor('rgba(255,255,255,0.86)')
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Medium)

    }
    .border({
      radius: '16lpx'
    })
    .width('732lpx')
    .height('508lpx')
    .backgroundColor('#404040')

  }


}