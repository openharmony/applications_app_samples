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

import { ColorMetrics, LengthMetrics, router } from '@kit.ArkUI';
import Logger from '../utils/Logger';
import { KeyCode } from '@kit.InputKit';
import cameraDemo from 'libentry.so';
import {
  photoFrameMarkKey,
  photoResolutionKey,
  photoMirrorKey,
  photoWaterMarkKey,
  resolutionIndexFour,
  resolutionIndexOne,
  resolutionIndexThree,
  resolutionIndexTwo,
  resolutionListKey,
  videoResolutionKey,
  videoWaterMarkKey
} from '../common/Constants';
import PreferenceUtil from '../utils/PreferenceUtil';
import CameraService from '../models/CameraModel';
import { camera } from '@kit.CameraKit';
import { deviceInfo } from '@kit.BasicServicesKit';

const TAG = 'Setting';
const MULTI_CAMERA_EXCLUDED_DEVICE_PREFIX = 'gk6320';

//点击tab键触发聚焦
function tabClick() {
  try {
  } catch (err) {
    console.error('settingList inputEventClient' + err);
  }
}

@Entry
@Component
struct Setting {
  //照片镜像开关
  @StorageLink('photoMirrorSwitch') photoMirrorSwitch: boolean = false;
  //相机水印开关
  @StorageLink('cameraWaterMarkSwitch') cameraWaterMarkSwitch: boolean = false;
  //相机相框开关
  @StorageLink('cameraWaterFrameSwitch') cameraWaterFrameSwitch: boolean = false;
  //视频水印开关
  @StorageLink('videoWaterMarkSwitch') videoWaterMarkSwitch: boolean = false;
  //照片分辨率
  @State cameraResolution: string = '1080*720';
  //视频分辨率
  @State videoResolution: string = '1080*720';
  //分辨率类型
  @State resolutionType: string = 'photo';
  @State testData: boolean = false;
  @State list: string[] = [];
  @State camerasArray: camera.CameraDevice[] = [];
  @StorageLink('isMultiCameraMode') isMultiCameraMode: boolean = false;
  // 新增：检测是否从多相机页面进入
  @StorageLink('fromMultiCamera') fromMultiCamera: boolean = false;
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogResolution({
      type: this.resolutionType,
      resolution: this.resolutionType == 'photo' ? this.cameraResolution : this.videoResolution,
      changeInputValue: (val: string) => {
        if (this.resolutionType === 'photo') {
          this.cameraResolution = val;
          let index = this.list.indexOf(val);
          PreferenceUtil.saveConfig(photoResolutionKey, index);

          cameraDemo.resolutionPhoto(val);
        } else if (this.resolutionType === 'video') {
          this.videoResolution = val;
          cameraDemo.resolutionVedio(val);
          let index = this.list.indexOf(val);
          PreferenceUtil.saveConfig(videoResolutionKey, index);
        }
      }
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: true,
    backgroundColor: 0xd9ffffff,
    cornerRadius: 10,
  });

  aboutToAppear(): void {
    let resolutionStr = PreferenceUtil.getConfig(resolutionListKey, '') as string;
    if (resolutionStr.length) {
      this.list = JSON.parse(resolutionStr);
    } else {
      this.list = [];
    }
    let cameraIndex = PreferenceUtil.getConfig(photoResolutionKey, 0) as number;
    let videoIndex = PreferenceUtil.getConfig(videoResolutionKey, 0) as number;
    if (this.list.length) {
      this.cameraResolution = this.list[cameraIndex];
      this.videoResolution = this.list[videoIndex];
    } else {
      this.cameraResolution = '';
      this.videoResolution = '';
    }

    this.cameraWaterMarkSwitch = PreferenceUtil.getConfig(photoWaterMarkKey, false) as boolean;
    this.photoMirrorSwitch = this.getMirrorParam();
    this.cameraWaterFrameSwitch = PreferenceUtil.getConfig(photoFrameMarkKey, false) as boolean;
    this.videoWaterMarkSwitch = PreferenceUtil.getConfig(videoWaterMarkKey, false) as boolean;

    AppStorage.setOrCreate('selectedFrame', 'fd://photopic1');
    AppStorage.setOrCreate('selectedVideoWaterMark', 'fd://photopic1');
    AppStorage.setOrCreate('selectedPhotoWaterMark', 'fd://photopic1');

    this.camerasArray = CameraService.getSupportedCameras();

    // 调试日志：显示fromMultiCamera状态
    Logger.info(TAG, `设置页面启动 - fromMultiCamera: ${this.fromMultiCamera}, 多机位按钮将${this.fromMultiCamera ? '隐藏' : '显示'}`);
  }

