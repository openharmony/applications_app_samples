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

import { TABS } from '../common/Constants';
import { NavStack } from '../common/manager/NavPathStackManager';
import { StorageManager } from '../common/manager/StorageManager';
import { Tools } from '../common/utils/Tools';
import { FileList } from './FileList';
import { Home } from './Home';
import { MLog } from '../common/utils/MLog';
import { display, ColorMetrics, LengthMetrics } from '@kit.ArkUI';
import app from '@system.app';
import { BusinessError, emitter, commonEventManager as CommonEvent } from '@kit.BasicServicesKit';
import { InputKeyEventUtils } from '../common/utils/InputKeyEventUtils';
import { FileAccessManager } from '../common/manager/FileAccessManager';
import { PageType } from '../model/PageType';
import { FileBean } from '../component/bean/FileBean';
import { Permission } from '../common/utils/Permission';
import { Units } from '../common/utils/PixelUnitConversion';
import lpx from '../common/utils/Lpx';

const TAG = 'Index';

//顶部目录内外部适配 文件操作适配
@Entry
@Component
struct Index {
  // 控制本机和外部存储焦点
  @State isFocusable: boolean = true;
  @State selectedTab: number = 0;
  @StorageLink('isShowHomePage') isShowHomePage: boolean = false;
  @LocalStorageLink('backPageBeanId') backPageBeanId: string = '';
  @State isShowPath: boolean = false;
  @State parentDirs: string[] = [];
  @State showFreeSize: [number, number] = [0, 0];
  @State freeSize: [number, number] = [0, 0];
  private subscriber?: CommonEvent.CommonEventSubscriber;
  @State isSelectMode: boolean = false;
  @State curName: string = '';
  private relativePathLocal: string = '';
  private relativePathUsb: string = '';
  @State pageName: string = '';
  focusController = this.getUIContext().getFocusController();

  aboutToAppear() {
    // 触发tab走焦
    this.focusController.activate(true, false);
    MLog.info(TAG, `AppInfo: ${JSON.stringify(app.getInfo())}`);
    NavStack.getIns().addStatusLis(mod => {
      this.isShowPath = NavStack.getIns().isShowPath();
      this.navRefresh(mod);
    });
    NavStack.getIns().pushRoot(PageType.HOME_PAGE);
    this.relativePathLocal = getContext(this).filesDir;
    let dis = display.getDefaultDisplaySync();
    MLog.print(TAG, `display:${JSON.stringify(dis)}`);
    this.externalDeviceListener();
    this.showFreeSize = this.freeSize;
    emitter.on('CHECK_EXTERNAL', this.checkExternal);
    emitter.on('REFRESH_SPACE_SIZE', this.refreshSpaceSize);
    Permission.checkAndRequest().then(ret => {
      MLog.print(TAG, `checkAndRequest ret:${ret}`);
      if (ret) {
        emitter.emit('CHECK_EXTERNAL');
        emitter.emit('REFRESH_SPACE_SIZE');
      } else {
        MLog.print(TAG, `checkAndRequest terminate`);
        app.terminate();
      }
    });
  }

  aboutToDisappear(): void {
    emitter.off('CHECK_EXTERNAL', this.checkExternal);
    emitter.off('REFRESH_SPACE_SIZE', this.refreshSpaceSize);
  }

