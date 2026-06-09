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
import { CommonConstants } from '@ohos/common';
import {
  AlarmInformationList,
  DistributedCameraList,
  FaultManagementlist,
  IAssemblyUnitList,
  IFeatureList,
  IProductionInformation,
  ISelectInformationTypeList,
  MenuList,
} from '../../../model/utils/CommitUtil';

@Component
export struct ProductionDifficulty {
  close: () => void = () => {
  };
  succ: () => void = () => {
  };
  @State title: Resource = $r(`app.string.production_equipment`);
  @State masterUnitData: IAssemblyUnitList = {
    id: '',
    label: '主部件'
  };
  @State featureData: IFeatureList = {
    id: '',
    label: '功能dadsd'
  };
  @State distributedCameraId: string = '';
  @State distributedCameraList: DistributedCameraList[] = [
    new DistributedCameraList('1', '摄像头'),
    new DistributedCameraList('2', '摄像头'),
    new DistributedCameraList('3', '摄像头'),
    new DistributedCameraList('4', '摄像头'),
    new DistributedCameraList('5', '摄像头'),
    new DistributedCameraList('6', '摄像头'),
    new DistributedCameraList('7', '摄像头'),
    new DistributedCameraList('7', '摄像头'),
  ];
  @State alarmInformationId: string = '';
  @State alarmInformationList: AlarmInformationList[] = [
    new AlarmInformationList('', '所有'),
    new AlarmInformationList('1', '红色报警'),
    new AlarmInformationList('2', '黄色报警'),
    new AlarmInformationList('3', '紫色报警'),
    new AlarmInformationList('4', '绿色报警'),
    new AlarmInformationList('5', '灰色报警'),
    new AlarmInformationList('6', '深蓝报警'),
    new AlarmInformationList('7', '浅蓝报警'),
  ];
  @State menuId: string = 'productionManagement';
  @State menuList: MenuList[] = [
    new MenuList('productionManagement', '生产管理', $r('app.media.productionManagement')),
    new MenuList('faultManagement', '故障管理', $r('app.media.faultManagement')),
  ];
  @State faultManagementlist: FaultManagementlist[] = [
    new FaultManagementlist('1', '报警：外部故障 -31N2看门狗', 'S130', '--', '--', '--'),
    new FaultManagementlist('1', '报警：外部故障 -31N2看门狗', 'S130', '--', '--', '--'),
    new FaultManagementlist('1', '报警：外部故障 -31N2看门狗', 'S130', '--', '--', '--'),
    new FaultManagementlist('1', '报警：外部故障 -31N2看门狗', 'S130', '--', '--', '--'),
    new FaultManagementlist('1', '报警：外部故障 -31N2看门狗', 'S130', '--', '--', '--'),
    new FaultManagementlist('1', '报警：外部故障 -31N2看门狗', 'S130', '--', '--', '--'),
    new FaultManagementlist('1', '报警：外部故障 -31N2看门狗', 'S130', '--', '--', '--'),
  ];
  @State productionInformation: IProductionInformation[] = [
    {
      id: 'production',
      label: '生产量',
      value: '8888',
      icon: $r('app.media.powerConsumption'),
    },
    {
      id: 'production',
      label: '耗电量',
      value: '5999',
      icon: $r('app.media.production'),
    },
    {
      id: 'production',
      label: '功率',
      value: '5999',
      icon: $r('app.media.power'),
    },
  ];
  @State selectInformationTypeData: ISelectInformationTypeList = {
    id: '',
    label: ''
  };
  @State selectInformationTypeList: ISelectInformationTypeList[] = [
    {
      id: 'allMessages',
      label: '所有的信息',
    },
    {
      id: 'exemptInformation',
      label: '免除的信息',
    },
    {
      id: 'effectiveInformation',
      label: '有效的信息',
    },
  ];
  @State assemblyUnitList: IAssemblyUnitList[] = [
    {
      id: '1',
      label: '综合部件1',
    },
    {
      id: '2',
      label: '综合部件2',
    },
    {
      id: '3',
      label: '综合部件3',
    },
  ];
  @State featureList: IFeatureList[] = [
    {
      id: '1',
      label: '功能定义：机器规格1',
    },
    {
      id: '2',
      label: '功能定义：机器规格2',
    },
    {
      id: '3',
      label: '功能定义：机器规格3',
    },
  ];
  @State isCameraDetailsShow: Boolean = false;
  @State isSelectInformationTypeShow: Boolean = false;
  @State isCompositeUnitShow: Boolean = false;
  @State isRefreshing: boolean = false;
  @State isLoadMore: boolean = false; // 是否下拉刷新
  @State page: number = 0;
  @State haveData: boolean = true; // 是否还有数据
  @State refreshText: string = ''; // 刷新提示文本