  onPageShow(): void {

  }

  getMirrorParam():boolean{
    return !(PreferenceUtil.getConfig(photoMirrorKey, false) as boolean);
  }

  handlePhotoMirror(value: boolean) {
    Logger.info(TAG, 'handlePhotoMirror ' + value);
    PreferenceUtil.saveConfig(photoMirrorKey, value);
    this.photoMirrorSwitch = value;
  }

  //相机水印开关处理
  handleCameraWaterMark(value: boolean) {
    Logger.info(TAG, 'handleCameraWaterMark ' + value);
    PreferenceUtil.saveConfig(photoWaterMarkKey, value);
    if (value) {
      const selectedPhotoWaterMark = 'default';
      cameraDemo.watermarkPhotoPic(selectedPhotoWaterMark);
      this.cameraWaterMarkSwitch = true;
      cameraDemo.watermarkPhotoFont('fd://photofont');
    } else {
      this.cameraWaterMarkSwitch = false;
    }
  }

  //相机相框开关处理
  handleCameraFrame(value: boolean) {
    Logger.info(TAG, 'handleCameraFrame ' + value);
    PreferenceUtil.saveConfig(photoFrameMarkKey, value);
    if (value) {
      const selectedFrame = 'default';
      cameraDemo.watermarkPhotoPic(selectedFrame);
      this.cameraWaterFrameSwitch = true;
    } else {
      this.cameraWaterFrameSwitch = false;
    }
  }

  //视频水印开关处理
  handleVideoWatermark(value: boolean) {
    Logger.info(TAG, 'handleVideoWatermark ' + value);
    PreferenceUtil.saveConfig(videoWaterMarkKey, value);
    if (value) {
      const selectedVideoWaterMark = 'default';
      cameraDemo.watermarkVedioPic(selectedVideoWaterMark);
      this.videoWaterMarkSwitch = true;
      cameraDemo.watermarkVedioFont('fd://vediofont');
    } else {
      this.videoWaterMarkSwitch = false;
    }
  }

  handleSwitch(isOn: boolean) {
    if (CameraService.getSupportedCameras().length > 1) {
      this.isMultiCameraMode = isOn;
      PreferenceUtil.saveConfig(photoResolutionKey, 0);
      PreferenceUtil.saveConfig(videoResolutionKey, 0);

      // 新增：如果启用多相机模式，跳转到多相机预览页面
      if (isOn) {
        Logger.info(TAG, '跳转到多相机预览页面');
        router.pushUrl({
          url: 'pages/MultiCameraPreviewPage'
        }).catch(() => {
          Logger.info(TAG, 'router pushUrl err');
        });
      }
    }
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.setting'))
          .size({ width: '126lpx', height: '88lpx' })
          .fontSize('63lpx')
          .fontColor('#FFFFFF')
      }
      .padding({ left: '96lpx', top: '42lpx' })
      .width('100%')

