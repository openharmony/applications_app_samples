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
import cert from '@ohos.security.cert';
import { promptAction } from '@kit.ArkUI';

class MyDataSource implements IDataSource {
  private list: number[] = [];
  private listener: DataChangeListener | undefined | null;

  constructor(list: number[]) {
    this.list = list;
  }

  totalCount(): number {
    return this.list.length;
  }

  getData(index: number): number {
    return this.list[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    this.listener = listener;
  }

  unregisterDataChangeListener() {
  }
}

class P1 {
  public id?: string;
  public text?: string;
  public status?: string;
  public time?: string;
}

@Component
export struct MedicalAdvice {
  private name: string = '张晓彤';
  private swiperController: SwiperController = new SwiperController();
  private data: MyDataSource = new MyDataSource([]);

  aboutToAppear(): void {
    let list: number[] = [];
    for (let i = 1; i <= 4; i++) {
      list.push(i);
    }
    this.data = new MyDataSource(list);
  }

  private arrList: P1[] = [
    {
      id: '1',
      text: '测血糖',
      status: '未执行',
      time: '9:00'
    },
    {
      id: '2',
      text: '多烯磷脂酰胆碱注射液',
      status: '已执行',
      time: '11:00'
    },
    {
      id: '3',
      text: '葡萄糖酸钙注射液',
      status: '未配液',
      time: '10:45'
    },
    {
      id: '4',
      text: '硫普罗宁注射液',
      status: '未执行',
      time: '10:30'
    },
    {
      id: '4',
      text: '异甘草酸镁注射液',
      status: '未执行',
      time: '10:30'
    },
    {
      id: '4',
      text: '测血压',
      status: '未执行',
      time: '10:15'
    },
    {
      id: '4',
      text: '复方甘草酸苷注射液',
      status: '未执行',
      time: '10:15'
    },
    {
      id: '4',
      text: '复方二氯醋酸二异丙胺注射液',
      status: '未执行',
      time: '10:15'
    },
    {
      id: '4',
      text: '测体温',
      status: '未执行',
      time: '07:45'
    },
    {
      id: '4',
      text: '测血糖',
      status: '未执行',
      time: '07:30'
    },
  ];
  @State currentIndex: number = 0;
  @Consume('pageInfos') pageInfos: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        //header
        Row() {
          Image($r('app.media.nurse_back')).width(20).height(20).position({ x: 10, y: 10 })
            .onClick(() => {
              this.pageInfos.clear();
            });
          Text('医嘱执行')
            .height(22)
            .fontColor('#fff')
            .fontSize(12);
        }.backgroundColor('#6fa7ff').width('100%').height(30).justifyContent(FlexAlign.Center);

        Row() {
        }
        .backgroundColor('#6fa7ff')
        .borderRadius({ bottomLeft: 10, bottomRight: 10 })
        .width('100%')
        .height(50)
        .justifyContent(FlexAlign.Center);

        // patient info
        Row() {
          Row() {
          }
          .width(50)
          .height('66%')
          .backgroundColor(Color.White)
          .borderRadius(5)
          .shadow({
            radius: 20,
            color: $r('app.color.gray999'),
            offsetX: 2,
            offsetY: 2
          })
          .position({ x: '-14%', y: 20 });

          Column() {
            Row() {
              Text('12').fontSize(20).fontColor(Color.Orange);
              Text('床').fontSize(10).fontColor(Color.Gray).margin({ right: 10, bottom: 3 });
              Text(this.name).fontSize(16).fontColor($r('app.color.nurse_blue')).margin({ right: 10 });
              Text('病重').fontSize(10).fontColor(Color.Gray).margin({ bottom: 3 });
            }.margin({ top: 15, bottom: 10 }).alignItems(VerticalAlign.Bottom);

            Row() {
              Text('女').fontSize(10).fontColor(Color.Gray).margin({ right: 10 });
              Text('76岁').fontSize(10).fontColor(Color.Gray);
            };
          }
          .width('84%')
          .height('80%')
          .backgroundColor(Color.White)
          .borderRadius(5)
          .shadow({
            radius: 20,
            color: $r('app.color.gray999'),
            offsetX: 2,
            offsetY: 2
          })
          .margin({ left: '9%' });

          Row() {
          }
          .width(50)
          .height('66%')
          .backgroundColor(Color.White)
          .borderRadius(5)
          .shadow({
            radius: 20,
            color: $r('app.color.gray999'),
            offsetX: 2,
            offsetY: 2
          })
          .position({ x: '96%', y: 20 });
        }.width('100%').height(90).position({ x: 0, y: 25 });

