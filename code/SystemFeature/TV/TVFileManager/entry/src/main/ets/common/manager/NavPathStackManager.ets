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
import { promptAction } from '@kit.ArkUI';
import { FileBean } from '../../component/bean/FileBean';
import { MLog } from '../utils/MLog';
import { HashMap } from '@kit.ArkTS';
import { DeviceType } from '../data/DeviceType';
import { PageType } from '../../model/PageType';

const TAG = 'NavPathStackManager';
const navPathStackTag = 'NavPathStackTag';

export const focusIdTag = 'FocusIdTag';

export const HOME_NAME = 'HOME';

enum SelectMode {
  None,
  Copy,
  Move
}

export type StatusListener = (isSelectMode: boolean) => void;

interface PathName { name: string; };

interface PathInfo {
  name: string,
  uri?: string;
  relativePath?: string;
  pageType: PageType;
  rootRelativePath?: string;
};

export class NavStack {
  private device: DeviceType = DeviceType.Local;
  private selectMode: SelectMode = SelectMode.None;
  private stateLisArr: StatusListener[] = [];
  private pathList: HashMap<DeviceType, PathName[]> = new HashMap();
  private bakNavPathMap: HashMap<DeviceType, PathInfo[]> = new HashMap();
  private externalActive: boolean = false;
  private backPressObs: Array<() => boolean | void> = [];

  public static getIns(): NavStack {
    let ins = AppStorage.get<NavStack>(navPathStackTag);
    if (!ins) {
      ins = new NavStack();
      AppStorage.setOrCreate<NavStack>(navPathStackTag, ins);
    }
    return ins;
  }

  public static setFocusId(name: string) {
    AppStorage.set(focusIdTag, name);
  }

  constructor() {
    this.pathList.set(DeviceType.Local, []);
    this.pathList.set(DeviceType.USB, []);
    this.bakNavPathMap.set(DeviceType.Local, []);
    this.bakNavPathMap.set(DeviceType.USB, []);
  }

  public regBackPressFun(fun: () => boolean | void) {
    fun && this.backPressObs.push(fun);
  }

  public unregBackPressFun(fun: () => boolean | void) {
    let index = this.backPressObs.indexOf(fun);
    if (index >= 0) {
      this.backPressObs.splice(index);
    }
  }

  public onBackPress(): boolean {
    for (let fun of this.backPressObs) {
      if (fun()) {
        return true;
      }
    }
    return false;
  }

  public clear() {
    this.device = 0;
    this.clearStack();
  }

  private clearStack() {
    this.pathList.set(DeviceType.Local, []);
    this.pathList.set(DeviceType.USB, []);
    this.bakNavPathMap.set(DeviceType.Local, []);
    this.bakNavPathMap.set(DeviceType.USB, []);
  }

  public set isShowHomePage(value: boolean) {
    AppStorage.set('isShowHomePage', value);
  }

  private showWarning(msg: string | ResourceStr) {
    promptAction.showToast({
      message: msg,
      duration: 1000
    });
  }

  public setDevice(dev: number) {
    if (dev <= DeviceType.USB) {
      this.device = dev;
      if (this.curNavPathInfo) {
        MLog.print(TAG, `setDevice dev:${this.device} pagename:${this.curNavPathInfo?.name} `);
        if (this.device === DeviceType.Local && this.isSelectMod() && this.curNavPathInfo?.name.startsWith(HOME_NAME)) {
          MLog.warn(TAG, `setDevice jump local root page`);
          //选择模式直接进入根目录
          this.pushRoot(PageType.ROOT_PAGE);
        } else {
        }
      } else {
        if (this.isExternal() && this.device == DeviceType.USB) {
          this.pushRoot(PageType.EXTERNAL_USB_PAGE);
        } else {
          this.pushRoot(PageType.HOME_PAGE);
        }
      }
      this.callRefresh();
    }

  }

  public isExternal(): boolean {
    return this.externalActive;
  }

  public getDevice(): number {
    return this.device;
  }

  public isSelectMod(): boolean {
    return this.selectMode != SelectMode.None;
  }

  public checkBackPress(): boolean {
    MLog.print(TAG, `checkBackPress dev:${this.device} curBakNavPath.length:${this.curBakNavPath.length} `);
    if (this.device == DeviceType.Local && this.isSelectMod()) {
      return this.curBakNavPath.length > 2;
    }
    return this.curBakNavPath.length > 1;
  }

