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
import SceneCardComponent from './SceneCardComponent';
import { SceneBean } from '../common/bean/SceneBean';
import { CommonConstants, Logger, PageViewUtils, Scene } from '@ohos/common';
import SceneModel from '../viewmodel/SceneModel';
import DeleteAlertDialog from '../view/DeleteAlertDialog';
import { SceneLibraryDataSource } from '../viewmodel/SceneLibraryManager';
import { ColorMetrics, LengthMetrics, router } from '@kit.ArkUI';

let TAG = 'SceneLibraryListComponent';

@Component
export default struct SceneLibraryListComponent {
  @Link sceneList: SceneLibraryDataSource;
  @Link currentIndex: number;
  @State currentDragSceneItem: Scene = {} as Scene;
  @State orientation: number = 0;
  @State isDrag: boolean = false;
  @State sceneId: string = '';
  @StorageLink('isUpdate') isUpdate: boolean = false;
  private deleteController: CustomDialogController = new CustomDialogController({
    builder: DeleteAlertDialog({
      onConfirm: () => {
        this.deleteScene(this.sceneId);
      }
    })
  });
  clickDetail: (id: string, type: number) => void = (id: string, type: number) => {
  };

  //交换数组中元素位置
  async changeIndex(index1: number, index2: number) {
    let sceneList: Scene[] = this.sceneList.getAllData() as Array<Scene>;
    let temp: Scene = sceneList[index1];
    sceneList[index1] = sceneList[index2];
    sceneList[index2] = temp;
    await SceneModel.getInstance().putPreference(sceneList);
    this.isUpdate = true;
  }

  // 置顶
  async setTopping(index: number) {
    let sceneList: Scene[] = this.sceneList.getAllData() as Array<Scene>;
    let temp: Scene = sceneList[index];
    sceneList.splice(index, 1);
    sceneList.unshift(temp);
    await SceneModel.getInstance().putPreference(sceneList);
    this.isUpdate = true;
  }

  // 计算组合设备数量
  computeDeviceNum(num1: number, num2: number) {
    return num1 + num2;
  }

  // 删除场景
  async deleteScene(id: string) {
    let sceneList: Scene[] = this.sceneList.getAllData() as Array<Scene>;
    sceneList = sceneList.filter((item: Scene) => {
      return item.scenarioCard.scenarioCardId != id;
    });
    await SceneModel.getInstance().putPreference(sceneList);
    this.deleteController.close();
    this.isUpdate = true;
  }

  // 获取场景卡片
  getIcon(type: number) {
    let icon: Resource = $r('app.media.ic_custom');
    switch (type) {
      case 1:
        icon = $r('app.media.ic_government_affairs');
        break;
      case 2:
        icon = $r('app.media.ic_traffic');
        break;
      case 3:
        icon = $r('app.media.ic_health_care');
        break;
      case 4:
        icon = $r('app.media.ic_education');
        break;
      case 5:
        icon = $r('app.media.ic_custom');
        break;
    }
    return icon;
  }

  aboutToAppear() {
    PageViewUtils.tabClick();
  }

  //拖拽过程中展示的样式
  @Builder
  pixelMapBuilder() {
    Column() {
      SceneCardComponent({
        icon: this.getIcon(2),
        name: this.currentDragSceneItem.scenarioCard.title,
        isEnabled: this.currentDragSceneItem.scenarioCard.enabled,
        content: '',
        deviceNum: this.computeDeviceNum(this.currentDragSceneItem.flow[0].actions.length,
          this.currentDragSceneItem.flow[0].trigger.events.length)
      });
    }
    .width('50%');
  }

