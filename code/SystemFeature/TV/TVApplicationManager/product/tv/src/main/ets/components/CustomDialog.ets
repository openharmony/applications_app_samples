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
import bundleInstall from '@ohos.bundle.installer';
import promptAction from '@ohos.promptAction';
import { BusinessError } from '@ohos.base';
import StoreAppList from '../common/utils/Storage';
import emitter from '@ohos.events.emitter';
import ErrorCodeHandler from './ErrorCode';
import { inputEventClient, KeyCode } from '@kit.InputKit';
import { LengthMetrics } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { AppIconCacheManager } from '../Utils/AppIconCacheManager';
import { AppNameCacheManager } from '../Utils/AppNameCacheManager';
import { Logger } from '../Utils/Logger';

const TAG: string = 'CustomDialogExample';

interface AppList {
  icon: ResourceStr;
  label: string;
  element: Element;
  moduleName: string;
  labelId: number;
  iconId: number;
}

class Element {
  public bundleName: string = '';
  public abilityName: string = '';
}

@CustomDialog
export default struct CustomDialogExample {
  @Link appList: Array<AppList>;
  @Link focusIndex: number;
  @Link ifMove: string;
  @Link arrowXPos: number;
  @State ifFocus: string = '';
  @Link dialogPostion: number[];
  @State appIcon: ResourceStr | PixelMap | null = '';
  @State appName: string = '';
  controller: CustomDialogController;
  cancel: () => void = () => {
  };
  confirm: () => void = () => {
  };

  withAddShortCuts(bundleName: string): boolean {
    if (globalThis.shortCutsBundleNames) {
      return !(globalThis.shortCutsBundleNames as string[]).includes(bundleName);
    } else {
      return false;
    }
  }

  //移动卸载后对应用列表做持久化存储
  localStorageApp() {
    let appList = this.appList.map(item => item.element);
    let storageList = new StoreAppList(getContext());
    storageList.setAppList(JSON.stringify(appList));
  }

  aboutToAppear(): void {
    emitter.on('move', () => {
      this.arrowXPos = 0;
      if (this.controller) {
        this.controller.close();
        this.cancel();
        this.ifMove = 'true';
      }
    });
    emitter.once('uninstall', () => {
      if (!this.focusIndex && this.focusIndex != 0) {
        Logger.info('focus error', this.focusIndex + '');
        return;
      }
      this.unInstallList(this.appList[this.focusIndex].element.bundleName);
    });

    const appInfo = this.appList[this.focusIndex];
    AppIconCacheManager.getInstance().getAppIcon(
      appInfo.element.bundleName,
      appInfo.moduleName || '',
      appInfo.element.abilityName,
      appInfo.iconId || 0,
    ).then((pixelMap: image.PixelMap | null) => {
      if (pixelMap) {
        this.appIcon = pixelMap;
      }
    });

    AppNameCacheManager.getInstance().get(
      appInfo.element.bundleName,
      appInfo.moduleName || '',
      appInfo.element.abilityName,
      appInfo.labelId || 0
    ).then(res => {
      this.appName = res;
    });

    setTimeout(() => {
      this.getUIContext().getFocusController()?.activate(true, false);
    }, 1000);

  }

  aboutToDisappear(): void {
    emitter.off('uninstall');
    emitter.off('move');
    try {
      this.getUIContext().getFocusController()?.activate(false);
    } catch (e) {
      Logger.info('Close focus error');
    }
  }

  // 界面删除应用
  unInstallList(bundleName: string) {
    if (!bundleName) {
      return;
    }
    let installParam: bundleInstall.InstallParam = {
      userId: 100,
      isKeepData: false,
      installFlag: 1,
    };
    this.unInstallApp(bundleName, installParam);
  }