  private refreshSpaceSize = (eventData?: emitter.EventData) => {
    if (eventData && eventData.data) {
      MLog.print(TAG, `refreshSpaceSize data:${JSON.stringify(eventData)}`);
      if (eventData.data?.isShowSpaceSize) {
        this.showFreeSize = this.freeSize;
      } else {
        this.showFreeSize = [0, 0];
      }
      if (eventData.data?.relativePath) {
        let pathSize = StorageManager.getFreeSpaceSize(eventData.data?.relativePath);
        MLog.print(TAG, `refreshSpaceSize pathSize:${JSON.stringify(pathSize)}`);
        this.showFreeSize = pathSize;
      }
    } else {
      MLog.print(TAG, `refreshSpaceSize isExternal:${NavStack.getIns().isExternal()}`);
      this.freeSize = StorageManager.getFreeSpaceSize(this.relativePathLocal);
      switch (this.selectedTab) {
        case 0:
          this.showFreeSize = this.freeSize;
          break;
        case 1:
          this.showFreeSize = [0, 0];
          break;
      }
    }
  }
  private checkExternal = () => {
    const prevUsbCount = this.getUsbDeviceCount(); // 记录之前的 USB 数量

    FileAccessManager.getIns(getContext(this)).getRoots().then(infoArr => {
      let currentUsbCount = 0;

      for (let it of infoArr) {
        if (FileAccessManager.isUsbDevice(it.deviceType)) {
          currentUsbCount++;
        }
      }

      MLog.print(TAG, `checkExternal prevUsbCount:${prevUsbCount} currentUsbCount:${currentUsbCount}`);

      // 如果 USB 数量减少（有 U 盘拔出），清空路径
      if (currentUsbCount < prevUsbCount || currentUsbCount === 0) {
        NavStack.getIns().closeUSB();
      }

      // 如果有 USB 存在
      if (currentUsbCount > 0) {
        NavStack.getIns().openUSB();
        setTimeout(() => {
        }, 300);
      }

      // 更新记录的 USB 数量
      this.setUsbDeviceCount(currentUsbCount);
    });
  }
  // 添加成员变量记录 USB 数量
  private usbDeviceCount: number = 0;

  private getUsbDeviceCount(): number {
    return this.usbDeviceCount;
  }

  private setUsbDeviceCount(count: number): void {
    this.usbDeviceCount = count;
  }

  navRefresh(isMode: boolean) {
    let curInfo = NavStack.getIns().curPageInfo;
    if (!curInfo) {
      return;
    }
    this.pageName =
      Object.values(PageType).includes(curInfo.name as PageType) ? curInfo.name : curInfo.name + Date.now();
    MLog.print(TAG, `navRefresh pageName:${this.pageName} curInfo:${JSON.stringify(curInfo)}`);
    this.isSelectMode = isMode;
    MLog.print(TAG, `change mode:${this.isSelectMode}`);
    this.parentDirs = NavStack.getIns().getPathListNames();
    MLog.print(TAG, `selectedTab:${this.selectedTab} NavStack Device:${NavStack.getIns().getDevice()}`);
    if (this.selectedTab != NavStack.getIns().getDevice()) {
      this.selectedTab = NavStack.getIns().getDevice();
    }

  }

  async onPageShow() {
    MLog.info(TAG, 'onPageShow ');
    this.isFocusable = false;
    let isFromShare: ESObject = AppStorage.get('isFromShare');
    MLog.info(TAG, 'isFromShare = ' + isFromShare);
    if (isFromShare) {
      let fileBean = await this.getShareDir();
      if (fileBean == undefined) {
        return;
      }
      MLog.info(TAG, 'fileBean = ' + JSON.stringify(fileBean.relativePath));
      NavStack.getIns().pushBean(fileBean);
      AppStorage.SetOrCreate('isFromShare', undefined);
    }
    emitter.emit('CHECK_EXTERNAL');
    emitter.emit('REFRESH_SPACE_SIZE');
    if (AppStorage.has('REFRESH_PAGE')) {
      MLog.info(TAG, `'REFRESH_PAGE value:${AppStorage.get('REFRESH_PAGE')}`);
      emitter.emit(AppStorage.get('REFRESH_PAGE'));
    }
  }

  public async getShareDir(): Promise<FileBean | undefined> {
    let manager = FileAccessManager.getIns();
    let roots = await manager.getRootLocal();
    if (!roots) {
      return undefined;
    }
    let fileInfo = await manager.getList(roots);
    for (let i of fileInfo) {
      MLog.info(TAG, 'getShareDir fileName = ' + i.fileName);
      if (i.fileName == 'Share') {
        let fileBean = new FileBean(i.uri, i).updateDirType();
        return fileBean;
      }
    }
    return undefined;
  }

