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
import launcherBundleManager from '@ohos.bundle.launcherBundleManager';
import { BusinessError } from '@ohos.base';
import inputConsumer from '@ohos.multimodalInput.inputConsumer';
import CustomDialogExample from '../components/CustomDialog';
import StoreAppList from '../common/utils/Storage';
import { headerBar } from '../view/HeaderBar';
import { gridList } from '../view/GridList';
import emitter from '@ohos.events.emitter';
import FilterAppList from '../components/FilterApp';
import display from '@ohos.display';
import { common } from '@kit.AbilityKit';
import CommonEvent from '@ohos.commonEventManager';
import { inputEventClient, KeyCode } from '@kit.InputKit';
import { EventUtil } from '../common/utils/EventUtil';
import App from '@system.app';
import { Logger } from '../Utils/Logger';

// import display from '@ohos.display';

const TAG = 'applicationManager';
const CURRENT_ID = 100;
const ADD_DOCKER_SHORTCUTS: string = 'ADD_DOCKER_SHORTCUTS';
const REMOVE_DOCKER_SHORTCUTS: string = 'REMOVE_DOCKER_SHORTCUTS';

interface AppList {
  icon: ResourceStr;
  label: string;
  installSource?: string,
  element: Element,
  installTime: number,
  moduleName: string,
  labelId: number,
  iconId: number
}

class Element {
  public bundleName: string = '';
  public abilityName: string = '';
}

interface Element1 {
  bundleName: string;
  abilityName: string;
}

let menuKey = 2067;
let tabKey = 2090;
let keyOptions: inputConsumer.KeyOptions = {
  preKeys: [],
  finalKey: tabKey,
  isFinalKeyDown: true,
  finalKeyDownDuration: 0
};
let keyOptionsMenu: inputConsumer.KeyOptions = {
  preKeys: [],
  finalKey: menuKey,
  isFinalKeyDown: false,
  finalKeyDownDuration: 1000
};

