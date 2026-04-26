/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
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
  @Link camerasList: camera.CameraDevice[]
  @Link currentCameraId: string
  @Link surfaceIdone:string
  @State cameraId: string = '';
  controller: CustomDialogController
  confirm: (currentCameraId:string,resArrItem:camera.CameraDevice,surfaceIdone:string) =>void=()=>{}

  setCameraId(id: string) {
    this.cameraId = id;
  }

  aboutToAppear(): void {
    focusControl.requestFocus('dialog');
    this.cameraId = this.currentCameraId;
  }

  // 拿到当前id在数组索引的方法
  getIdIndex(): number {
    let resIndex: number;
    let resArrItem: camera.CameraDevice;
    resArrItem = this.camerasList.find(item => {
      return item.cameraId === this.cameraId;
    })! // ! => 断言必有返回值
    resIndex = this.camerasList.indexOf(resArrItem);
    return resIndex;
  }

  build() {
    Column() {
      Text($r('app.string.pleaseChooseCamera'))
        .fontSize('40lpx')
        .fontColor('#fff')
      List({ space: '24lpx' }) {
        ForEach(this.camerasList, (item: camera.CameraDevice) => {
          ListItem() {
            Row() {
              Text(
                CameraConnectionType[item.connectionType] +
                CameraPositionEnum[item.cameraPosition] +
                CameraTypeEnum[item.cameraType] +
                '相机'
              )
                .fontSize('36lpx')
                .fontWeight(500)
                .lineHeight('42lpx')
                .fontColor('#dbffffff')
              Image(this.cameraId == item.cameraId ? $r('app.media.Radio_On') : $r('app.media.Radio_Off'))
                .width('42lpx')
                .height('42lpx')
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
            .alignItems(VerticalAlign.Center)
          }
          .width('100%')
          .borderRadius('18lpx')
          .backgroundColor('#33ffffff')
          .onTouch((e) => {
            if (e.type == TouchType.Up) {
              this.currentCameraId = item.cameraId;
              AppStorage.setOrCreate<string>('cameraId', this.currentCameraId);
              let resArrItem: camera.CameraDevice;
              resArrItem = this.camerasList.find(item => {
                return item.cameraId == this.currentCameraId;
              })! // ! => 断言必有返回值
              this.confirm(this.currentCameraId,resArrItem,this.surfaceIdone);
              // 关闭相机弹窗
              this.controller.close();
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
      let arrLength = this.camerasList.length;
      const currentIndex = this.getIdIndex();
      if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Up) {
        if (currentIndex == arrLength - 1) {
          this.setCameraId(this.camerasList[0].cameraId);
          return
        }
        this.setCameraId(this.camerasList[currentIndex + 1].cameraId);
      }
      if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Up) {
        if (currentIndex == 0) {
          this.setCameraId(this.camerasList[arrLength -1].cameraId);
          return
        }
        this.setCameraId(this.camerasList[currentIndex - 1].cameraId);
      }
      // 遥控器确认键触发关闭弹窗事件 并设置相机Id
      if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) && e.type == KeyType.Up) {
        this.currentCameraId = this.cameraId;
        // 选中后将当前的相机Id存储
        AppStorage.setOrCreate<string>('cameraId', this.currentCameraId);
        let resArrItem: camera.CameraDevice;
        resArrItem = this.camerasList.find(item => {
          return item.cameraId == this.currentCameraId;
        })! // ! => 断言必有返回值
        this.confirm(this.currentCameraId,resArrItem,this.surfaceIdone);
        // 关闭相机弹窗
        this.controller.close();
      }
    });
  }
}