      Column({ space: '23lpx' }) {
        if (!this.isMultiCameraMode) {
          Row() {
            Text($r('app.string.photo'))
              .fontSize('36lpx')
              .fontColor('#808080')
          }
          .width('100%')

          Column() {
            SettingItem({
              img: $r('app.media.resolution'),
              title: $r('app.string.photoResolution'),
              isON: this.testData,
              content: this.cameraResolution,
              contentCanClick: false,
              clickAction: () => {
                this.resolutionType = 'photo';
                this.dialogController?.open();
              }
            });
            SettingItem({
              img: $r('app.media.camera_mirror_default'),
              title: $r('app.string.cameraMirror'),
              isON: this.photoMirrorSwitch,
              contentCanClick: false,
              handleSwitch: this.handlePhotoMirror,
              clickAction: () => {

              }
            });
            SettingItem({
              img: $r('app.media.camera_watermark'),
              title: $r('app.string.cameraWatermark'),
              isON: this.cameraWaterMarkSwitch,
              contentCanClick: false,
              handleSwitch: this.handleCameraWaterMark,
              clickAction: () => {
                router.pushUrl({
                  url: 'pages/WaterMarkPage',
                  params: {
                    type: 'photo'
                  }
                });
              }
            });
            SettingItem({
              img: $r('app.media.camera_frame'),
              title: $r('app.string.cameraFrame'),
              isON: this.cameraWaterFrameSwitch,
              contentCanClick: false,
              handleSwitch: this.handleCameraFrame,
              clickAction: () => {
                router.pushUrl({
                  url: 'pages/PhotoFramePage'
                });
              }
            });
          }
          .borderRadius('48lpx')
          .width('100%')
          .height('35%')
          .backgroundColor('#333333')
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({
            left: '33lpx',
            right: '34lpx',
            top: '67lpx',
            bottom: '58lpx'
          });

          Row() {
            Text($r('app.string.video'))
              .fontSize('36lpx')
              .fontColor('#808080')
          }
          .width('100%')

          Column() {
            SettingItem({
              img: $r('app.media.video_resolution'),
              title: $r('app.string.videoResolution'),
              isON: this.testData,
              content: this.videoResolution,
              contentCanClick: false,
              clickAction: () => {
                this.resolutionType = 'video';
                this.dialogController?.open();
              }
            });
            SettingItem({
              img: $r('app.media.video_watermark'),
              title: $r('app.string.videoWatermark'),
              isON: this.videoWaterMarkSwitch,
              contentCanClick: false,
              handleSwitch: this.handleVideoWatermark,
              clickAction: () => {
                router.pushUrl({
                  url: 'pages/WaterMarkPage',
                  params: {
                    type: 'video'
                  }
                });
              }
            });
          }
          .borderRadius('48lpx')
          .width('100%')
          .height('18%')
          .backgroundColor('#333333')
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({
            left: '33lpx',
            right: '34lpx',
            top: '49lpx',
            bottom: '43lpx'
          });
        }
        // 多机位按钮：只有在SDK版本满足且不是从多相机页面进入时才显示。6320不保留多机位功能
        if (deviceInfo.sdkApiVersion > 12 &&
          !this.fromMultiCamera &&
          !deviceInfo.productModel.startsWith(MULTI_CAMERA_EXCLUDED_DEVICE_PREFIX)) {
          Row() {
            Text($r('app.string.cameraMode'))
              .fontSize('36lpx')
              .fontColor('#808080')
          }
          .width('100%')

          Column() {
            SettingItem({
              img: $r('app.media.video_watermark'),
              title: $r('app.string.multiCamera'),
              isON: this.isMultiCameraMode,
              contentCanClick: false,
              handleSwitch: this.handleSwitch,
              clickAction: () => {
              }
            });
          }
          .borderRadius('48lpx')
          .width('100%')
          .height('15%')
          .backgroundColor('#333333')
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({
            left: '33lpx',
            right: '34lpx',
            top: '49lpx',
            bottom: '43lpx'
          });
        }

        // 如果是从多相机页面进入，显示当前模式信息
        if (this.fromMultiCamera) {
          Row() {
            Text($r('app.string.cameraMode'))
              .fontSize('36lpx')
              .fontColor('#808080')
          }
          .width('100%')

          Column() {
            Row() {
              Image($r('app.media.video_watermark'))
                .width('60lpx')
                .height('40lpx')
                .objectFit(ImageFit.Contain)

              Text('当前为多机位模式中的单相机视图')
                .fontSize('32lpx')
                .fontColor('#FFFFFF')
                .margin({ left: '34lpx' })

              Text('使用返回键切换')
                .fontSize('28lpx')
                .fontColor('#CCCCCC')
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({ left: '20lpx', right: '20lpx' })
          }
          .borderRadius('48lpx')
          .width('100%')
          .height('15%')
          .backgroundColor('#444444')
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .padding({
            left: '33lpx',
            right: '34lpx',
            top: '49lpx',
            bottom: '43lpx'
          });
        }
      }
      .width('55%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#FF18181A')
    .onKeyEvent((event) => {
      if (event.keyCode == KeyCode.KEYCODE_ESCAPE) {
        router.back();
      }
    });
  }
}

@Component
struct SettingItem {
  @State img: ResourceStr = '';
  @State title: Resource = $r('app.string.multiCamera');
  @Prop content: string = '';
  @Link isON: boolean
  @State contentCanClick: boolean = false;
  handleSwitch: (value: boolean) => void = (value: boolean) => {
  }
  clickAction: () => void = () => {
  }
  @State isEnabled: boolean = true;
  @State isClick: boolean = true;
  @State titleBase: string = '';
  @StorageLink('isMultiCameraMode') isMultiCameraMode: boolean = false;