@Entry
@Component
struct Index {
  //变量定义区域
  private infoList: Array<launcherBundleManager.LauncherAbilityInfo> = [];
  @State appList: Array<AppList> = [];
  @State focusIndex: number = 0;
  @State temp: number = 0;
  @State arrowXPos: number = 0;
  @State ifMove: string = 'false';
  @State flag: boolean = false;
  @State bigScreen: boolean = false;
  private hasFirstPageShowHandled: boolean = false;
  @State dialogPostion: number[] = [111, 184.5];
  @State
  dialogCanceled: boolean = true;
  @State startAbilityBundle: boolean = true;
  // 弹窗
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogExample({
      cancel: () => {
        this.dialogCanceled = true;
      },
      confirm: () => {
      },
      appList: this.appList,
      focusIndex: this.focusIndex,
      ifMove: this.ifMove,
      arrowXPos: this.arrowXPos,
      dialogPostion: this.dialogPostion
    }),
    cancel: this.dialogCancel,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    isModal: true,
    customStyle: true,
    cornerRadius: 10,

  });

  dialogCancel() {
    this.dialogCanceled = true;
  }

  //点击空白区域退出弹窗
  existApp() {
    Logger.info('Click the callback in the blank area');
  }

  // 退出时杀死自身进程
  onBackPress(): boolean | void {
    if (this.ifMove === 'true') {
      emitter.emit('exitMoveMode');
      return true;
    } else {
      (getContext(this) as common.UIAbilityContext).terminateSelf();
    }
  }

  // 获取全部应用
  getAllAppList() {
    launcherBundleManager.getAllLauncherAbilityInfo(CURRENT_ID)
      .then((infoList): Promise<void> => {
        this.infoList = infoList;
        return this.getAppInfo(infoList);
      })
      .catch((err: BusinessError) => {
        Logger.info(TAG, 'getAllLauncherAbilityInfo fail, err: ' + JSON.stringify(err));
      });
  }

  //系统接口删除应用
  //组合键监听功能
  compareKey() {
    let callback = (keyOptions: inputConsumer.KeyOptions) => {
      this.flag = true;
      if (this.dialogCanceled && this.dialogController != null && this.ifMove == 'false' && this.appList.length) {
        try {
          // 安全地获取对话框位置
          const bundleName = this.appList[this.focusIndex]?.element?.bundleName;
          if (bundleName) {
            this.dialogPostion = this.getRect(bundleName);
            Logger.info(`Dialog position set to: [${this.dialogPostion[0]}, ${this.dialogPostion[1]}] for ${bundleName}`);
          } else {
            Logger.info('Warning: bundleName is undefined, using default dialog position');
            this.dialogPostion = [0, 0]; // 使用默认位置
          }

          this.dialogCanceled = false;
          this.dialogController.open();
        } catch (error) {
          Logger.info(`Error in callback`);
          // 即使出错，也确保对话框能正常显示
          this.dialogPostion = [0, 0];
          this.dialogCanceled = false;
          this.dialogController.open();
        }
      }
    };
    try {
      inputConsumer.on('key', keyOptions, callback);
      inputConsumer.on('key', keyOptionsMenu, callback);
    } catch (error) {
      Logger.info(`Subscribe failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
    }
  }

  getRect(componentId: string): Array<number> {
    try {
      let componentJson = getInspectorByKey(componentId);

      // 验证返回的JSON字符串是否有效
      if (!componentJson || typeof componentJson !== 'string') {
        Logger.info(`getRect: Invalid componentJson for ${componentId}, using default position`);
        return [0, 0]; // 返回默认位置
      }

      // 清理可能的异常字符
      componentJson = componentJson.trim();

      // 验证是否为有效的JSON格式
      if (!componentJson.startsWith('{') || !componentJson.endsWith('}')) {
        Logger.info(`getRect: Invalid JSON format for ${componentId}: ${componentJson}`);
        return [0, 0]; // 返回默认位置
      }

      let obj: Record<string, string> = {};

      try {
        obj = JSON.parse(componentJson);
      } catch (e) {
        Logger.info(`JSON.parse error: ${e}`);
      }

      // 验证obj.$rect是否存在
      if (!obj.$rect) {
        Logger.info(`getRect: $rect property not found for ${componentId}`);
        return [0, 0]; // 返回默认位置
      }

      let r: string = this.replaceAll(obj.$rect, ' ', '');
      r = this.replaceAll(r, '][', ',');
      r = this.replaceAll(r, '[', '');
      r = this.replaceAll(r, ']', '');
      let rectInfo: string[] = r.split(',');

      // 验证解析结果
      if (rectInfo.length < 2) {
        Logger.info(`getRect: Invalid rect format for ${componentId}: ${obj.$rect}`);
        return [0, 0]; // 返回默认位置
      }

      const x = px2lpx(parseFloat(rectInfo[0]));
      const y = px2lpx(parseFloat(rectInfo[1]));

      // 验证解析的数值是否有效
      if (isNaN(x) || isNaN(y)) {
        Logger.info(`getRect: Invalid coordinate values for ${componentId}: x=${x}, y=${y}`);
        return [0, 0]; // 返回默认位置
      }

      return [x, y];

    } catch (error) {
      Logger.info(`getRect: JSON parse error for ${componentId}: ${JSON.stringify(error)}`);
      return [0, 0]; // 返回默认位置，避免崩溃
    }
  }

  replaceAll(str: string, searchValue: string, replaceValue: string): string {
    while (str.includes(searchValue)) {
      str = str.replace(searchValue, replaceValue);
    }
    return str;
  }

  onPageHide(): void {
    inputConsumer.off('key', keyOptions);
    inputConsumer.off('key', keyOptionsMenu);
    this.dialogController?.close();
  }

  onPageShow(): void {
    this.compareKey();
    if (!this.hasFirstPageShowHandled) {
      this.hasFirstPageShowHandled = true;
      return;
    }
    // 页面重新回到前台时刷新应用列表，确保商店安装后能立即显示新应用
    this.showState = true;
    this.getAllAppList();
  }

  //进入组件
  aboutToAppear() {
    let dis = display.getDefaultDisplaySync();
    if (dis.width > 1920) {
      Logger.info('HmLog-->', '屏幕宽度为3840');
      this.bigScreen = true;
    } else {
      Logger.info('HmLog-->', '屏幕宽度为1920');

      this.bigScreen = false;
    }
    this.ifMove = 'false';
    Logger.info(TAG + 'aboutToAppear');

    interface dataP {
      appList: Array<AppList>;
    }

    emitter.on(('closeDialog'), () => {
      this.compareKey();
      this.dialogController?.close();
      this.dialogCanceled = true;
    });

    emitter.on('unInstallApp', (data) => {

      if (this.focusIndex == this.appList.length) {
        this.focusIndex = this.focusIndex - 1 >= 0 ? this.focusIndex - 1 : 0;
      }
      this.appList = (data as dataP).appList;
    });

    emitter.on('addShortcuts', (data) => {
      let bundleName: string = String(data.data);
      Logger.info(TAG, 'add_shortcuts ' + bundleName);
      CommonEvent.publish(ADD_DOCKER_SHORTCUTS, { data: bundleName }, (error) => {
        if (!error) {
          (getContext(this) as common.UIAbilityContext).terminateSelf();
        }
      });
    });

    // after uninstall ,requir notify launcher remove the shortcuts
    emitter.on('removeShotcuts', (data) => {
      let bundleName: string = String(data.data);
      Logger.info(TAG, 'removeShotcuts ' + bundleName);
      CommonEvent.publish(REMOVE_DOCKER_SHORTCUTS, { data: bundleName }, (error) => {
        if (!error) {
          Logger.info(TAG, 'removeShotcuts sucess');
        }
      });
    });

    emitter.on('menuEvent', (data) => {
      if (data.data) {
        inputConsumer.off('key', keyOptions);
        inputConsumer.off('key', keyOptionsMenu);
        this.dialogController?.close();
      }
    });
    EventUtil.changePointStyle(false);

    this.getAllAppList();
  }

  // 获取历史排序
  orderList(tempList: Array<Element1>, sortedAppList: Array<AppList>): Array<AppList> {
    let appTempList: AppList[] = [];
    tempList.forEach((item) => {
      let obj = sortedAppList.find(e => JSON.stringify(e.element) === JSON.stringify(item));
      appTempList.push(obj as AppList);
      sortedAppList = sortedAppList.filter(e => JSON.stringify(e.element) !== JSON.stringify(item));
    });
    let resultAppList = [...appTempList, ...sortedAppList];
    resultAppList = resultAppList.filter(item => item != null && item != undefined);
    return resultAppList;
  }

  //初始化数据
  async getAppInfo(applist: Array<launcherBundleManager.LauncherAbilityInfo>) {
    let curAppInfo: launcherBundleManager.LauncherAbilityInfo;
    let tempList: AppList[] = [];
    const uniqueElementSet: Set<string> = new Set<string>();
    for (let i = 0; i < this.infoList.length; i++) {
      curAppInfo = this.infoList[i];
      if (curAppInfo.elementName.bundleName === 'com.ohos.adminprovisioning' ||
        curAppInfo.elementName.bundleName === 'com.samples.applicationmanager') {
        continue;
      }

      let appInfo: AppList =
        {
          element: { bundleName: '', abilityName: '' },
          label: '',
          icon: '',
          installSource: '',
          installTime: 0,
          labelId: curAppInfo.labelId,
          iconId: curAppInfo.iconId,
          moduleName: ''
        };
      appInfo.element.abilityName = curAppInfo.elementName.abilityName;
      appInfo.moduleName = curAppInfo.elementName.moduleName!;
      appInfo.element.bundleName = curAppInfo.elementName.bundleName;
      appInfo.installTime = curAppInfo.installTime;
      let appFilter = new FilterAppList();
      //过滤多余应用
      if (appFilter.handleFilter(JSON.stringify(appInfo.element))) {
        const uniqueKey = `${appInfo.element.bundleName}::${appInfo.element.abilityName}::${appInfo.moduleName}`;
        if (uniqueElementSet.has(uniqueKey)) {
          continue;
        }
        uniqueElementSet.add(uniqueKey);
        tempList.push(appInfo);
      }
    }
    tempList.sort((a, b) => {
      const timeA = a.installTime;
      const timeB = b.installTime;
      return timeA - timeB;
    });
    let storageList = new StoreAppList(getContext());
    let storageAppList = await storageList.getAppList();
    if (tempList.length === 0) {
      this.appList = [];
    } else if (storageAppList.length === 0) {
      this.appList = [...tempList];
    } else {
      this.appList = this.orderList(storageAppList, tempList);
    }
    setTimeout(() => {
      this.showState = false;
    }, 0);
    AppStorage.setOrCreate('time', (new Date()).getTime());
  }

  @State showState: boolean = true;

  //UI代码块
  build() {
    Column() {
      headerBar();
      Stack() {
        if (this.showState) {
          Column()
            .width('1804lpx')
            .height('912lpx').zIndex(1).backgroundColor('#18181A');
        }
        gridList({
          allList: this.appList,
          ifMove: this.ifMove,
          focusIndex: this.focusIndex,
          bigScreen: this.bigScreen,
          arrowXPos: this.arrowXPos,
          startAbilityBundle: this.startAbilityBundle,
          longPressAction: () => {
            this.flag = true;
            if (this.dialogCanceled && this.dialogController != null && this.ifMove == 'false' && this.appList.length) {
              try {
                // 安全地获取对话框位置
                const bundleName = this.appList[this.focusIndex]?.element?.bundleName;
                if (bundleName) {
                  this.dialogPostion = this.getRect(bundleName);
                  Logger.info(`===Dialog position set to: [${this.dialogPostion[0]}, ${this.dialogPostion[1]}] for ${bundleName}`);
                } else {
                  Logger.info('===Warning: bundleName is undefined, using default dialog position');
                  this.dialogPostion = [0, 0]; // 使用默认位置
                }

                this.dialogCanceled = false;
                this.dialogController.open();
              } catch (error) {
                Logger.info(`===Error in callback`);
                // 即使出错，也确保对话框能正常显示
                this.dialogPostion = [0, 0];
                this.dialogCanceled = false;
                this.dialogController.open();
              }
            }
          }
        }).focusable(true);
      };
    }
    .height('100%')
    .width('100%')
    .focusable(true)
    .backgroundColor('#18181A')
    .onTouch((event) => {
      EventUtil.isTouchEvent(event);
    });

  }
}