/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { fileIo } from '@kit.CoreFileKit'
import { display } from '@kit.ArkUI'
import { camera } from '@kit.CameraKit'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import player from 'libplayer.so'
import recorder from 'librecorder.so'
import Logger from '../common/utils/Logger'
import DateTimeUtil from '../common/utils/DateTimeUtils'
import { CommonConstants as Const } from '../common/CommonConstants'
import { CameraDataModel } from '../model/CameraDateModel'
import { encoderProfileCameraCheck, setFirstCameraProfile } from '../common/utils/CameraCheck'
import picker from '@ohos.file.picker'

const TAG: string = 'Sample_Player';
const DATETIME: DateTimeUtil = new DateTimeUtil();

@Entry
@Component
export struct Player {
  @State buttonEnabled: boolean = true;
  @State isShow: boolean = false;
  private videoDecoderType: number = 0;
  private videoDecoderRunMode: number = 0;
  private cameraData: CameraDataModel = new CameraDataModel();
  private selectFilePath: string | null = null;
  private display = display.getDefaultDisplaySync();
  private sourcePath: string[] = ['从文件管理选取', '从图库选取'];

  selectFile() {
    TextPickerDialog.show({
      range: this.sourcePath,
      canLoop: false,
      selected: 0,
      onAccept: (value: TextPickerResult) => {
        switch (value.value) {
          case '从文件管理选取':
            this.selectDocFile();
            break;
          case '从图库选取':
            this.selectAlbumFile();
            break;
          default:
            this.selectAlbumFile();
            break;
        }
      }
    })
  }

  selectDocFile() {
    let documentSelectOptions = new picker.DocumentSelectOptions;
    let documentViewPicker = new picker.DocumentViewPicker;
    documentViewPicker.select(documentSelectOptions)
      .then((documentSelectResult) => {
        this.selectFilePath = documentSelectResult[0];
        if (this.selectFilePath == null) {
          this.getUIContext().getPromptAction().showToast({
            message: $r('app.string.alert'),
            duration: Const.DURATION,
            bottom: Const.BOTTOM
          })
        } else {
          this.play();
          Logger.info(TAG, 'documentViewPicker.select to file succeed and URI is:' + this.selectFilePath);
        }
      })
  }

  selectAlbumFile() {
    let photoPicker = new photoAccessHelper.PhotoViewPicker();
    photoPicker.select({
      MIMEType: photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE,
      maxSelectNumber: 1
    })
      .then((photoSelectResult) => {
        this.selectFilePath = photoSelectResult.photoUris[0];
        if (this.selectFilePath == null) {
          this.getUIContext().getPromptAction().showToast({
            message: $r('app.string.alert'),
            duration: Const.DURATION,
            bottom: Const.BOTTOM
          });
        } else {
          this.play();
          Logger.info(TAG, 'documentViewPicker.select to file succeed and URI is:' + this.selectFilePath);
        }
      })
  }

  setPlaybackSpeed(speed: number) {
    player.setPlaybackSpeed(speed);
  }

  play() {
    let inputFile = fileIo.openSync(this.selectFilePath, fileIo.OpenMode.READ_ONLY);
    if (!inputFile) {
      Logger.error(TAG, 'player inputFile is null');
    }
    let inputFileState = fileIo.statSync(inputFile.fd);
    if (inputFileState.size <= 0) {
      Logger.error(TAG, 'player inputFile size is 0');
    }
    this.buttonEnabled = false;
    player.playNative(inputFile.fd, Const.DEFAULT_VALUE, inputFileState.size, this.videoDecoderType,
      this.videoDecoderRunMode, () => {
        Logger.info(TAG, 'player JSCallback');
        this.buttonEnabled = true;
        fileIo.close(inputFile);
      })
  }

