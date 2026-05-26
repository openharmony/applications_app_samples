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

import { router } from '@kit.ArkUI';
import { Project, HttpApi } from '@ohos/connect_cloud';
import { Logger } from '@ohos/common';
import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';

const TAG = 'AddDeviceToProjectPage';

@HMRouter({ pageUrl: 'project/AddDeviceToProjectPage' })
@Component
export struct AddDeviceToProjectPage {
  @State isTouch: boolean = false;
  @State projectList: Project[] = [];
  private icBackIsVisibility: boolean = true;
  private selectProjectItemId: number = -1;
  private deviceId: string = '';

  aboutToAppear(): void {
    class RouteParm {
      public deviceId!: string;
    };
    // 设备配网的页面还没做，假设是通过路由参数传来待添加设备的设备id
    let parm = HMRouterMgr.getCurrentParam() as RouteParm;
    this.deviceId = parm.deviceId;
    let projectManger: HttpApi = HttpApi.getInstance();
    projectManger.getAllProject().then((value) => {
      this.projectList = value;
    }).catch((err: object) => {
      Logger.warn(TAG, 'get projects failed');
    });
  }

  @Builder
  indicatorBuilder() {
    Image($r('app.media.check'));
  }

  build() {
    GridContainer({ gutter: 24, margin: 24 }) {
      Column() {
        //头部
        Row() {
          Stack({ alignContent: Alignment.Center }) {
            Image($r('app.media.ic_back'))
              .width('24vp')
              .height('24vp')
              .fillColor($r('sys.color.ohos_id_color_primary'));
          }
          .margin({ right: 16 })
          .backgroundColor(this.isTouch ? '#E3E3E3' : '#00000000')
          .visibility(this.icBackIsVisibility ? Visibility.Visible : Visibility.None)
          .onClick(() => {
            HMRouterMgr.pop();
          })
          .onTouch((event?: TouchEvent | undefined) => {
            if (event?.type === TouchType.Down) {
              this.isTouch = true;
            }
            if (event?.type === TouchType.Up) {
              this.isTouch = false;
            }
          });

          Text($r('app.string.project_select_text'))
            .fontSize(24)
            .lineHeight(33)
            .fontFamily('HarmonyHeiTi-Bold')
            .fontWeight(FontWeight.Bold)
            .fontColor('#182431')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .textAlign(TextAlign.Start)
            .margin({ top: 13, bottom: 15 });
        }
        .width('100%')
        .padding({ left: 12 })
        .height(56)
        .alignItems(VerticalAlign.Center)
        .align(Alignment.Start);

        Scroll() {
          Column() {
            Row() {
              Text($r('app.string.select_project_text'))
                .fontSize(16)
                .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                .height(40)
                .fontWeight(FontWeight.Medium)
                .lineHeight(20)
                .padding({
                  left: 12,
                });
              Blank();
            }.width('100%')
            .margin({
              top: 10,
            });

            Column() {
              List() {
                ForEach(this.projectList, (item: Project, index: number) => {
                  ListItem() {
                    Row() {
                      Row() {
                        Text(item.name)
                          .fontWeight(FontWeight.Medium);
                        Blank();
                        Radio({
                          value: 'Radio',
                          group: 'radioGroup',
                          indicatorType: RadioIndicatorType.CUSTOM,
                          indicatorBuilder: () => {
                            this.indicatorBuilder();
                          }
                        })
                          .checked(false)
                          .radioStyle({
                            checkedBackgroundColor: Color.Transparent,
                            uncheckedBorderColor: Color.Transparent
                          })
                          .height(25)
                          .width(25)
                          .onChange((isChecked: boolean) => {
                            if (isChecked) {
                              this.selectProjectItemId = index;
                            }
                          });
                      }
                      .flexShrink(0)
                      .alignItems(VerticalAlign.Center)
                      .align(Alignment.Start)
                      .layoutWeight(1)
                      .margin({
                        left: 12,
                        right: 6
                      });

                    }.width('100%')
                    .height(54)
                    .borderRadius(24)
                    .backgroundColor('#FFFFFF');

                  };
                }, (item: string) => item);
              }
              .padding(10)
              .backgroundColor('#FFFFFF')
              .borderRadius(24)
              .divider({
                strokeWidth: 0.5,
                color: '#E3E3E3',
                startMargin: 12,
                endMargin: 12
              });
            }.width('100%')
            .constraintSize({ maxHeight: '60%' });

            Row() {
              Text($r('app.string.create_project_text'))
                .fontSize(16)
                .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                .height(40)
                .lineHeight(20)
                .padding({
                  left: 12,
                });
              Blank();
            }.width('100%')
            .margin({
              top: 10,
            });

            Column() {
              Row() {
                Text($r('app.string.create_project_text'))
                  .fontColor($r('sys.color.ohos_fa_text_primary'))
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium);
                Blank();
                Button() {
                  Image($r('app.media.plus'))
                    .width(25);
                }
                .type(ButtonType.Circle)
                .margin({ right: 6 })
                .backgroundColor('0x317aff')
                .height(25)
                .onClick(() => {
                  HMRouterMgr.push({ pageUrl: 'project/CreateProjectPage' });
                });
              }
              .width('100%')
              .height(56)
              .padding({ left: 12, right: 6 })
              .alignItems(VerticalAlign.Center)
              .border({
                width: {
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0.5
                },
                color: '#E3E3E3',
                style: BorderStyle.Solid
              });
            }
            .margin({ top: 8 })
            .width('100%')
            .height(56)
            .backgroundColor('#FFFFFF')
            .borderRadius(28)
            .padding({ left: 12, right: 6 })
            .borderRadius(24);
          };
        }.scrollBarWidth(0)
        .width('100%')
        .align(Alignment.TopStart)
        .layoutWeight(1);

        Blank();
        Column() {
          Button() {
            Text($r('app.string.finish_project_select'))
              .fontSize(20)
              .lineHeight(20)
              .fontFamily('HarmonyHeiTi-Bold')
              .fontWeight(FontWeight.Bold)
              .fontColor('#ffffff')
              .maxLines(1)
              .onClick(() => {
                if (this.selectProjectItemId != -1) {
                  if (this.projectList[this.selectProjectItemId].id != undefined) {
                    let projectId: string = this.projectList[this.selectProjectItemId].id!;
                    let deviceManger: HttpApi = HttpApi.getInstance();
                    deviceManger.addDeviceToProject({ projectId: projectId, deviceIdList: [this.deviceId] });
                    HMRouterMgr.push({ pageUrl: 'CategoryPage' });
                  }
                }
              });
          }
          .height(40)
          .width('80%')
          .margin({ bottom: 20 });
        };

      }.height('100%')
      .useSizeType({
        sm: { span: 4, offset: 0 },
        md: { span: 6, offset: 1 },
        lg: { span: 8, offset: 2 }
      });
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);
  }
}