  //系统接口删除应用
  unInstallApp(bundleName: string, installParam: bundleInstall.InstallParam) {
    Logger.info(bundleName, '正在被下载的应用bundleName');
    let appList = this.appList;
    bundleInstall.getBundleInstaller().then(installer => {
      installer.uninstall(bundleName, installParam, err => {

        if (err) {
          let dealErr = new ErrorCodeHandler();
          this.getUIContext().getPromptAction().showToast({
            message: 'uninstall failed,' + dealErr.handleErrorCode(err.code as number),
            duration: 2000
          });
          Logger.error('uninstall failed:' + JSON.stringify(err));
        } else {

          appList.splice(this.focusIndex, 1);
          if (this.focusIndex <= appList.length - 1) {
            this.focusIndex = this.focusIndex - 1 >= 0 ? this.focusIndex - 1 : 0;

          } else {
            this.focusIndex = appList.length - 1;
          }
          Logger.info(this.focusIndex + 'this.focusIndex' + appList.length + 'appList.length');
          this.localStorageApp();
          this.controller?.close();
          this.cancel();

          if (!this.withAddShortCuts(bundleName)) {
            emitter.emit('removeShotcuts', { data: bundleName });
          }

          Logger.info('Uninstall and cleanup successful');
          this.getUIContext().getPromptAction().showToast({
            message: 'Uninstall and cleanup successful',
            duration: 2000
          });
        }
      });
    }).catch((error: BusinessError) => {
      let message = (error as BusinessError).message;
      Logger.error('getBundleInstaller failed. Cause: ' + message);
    });
  }

  getPlacement(index: number) {
    let offset: number = ++index % 6;
    let left = [1, 2, 3].find((o => o == offset));
    return left ? 0 : 1; // 0代表在图像右侧  1代表在图像左侧
  }