  async aboutToAppear(): Promise<void> {
    this.titleBase = await getContext(this).resourceManager.getStringValue($r('app.string.multiCamera'));
    if (CameraService.getSupportedCameras().length < 2 && this.title.id == $r('app.string.multiCamera').id) {
      this.isEnabled = false;
    }
  }

  build() {
    Row() {
      Row() {
        Image(this.img)
          .width('60lpx')
          .height('40lpx')
          .objectFit(ImageFit.Contain)
          .focusable(false)

        Text(this.title)
          .size({ width: '240lpx', height: '50lpx' })
          .fontSize('36lpx')
          .fontColor('#FFFFFF')
          .margin({ left: '34lpx' })
          .focusable(false)
          .focusBox({
            margin: LengthMetrics.px(5),
            strokeColor: ColorMetrics.resourceColor(Color.White),
            strokeWidth: LengthMetrics.px(2)
          })
          .onClick(() => {
            if (this.contentCanClick) {
              this.clickAction();
            }
          });
      }


      Toggle({ type: ToggleType.Switch, isOn: this.isON })
        .selectedColor('#007DFF')
        .switchPointColor('#FFFFFF')
        .width('115lpx')
        .height('53lpx')
        .focusBox({
          margin: LengthMetrics.px(5),
          strokeColor: ColorMetrics.resourceColor(Color.White),
          strokeWidth: LengthMetrics.px(2)
        })
        .onChange((isOn: boolean) => {
          console.info(this.title + 'Component status:' + isOn);
          this.handleSwitch(isOn);
        })
        .enabled(this.isEnabled)
        .visibility(this.content === '' ? Visibility.Visible : Visibility.None)
        .defaultFocus(this.isMultiCameraMode)

      Row() {
        Text(this.content)
          .fontSize('34lpx')
          .fontColor('#FFFFFF')
        Image($r('app.media.right'))
          .width('30lpx')
          .height('30lpx')
          .objectFit(ImageFit.Contain)
      }
      .defaultFocus(!this.isMultiCameraMode)
      .visibility(this.content != '' ? Visibility.Visible : Visibility.None)
      .groupDefaultFocus(true)
      .focusBox({
        margin: LengthMetrics.px(5),
        strokeColor: ColorMetrics.resourceColor(Color.White),
        strokeWidth: LengthMetrics.px(2)
      })
      .onClick(() => {
        this.clickAction();

      });

    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }
}

@CustomDialog
struct CustomDialogResolution {
  @State resolution: string = '';
  @State resolutionList: string[] = [];
  //照片还是视频
  type: string = '';
  controller?: CustomDialogController;
  changeInputValue: (val: string) => void = () => {
  };

  aboutToAppear(): void {
    let list: string[] = JSON.parse(PreferenceUtil.getConfig(resolutionListKey, []));
    if (list.length) {
      this.resolutionList = JSON.parse(PreferenceUtil.getConfig(resolutionListKey, []));
      //   过滤掉一样的
      this.resolutionList=this.resolutionList.filter((item,index)=>{
        return this.resolutionList.indexOf(item)===index;
      });
    }

    setTimeout(() => {
      tabClick();
    }, 500)
  }

  build() {
    Column() {
      Text($r('app.string.resolution'))
        .fontSize('63lpx')
        .fontColor(Color.White)
      Scroll() {
        Column() {
          ForEach(this.resolutionList, (item: string, index: number) => {
            Row({space: '10lpx'}) {
              Text(item)
                .fontSize('48lpx')
                .fontColor(Color.White)
              Radio({ value: 'Radio' + index, group: 'resolutionGroup' })
                .checked(this.resolution == item)
                .width('60lpx')
                .height('60lpx')
                .focusBox({
                  margin: LengthMetrics.px(5),
                  strokeColor: ColorMetrics.resourceColor(Color.White),
                  strokeWidth: LengthMetrics.px(2)
                })
                .onChange((isChecked: boolean) => {
                  if (isChecked) {
                    this.changeInputValue(item);
                  }
                })
                .onClick(() => {
                  this.controller?.close();
                });
            }.width('100%').justifyContent(FlexAlign.SpaceBetween).padding({ left: '20lpx', right: '20lpx' })
          });
        }
        .justifyContent(FlexAlign.SpaceAround)
      }
      .constraintSize({
        maxHeight: '70%'
      })
      .width('100%')
    }
    .backgroundColor('#2D2B2B')
    .width('60%')
    .borderRadius('48lpx')
    .padding('10lpx')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