  public isExitApp(): boolean {
    MLog.print(TAG, `isExitApp dev:${this.device} curBakNavPath.length:${this.curBakNavPath.length} `);
    if (this.isSelectMod()) {
      return false;
    }
    return this.curBakNavPath.length == 1;
  }

  public addStatusLis(lis: StatusListener) {
    this.stateLisArr.push(lis);
  }

  public removeStatusLis(lis: StatusListener) {
    let index = this.stateLisArr.indexOf(lis);
    if (index >= 0) {
      this.stateLisArr.splice(index);
    }
  }

  private callRefresh() {
    this.stateLisArr.forEach(it => it(this.isSelectMod()));
  }

  public setCopyMode() {
    this.selectMode = SelectMode.Copy;
    this.callRefresh();
  }

  public setMoveMode() {
    this.selectMode = SelectMode.Move;
    this.callRefresh();
  }


  public closeSelectMode() {
    this.selectMode = SelectMode.None;
  }

  public isCopy(): boolean {
    return this.selectMode == SelectMode.Copy;
  }

  public isMove(): boolean {
    return this.selectMode == SelectMode.Move;
  }

  closeUSB() {
    this.bakNavPathMap.set(DeviceType.USB, []);
    this.pathList.set(DeviceType.USB, []);
    this.externalActive = false;
    this.callRefresh();
  }

  openUSB() {
    this.externalActive = true;
  }

  pushRoot(value: PageType) {
    let type = value;
    if (type == PageType.EXTERNAL_USB_PAGE) {
      this.externalActive = true;
    }
    if (type == PageType.HOME_PAGE) {
      this.clearStack();
      MLog.print(TAG, `clear stack!`);
    }
    this.pushPath(type);
  }

  pushBean(bean: FileBean) {
    if (bean) {
      this.pathList.get(this.device).push({ name: bean.getPath() });
      this.pushPath(`${this.device}-${bean.name}`, bean);
    }
  }

  private pushPath(name: string, bean?: FileBean) {
    MLog.print(TAG, `pushPath name:${name} bean:${JSON.stringify(bean)}`);
    //初始化时会直接push usb的路径进来
    let curType: DeviceType = this.device;
    if (name === PageType.EXTERNAL_USB_PAGE) {
      curType = DeviceType.USB;
    }
    let info: PathInfo = {
      name: name,
      pageType: name as PageType,
      uri: bean?.getPath(),
      relativePath: bean?.relativePath,
      rootRelativePath: bean?.isRoot ? bean?.relativePath : this.curPageInfo?.rootRelativePath
    };
    this.bakNavPathMap.get(curType).push(info);
    MLog.print(TAG, `pushPath info:${JSON.stringify(info)}`);
    MLog.warn(TAG,
      `bakNavPathMap curType:${curType} info:${info.name} bak:${this.bakNavPathMap.get(curType).map(it => it.name)} `);

    this.callRefresh();
  }

  getPathListNames(): string[] {
    return this.pathList.get(this.device).map(it => it.name);
  }

  get curPageInfo(): PathInfo {
    return this.curNavPathInfo;
  }


  private get curBakNavPath(): PathInfo[] {
    return this.bakNavPathMap.get(this.device);
  }

  private get curNavPathInfo(): PathInfo {
    let nav = this.curBakNavPath;
    if (nav.length > 0) {
      return nav[nav.length - 1];
    } else {
      return nav[0];
    }
  }

  public isShowPath(): boolean {
    if (this.device == DeviceType.Local) {
      return this.curBakNavPath.length > 1;
    } else {
      return true;
    }
  }

  popPath() {
    if (this.curBakNavPath.length < 1) {
      MLog.warn(TAG, `bakNavPathMap device:${this.device} curBakNavPath:${this.curBakNavPath.map(it => it.name)} `);
      return;
    }
    let info = this.curBakNavPath.pop();
    MLog.info(TAG,
      `bakNavPathMap device:${this.device} info:${info?.name} curBakNavPath:${this.curBakNavPath.map(it => it.name)} `);

    let bean = this.pathList.get(this.device).pop();
    MLog.print(TAG, `popPath pathList pop:${bean?.name} PathListNames:${this.getPathListNames()}`);

    this.callRefresh();

  }
}