  async checkIsProfileSupport(): Promise<void> {
    let cameraManager: camera.CameraManager = camera.getCameraManager(getContext(this));
    if (!cameraManager) {
      Logger.error(TAG, 'camera.getCameraManager error!');
    }

    let encoderProfile: undefined | camera.VideoProfile =
      await encoderProfileCameraCheck(cameraManager, this.cameraData);
    if (!encoderProfile) {
      Logger.error(TAG, 'encoderProfile is not found');
      this.getUIContext().getPromptAction().showToast({
        message: $r('app.string.alert1'),
        duration: Const.DURATION,
        bottom: Const.BOTTOM,
        backgroundColor: Color.White,
        backgroundBlurStyle: BlurStyle.NONE
      });
      this.cameraData = new CameraDataModel();
      encoderProfile = await encoderProfileCameraCheck(cameraManager, this.cameraData);
      if (!encoderProfile) {
        Logger.error(TAG, '1080P video profile is not found, set first camera profile');
        let encoderProfile: camera.VideoProfile = await setFirstCameraProfile(cameraManager) as camera.VideoProfile;
        this.cameraData.cameraWidth = encoderProfile.size.width;
        this.cameraData.cameraHeight = encoderProfile.size.height;
        this.cameraData.frameRate = encoderProfile.frameRateRange.max;
        this.cameraData.bitRate = Const.BITRATE_VIDEO_2M;
        this.cameraData.format = encoderProfile.format;
      }
      return;
    } else {
      this.getUIContext().getPromptAction().showToast({
        message: $r('app.string.success'),
        duration: Const.DURATION,
        bottom: Const.BOTTOM,
        backgroundColor: Color.White,
        backgroundBlurStyle: BlurStyle.NONE
      });
    }
  }

  @Builder
  PlayerSettingButton() {
    Button('设置')
      .size({
        width: '18.5%',
        height: $r('app.float.index_button_height')
      })
      .enabled(this.buttonEnabled)
      .margin({ bottom: $r('app.float.button_margin_bottom') })
      .onClick(() => {
        this.getUIContext().showTextPickerDialog({
          defaultPickerItemHeight: Const.DEFAULT_PICKER_ITEM_HEIGHT,
          selectedTextStyle: ({
            font: ({
              size: Const.SELECTED_TEXT_STYLE_FONT_SIZE
            })
          }),
          range: Const.PLAYER_INFO,
          canLoop: false,
          alignment: DialogAlignment.Center,
          backgroundColor: Color.White,
          backgroundBlurStyle: BlurStyle.BACKGROUND_ULTRA_THICK,
          onAccept: (value: TextPickerResult) => {
            switch (value.value[0]) {
              case Const.VIDEO_DECODE_TYPE[0]: {
                this.videoDecoderType = 0;
                break;
              }
              case Const.VIDEO_DECODE_TYPE[1]: {
                this.videoDecoderType = 1;
                break;
              }
              case Const.VIDEO_DECODE_TYPE[2]: {
                this.videoDecoderType = 2;
                break;
              }
              default:
                break;
            }

            switch (value.value[1]) {
              case Const.VIDEO_DECODER_RUN_MODE[0]: {
                this.videoDecoderRunMode = 0;
                break;
              }
              case Const.VIDEO_DECODER_RUN_MODE[1]: {
                this.videoDecoderRunMode = 1;
                break;
              }
              default:
                break;
            }

            this.getUIContext().getPromptAction().showToast({
              message: $r('app.string.success'),
              duration: Const.DURATION,
              bottom: Const.BOTTOM,
              backgroundColor: Color.White,
              backgroundBlurStyle: BlurStyle.NONE
            });
          }
        })
      })
  }