        // TAB
        Row() {
          Text('注射药品类医嘱')
            .height(22)
            .border({
              width: { bottom: 2 },
              color: $r('app.color.nurse_blue'),
            })
            .fontSize(10)
            .fontColor(this.currentIndex === 0 ? $r('app.color.nurse_blue') : Color.Gray)
            .margin({ right: 10 });
          Text('护理类医嘱')
            .height(22)
            .border({
              width: { bottom: 2 },
              color: (this.currentIndex === 1 ? $r('app.color.nurse_blue') : Color.White),
            })
            .fontSize(10)
            .fontColor(this.currentIndex === 1 ? $r('app.color.nurse_blue') : Color.Gray)
            .margin({ left: 10 });
        }.margin({ top: 35 });

        Stack({ alignContent: Alignment.TopStart }) {
          Column() {
            //列表
            List({ space: 5, initialIndex: 0 }) {
              ForEach(this.arrList, (item: P1) => {
                ListItem() {
                  Column() {
                    Row() {
                      Text(item.text)
                        .fontSize(10)
                        .fontWeight(600)
                        .fontColor($r('app.color.nurse_blue'))
                        .lineHeight(14)
                        .width('70%')
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis });
                      Text(item.status).fontSize(9).fontColor(Color.Gray).lineHeight(14);
                    }.width('100%').justifyContent(FlexAlign.SpaceBetween);

                    Text(item.time)
                      .fontSize(9)
                      .fontColor(Color.Gray)
                      .lineHeight(14)
                      .width('100%')
                      .textAlign(TextAlign.Start);
                  }
                  .onClick(() => {
                    if (item.status == '未配液') {
                      this.pageInfos.pushPath({ name: 'Drug' }); //将name指定的NavDestination页面信息入栈
                    } else if (item.status == '未执行') {
                      promptAction.showDialog({
                        title: '计划' + item.time,
                        message: item.text,
                        buttons: [
                          {
                            text: '执行',
                            color: '#000000',
                          }
                        ],
                      })
                        .then(data => {
                          promptAction.showDialog({
                            title: '确定执行',
                            buttons: [
                              {
                                text: '取消',
                                color: '#000000',
                              },
                              {
                                text: '确认',
                                color: '#000000',
                              }
                            ],
                          }).then(data => {
                            item.status = '已执行';
                            console.info('showActionMenu success, click button: ' + data.index);
                          });
                        });
                    }

                  })
                  .width('96%')
                  .padding(5)
                  .margin({ top: 5, left: 5, right: 5 })
                  .backgroundColor(Color.White)
                  .shadow({
                    radius: 20,
                    color: $r('app.color.gray999'),
                    offsetX: 2,
                    offsetY: 2
                  })
                  .borderRadius(5);

                };
              });
            }
            .listDirection(Axis.Vertical) // 排列方向
            .edgeEffect(EdgeEffect.None) // 滑动到边缘无效果
            .chainAnimation(false) // 联动特效关闭
            .onScrollIndex((firstIndex: number, lastIndex: number) => {
              console.info('first' + firstIndex);
              console.info('last' + lastIndex);
            })
            .width('100%')
            .height('100%')
            .padding(5);
          }.width('100%').height('85%');
        };
      };
    }.hideTitleBar(true);
  }
}