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

/* AI人脸识别主页 */
import { KeyCode } from '@kit.InputKit';
import { initInfo } from '../utils/log';
import CameraService from '../common/CameraService';
import { abilityAccessCtrl } from '@kit.AbilityKit';
import { PointerUtil } from '../common/PointerUtil';
import { EventUtil } from '../common/EventUtil';

const TAG: string = 'Index';
let log: (tag?: string | number, log?: string | number | undefined) => void = initInfo('index.ets');

@Builder
export function IndexBuilder() {
  Index();
}

// 图片Row复用样式
@Styles
function rowImageStyles() {
  .width('100lpx')
  .height('100lpx')
  .borderColor('#ffffffff')
  .borderStyle(BorderStyle.Solid);
}

// 图片复用样式
@Styles
function imageStyles() {
  .width('100lpx')
  .height('100lpx')
  .clip(true);
}

// 文本复用样式
@Extend(Text)
function textStyle(sign: string) {
  .fontColor('#dbffffff')
  .fontSize('24lpx')
  .lineHeight('35lpx')
  .margin({ top: '12lpx' })
  .id(sign)
  .padding({
    left: '15lpx',
    top: '5lpx',
    right: '15lpx',
    bottom: '5lpx'
  });
}

@Entry
@Component
struct Index {
  private cameraService: CameraService = new CameraService(getContext(this));
  @State focusId: string = '0';
  @State showNoCamera: boolean = false;
  private atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  @Provide('NavPathStack') pageStack: NavPathStack = new NavPathStack();

  async requestPermissionsFn() {
    try {
      this.atManager.requestPermissionsFromUser(getContext(this), [
        'ohos.permission.CAMERA',
        'ohos.permission.READ_MEDIA',
        'ohos.permission.READ_IMAGEVIDEO',
        'ohos.permission.MEDIA_LOCATION',
        'ohos.permission.DISTRIBUTED_DATASYNC'
      ]);
    } catch (err) {
      log(TAG, `requestPermissionsFromUser call Failed! error: ${err.code}`);
    }
  }

  async aboutToAppear() {
    await this.requestPermissionsFn();
    PointerUtil.changePointStyle(false);
  }

  defaultFocusBtn() {
    let focusId: string = AppStorage.get<string>('focusId') || '0';
    focusControl.requestFocus(focusId);
  }

  onPageShow() {
    this.defaultFocusBtn();
  }

  onPageHide() {
    AppStorage.setOrCreate<string>('focusId', this.focusId);
  }

  // 摄像头
  openCamera() {
    let length: number = this.cameraService.getCamerasList().length;
    if (length > 0) {
      this.pageStack.pushPath({ name: 'CameraPreview', param: 0 });
    } else {
      this.showNoCamera = true;
      setTimeout(() => {
        this.showNoCamera = false;
      }, 2000);
    }
  }

  openImageSelect() {
    this.pageStack.pushPathByName('ImageSelect', 0);
  }

  focusBtn(id: string) {
    this.focusId = id;
    AppStorage.setOrCreate<string>('focusId', id);
  }

  clickFocusBtn(id: string) {
    this.focusBtn(id);
    focusControl.requestFocus(id);
  }

  // 分布式认证点击事件
  distributedAttestation() {
    // 去往分布式认证页面
    this.pageStack.pushPath({ name: 'DistributedAttestation' });
  }

  build() {
    Navigation(this.pageStack) {
      Column() {
        Stack({ alignContent: Alignment.Bottom }) {
          Row({ space: '20lpx' }) {
            Column() {
              Row() {
                Image(this.focusId === '1' ? $rawfile('Preview_On.svg') : $rawfile('Preview_Off.svg'))
                  .width('100lpx')
                  .height('100lpx')
                  .objectFit(ImageFit.Cover)
                  .clip(true);
              }
              .width('100lpx')
              .height('100lpx')
              .backgroundColor('#0dffffff')
              .justifyContent(FlexAlign.Center)
              .alignItems(VerticalAlign.Center)
              .borderRadius('200')
              .borderColor('#ffffffff')
              .borderStyle(BorderStyle.Solid);

              Row() {
                Text($r('app.string.image_facial_recognition'))
                  .textStyle('1');
              };
            }
            .onHover(() => {
              this.clickFocusBtn('1');
            })
            .onTouch((e) => {
              EventUtil.isTouchEvent(e);
              if (e.type === TouchType.Up) {
                this.clickFocusBtn('1');
                this.openImageSelect();
              }
            });

            Column() {
              Row() {
                Image(this.focusId === '0' ? $rawfile('Camera_On.svg') : $rawfile('Camera_Off.svg'))
                  .imageStyles()
                  .objectFit(ImageFit.Cover);
              }
              .rowImageStyles()
              .justifyContent(FlexAlign.Center)
              .alignItems(VerticalAlign.Center);

              Row() {
                Text($r('app.string.camera_facial_recognition'))
                  .textStyle('0');
              };
            }
            .onHover(() => {
              this.clickFocusBtn('0');
            })
            .onTouch((e) => {
              EventUtil.isTouchEvent(e);
              if (e.type === TouchType.Up) {
                this.clickFocusBtn('0');
                this.openCamera();
              }
            });

            Column() {
              Row() {
                Image(this.focusId === '-1' ? $rawfile('link_On.svg') : $rawfile('link_Off.svg'))
                  .imageStyles()
                  .objectFit(ImageFit.Cover);
              }
              .rowImageStyles()
              .justifyContent(FlexAlign.Center)
              .alignItems(VerticalAlign.Center);

              Text($r('app.string.device_authentication'))
                .textStyle('-1');
            }
            .onHover(() => {
              this.clickFocusBtn('-1');
            }).onTouch((e) => {
              EventUtil.isTouchEvent(e);
              if (e.type === TouchType.Up) {
                this.clickFocusBtn('-1');
                this.distributedAttestation();
              }
            });
          }
          .width('50%')
          .justifyContent(FlexAlign.SpaceAround)
          .margin({
            bottom: '120lpx'
          });

          if (this.showNoCamera) {
            Row() {
              Text($r('app.string.connect_to_camera'))
                .fontSize(50)
                .fontWeight(FontWeight.Bold)
                .fontColor(0x58D68D);
            }
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .backgroundColor(0x55000000)
            .zIndex(6);
          }

        };
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.End);
    }
    .hideTitleBar(true)
    .hideToolBar(true)
    .mode(NavigationMode.Stack)
    .width('100%')
    .height('100%')
    .focusable(true)
    .onKeyEvent(e => {
      if (e.type === KeyType.Up) {
        switch (e.keyCode) {
          case KeyCode.KEYCODE_DPAD_LEFT:
            this.focusId === '-1' ?
              this.clickFocusBtn('0') : this.focusId === '0' ?
              this.clickFocusBtn('1') : this.clickFocusBtn('-1');
            break;
          case KeyCode.KEYCODE_DPAD_RIGHT:
            this.focusId === '1' ?
              this.clickFocusBtn('0') : this.focusId === '0' ?
              this.clickFocusBtn('-1') : this.clickFocusBtn('1');
            break;
          case KeyCode.KEYCODE_ENTER:
            this.focusId === '1' ?
              this.openImageSelect() : this.focusId === '0' ?
              this.openCamera() : this.distributedAttestation();
            break;
          default:
            break;
        }
      }
    })
    .backgroundColor('#18181A')
    .onTouch((event) => {
      PointerUtil.changePointStyle(event.type === TouchType.Down);
    });
  }
}


