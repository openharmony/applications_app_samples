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

// 多机位切换按钮上方的弹层组件
import { camera } from '@kit.CameraKit';
import { KeyCode } from '@kit.InputKit';
import { EventUtil } from '../common/EventUtil';

// 相机位置
enum CameraPositionEnum {
  '未知',
  '后置',
  '前置',
  '折叠态'
}

// 相机类型
enum CameraTypeEnum {
  '未知',
  '广角',
  '超广角',
  '长焦',
  '景深',
}

// 连接方式
enum CameraConnectionType {
  '内置',
  'USB连接',
  '远程连接',
}

@CustomDialog
export struct CamerasListDialog {
  @Prop camerasList: Array<camera.CameraDevice>;
  @Prop currentCameraDevice: camera.CameraDevice;
  controller: CustomDialogController;
  selectEvent: (cameraDevice: camera.CameraDevice) => void = () => {
  };

  // 拿到当前id在数组索引的方法
  getIdIndex(): number {
    let resIndex: number = this.camerasList.findIndex(item => {
      return item.cameraId === this.currentCameraDevice.cameraId;
    });
    return resIndex;
  }

  // touch事件或者按键事件选中相机方法
  actionSelectCamera() {
    this.selectEvent(this.currentCameraDevice);
    // 关闭相机弹窗
    this.controller.close();
    focusControl.requestFocus('-1');
  }

  build() {
    Column() {
      Text($r('app.string.dialog_select_camera'))
        .fontSize('40lpx')
        .fontColor('#fff');
      List({ space: '24lpx' }) {
        ForEach(this.camerasList, (item: camera.CameraDevice) => {
          ListItem() {
            Row() {
              Text(CameraConnectionType[item.connectionType] + CameraPositionEnum[item.cameraPosition] +
              CameraTypeEnum[item.cameraType] + $r('app.string.camera'))
                .fontSize('36lpx')
                .fontWeight(500)
                .lineHeight('42lpx')
                .fontColor('#dbffffff');
              Image(this.currentCameraDevice.cameraId === item.cameraId ? $rawfile('Radio_On.svg') :
                $rawfile('Radio_Off.svg'))
                .width('42lpx')
                .height('42lpx');
            }
            .width('100%')
            .height('96lpx')
            .padding({
              top: '26lpx',
              bottom: '26lpx',
              left: '30lpx',
              right: '30lpx'
            })
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center);
          }
          .width('100%')
          .borderRadius('18lpx')
          .backgroundColor('#33ffffff')
          .onTouch((e) => {
            EventUtil.isTouchEvent(e);
            if (e.type === TouchType.Up) {
              this.currentCameraDevice = item;
              this.actionSelectCamera();
            }
          });
        });
      }
      .margin({
        top: '48lpx'
      });
    }
    .width('50%')
    .backgroundColor('#1D2A4A')
    .borderRadius('24lpx')
    .padding({
      top: '52lpx',
      bottom: '52lpx',
      left: '70lpx',
      right: '70lpx'
    })
    .id('dialog')
    .focusable(true)
    .onKeyEvent(e => {
      let arrLength: number = this.camerasList.length;
      const currentIndex: number = this.getIdIndex();
      if (e.keyCode === KeyCode.KEYCODE_DPAD_DOWN && e.type === KeyType.Up) {
        if (currentIndex === arrLength - 1) {
          this.currentCameraDevice = this.camerasList[0];
          return;
        }
        this.currentCameraDevice = this.camerasList[currentIndex + 1];
      }
      if (e.keyCode === KeyCode.KEYCODE_DPAD_UP && e.type === KeyType.Up) {
        if (currentIndex === 0) {
          this.currentCameraDevice = this.camerasList[arrLength -1];
          return;
        }
        this.currentCameraDevice = this.camerasList[currentIndex -1];
      }
      // 遥控器确认键触发关闭弹窗事件 并设置相机Id
      if ((e.keyCode === KeyCode.KEYCODE_DPAD_CENTER || e.keyCode === KeyCode.KEYCODE_ENTER) && e.type === KeyType.Up) {
        this.actionSelectCamera();
      }
    });
  }
}