  onBackPress(): boolean | void {
    MLog.info(TAG, `onBackPress`);
    if (NavStack.getIns().onBackPress()) {
      MLog.warn(TAG, `onBackPress true`);
      return true;
    }
    if (NavStack.getIns().isExitApp()) {
      MLog.warn(TAG, `onBackPress isExitApp`);
      return false;
    } else {
      return true;
    }
  }

  build() {
    Column() {
      this.TitleBar();

      Row() {
        this.Tabs();
        if (this.showFreeSize && this.showFreeSize[1]) {
          this.StorageSpace()
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .width('100%')
      .margin({ top: lpx(Units.px2vp(24)) })

      Row() {
        if (this.pageName === PageType.HOME_PAGE) {
          Home({
            isFocusable: this.isFocusable
          })
        } else {
          FileList({
            name: this.pageName,
            isFocusable: this.isFocusable
          })
        }
      }.layoutWeight(1)
      .focusBox({
        strokeColor: ColorMetrics.numeric(Color.Transparent),
        strokeWidth: LengthMetrics.px(0)
      })
      .margin({ top: lpx(Units.px2vp(10)), bottom: lpx(Units.px2vp(16)) })

    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.ic_bg'))
    .backgroundImageSize({ width: '100%', height: '100%' })
    .padding({ left: lpx(Units.px2vp(24)), right: lpx(Units.px2vp(24)), top: lpx(Units.px2vp(13)) })
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down) {
      }
    })
  }

