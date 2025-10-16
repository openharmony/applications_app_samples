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


import { hilog } from '@kit.PerformanceAnalysisKit';
import RpcTool from '../tool/RpcTool'
import { preferences } from '@kit.ArkData'

const DIRECT_KEY = 'direction'
class Region {
  public direction?: string
  public val?: string
  public img?: string
}

@Component
export struct RegionComponent {
  private regionList: Region[][] = [
    [{ direction: '向上', val: 'top', img: 'pic_handwriting_upxhdpi.png' },
      { direction: '向下', val: 'down', img: 'pic_handwriting_downxhdpi.png' }],
    [{ direction: '向左', val: 'left', img: 'pic_handwriting_leftxhdpi.png' },
      { direction: '向右', val: 'right', img: 'pic_handwriting_rightxhdpi.png' }]]
  private titleList = ['上下旋转', '左右旋转']
  private previewRegionImg = [$rawfile('pic_scale_set_leftxhdpi.png'),
                              $rawfile('pic_scale_set_downxhdpi.png'),
                              $rawfile('pic_scale_set_rightxhdpi.png'),
                              $rawfile('pic_scale_set_upxhdpi.png')]
  @State private currDirection: string = 'left'
  @State private currDirectionNumber: number = 0
  private keyPreference: preferences.Preferences | null = null;

  setDirection(directionVal: string) {
    let angle = 0
    if (directionVal == 'right') {
      angle = 180
    } else if (directionVal == 'top') {
      angle = 270
    } else if (directionVal == 'down') {
      angle = 90
    }
    hilog.info(0, 'testTag ui', 'set direction angle:' + angle);
    let direction = angle / 90;
    if (this.keyPreference != null) {
      this.keyPreference.putSync(DIRECT_KEY, direction);
      this.keyPreference.flushSync();
    }
    this.currDirectionNumber = direction
    RpcTool.getInstance().setDirection(angle / 90)
  }

  getDirection() {
    if (this.keyPreference == null) {
      let filePath = getContext().filesDir;
      hilog.info(0, 'testTag', `RegionComponent getDirection, filePath: ${filePath}`);
      this.keyPreference = preferences.getPreferencesSync(getContext(this), {name: 'keyInfo'});
    }
    let direction = this.keyPreference?.getSync(DIRECT_KEY, 0)
    switch (direction) {
      case 0:
        this.currDirection = 'left'
        this.currDirectionNumber = 0
        break;
      case 1:
        this.currDirection = 'down'
        this.currDirectionNumber = 1
        break;
      case 2:
        this.currDirection = 'right'
        this.currDirectionNumber = 2
        break;
      case 3:
        this.currDirection = 'up'
        this.currDirectionNumber = 3
        break;
    }
  }

  aboutToAppear() {
    this.getDirection()
  }

  build() {
    Column() {
      // 内容
      Row() {
        Column() {
          Image(this.previewRegionImg[this.currDirectionNumber])
            .height(460)
        }.padding({ right: 100 })

        Column() {
          ForEach(this.titleList, (title: string, index) => {
            // 标题分割栏 上下旋转、左右旋转
            Row() {
              Text(title)
                .fontSize(20)
                .width(110)
                .fontWeight(FontWeight.Bold)
                .textAlign(TextAlign.Center)
                .border({ width: { left: 5 }, color: '#0A59F7' })
            }.padding({ bottom: 20 })
            // 向左、向右设置
            Row() {
              ForEach(this.regionList[index], (set: Region) => {
                Column() {
                  Image($rawfile(set.img))
                    .height((index == 0) ? 100 : 60)
                    .padding({ left: 8 })
                  Row() {
                    Radio({ value: set.val, group: 'radioGroup' })
                      .checked(this.currDirection == set.val)
                      .onClick(() => {
                        if(set.val) {
                          this.setDirection(set.val)
                        }
                      })
                    Text(set.direction)
                  }.padding({ top: 15, bottom: 25 })
                }.width(160)
                .alignItems(HorizontalAlign.Start)
              })
            }.padding({ left: 15 })
          })
        }
        .alignItems(HorizontalAlign.Start)
      }.layoutWeight(1)
      .alignItems(VerticalAlign.Center)

      // 按钮
      Row() {
        Button('区域设置')
          .width(150)
          .margin({ right: 40 })
        Button('自动矫正')
          .width(150)
          .margin({ right: 40 })
        Button('默认全屏映射')
          .width(150)
      }.justifyContent(FlexAlign.SpaceBetween)
      .visibility(Visibility.None)
      .margin({ bottom: 15 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}