  /* 上拉刷新 */
  @Builder
  getRefreshBuilder() {
    Row({ space: 8 }) {
      LoadingProgress()
        .width(20)
        .aspectRatio(1);
      Text(this.refreshText)
        .fontSize(14)
        .fontColor('#818181');
    };
  }

  async getData() {
    // 上拉加载，加载下一页10条数据，page++
    if (this.isLoadMore) {
      this.page++;
    }
    // 下拉刷新，重置到第一条数据，page为1
    if (this.isRefreshing) {
      this.page = 1;
    }
    if (this.isLoadMore) {
      // 下拉刷新追加数据
    } else {
      // 刷新重置数据替换
    }
  }

  // 选择综合部件模态框
  @Builder
  compositeUnitBuilder() {
    Column() {
      Row() {
        Row() {
          Text() {
            Span(this.masterUnitData.label || '');
            Span('/');
            Span(this.featureData.label || '');
          }
          .fontColor($r('app.color.text_color_3'))
          .fontSize($r('app.string.font_16'));
        };

        Row() {
          Image($r('app.media.close_outline'))
            .width($r('app.string.icon_width'))
            .height($r('app.string.icon_height'));
        }.onClick(() => this.isCompositeUnitShow = false);
      }.width('100%').justifyContent(FlexAlign.SpaceBetween).padding({
        top: $r('app.string.p_24'),
        bottom: $r('app.string.p_16'),
        left: $r('app.string.p_16'),
        right: $r('app.string.p_16'),
      }).backgroundColor('#f3f3f3');

      Column() {
        Row() {
          Column() {
            ForEach(this.assemblyUnitList, (item: IAssemblyUnitList) => {
              Column() {
                Text(item.label || '')
                  .fontColor(this.masterUnitData.id == item.id ? $r('app.color.text_color_5') :
                  $r('app.color.text_color_3'))
                  .fontSize($r('app.string.font_14'));
              }
              .height(44)
              .width('100%')
              .backgroundColor(this.masterUnitData.id == item.id ? '#f3f3f3' : '#ffffff')
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Start)
              .padding({ left: $r('app.string.p_16') })
              .onClick(() => {
                this.masterUnitData = item;
              });
            });
          }.width(144).height('100%');

          Column() {
            ForEach(this.featureList, (item: IFeatureList) => {
              Column() {
                Text(item.label || '')
                  .fontColor(this.featureData.id == item.id ? $r('app.color.text_color_5') :
                  $r('app.color.text_color_3'))
                  .fontSize($r('app.string.font_14'));
              }
              .height(44)
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Start)
              .padding({ left: $r('app.string.p_16') })
              .backgroundColor(this.featureData.id == item.id ? 'rgba(16,88,247,0.08)' : '#f3f3f3')
              .onClick(() => {
                this.featureData = item;
              });
            });
          }.layoutWeight(1).height('100%').backgroundColor('#f3f3f3');

        }.height('100%').width('100%');
      }.layoutWeight(1);
    }.height('100%').width('100%');
  }

  // 选择信息类型模态框
  @Builder
  selectInformationTypeBuilder() {
    Column() {
      Row() {
        Text($r(`app.string.select_information_type`))
          .fontColor($r('app.color.text_color_3'))
          .fontSize($r('app.string.font_16'));
      }.width('100%').margin({ bottom: $r('app.string.p_8') });

      Column() {
        ForEach(this.selectInformationTypeList, (item: ISelectInformationTypeList, i: number) => {
          Row() {
            Text(item.label || '')
              .fontColor($r('app.color.text_color_3'))
              .fontSize($r('app.string.font_14'));

            if (this.selectInformationTypeData.id == item.id) {
              Image($r('app.media.correct'))
                .width(16)
                .height(16);
            }
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')
          .padding({ top: $r('app.string.p_16'), bottom: $r('app.string.p_16') })
          .border({
            width: { bottom: i < this.productionInformation.length - 1 ? 1 : 0 },
            color: { bottom: '#ececec' },
          })
          .onClick(() => {
            this.selectInformationTypeData = item;
          });
        });
      };

    }.height('100%').width('100%').padding($r('app.string.p_24'));
  }

  // 选择摄像头信息模态框
  @Builder
  modifySceneIconBuilder() {
    Column() {
      Row() {
        Image($r('app.media.ic_public_back'))
          .width($r('app.string.icon_width'))
          .height($r('app.string.icon_height'));
      }
      .width(CommonConstants.FULL_WIDTH_PERCENT)
      .height(188)
      .borderRadius(16)
      .backgroundColor('rgba(0,0,0,0.7)')
      .justifyContent(FlexAlign.Center)
      .margin({ bottom: $r('app.string.p_24') });

      Row() {
        Text($r(`app.string.camera`))
          .fontColor($r('app.color.text_color_3'))
          .fontSize($r('app.string.font_16'));
      }.width('100%').margin({ bottom: $r('app.string.p_24') });

      Row() {
        Text($r(`app.string.coordinate_name`))
          .fontColor($r('app.color.text_color_4'))
          .fontSize($r('app.string.font_14'));

        Text($r('app.string.Coordinate_Name1'))
          .fontColor($r('app.color.text_color_3'))
          .fontSize($r('app.string.font_14'));
      }.justifyContent(FlexAlign.SpaceBetween).width('100%').padding({ bottom: $r('app.string.p_16') })
      .border({
        width: { bottom: 1 },
        color: { bottom: '#ececec' },
      });

      Row() {
        Text($r(`app.string.coordinate_axis`))
          .fontColor($r('app.color.text_color_4'))
          .fontSize($r('app.string.font_14'));

        Row() {
          Text() {
            Span($r(`app.string.level`));
            Span('11');
          }
          .fontColor($r('app.color.text_color_3'))
          .fontSize($r('app.string.font_14'));

          Text() {
            Span($r(`app.string.pitching`));
            Span('11');
          }
          .fontColor($r('app.color.text_color_3'))
          .fontSize($r('app.string.font_14'));

          Text() {
            Span($r(`app.string.focal_num`));
            Span('11');
          }
          .fontColor($r('app.color.text_color_3'))
          .fontSize($r('app.string.font_14'));
        };
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding({ bottom: $r('app.string.p_16'), top: $r('app.string.p_16') })
      .border({
        width: { bottom: 1 },
        color: { bottom: '#ececec' },
      });

      Row() {
        Text($r(`app.string.alarm_information`))
          .fontColor($r('app.color.text_color_4'))
          .fontSize($r('app.string.font_14'));

        Text($r('app.string.Coordinate_Name1'))
          .fontColor($r('app.color.text_color_3'))
          .fontSize($r('app.string.font_14'));
      }.justifyContent(FlexAlign.SpaceBetween).width('100%').padding({ top: $r('app.string.p_16') });
    }.height('100%').width('100%').padding($r('app.string.p_12'));
  }

  // 生产设备
  @Builder
  productionEquipmentBuild() {
    Column() {
      Row() {
        Image($r('app.media.ic_public_back'))
          .width($r('app.string.icon_width'))
          .height($r('app.string.icon_height'));

        Flex({
          direction: FlexDirection.Column,
          justifyContent: FlexAlign.End,
        }) {
          Row({ space: 12 }) {
            Row() {
              Image($r('app.media.zoom'))
                .width(16)
                .height(16);
            }
            .width(28)
            .height(28)
            .borderRadius(28)
            .justifyContent(FlexAlign.Center)
            .backgroundColor('rgba(0,0,0,0.5)');
          }
          .padding({ right: $r('app.string.p_12'), bottom: $r('app.string.p_12') })
          .justifyContent(FlexAlign.End)
          .width('100%')
          .height(30);
        }.position({ x: 0, y: 0 });
      }
      .offset({ x: 0, y: 0 })
      .width(CommonConstants.FULL_WIDTH_PERCENT)
      .height(188)
      .borderRadius(16)
      .backgroundColor('rgba(0,0,0,0.7)')
      .justifyContent(FlexAlign.Center)
      .margin({ bottom: $r('app.string.p_12') });

      Row() {
        Row({ space: 6 }) {
          Text($r('app.string.Call_police')).fontColor($r('app.color.text_color_9'))
            .fontSize($r('app.string.font_14'));

          Text($r('app.string.External_Fault')).fontColor($r('app.color.text_color_1'))
            .fontSize($r('app.string.font_14'));
        };

        Button($r('app.string.view_details'))
          .width(72)
          .height(24)
          .backgroundColor('#ff4747')
          .fontColor($r('app.color.equipment_img_bg'))
          .onClick(() => this.succ());
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .height(40)
      .borderRadius(16)
      .padding({
        left: $r('app.string.p_12'),
        right: $r('app.string.p_12'),
        top: $r('app.string.p_6'),
        bottom: $r('app.string.p_6')
      })
      .margin({ bottom: $r('app.string.p_12') })
      .linearGradient({
        direction: GradientDirection.Right, // 渐变方向
        colors: [['rgba(255,71,71,0.2)', 0.0], ['rgba(255, 71, 71, 0)', 0.6]]
      });

      Flex() {
        ForEach(this.productionInformation, (item: IProductionInformation) => {
          Column({ space: 6 }) {
            Row() {
              Text(item.value || '')
                .fontColor($r('app.color.text_color_3'))
                .fontSize($r('app.string.font_14'));
            };

            Row({ space: 4 }) {
              Image(item.icon)
                .width($r('app.string.card_border_radius'))
                .width($r('app.string.card_border_radius'));

              Text(item.label || '')
                .fontColor($r('app.color.text_color_3'))
                .fontSize($r('app.string.font_14'));
            };
          }
          .justifyContent(FlexAlign.Center)
          .width('100%')
          .height('100%');
        });
      }
      .width('100%')
      .height(72)
      .borderRadius(16)
      .backgroundColor($r('app.color.equipment_img_bg'))
      .margin({ bottom: $r('app.string.p_24') });

      Row() {
        Text($r(`app.string.distributed_camera`)).fontColor($r('app.color.text_color_1'))
          .fontSize($r('app.string.font_14'));
      }.width('100%').margin({ bottom: $r('app.string.p_12') });

      List({ space: 8, initialIndex: 0 }) {
        ForEach(this.distributedCameraList, (item: DistributedCameraList) => {
          ListItem() {
            Row() {
              Text(item.name || '')
                .fontColor(this.distributedCameraId == item.id ? $r('app.color.operation_bg') :
                $r('app.color.text_color_3'))
                .fontSize($r('app.string.font_14'));
            };
          }
          .width(82)
          .height('100%')
          .borderRadius(20)
          .backgroundColor($r('app.color.equipment_img_bg'))
          .onClick(() => {
            this.distributedCameraId = item.id;
          });
        });
      }
      .listDirection(Axis.Horizontal) // 设置滚动方向为横向滚动
      .scrollBar(BarState.Off)
      .margin({ bottom: $r('app.string.p_12') })
      .width('100%')
      .height(40);


      Row() {
        Image($r('app.media.ic_public_back'))
          .width($r('app.string.icon_width'))
          .height($r('app.string.icon_height'));


        Flex({
          direction: FlexDirection.Column,
          justifyContent: FlexAlign.End,
        }) {
          Row() {
            Row() {
              Image($r('app.media.set_white'))
                .width(16)
                .height(16);
            }
            .width(28)
            .height(28)
            .borderRadius(28)
            .justifyContent(FlexAlign.Center)
            .backgroundColor('rgba(0,0,0,0.5)')
            .onClick(() => this.isCameraDetailsShow = true);
          }
          .padding({ right: $r('app.string.p_12'), bottom: $r('app.string.p_12') })
          .justifyContent(FlexAlign.End)
          .width('100%')
          .height(30);
        }.position({ x: 0, y: 0 });
      }
      .offset({ x: 0, y: 0 })
      .width(CommonConstants.FULL_WIDTH_PERCENT)
      .height(188)
      .borderRadius(16)
      .backgroundColor('rgba(0,0,0,0.7)')
      .justifyContent(FlexAlign.Center)
      .bindSheet($$this.isCameraDetailsShow, this.modifySceneIconBuilder(), {
        height: 417,
        blurStyle: BlurStyle.Thick,
        showClose: false,
        preferType: SheetType.CENTER,
        onWillDismiss: ((dismissSheetAction: DismissSheetAction) => {
          if (dismissSheetAction.reason == DismissReason.SLIDE_DOWN) {
            dismissSheetAction.dismiss(); //注册dismiss行为
          } else if (dismissSheetAction.reason == DismissReason.TOUCH_OUTSIDE) {
            this.isCameraDetailsShow = false;
          }
        }),
        onWillSpringBackWhenDismiss: ((springBackAction: SpringBackAction) => {
          //没有注册springBack, 下拉半模态页面无回弹行为
          springBackAction.springBack();
        }),
      });
    };
  }

  // 故障管理
  @Builder
  faultManagement() {
    Column() {
      Row({ space: 6 }) {
        Row() {
          Row() {
            Text(this.masterUnitData.label || '')
              .fontColor('rgba(0,0,0,0.9')
              .fontSize($r('app.string.font_16'))
              .width(50)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1);

            Text('/');

            Text(this.featureData.label || '')
              .width(50)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
              .fontColor('rgba(0,0,0,0.9')
              .fontSize($r('app.string.font_16'));
          };

          Image($r('app.media.caret_down'))
            .width(16)
            .height(16);
        }
        .height(40)
        .width(158)
        .borderRadius(20)
        .backgroundColor('rgba(0,0,0,0.05)')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12') })
        .onClick(() => {
          this.isCompositeUnitShow = true;
        })
        .bindSheet($$this.isCompositeUnitShow, this.compositeUnitBuilder(), {
          height: 770,
          blurStyle: BlurStyle.Thick,
          showClose: false,
          preferType: SheetType.CENTER,
          onWillDismiss: ((dismissSheetAction: DismissSheetAction) => {
            if (dismissSheetAction.reason == DismissReason.SLIDE_DOWN) {
              dismissSheetAction.dismiss(); //注册dismiss行为
            } else if (dismissSheetAction.reason == DismissReason.TOUCH_OUTSIDE) {
              this.isCompositeUnitShow = false;
            }
          }),
          onWillSpringBackWhenDismiss: ((springBackAction: SpringBackAction) => {
            //没有注册springBack, 下拉半模态页面无回弹行为
            springBackAction.springBack();
          }),
        });

        Row() {
          Text() {
            Span(this.selectInformationTypeData.label || '选择信息类型');
          }
          .fontColor('rgba(0,0,0,0.9')
          .fontSize($r('app.string.font_16'))
          .width(90)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1);

          Image($r('app.media.caret_down'))
            .width(16)
            .height(16);
        }
        .height(40)
        .width(124)
        .borderRadius(20)
        .backgroundColor('rgba(0,0,0,0.05)')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12') })
        .onClick(() => {
          this.isSelectInformationTypeShow = true;
        })
        .bindSheet($$this.isSelectInformationTypeShow, this.selectInformationTypeBuilder(), {
          height: 209,
          blurStyle: BlurStyle.Thick,
          showClose: false,
          preferType: SheetType.CENTER,
          onWillDismiss: ((dismissSheetAction: DismissSheetAction) => {
            if (dismissSheetAction.reason == DismissReason.SLIDE_DOWN) {
              dismissSheetAction.dismiss(); //注册dismiss行为
            } else if (dismissSheetAction.reason == DismissReason.TOUCH_OUTSIDE) {
              this.isSelectInformationTypeShow = false;
            }
          }),
          onWillSpringBackWhenDismiss: ((springBackAction: SpringBackAction) => {
            //没有注册springBack, 下拉半模态页面无回弹行为
            springBackAction.springBack();
          }),
        });

        Row() {
          Image($r('app.media.search'))
            .width(16)
            .height(16);
        }
        .height(40)
        .width(40)
        .borderRadius(20)
        .backgroundColor('rgba(0,0,0,0.05)')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12') });
      }.margin({ bottom: 12 });

      List({ space: 8, initialIndex: 0 }) {
        ForEach(this.alarmInformationList, (item: AlarmInformationList) => {
          ListItem() {
            Row() {
              Text(item.name || '')
                .fontColor(this.alarmInformationId == item.id ? $r('app.color.operation_bg') :
                $r('app.color.text_color_3'))
                .fontSize($r('app.string.font_14'));
            };
          }
          .width(82)
          .height('100%')
          .borderRadius(20)
          .backgroundColor(this.alarmInformationId == item.id ? '#ffffff' : '#e6e8ea')
          .onClick(() => {
            this.alarmInformationId = item.id;
          });
        });
      }
      .listDirection(Axis.Horizontal) // 设置滚动方向为横向滚动
      .scrollBar(BarState.Off)
      .margin({ bottom: $r('app.string.p_12') })
      .width('100%')
      .height(40);

      Column() {
        Refresh({ refreshing: $$this.isRefreshing, builder: this.getRefreshBuilder() }) {
          List({ space: 12, initialIndex: 0 }) {
            ForEach(this.faultManagementlist, (item: FaultManagementlist) => {
              ListItem() {
                Column() {
                  Row() {
                    Text(item.title || '')
                      .fontColor('#e84026')
                      .fontSize($r('app.string.font_14'));
                  }.width('100%').margin({ bottom: $r('app.string.p_16') });

                  Row() {
                    Row({ space: 6 }) {
                      Text($r('app.string.Device_number'))
                        .fontColor('rgba(102,102,102,1)')
                        .fontSize($r('app.string.font_14'));
                      Text(item.deviceNumber || '')
                        .fontColor('rgba(0,0,0,1)')
                        .fontSize($r('app.string.font_14'));
                    }.width('50%');

                    Row({ space: 6 }) {
                      Text($r('app.string.Type'))
                        .fontColor('rgba(102,102,102,1)')
                        .fontSize($r('app.string.font_14'));
                      Text(item.type || '')
                        .fontColor('rgba(0,0,0,1)')
                        .fontSize($r('app.string.font_14'));
                    }.width('50%');
                  }.margin({ bottom: $r('app.string.p_12') });

                  Row() {
                    Row({ space: 6 }) {
                      Text($r('app.string.Can_be_blocked'))
                        .fontColor('rgba(102,102,102,1)')
                        .fontSize($r('app.string.font_14'));
                      Text(item.maskable || '')
                        .fontColor('rgba(0,0,0,1)')
                        .fontSize($r('app.string.font_14'));
                    }.width('50%');

                    Row({ space: 6 }) {
                      Text($r('app.string.Invalid'))
                        .fontColor('rgba(102,102,102,1)')
                        .fontSize($r('app.string.font_14'));
                      Text(item.invalid || '')
                        .fontColor('rgba(0,0,0,1)')
                        .fontSize($r('app.string.font_14'));
                    }.width('50%');
                  };
                }.height('100%').width('100%');
              }
              .padding({
                left: $r('app.string.p_12'),
                right: $r('app.string.p_12'),
                top: $r('app.string.p_16'),
                bottom: $r('app.string.p_16')
              })
              .width('100%')
              .height(110)
              .borderRadius(16)
              .backgroundColor('#ffffff')
              .onClick(() => {
                this.alarmInformationId = item.id;
              });
            });

            ListItem() {
              Row({ space: 8 }) {
                if (this.isLoadMore) {
                  Text($r('app.string.Loading'))
                    .fontSize(14)
                    .fontColor('#818181');
                  LoadingProgress()
                    .width(20)
                    .aspectRatio(1);
                }
                if (!this.haveData && !this.isLoadMore) {
                  Text($r('app.string.no_more_data'))
                    .fontSize(14)
                    .fontColor('#818181');
                }
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .margin(5);
            };
          }
          .listDirection(Axis.Vertical) // 设置滚动方向为横向滚动
          .scrollBar(BarState.Off)
          .width('100%')
          .height('100%')
          .onReachEnd(() => {
            // 如果还有数据，就触底加载更多
            if (this.haveData) {
              this.isLoadMore = true;
              this.getData();
            }
          });
        }.onStateChange(async (status: RefreshStatus) => {
          switch (status) {
            case RefreshStatus.Inactive:
              break;
            case RefreshStatus.Drag:
              this.refreshText = '继续往下拉';
              break;
            case RefreshStatus.OverDrag:
              this.refreshText = '松手加载';
              break;
            case RefreshStatus.Refresh:
              this.refreshText = '加载中';
              await this.getData();
              break;
            case RefreshStatus.Done:
              this.refreshText = '加载成功';
          }
        });
      }.layoutWeight(1);
    };
  }

  build() {
    Column() {
      Column() {
        Text(this.menuId == 'productionManagement' ? $r(`app.string.production_equipment`) :
        $r(`app.string.fault_management`)).fontColor($r('app.color.text_color_3'))
          .fontSize($r('app.string.font_20'));
      }.margin({ bottom: $r('app.string.p_20') });

      Column() {
        if (this.menuId == 'productionManagement') {
          this.productionEquipmentBuild();
        } else {
          this.faultManagement();
        }
      }
      .padding({ left: $r('app.string.p_24'), right: $r('app.string.p_24') })
      .layoutWeight(1);

      Column() {
        Flex() {
          ForEach(this.menuList, (item: MenuList) => {
            Column({ space: 6 }) {
              Image(item.icon)
                .width($r('app.string.icon_width'))
                .height($r('app.string.icon_height'))
                .fillColor(this.menuId == item.id ? $r('app.color.text_color_5') : $r('app.color.text_color_1'));

              Text(item.name || '')
                .fontColor(this.menuId == item.id ? $r('app.color.text_color_5') : $r('app.color.text_color_1'))
                .fontSize($r('app.string.font_14'));
            }
            .justifyContent(FlexAlign.Center)
            .width('100%')
            .height('100%')
            .onClick(() => this.menuId = item.id);
          });
        }
        .width('100%')
        .height(72)
        .backgroundColor('#f1f3f5')
        .shadow({
          radius: 1,
          color: 'rgba(0,0,0,0.1)',
          offsetY: -1,
          offsetX: 0
        });
      };

    }.width(CommonConstants.FULL_WIDTH_PERCENT)
    .layoutWeight(1);
  }
}