  @Builder
  TitleBar() {
    Row() {
      Row() {
        Text($r('app.string.app_name'))
          .fontSize(lpx(Units.px2fp(32)))
          .fontColor($r('app.color.title_bar_text'))
          .margin({ right: lpx(Units.px2vp(24)) })

        if (this.isShowPath) {
          Row() {
            Text(this.getParentDirName('', -1))
              .fontSize(lpx(Units.px2fp(16)))
              .fontColor($r('app.color.title_bar_hint_text'))
            if (this.parentDirs?.length > 0) {
              Text() {
                ForEach(this.parentDirs, (item: string, index: number) => {
                  Span(this.getParentDirName(item, index))
                })
              }
              .fontSize(lpx(Units.px2fp(16)))
              .fontColor($r('app.color.title_bar_hint_text'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .ellipsisMode(EllipsisMode.CENTER)

            }
          }.width('50%')
          .justifyContent(FlexAlign.Start)
        }
      }
      .alignItems(VerticalAlign.Bottom)

      if (!this.isShowHomePage) {
        Text($r('app.string.title_bar_hint'))
          .fontSize(lpx(Units.px2fp(18)))
          .fontColor($r('app.color.title_bar_hint_text'))
      }
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  Tabs() {
    Row() {
      ForEach(TABS, (item: string, index: number) => {
        Text(item)
          .id(`index_${index}`)
          .fontSize(lpx(Units.px2fp(20)))
          .fontColor(this.selectedTab == index ? $r('app.color.home_tab_text_sel') : $r('app.color.home_tab_text'))
          .padding({
            left: lpx(Units.px2vp(24)),
            right: lpx(Units.px2vp(24)),
            top: lpx(Units.px2vp(12)),
            bottom: lpx(Units.px2vp(12))
          })
          .backgroundColor(this.selectedTab == index ? $r('app.color.home_tab_bg_sel') : $r('app.color.home_tab_bg'))
          .borderRadius(lpx(Units.px2vp(110)))
          .margin({ right: lpx(Units.px2vp(24)) })
          .onTouch((e) => {
            if (e.type === TouchType.Down) {
              console.log(`zyh touch down ${this.isFocusable}`);
              // 请求焦点
              this.getUIContext().getFocusController().requestFocus(`index_${index}`);
            }
          })
          .onHover((isHover) => {
            if (isHover) {
              this.isFocusable = true;
              focusControl.requestFocus(`index_${index}`);
            }
          })
          .onClick(() => {
            this.isFocusable = true;
            this.switchTab(index);
          })
          .focusable(true)
          .defaultFocus(index == 0 ? true : false)
          .focusScopePriority('tabs', this.selectedTab == index ? FocusPriority.PRIOR : FocusPriority.AUTO)
          .focusBox({
            strokeColor: ColorMetrics.rgba(255, 255, 255, 1),
            strokeWidth: LengthMetrics.lpx(1),
            margin: LengthMetrics.lpx(2)
          })
      })
    }
    .focusScopeId('tabs', true)
  }

  @Builder
  StorageSpace() {
    Column() {
      Text($r('app.string.storage_space_text',
        `${Tools.byte2Str(this.showFreeSize[1] - this.showFreeSize[0]) + '/' + Tools.byte2Str(this.showFreeSize[1])}`))
        .fontSize(lpx(Units.px2fp(18)))
        .fontColor($r('app.color.title_bar_hint_text'))
        .fontWeight(400)
      Progress({
        value: (this.showFreeSize[1] - this.showFreeSize[0]) / 1000,
        total: this.showFreeSize[1] / 1000,
        type: ProgressType.Linear
      })
        .width(lpx(Units.px2vp(168)))
        .height(lpx(Units.px2vp(10)))
        .margin({ top: lpx(Units.px2vp(10)) })
        .color($r('app.color.storage_progress_color'))
        .backgroundColor('#A5ABB7')
        .style({ strokeWidth: lpx(Units.px2vp(10)) })

    }
    .alignItems(HorizontalAlign.Center)
  }

  private switchTab(index: number) {
    MLog.print(TAG, `switchTab:${index} selectedTab:${this.selectedTab}`);
    if (this.selectedTab == index) {
      return;
    }

    try {
      if (index == 1 && !NavStack.getIns().isExternal()) {
        MLog.showToast(TAG, '没有检测到外部存储');
        return;
      }
    } catch (e) {
      console.log('get isExternal failed:', e.message);
    }

    this.selectedTab = index;
    NavStack.getIns().setDevice(this.selectedTab);
    if (index == 1) {
      this.checkExternal();
    }
    this.refreshSpaceSize();
  }

  private getParentDirName(name: string, index: number) {
    if (index == -1) {
      return this.selectedTab == 1 ?
        $r('app.string.external_storage', this.parentDirs?.length > 0 ? ' > ' : '')
        : $r('app.string.media_type_device', this.parentDirs?.length > 0 ? ' > ' : '');
    }
    return index == this.parentDirs.length - 1 ? name : `${name} > `;
  }

  private async externalDeviceListener() {

    const subscribeInfo: CommonEvent.CommonEventSubscribeInfo = {
      events: [
        'usual.event.data.VOLUME_UNMOUNTED',
        'usual.event.data.VOLUME_MOUNTED',
      ]
    };
    this.subscriber = await CommonEvent.createSubscriber(subscribeInfo);
    CommonEvent.subscribe(this.subscriber, (err: BusinessError, data: CommonEvent.CommonEventData) => {
      if (data && data.event === 'usual.event.data.VOLUME_UNMOUNTED') {
        MLog.print(TAG, `CommonEvent VOLUME_UNMOUNTED data:${JSON.stringify(data)}`);
        emitter.emit('CHECK_EXTERNAL');
        if (this.selectedTab == 1) {
          this.switchTab(0);

        }
      } else if (data && data.event === 'usual.event.data.VOLUME_MOUNTED') {
        MLog.print(TAG, `CommonEvent VOLUME_MOUNTED data:${JSON.stringify(data)}`);
        emitter.emit('CHECK_EXTERNAL');

      }
    });
  }
}