  build() {
    Stack() {
      Row() {
        Column() {
          Stack({ alignContent: Alignment.Center }) {
            Row() {
            }
            .backgroundColor('#e6ffffff')
            .zIndex(5)
            .borderRadius('18lpx')
            .width('266lpx')
            .height('158lpx');

            Image(this.appIcon)
              .height('108lpx')// .borderRadius('22lpx')
              .aspectRatio(1)
              .objectFit(ImageFit.Contain)
              .interpolation(ImageInterpolation.High)
              .syncLoad(true)
              .zIndex(5);
          }
          .padding('5lpx')
          .border({
            radius: '24lpx',
            color: 'rgba(255, 255, 255, 0.86)',
            width: '2lpx',
          });

          //   .margin({ top: '20lpx', left: -5 })

          Text(this.appName)
            .fontSize('36lpx')
            .fontColor('rgba(255, 255, 255, 0.6)')
            .textAlign(TextAlign.Center)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({
              // top: this.focusIndex === index ? '-24lpx' : '-36lpx'
              top: '24lpx',
              left: '-5'
            }); // .opacity(this.focusIndex === index && this.ifMove == 'true' ? 0 : 1)
        };

        Column({ space: 8 }) {
          Row() {
            Button($r('app.string.Desktop_shortcut'), { type: ButtonType.Normal, stateEffect: true })
              .defaultFocus(this.withAddShortCuts(this.appList[this.focusIndex].element.bundleName) ? true : false)
              .fontColor(this.ifFocus === 'add_shortcuts' ? $r('app.color.focus_true') : $r('app.color.focus_false'))
              .backgroundColor(this.ifFocus === 'add_shortcuts' ? $r('app.color.focus_BG_true') :
              $r('app.color.focus_BG_false'))//.width('50%')
              .borderRadius(8)
              .id('add_shortcuts')
              .fontSize('36lpx')
              .height('70lpx')
              .width('450lpx')
              .onClick(() => {
                emitter.emit('addShortcuts', { data: this.appList[this.focusIndex].element.bundleName });
              })
              .onBlur(() => {
              })
              .onFocus(() => {
                this.ifFocus = 'add_shortcuts';
              })
              .focusBox({
                strokeWidth: LengthMetrics.px(0)
              })
              .onHover(() => {
                this.ifFocus = 'add_shortcuts';
              });
          }
          .visibility(this.withAddShortCuts(this.appList[this.focusIndex].element.bundleName) ? Visibility.Visible :
          Visibility.None)
          .focusable(this.withAddShortCuts(this.appList[this.focusIndex].element.bundleName))
          .width(this.ifFocus === 'add_shortcuts' ? '470lpx' : '450lpx')
          .height(this.ifFocus === 'add_shortcuts' ? '90lpx' : '70lpx')
          .backgroundColor(Color.Transparent)
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .borderRadius(12)
          .border({ width: 2 })
          .borderColor(this.ifFocus === 'add_shortcuts' ? $r('app.color.focus_BG_true') :
          $r('app.color.focus_BG_false'));

          Row() {
            Button($r('app.string.uninstall'), { type: ButtonType.Normal, stateEffect: true })
              .defaultFocus(this.withAddShortCuts(this.appList[this.focusIndex].element.bundleName) ? false : true)
              .fontColor(this.ifFocus === 'uninstall' ? $r('app.color.focus_true') : $r('app.color.focus_false'))
              .backgroundColor(this.ifFocus === 'uninstall' ? $r('app.color.focus_BG_true') :
              $r('app.color.focus_BG_false'))
              .borderRadius(8)
              .id('uninstall')
              .fontSize('36lpx')
              .height('70lpx')
              .width('450lpx')
              .onClick(() => {
                emitter.emit('uninstall');
              })
              .onBlur(() => {
              })
              .onFocus(() => {
                this.ifFocus = 'uninstall';
              })
              .focusBox({
                strokeWidth: LengthMetrics.px(0)
              })
              .onHover(() => {
                this.ifFocus = 'uninstall';
              });
          }
          .width(this.ifFocus === 'uninstall' ? '470lpx' : '450lpx')
          .height(this.ifFocus === 'uninstall' ? '90lpx' : '70lpx')
          .backgroundColor(Color.Transparent)
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .borderRadius(12)
          .border({ width: 2 })
          .borderColor(this.ifFocus === 'uninstall' ? $r('app.color.focus_BG_true') : $r('app.color.focus_BG_false'));

          Row() {
            Button($r('app.string.move'), { type: ButtonType.Normal, stateEffect: true })
              .fontColor(this.ifFocus === 'move' ? $r('app.color.focus_true') : $r('app.color.focus_false'))
              .backgroundColor(this.ifFocus === 'move' ? $r('app.color.focus_BG_true') :
              $r('app.color.focus_BG_false'))
              .borderRadius(8)
              .id('move')
              .fontSize('36lpx')
              .height('70lpx')
              .width('450lpx')
              .onClick(() => {
                emitter.emit('move');
              })
              .onBlur(() => {
              })
              .onFocus(() => {
                this.ifFocus = 'move';
              })
              .focusBox({
                strokeWidth: LengthMetrics.px(0)
              })
              .onHover(() => {
                this.ifFocus = 'move';
              });
          }
          .width(this.ifFocus === 'move' ? '470lpx' : '450lpx')
          .height(this.ifFocus === 'move' ? '90lpx' : '70lpx')
          .backgroundColor(Color.Transparent)
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .borderRadius(12)
          .border({ width: 2 })
          .borderColor(this.ifFocus === 'move' ? $r('app.color.focus_BG_true') : $r('app.color.focus_BG_false'));
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ left: this.getPlacement(this.focusIndex) == 0 ? '15lpx' : '-765lpx' })
        .onKeyEvent((event) => {
          if (event.type == KeyType.Down) {
            if (event.keyCode == KeyCode.KEYCODE_DPAD_DOWN) {
              switch (this.ifFocus) {
                case 'add_shortcuts':
                  focusControl.requestFocus('uninstall');
                  break;
                case 'uninstall':
                  focusControl.requestFocus('move');
                  break;
                case 'move':
                  if (this.withAddShortCuts(this.appList[this.focusIndex].element.bundleName) ? true : false) {
                    focusControl.requestFocus('add_shortcuts');
                  } else {
                    focusControl.requestFocus('uninstall');
                  }
                  break;
              }
            }
            if (event.keyCode == KeyCode.KEYCODE_DPAD_UP) {
              switch (this.ifFocus) {
                case 'add_shortcuts':
                  focusControl.requestFocus('move');
                  break;
                case 'uninstall':
                  if (this.withAddShortCuts(this.appList[this.focusIndex].element.bundleName) ? true : false) {
                    focusControl.requestFocus('add_shortcuts');
                  } else {
                    focusControl.requestFocus('move');
                  }
                  break;
                case 'move':
                  focusControl.requestFocus('uninstall');
                  break;
              }
            }
          }
        });

        Button() {
        }.onFocus(() => {
          this.controller.close();
          this.cancel();
        }).visibility(Visibility.Hidden);

      }.alignItems(VerticalAlign.Top)
      .position(({ x: this.dialogPostion[0] + 'lpx', y: this.dialogPostion[1] + 'lpx' }));
    }.width('100%').height('100%')
    .backgroundColor(0xf218181A);
  }
}
