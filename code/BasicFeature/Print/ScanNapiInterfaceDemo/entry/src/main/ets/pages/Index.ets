/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import {Scan} from '../scan/scan';
import {ScanLog} from '../scan/log';
import {ScannerDevice} from '../scan/scan';
import {ScanProgress} from '../scan/scan';
import {ScanOptionValue} from '../scan/scan';
import image from '@ohos.multimedia.image';

@CustomDialog
struct CustomDialogPicture {
  controller : CustomDialogController
  @Link image : PixelMap;
  build() {
    Column() {
      Text('Close')
        .fontSize(25)
        .margin(({top : 10, bottom : 10}))
        .fontColor(Color.Red)
        .fontWeight(FontWeight.Bold)
        .onClick(()=>{
          this.controller.close();
        })
      Row() {
        if (this.image != undefined) {
          Image(this.image)
            .width('100%')
            .height('100%')
        }
      }
    }
  }
}

@Entry
@Component
struct Index {
  public scannerId : string | undefined = undefined;
  public timerId : number = 0;
  @State fd : number = -1;
  @State image: PixelMap | undefined = undefined;
  pictureController : CustomDialogController = new CustomDialogController({
    builder : CustomDialogPicture({
      image:$image
    }),
    alignment : DialogAlignment.Default,
  })
  aboutToAppear(): void {
    Scan.initScan().then(()=>{
      ScanLog.info('init scan successful')
    }).catch(() => {
      ScanLog.warn('init scan error')
    })
  }

  aboutToDisappear(): void {
    Scan.closeScanner(this.scannerId).then(()=>{
    }).catch(()=>{
      ScanLog.warn('scan closeScan error');
    })
    Scan.exitScan().then(()=>{
      ScanLog.info('exit scan successful')
    }).catch(()=>{
      ScanLog.warn('exit scan error')
    })
  }

  build() {
    Column() {
      Text('Scanner Interface Demo')
        .fontSize(25)
        .fontColor(Color.Black)
        .height(100)
      Row() {
        Column() {
          Button('Searching Scanner')
            .onClick(() => {
              Scan.on('scanDeviceFound', (device: ScannerDevice | string) => {
                ScanLog.info('scanner info : ' + JSON.stringify(device));
                if (typeof device === 'object' && device !== null) {
                  this.scannerId = device.deviceId;
                }
              })
              Scan.getScannerList().then(() => {
                ScanLog.info('scan getScannerList successful');
              }).catch(() => {
                ScanLog.warn('scan getScannerList error')
              })
            })
            .height(180)
            .width(180)
          Button('Start Scan')
            .onClick(() => {
              Scan.startScan(this.scannerId, false).then(() => {
                this.timerId = setInterval(() => {
                  Scan.getProgress(this.scannerId).then((scanProgress: ScanProgress) => {
                    ScanLog.info('scan getProgress' + JSON.stringify(scanProgress))
                    if (scanProgress.progress === 100) {
                      if (scanProgress.isFinal) {
                        clearInterval(this.timerId);
                      }
                      let fd = scanProgress.pictureFd;
                      let imageSource = image.createImageSource(fd);
                      imageSource.createPixelMap().then((pic) => {
                        this.image = pic;
                      })
                    }
                  }).catch(() => {
                    ScanLog.warn('scan getProgress error');
                    clearInterval(this.timerId);
                  })
                }, 500);
              }).catch(() => {
                ScanLog.warn('scan startScan error');
              })
            })
            .height(180)
            .width(180)
          Button('Cancel Scan')
            .onClick(() => {
              Scan.cancelScan(this.scannerId).then(() => {
              }).catch(() => {
                ScanLog.warn('scan cancelScan error');
              })
            })
            .height(180)
            .width(180)
        }

        Column() {
          Button('open Scanner')
            .onClick(() => {
              Scan.openScanner(this.scannerId).then(() => {
              }).catch(() => {
                ScanLog.warn('scan openScanner error');
              })
            })
            .height(180)
            .width(180)
          Button('get options')
            .onClick(() => {
              let optionCount = 12;
              for (let i = 1; i < optionCount; i++) {
                Scan.getScanOptionDesc(this.scannerId, i).then((data) => {
                  ScanLog.info('scan getScanOptionDesc : ' + i + JSON.stringify(data));
                }).catch(() => {
                  ScanLog.warn('scan getScanOptionDesc error');
                })
              }

            })
            .height(180)
            .width(180)
          Button('set option')
            .onClick(() => {
              let value : ScanOptionValue = {
                valueType : 3,
                valueSize : 0,
                strValue : 'Automatic Document Feeder',
              };
              Scan.setScanOption(this.scannerId, 6, value).then(() => {
              }).catch(() => {
                ScanLog.warn('scan setScanOption error');
              })
            })
            .height(180)
            .width(180)
        }
      }
      Button('picture preview')
        .fontSize(25)
        .fontColor(Color.Black)
        .height(100)
        .width(350)
        .onClick(()=>{
          this.pictureController.open();
        })
    }
  }
}