  @Builder
  MenuBuilder(index: number, id: string) {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Center }) {
      Text($r('app.string.Topping'))
        .padding({ left: $r('app.string.p_12') })
        .width(CommonConstants.FULL_WIDTH_PERCENT)
        .lineHeight($r('app.string.menu_item_height'))
        .onClick(() => {
          this.setTopping(index);
        });
      Divider().strokeWidth(1).margin(5).color($r('app.color.dialog_divider_color'));
      Text($r('app.string.delete'))
        .padding({ left: $r('app.string.p_12') })
        .width(CommonConstants.FULL_WIDTH_PERCENT)
        .lineHeight($r('app.string.menu_item_height'))
        .onClick(() => {
          this.sceneId = id;
          this.deleteController.open();
        });
    }
    .width($r('app.string.menu_body_width'))
    .height($r('app.string.menu_body_height'));
  }

  build() {
    Column() {
      Grid(new Scroller()) {
        LazyForEach(this.sceneList, (item: Scene, index: number) => {
          GridItem() {
            if (this.currentIndex == 0) {
              SceneCardComponent({
                icon: this.getIcon(2),
                name: item.scenarioCard.title,
                content: '',
                isEnabled: item.scenarioCard.enabled,
                isFlag: true,
                deviceNum: item.scenarioCard.tag == 'custom' ?
                this.computeDeviceNum(item.flow[0].actions.length, item.flow[0].trigger.events.length) :
                this.computeDeviceNum(item.flow[0].actions[0].actions.length, item.flow[0].trigger.events.length),
                enableCallback: (value: boolean) => {
                  let sceneList: Scene[] = this.sceneList.getAllData() as Array<Scene>;
                  sceneList[index].scenarioCard.enabled = value;
                  SceneModel.getInstance().putPreference(sceneList);
                },
                onClickEvent: () => {
                  if (item.scenarioCard.tag == 'custom') {
                    this.clickDetail(item.scenarioCard.scenarioCardId, 0);
                  } else {
                    this.clickDetail(item.scenarioCard.scenarioCardId, 1);
                  }
                }
              })
                .bindContextMenu(this.MenuBuilder(index, item.scenarioCard.scenarioCardId), ResponseType.LongPress)
                .onTouch((event: TouchEvent) => {
                  if (event.type === TouchType.Down) {
                    this.currentDragSceneItem = item;
                  }
                });
            } else if (this.currentIndex == 1) {
              SceneCardComponent({
                icon: this.getIcon(2),
                name: item.scenarioCard.title,
                content: '',
                isEnabled: item.scenarioCard.enabled,
                isFlag: false,
                deviceNum: this.computeDeviceNum(item.flow[0].actions[0].actions.length,
                  item.flow[0].trigger.events.length),
                enableCallback: (value: boolean) => {
                },
                onClickEvent: () => {
                  if ((item.scenarioCard.title == '智慧隧道' ||
                    item.scenarioCard.title == 'Intelligent tunnel environment control') &&
                    item.scenarioCard.type == 'release') {
                    router.pushUrl({
                      url: 'pages/ovble/SmartTunnelScene'
                    }).catch((error: Error) => {
                      Logger.error(TAG, 'LauncherPage pushUrl error ' + JSON.stringify(error));
                    });
                  } else if ((item.scenarioCard.title == '医嘱执行' ||
                    item.scenarioCard.title == 'Execution of medical orders') && item.scenarioCard.type == 'release') {
                    router.pushUrl({
                      url: 'pages/OrderExecution/Login'
                    }).catch((error: Error) => {
                      Logger.error(TAG, 'LauncherPage pushUrl error ' + JSON.stringify(error));
                    });
                  } else {
                    this.clickDetail(item.scenarioCard.scenarioCardId, 1);
                  }
                }
              });
            }
          }
          .focusable(true)
          .focusBox({
            margin: LengthMetrics.px(2),
            strokeColor: ColorMetrics.resourceColor($r('app.color.text_color_white')),
            strokeWidth: LengthMetrics.px(2)
          })
          .id(`gridItem${index}`)
          .onHover(() => {
            this.getUIContext().getFocusController().requestFocus(`gridItem${index}`);
          });
        }, (item: SceneBean, index: number) => index + JSON.stringify(item));
      }
      .id('SceneLibraryList')
      .columnsTemplate(this.orientation == 0 ? '1fr 1fr' : '1fr 1fr 1fr 1fr 1fr 1fr')
      .columnsGap($r('app.string.p_12'))
      .rowsGap($r('app.string.p_12'))
      .width(CommonConstants.FULL_WIDTH_PERCENT)
      .supportAnimation(true)
      //设置Grid是否进入编辑模式，进入编辑模式可以拖拽Grid组件内部GridItem
      .editMode(this.isDrag)
      //第一次拖拽此事件绑定的组件时，触发回调
      .onItemDragStart((event: ItemDragInfo, itemIndex: number) => {
        //设置拖拽过程中显示的图片


      })
      //绑定此事件的组件可作为拖拽释放目标，当在本组件范围内停止拖拽行为时，触发回调
      //itemIndex为拖拽起始位置，insertIndex为拖拽插入位置
      .onItemDrop((event: ItemDragInfo, itemIndex: number, insertIndex: number, isSuccess: boolean) => {
        //不支持拖拽到已有内容以外的位置
        if (insertIndex < this.sceneList.totalCount()) {
          this.changeIndex(itemIndex, insertIndex);
        }
      })
      .margin({ left: $r('app.string.p_12'), right: $r('app.string.p_12') })
      .width('100%')
      .padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12'), top: 10 });
    };

  }
}