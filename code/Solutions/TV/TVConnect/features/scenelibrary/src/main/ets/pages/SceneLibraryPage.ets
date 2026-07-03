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
import SceneLibraryListComponent from '../view/SceneLibraryListComponent';
import EmptyPage from '../view/EmptyPage';
import SceneTabPage from '../view/SceneTabPage';
import TabsConfig from '../model/TabsConfig';
import { CommonConstants, Logger, PageViewUtils, Scene } from '@ohos/common';
import SceneModel from '../viewmodel/SceneModel';
import { SceneBean } from '../common/bean/SceneBean';
import {
  MySceneLibraryDataSource,
  SceneLibraryDataSource,
  SceneLibraryManager
} from '../viewmodel/SceneLibraryManager';
import { promptAction, router } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import SceneManager from '../viewmodel/SceneManager';
import { HMRouter } from '@hadss/hmrouter';

let TAG = 'SceneLibraryPage';

@HMRouter({ pageUrl: 'SceneLibraryPage', singleton: true, lifecycle: 'SceneLibraryPageLifecycle' })
@Component
export struct SceneLibraryPage {
  @State currentIndex: number = 0;
  @State isEmpty: boolean = true;
  @StorageLink('isUpdate') @Watch('updateChange') isUpdate: boolean = false;
  @StorageLink('mySceneList') mySceneList: Scene[] = [];
  // 检测设备横竖屏
  @State orientation: number = 1;
  @State sceneLibraryManager: SceneLibraryManager = SceneLibraryManager.getInstance();
  @StorageLink('isImport') isImport: boolean = false;
  @StorageLink('sceneList') sceneList: SceneBean[] = [];
  @State currentContentData: SceneLibraryDataSource = SceneLibraryManager.getInstance().currentContentData;
  @State myContentData: MySceneLibraryDataSource = SceneLibraryManager.getInstance().myContentData;
  addClick: (type: number, id?: string, isEdit?: boolean) => void = (type: number, id?: string, isEdit?: boolean) => {
    router.pushUrl({ url: 'pages/ScenePage', params: { type: type, id: id, isEdit: isEdit } });
  };

  async aboutToAppear() {
    let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    //初始化操作
    SceneManager.init(context);
    await SceneModel.getInstance().getPreferencesFromStorage();
    if (SceneModel.getInstance().hasPreference()) {
      this.mySceneList = SceneModel.getInstance().getPreference();
      this.myContentData.initData(this.mySceneList);
      Logger.info(TAG, 'this.mySceneList:' + JSON.stringify(this.mySceneList));
      this.currentIndex = this.mySceneList.length == 0 ? 1 : 0;
      this.isEmpty = this.mySceneList.length == 0 ? true : false;
    } else {
      this.isEmpty = true;
    }

    PageViewUtils.tabClick();
  }

  toast(msg: string | Resource) {
    promptAction.showToast({
      message: msg,
      duration: 2000,
      bottom: '160vp'
    });
  }

  updateChange() {
    if (this.isUpdate) {
      if (SceneModel.getInstance().hasPreference()) {
        this.mySceneList = SceneModel.getInstance().getPreference();
        this.myContentData.initData(this.mySceneList);
        this.currentIndex = this.mySceneList.length == 0 ? 1 : 0;
        this.isEmpty = this.mySceneList.length == 0 ? true : false;
      } else {
        this.isEmpty = true;
      }
      this.isUpdate = false;
    }
  }

  build() {
    Column() {
      SceneTabPage({
        tabItems: TabsConfig.tabItems,
        currentIndex: this.currentIndex,
        changeTab: (tab: number) => {
          this.currentIndex = tab;
        },
        addClick: () => {
          if (this.mySceneList.length >= 50) {
            this.toast($r('app.string.add_limited_tip'));
            return;
          } else {
            this.addClick(0);
          }
        }
      });
      Row() {
        if (this.currentIndex == 0) {
          if (this.isEmpty && this.mySceneList.length === 0) {
            EmptyPage({
              addClick: (type: number) => {
                if (type == 1) {
                  this.currentIndex = 1;
                } else {
                  this.addClick(0);
                }
              }
            });
          } else {
            SceneLibraryListComponent({
              sceneList: $myContentData,
              orientation: this.orientation,
              currentIndex: $currentIndex,
              isDrag: true,
              clickDetail: (id: string, type) => {
                if (type == 1) {
                  this.addClick(1, id, true);
                } else {
                  this.addClick(4, id, true);
                }
              }
            });
          }
        } else {
          SceneLibraryListComponent({
            sceneList: $currentContentData,
            orientation: this.orientation,
            currentIndex: $currentIndex,
            isDrag: false,
            clickDetail: (id: string, type) => {
              if (this.mySceneList.length >= 50) {
                this.toast($r('app.string.add_limited_tip'));
                return;
              } else {
                this.addClick(1, id, false);
              }
            }
          });
        }
      }
      .width(CommonConstants.FULL_WIDTH_PERCENT)
      .layoutWeight(1);
    }
    .padding({ top: $r('app.string.default_page_padding'), bottom: $r('app.string.default_page_padding') })
    .backgroundColor($r('app.color.page_background'));
  }

  @Builder
  TabBuilder(index: number, name: string | Resource) {
    Column() {
      Text(name)
        .fontColor(this.currentIndex === index ? $r('app.color.scene_tab_select_color') :
        $r('app.color.scene_tab_color'))
        .fontSize(this.currentIndex === index ? $r('app.string.font_20') : $r('app.string.font_16'))
        .lineHeight($r('app.string.line_22'));
    }
    .height('56vp')
    .justifyContent(FlexAlign.Center);
  }
}