  @Builder
  RecorderSettingButton() {
    Button('设置')
      .enabled(this.buttonEnabled)
      .size({
        width: '18.5%',
        height: $r('app.float.index_button_height')
      })
      .enabled(this.buttonEnabled)
      .onClick(() => {
        this.getUIContext().showTextPickerDialog({
          defaultPickerItemHeight: Const.DEFAULT_PICKER_ITEM_HEIGHT,
          selectedTextStyle: ({
            font: ({
              size: Const.SELECTED_TEXT_STYLE_FONT_SIZE
            })
          }),
          range: Const.RECORDER_INFO,
          canLoop: false,
          alignment: DialogAlignment.Center,
          backgroundColor: Color.White,
          backgroundBlurStyle: BlurStyle.BACKGROUND_ULTRA_THICK,
          onAccept: (value: TextPickerResult) => {
            switch (value.value[0]) {
              case Const.VIDEO_MIMETYPE[0]: {
                this.cameraData.setCodecFormat(Const.TRUE, Const.MIME_VIDEO_HEVC);
                break;
              }
              case Const.VIDEO_MIMETYPE[1]: {
                this.cameraData.setCodecFormat(Const.FALSE, Const.MIME_VIDEO_AVC);
                break;
              }
              case Const.VIDEO_MIMETYPE[2]: {
                this.cameraData.setCodecFormat(Const.FALSE, Const.MIME_VIDEO_HEVC);
                break;
              }
              default:
                break;
            }

            switch (value.value[1]) {
              case Const.VIDEO_RESOLUTION[0]: {
                this.cameraData.setResolution(Const.VIDEO_WIDTH_4K, Const.VIDEO_HEIGHT_4K, Const.BITRATE_VIDEO_30M);
                break;
              }
              case Const.VIDEO_RESOLUTION[1]: {
                this.cameraData.setResolution(Const.VIDEO_WIDTH_1080P, Const.VIDEO_HEIGHT_1080P,
                  Const.BITRATE_VIDEO_20M);
                break;
              }
              case Const.VIDEO_RESOLUTION[2]: {
                this.cameraData.setResolution(Const.VIDEO_WIDTH_720P, Const.VIDEO_HEIGHT_720P, Const.BITRATE_VIDEO_10M);
                break;
              }
              default:
                break;
            }

            switch (value.value[2]) {
              case Const.VIDEO_FRAMERATE[0]: {
                this.cameraData.frameRate = Const.FRAMERATE_VIDEO_30FPS;
                break;
              }
              case Const.VIDEO_FRAMERATE[1]: {
                this.cameraData.frameRate = Const.FRAMERATE_VIDEO_60FPS;
                break;
              }
              default:
                break;
            }
            this.checkIsProfileSupport();
          }
        })
      })
  }

