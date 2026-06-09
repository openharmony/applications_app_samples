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
import { MedicalAdvice } from './MedicalAdvice';
import { Drug } from './Drug';
import { Logger } from '@ohos/common';

class Pe {
  public id?: string;
  public name?: string;
  public status?: string;
}

@Component
export default struct PatientList {
  private name = '';
  private arrList: Pe[] = [
    { id: '1', name: '张晓彤', status: '病危' },
    { id: '2', name: '赵月', status: '病危' },
    { id: '3', name: '孙晓娜', status: '病重' },
    { id: '4', name: '李倩', status: '病危' },
    { id: '5', name: '成小君', status: '病重' },
    { id: '6', name: '焦俊', status: '病重' },
    { id: '7', name: '田甜', status: '病重' },
    { id: '8', name: '刘嘉轩', status: '病重' },
    { id: '9', name: '孙启松', status: '病重' },
  ];
  @State currentIndex: number = 0;
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack();

  @Builder
  PageMap(name: string) {
    if (name === 'MedicalAdvice') {
      MedicalAdvice({ name: this.name });
    } else if (name === 'Drug') {
      Drug();
    }
  }

  build() {
    Navigation(this.pageInfos) {
      Column() {
        Row() {
        }.backgroundColor('#6fa7ff').width('100%').height(30).justifyContent(FlexAlign.Center);

        Row() {
          Text($r('app.string.Patient_List'))
            .height(22)
            .border({
              width: 0.5,
              color: Color.White,
              radius: {
                bottomLeft: 5,
                bottomRight: 0,
                topRight: 0,
                topLeft: 5
              }
            })
            .fontSize(10)
            .fontColor(this.currentIndex === 0 ? $r('app.color.nurse_blue') : Color.White)
            .backgroundColor(this.currentIndex === 0 ? Color.White : '')
            .padding({ left: 10, right: 10 });
          Text($r('app.string.My_patient'))
            .height(22)
            .border({
              width: 0.5,
              color: Color.White,
              radius: {
                bottomLeft: 0,
                bottomRight: 5,
                topRight: 5,
                topLeft: 0
              }
            })
            .fontSize(10)
            .fontColor(this.currentIndex === 1 ? $r('app.color.nurse_blue') : Color.White)
            .backgroundColor(this.currentIndex === 1 ? Color.White : '')
            .padding({ left: 10, right: 10 });
          Image($r('app.media.nurse_search')).width(15).position({ x: '86%', y: 5 });
        }
        .backgroundColor('#6fa7ff')
        .borderRadius({ bottomLeft: 10, bottomRight: 10 })
        .width('100%')
        .height(50)
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Top)
        .padding({ top: 5 });

        Stack({ alignContent: Alignment.TopStart }) {
          Column() {
            //列表
            List({ space: 5, initialIndex: 0 }) {
              ForEach(this.arrList, (item: Pe) => {
                ListItem() {
                  Row() {
                    Row() {
                      Circle({ width: 20, height: 20 }).fill('#f2f2f2');
                      Text(item.id)
                        .fontSize(10)
                        .fontWeight(600)
                        .fontColor($r('app.color.nurse_blue'))
                        .width(20)
                        .height(20)
                        .textAlign(TextAlign.Center)
                        .position({ x: 0 })
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis });
                    };

                    Text(item.name)
                      .fontSize(10)
                      .fontWeight(600)
                      .fontColor($r('app.color.nurse_blue'))
                      .lineHeight(14)
                      .width('30%')
                      .maxLines(2)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .margin({ left: 15, right: 50 });
                    Text(item.status).fontSize(9).fontColor(Color.Gray).lineHeight(14);

                  }
                  .onClick(() => {
                    this.pageInfos.pushPath({ name: 'MedicalAdvice' }); //将name指定的NavDestination页面信息入栈
                    if (item.name != undefined) {
                      this.name = item.name;
                    }
                  })
                  .width('96%')
                  .padding(5)
                  .margin({ left: 5, right: 5 })
                  .border({
                    width: { bottom: 1 },
                    color: { bottom: '#f2f2f2' },
                    style: {
                      bottom: BorderStyle.Solid,
                    }
                  });
                };
              });
            }
            .listDirection(Axis.Vertical) // 排列方向
            .edgeEffect(EdgeEffect.None) // 滑动到边缘无效果
            .chainAnimation(false) // 联动特效关闭
            .onScrollIndex((firstIndex: number, lastIndex: number) => {
              Logger.info('first' + firstIndex);
              Logger.info('last' + lastIndex);
            })
            .width('100%')
            .height('100%')
            .padding(5);
          }.width('100%').height('85%');
        };
      }.height('100%');
    }.hideTitleBar(true).navDestination(this.PageMap);
  }
}