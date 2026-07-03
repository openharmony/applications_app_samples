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
import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';

@HMRouter({ pageUrl: 'project/EditProjectPage' })
@Component
export struct EditProjectPage {
  @State isTouch: boolean = false;
  @State project: Project = new Project();
  private icBackIsVisibility: boolean = true;

  onPageShow(): void {
    class RouteParm {
      public projectId!: string;
    };

    let parm = HMRouterMgr.getCurrentParam() as RouteParm;
    // 通过路由参数传来需要编辑的项目id
    let projectId = parm.projectId;
    let projectManger: HttpApi = HttpApi.getInstance();
    // 获取需要编辑的项目数据
    projectManger.getAllProject().then((projects) => {
      projects.forEach((value) => {
        if (value.id === projectId) {
          this.project = value;
        }
      });
    });

  }

  build() {
    GridContainer({ gutter: 24, margin: 24 }) {
      Column() {
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

          Text($r('app.string.edit_project_text'))
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
              Text($r('app.string.project_information_text'))
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
              Row() {
                Text($r('app.string.project_name_text'))
                  .fontColor($r('sys.color.ohos_fa_text_primary'))
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium);
                Blank();
                TextInput({ placeholder: $r('app.string.project_name_text_input_placeholder'), })
                  .placeholderColor('#ff8c8c8c')
                  .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                  .fontSize(14)
                  .fontWeight(FontWeight.Medium)
                  .placeholderFont({ size: 14 })
                  .textAlign(TextAlign.Center)
                  .constraintSize({ maxWidth: '80%', minWidth: '50%' })
                  .backgroundColor($r('app.color.white'))
                  .caretColor(Color.Black)
                  .caretStyle({ width: 1 })
                  .onChange((value: string) => {
                    this.project.name = value;
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

              Row() {
                Text($r('app.string.project_location_text'))
                  .fontColor($r('sys.color.ohos_fa_text_primary'))
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium);
                Blank();
                Text(this.project.locationName)
                  .fontSize(14)
                  .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                  .margin({ right: 6 });
                Button() {
                  Image($r('app.media.right'))
                    .width(25);
                }
                .type(ButtonType.Circle)
                .margin({ right: 6 })
                .backgroundColor(Color.Transparent)
                .height(25);
              }
              .width('100%')
              .height(56)
              .padding({ left: 12, right: 6 })
              .alignItems(VerticalAlign.Center);
            }
            .margin({ top: 8 })
            .width('100%')
            .height(56 * 2)
            .backgroundColor('#FFFFFF')
            .borderRadius(28)
            .padding({ left: 12, right: 6 })
            .borderRadius(24);

            Row() {
              Text($r('app.string.project_member_text'))
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

            Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, }) {
              Column() {
                Button() {
                  Image($r('app.media.people'))
                    .width(30);
                }.width(40)
                .backgroundColor('#d2dff6')
                .type(ButtonType.Circle)
                .height(50);

                Text($r('app.string.project_member_demo'))
                  .fontSize(12);
              }.height(60)
              .width(60)
              .justifyContent(FlexAlign.SpaceAround);

              Column() {
                Button() {
                  Image($r('app.media.people_plus'))
                    .width(30);
                }
                .width(40)
                .backgroundColor('#ffffff')
                .type(ButtonType.Circle)
                .height(50)
                .border({
                  color: '#E3E3E3',
                  style: BorderStyle.Solid,
                  width: 1.5
                });

                Text($r('app.string.member_addition'))
                  .fontSize(12);
              }.height(60)
              .width(60)
              .justifyContent(FlexAlign.SpaceAround);
            }
            .padding(10)
            .backgroundColor('#FFFFFF')
            .borderRadius(24);
          };
        }.scrollBarWidth(0)
        .width('100%')
        .align(Alignment.TopStart)
        .layoutWeight(1);

        Blank();
        Column() {
          Row() {
            Button() {
              Text($r('app.string.delete_project_button'))
                .fontSize(20)
                .lineHeight(20)
                .fontFamily('HarmonyHeiTi-Bold')
                .fontWeight(FontWeight.Bold)
                .fontColor('#ffffff')
                .maxLines(1)
                .onClick(() => {
                  let projectManger: HttpApi = HttpApi.getInstance();
                  projectManger.deleteProject(this.project.id!);
                  HMRouterMgr.pop();
                });
            }
            .height(40)
            .width('40%')
            .margin({
              right: 20,
              bottom: 20
            });

            Button() {
              Text($r('app.string.finish_project'))
                .fontSize(20)
                .lineHeight(20)
                .fontFamily('HarmonyHeiTi-Bold')
                .fontWeight(FontWeight.Bold)
                .fontColor('#ffffff')
                .maxLines(1)
                .onClick(() => {
                  if (this.project.name != '') {
                    let projectManger: HttpApi = HttpApi.getInstance();
                    projectManger.updateProject(this.project);
                    HMRouterMgr.pop();
                  }
                });
            }
            .height(40)
            .width('40%')
            .margin({
              left: 20,
              bottom: 20
            });
          };
        };
      }.useSizeType({
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