  @Builder
  Authorized() {
    Column() {
      Text($r('app.string.saveButtonNote'))
        .width('100%')
        .fontSize('16vp')
        .margin({ bottom: '12vp' })

      Row() {
        Button($r('app.string.saveButtonCancel'))
          .onClick(() => {
            this.isShow = false
          })
          .width('48%')

        Blank()

        SaveButton({ text: SaveDescription.SAVE })
          .onClick(async () => {
            const context = this.getUIContext().getHostContext();
            let helper = photoAccessHelper.getPhotoAccessHelper(context);
            let uri = await helper.createAsset(photoAccessHelper.PhotoType.VIDEO, 'mp4', {
              title: `AVCodecVideo_${DATETIME.getDate()}_${DATETIME.getTime()}`
            });
            await this.checkIsProfileSupport();
            let file = await fileIo.open(uri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
            this.cameraData.outputfd = file.fd;
            if (this.cameraData.outputfd !== null) {
              recorder.initNative(this.cameraData.outputfd, this.cameraData.videoCodecMime, this.cameraData.cameraWidth,
                this.cameraData.cameraHeight, this.cameraData.frameRate, this.cameraData.isHDRVivid,
                this.cameraData.bitRate, this.cameraData.format).then((data) => {
                if (data.surfaceId !== null) {
                  this.cameraData.surfaceId = data.surfaceId;
                  this.getUIContext().getRouter().pushUrl({
                    url: 'recorder/Recorder',
                    params: this.cameraData
                  });
                }
              })
            } else {
              Logger.error(TAG, 'get outputfd failed!');
            }
          })
          .width('48%')
          .height('40vp')
      }
      .justifyContent(FlexAlign.SpaceAround)
      .alignItems(VerticalAlign.Bottom)
      .margin({ bottom: '44vp' })
      .width('100%')
      .height('52vp')
    }
    .justifyContent(FlexAlign.End)
    .padding({ left: '16vp', right: '16vp' })
    .width('100%')
    .height('100%')
  }

  @Builder
  Window() {
    Row() {
      XComponent({
        id: 'player',
        type: XComponentType.SURFACE,
        libraryname: 'player'
      })
        .height(Const.FULL_SIZE)
        .width(Const.FULL_SIZE)
        .gesture(
          GestureGroup(GestureMode.Exclusive,
            LongPressGesture({ repeat: true })// 长按动作存在会连续触发
              .onAction((event: GestureEvent | undefined) => {
                if (!this.buttonEnabled) {
                  this.setPlaybackSpeed(2);
                  this.getUIContext().getPromptAction().showToast({ message: 'X2' });
                }
              })// 长按动作一结束触发
              .onActionEnd(() => {
                if (!this.buttonEnabled) {
                  this.setPlaybackSpeed(1);
                  this.getUIContext().getPromptAction().showToast({ message: 'X1' });
                }
              }),
            /**
             * todo:单击播放窗口播放/暂停
             * TapGesture({ count: 1, fingers: 1 })
             *   .onAction(() => {
             *     if (!this.isStart) {
             *       this.resume()
             *     } else {
             *       this.pause()
             *     }
             *     this.isStart = !this.isStart
             *   })
             */
          )
        )
    }
    .alignRules({
      'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
      'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start }
    })
  }

  build() {
    Stack() {
      this.Window()

      Column() {
        Row() {
          this.PlayerSettingButton()

          Blank(5)
          Button(this.buttonEnabled ? $r('app.string.play') : $r('app.string.playing'))
            .onClick(() => {
              this.selectFile()
            })
            .size({
              width: '60%',
              height: $r('app.float.index_button_height')
            })
            .enabled(this.buttonEnabled)
            .margin({ bottom: $r('app.float.button_margin_bottom') })
          Blank(5)
          Button('倍速')
            .enabled(!this.buttonEnabled)
            .size({
              width: '18.5%',
              height: $r('app.float.index_button_height')
            })
            .margin({ bottom: $r('app.float.button_margin_bottom') })
            .onClick(() => {
              this.getUIContext().getPromptAction().showToast({ message: '播放时长按播放窗口也可倍速播放' });
              TextPickerDialog.show({
                defaultPickerItemHeight: Const.DEFAULT_PICKER_ITEM_HEIGHT,
                selectedTextStyle: ({
                  font: ({
                    size: Const.SELECTED_TEXT_STYLE_FONT_SIZE
                  })
                }),
                range: Const.PLAYBACK_SPEED,
                canLoop: false,
                alignment: DialogAlignment.Center,
                backgroundColor: Color.White,
                backgroundBlurStyle: BlurStyle.BACKGROUND_ULTRA_THICK,
                onAccept: (value: TextPickerResult) => {
                  switch (value.value) {
                    case Const.PLAYBACK_SPEED[0]: {
                      this.setPlaybackSpeed(1);
                      this.getUIContext().getPromptAction().showToast({ message: 'X1' });
                      break;
                    }
                    case Const.PLAYBACK_SPEED[1]: {
                      this.setPlaybackSpeed(2);
                      this.getUIContext().getPromptAction().showToast({ message: 'X2' });
                      break;
                    }
                    case Const.PLAYBACK_SPEED[2]: {
                      this.setPlaybackSpeed(3);
                      this.getUIContext().getPromptAction().showToast({ message: 'X3' });
                      break;
                    }
                    default:
                      break;
                  }
                }
              })
            })
        }

        Row() {
          this.RecorderSettingButton()
          Blank(5)
          Button($r('app.string.record'))
            .onClick(() => {
              this.isShow = true;
            })
            .bindSheet($$this.isShow, this.Authorized, {
              height: 210,
              title: {
                title: $r('app.string.saveButtonTitle')
              }
            })
            .size({
              width: '80%',
              height: $r('app.float.index_button_height')
            })
            .enabled(this.buttonEnabled)
        }
      }
      .margin({ top: (this.display.height * 0.7) + 'px' })
      .alignRules({
        'bottom': { 'anchor': '__container__', 'align': VerticalAlign.Bottom },
        'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start }
      })
      .padding({ left: '16vp', right: '16vp', bottom: '16vp' })
      .width($r('app.string.full_width'))
      .height($r('app.float.index_column_height'))
      .justifyContent(FlexAlign.End)
    }
    .width($r('app.string.full_width'))
    .height($r('app.string.full_height'))
  }
}