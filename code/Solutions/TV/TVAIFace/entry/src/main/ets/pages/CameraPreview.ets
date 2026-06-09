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
import Logger from '../common/Logger';
import CameraService from '../common/CameraService';
import { image } from '@kit.ImageKit';
import { BusinessError } from '@ohos.base';
import { camera } from '@kit.CameraKit';
import { CamerasListDialog } from '../Components/CamerasListDialog';
import { KeyCode } from '@kit.InputKit';
import { mindSporeLite } from '@kit.MindSporeLiteKit';
import { common } from '@kit.AbilityKit';
import { LengthMetricsUnit, promptAction } from '@kit.ArkUI';
import { CRect2f, _ratio_enum, _scale_enum, bbox_pred, nms_cpu } from '../utils/Caffe';
import { log } from '../utils/Log';
import { getScreenSize } from '../utils/Utils';
import { taskpool } from '@kit.ArkTS';
import { AcInfo, AnchorCfg, FaceObject, finalboxModel } from '../Types/ParamsType';
import { EventUtil } from '../common/EventUtil';

const region: image.Region = {
  size: { width: 640, height: 480 },
  x: 0,
  y: 0
};


@Builder
export function CameraPreviewBuilder() {
  CameraPreview();
}

@Concurrent
async function Argb2BgrTaskPoolFunc(rgba: Uint8Array, size: number): Promise<ArrayBuffer> {
  let bgr = new Float32Array(size * 3);
  for (let i = 0; i < size; i++) {
    bgr[i * 3 + 0] = rgba[i * 4 + 2];
    bgr[i * 3 + 1] = rgba[i * 4 + 1];
    bgr[i * 3 + 2] = rgba[i * 4 + 0];
  }
  const imgBuffer = bgr.buffer as ArrayBuffer;
  return imgBuffer;
}

async function mainTaskPoolFunc(rgba: Uint8Array, size: number): Promise<ArrayBuffer> {
  // 创建任务并执行
  let Argb2BgrTask: taskpool.Task = new taskpool.Task(Argb2BgrTaskPoolFunc, rgba, size);
  let Argb2BgrTaskResult: ArrayBuffer = await taskpool.execute(Argb2BgrTask) as ArrayBuffer;
  return Argb2BgrTaskResult;
}

@Component
struct CameraPreview {
  private context = getContext(this) as common.UIAbilityContext;
  private surfaceId: string = '-1';
  private tag: string = 'CameraPage';
  private mXComponentController: XComponentController = new XComponentController();
  private cameraService: CameraService = new CameraService(getContext(this));
  private canvasContext: CanvasRenderingContext2D =
    new CanvasRenderingContext2D(new RenderingContextSettings(true), LengthMetricsUnit.PX);
  private canvasContext2: CanvasRenderingContext2D =
    new CanvasRenderingContext2D(new RenderingContextSettings(true), LengthMetricsUnit.PX);
  @State camerasList: Array<camera.CameraDevice> = [];
  @State currentCameraDevice: camera.CameraDevice = {} as camera.CameraDevice; // 当前选中的相机Id
  @State pageW: number = 720;
  @State pageH: number = 480;
  @State canvasW: number = 720;
  @State canvasH: number = 480;
  @State canvasW2: number = 720;
  @State canvasH2: number = 480;
  canvasRatioW: number = 1; // canvas比率
  canvasRatioH: number = 1; // canvas比率
  @State offsetX: number = 0;
  @State offsetY: number = 0;
  @State faces: Array<FaceObject> = [];
  timerId: number | null = null;
  imgBuffer: ArrayBuffer | null = null;
  msliteModel: mindSporeLite.Model | null = null;
  // 相机列表弹窗实例
  camerasDialogController: CustomDialogController = new CustomDialogController({
    builder: CamerasListDialog({
      camerasList: this.camerasList,
      currentCameraDevice: this.currentCameraDevice,
      selectEvent: (cameraDevice: camera.CameraDevice) => {
        this.selectDialogCameraEvent(cameraDevice);
      }
    }),
    openAnimation: {
      duration: 500
    },
    gridCount: 12,
    alignment: DialogAlignment.Center,
    customStyle: true
  });
  @Consume('NavPathStack') pageStack: NavPathStack;
  isNextRound: boolean = true;

  selectDialogCameraEvent(cameraDevice: camera.CameraDevice) {
    this.currentCameraDevice = cameraDevice;
    this.cameraService.initCamera(this.surfaceId, cameraDevice);
  }

  async aboutToAppear() {
    // 进入就将焦点聚焦于多机位切换按钮
    focusControl.requestFocus('-1');
    getScreenSize().then((data) => {
      AppStorage.setOrCreate<number>('screen_px_w', data.pageW);
      AppStorage.setOrCreate<number>('screen_px_h', data.pageH);
      AppStorage.setOrCreate<number>('screen_lpx_w', data.width);
      AppStorage.setOrCreate<number>('screen_lpx_h', data.height);
      AppStorage.setOrCreate<number>('screen_dpi', data.dpi);
      AppStorage.setOrCreate<number>('screen_lpi', data.lpi);
      // this.screenW = data.width;
      // this.screenH = data.height;
      // this.pageW = data.pageW;
      // this.pageH = data.pageH;
      // 计算canvas宽高、比率
      if (this.pageW > this.pageH) {
        this.canvasH2 = this.pageH;
        this.canvasW2 = this.canvasW * this.canvasH2 / this.canvasH;
      } else {
        this.canvasW2 = this.pageW;
        this.canvasH2 = this.canvasH * this.canvasW2 / this.canvasW;
      }
      this.canvasRatioW = this.canvasW2 / this.canvasW;
      this.canvasRatioH = this.canvasH2 / this.canvasH;
      this.offsetX = Math.floor((this.pageW - this.canvasW2) / 2);
      this.offsetY = Math.floor((this.pageH - this.canvasH2) / 2);
    });
    let modelName = 'mnet_caffemodel_480_720.ms';
    await this.getModelBuffer(modelName);
  }

  async pixelMapToArrayBuffer(pixelMap: image.PixelMap) {
    try {
      const buffSize = await pixelMap.getPixelBytesNumber();
      const buffer = new ArrayBuffer(buffSize);
      await pixelMap.readPixelsToBuffer(buffer);
      this.rgbaToBgr(new Uint8Array(buffer), 720 * 480);
    } catch (e) {
      console.error('Failed to read pixels to buffer', e);
    }
  }

  rgbaToBgr(rgba: Uint8Array, size: number): void {
    let bgr = new Float32Array(size * 3);
    for (let i = 0; i < size; i++) {
      bgr[i * 3 + 2] = rgba[i * 4 + 2];
      bgr[i * 3 + 1] = rgba[i * 4 + 1];
      bgr[i * 3 + 0] = rgba[i * 4 + 0];
    }
    this.imgBuffer = bgr.buffer as ArrayBuffer;
  }

  async getPixelMapFromSurface() {
    this.timerId = setInterval(() => {
      if (this.isNextRound) {
        this.isNextRound = false;
        try {
          this.getUIContext()
            .getComponentSnapshot()
            .get('XComponent', { scale: 1, waitUntilRenderFinished: true })
            .then(async (pixelMap: PixelMap) => {
              await this.pixelMapToArrayBuffer(pixelMap);
              if (this.imgBuffer) {
                this.imageScan();
              }
            })
            .catch((error: BusinessError) => {
              log('Failed to create pixelmap', JSON.stringify(error));
            });
        } catch (err) {
          this.isNextRound = true;
        }
      }
    }, 100);
  }

  openCamerasListDialog() {
    // 打开相机列表弹窗
    this.camerasList = this.cameraService.getCamerasList();
    if (this.camerasList.length > 0 && this.camerasDialogController) {
      this.camerasDialogController.open();
    }
  }

  // 数据后处理
  acFilterAnchor(acArray: AcInfo[]) {
    let anchor_num = 2;
    let stride = [32, 16, 8];
    let anchor_cfg: Array<AnchorCfg> = [
      { SCALES: [32, 16], RATIOS: [1], BASE_SIZE: 16 },
      { SCALES: [8, 4], RATIOS: [1], BASE_SIZE: 16 },
      { SCALES: [2, 1], RATIOS: [1], BASE_SIZE: 16 }
    ];

    let confidence_threshold = 0.5;
    let nms_threshold = 0.4;

    let ratiow = 1.0;
    let ratioh = 1.0;

    let proposals: FaceObject[] = [];

    acArray.forEach((ac: AcInfo, index: number) => {
      let clsData = new Float32Array(ac.cls!.getData());
      let regData = new Float32Array(ac.reg!.getData());
      // let ptsData = new Float32Array(ac.pts!.getData());

      // log(`clsData length: ${clsData.length}`);
      // log(`regData length: ${regData.length}`);
      // log(`ptsData length: ${ptsData.length}`);

      let pts_length = 0;
      //      if (ptsData) {
      //        pts_length = ac['pts'].shape[1]/anchor_num/2;
      //      }

      let w = ac.cls!.shape[3];
      let h = ac.cls!.shape[2];
      let step = h * w;

      let anchor_stride = stride[index];
      let cfg: AnchorCfg = anchor_cfg[index];

      let base_anchor = new CRect2f(0, 0, cfg.BASE_SIZE - 1, cfg.BASE_SIZE - 1);
      let ratio_anchors: number[][] = _ratio_enum(base_anchor.val, cfg.RATIOS);
      let preset_anchors: number[][] = _scale_enum(ratio_anchors, cfg.SCALES);

      for (let i = 0; i < w; i++) {
        for (let j = 0; j < h; j++) {
          let id = j * w + i;
          for (let a = 0; a < anchor_num; a++) {
            let cls_score = clsData[(anchor_num + a) * step + id];
            if (cls_score > confidence_threshold) {
              let boxObj = new CRect2f(i * anchor_stride + preset_anchors[a][0],
                j * anchor_stride + preset_anchors[a][1],
                i * anchor_stride + preset_anchors[a][2],
                j * anchor_stride + preset_anchors[a][3]);
              let box: number[] = boxObj.val;

              let deltaObj = new CRect2f(regData[(a * 4 + 0) * step + id], regData[(a * 4 + 1) * step + id],
                regData[(a * 4 + 2) * step + id], regData[(a * 4 + 3) * step + id]);
              let delta: number[] = deltaObj.val;
              let res: FaceObject = {
                score: 0,
                finalbox: {
                  x: 0,
                  y: 0,
                  width: 0,
                  height: 0,
                  size: 0,
                  w: 0,
                  h: 0
                },
                pts: []
              };

              res.finalbox = bbox_pred(box, delta, this.canvasRatioW, this.canvasRatioH) as finalboxModel;
              res.score = cls_score;
              //              if (ptsData) {
              //                let pts_delta = [];
              //                for (let p = 0; p < pts_length; p++) {
              //                  pts_delta[p] = {
              //                    x: ptsData[(a * 10 + p * 2) * step+id],
              //                    y: ptsData[(a * 10 + p * 2 + 1) * step+id]
              //                  }
              //                }
              //                res.pts = landmark_pred(box, pts_delta);
              //              }
              //              log(`proposals data: ${JSON.stringify(res)}`);
              proposals.push(res);
            }
          }
        }
      }
    });

    let data: FaceObject[] = nms_cpu(proposals, nms_threshold);
    this.drawFace(data);
  }

  // 绘制人脸
  drawFace(data: FaceObject[]) {
    if (data.length < 1) {
      this.faces = [];
    } else {
      let faces: FaceObject[] = [];
      data.forEach((item: FaceObject) => {
        let finalbox = item.finalbox;
        //      let score = item.score;
        //      let pts = item.pts;

        let x: number = finalbox.x + this.offsetX;
        let y: number = finalbox.y + this.offsetY;

        let w = finalbox.w - finalbox.x;
        let h = finalbox.h - finalbox.y;

        let size1 = Math.floor(w / 5);
        let size2 = Math.floor(h / 5);
        let size = size1 > size2 ? size2 : size1;
        let face: FaceObject = {
          finalbox: {
            x,
            y,
            size,
            width: w,
            height: h,
            w,
            h,
          },
          pts: []
        };
        faces.push(face);
      });
      this.faces = faces;
    }
    this.isNextRound = true;
  }

  // 加载模型
  async getModelBuffer(modelName: string) {
    // let modelName = "mnet.ms";
    // let option: mindSporeLite.Context = {
    //   target: ["nnrt"]
    // };
    try {
      let modelBuffer = await this.context.resourceManager.getRawFileContent(modelName);
      let option: mindSporeLite.Context = {
        target: ['cpu']
      };
      this.msliteModel = await mindSporeLite.loadModelFromBuffer(modelBuffer.buffer as ArrayBuffer, option); // 加载模型
    } catch (e) {
      promptAction.showToast({
        message: 'AI模型加载失败，请重试！',
        duration: 3000,
        bottom: `${px2vp(1080 + 100) / 2}`
      });
    }
  }

  // AI接口推理图片
  async imageScan() {
    if (this.msliteModel == null) {
      return;
    }
    let modelInputs = this.msliteModel.getInputs(); // 获取模型输入 返回数组类型
    modelInputs.forEach((item, index) => {
      item.setData(this.imgBuffer); // 将图片输入
    });
    let modelOutputs = await this.msliteModel.predict(modelInputs); // 执行推理
    // if (modelInputs) {
    //   console.log(`modelOutputs length:` + modelOutputs.length);
    // } else {
    //   console.log(`modelOutputs:` + JSON.stringify(modelOutputs));
    // }
    let acArray: Array<AcInfo> = [{}, {}, {}]; // {32, 16, 8}
    modelOutputs.forEach((item, index) => {
      let name = item.name;
      let key = '';
      if (name.includes('face_rpn_cls_prob_reshape_stride')) {
        key = 'cls';
      } else if (name.includes('face_rpn_bbox_pred_stride')) {
        key = 'reg';
      }
      // else if (name.includes('face_rpn_landmark_pred_stride')) {
      //   key = "pts";
      // }
      if (name.includes('32')) {
        // acArray[0][key] = item;
        Object(acArray[0])[key] = item;
      } else if (name.includes('16')) {
        //acArray[1][key] = item;
        Object(acArray[1])[key] = item;
      } else if (name.includes('8')) {
        //acArray[2][key] = item;
        Object(acArray[2])[key] = item;
      }
    });
    this.acFilterAnchor(acArray);
  }

  build() {
    NavDestination() {
      Column() {
        Stack() {
          // 相机画面
          XComponent({
            type: XComponentType.SURFACE,
            controller: this.mXComponentController
          }).onLoad(async () => {
            Logger.info(this.tag, 'onLoad is called');
            this.mXComponentController.setXComponentSurfaceRect({ surfaceWidth: 720, surfaceHeight: 480 });
            // this.mXComponentController.setXComponentSurfaceRect({ surfaceWidth: 1920, surfaceHeight: 1080 });
            // this.mXComponentController.setXComponentSurfaceSize({ surfaceWidth: 1920, surfaceHeight: 1080 });
            this.surfaceId = this.mXComponentController.getXComponentSurfaceId();
            this.camerasList = this.cameraService.getCamerasList();
            if (this.camerasList.length > 0) {
              this.currentCameraDevice = this.camerasList[0];
            }
            this.cameraService.initCamera(this.surfaceId);
            this.getPixelMapFromSurface();
          })
            .id('XComponent')
            .width('720px')
            .height('480px');
          ForEach(this.faces, (item: FaceObject, index) => {
            Column() {
              Image($r('app.media.ic_left_above'))
                .width(`${item.finalbox.size}px`)
                .height(`${item.finalbox.size}px`)
                .position({ x: `${item.finalbox.x}px`, y: `${item.finalbox.y}px` });
              Image($r('app.media.ic_right_above'))
                .width(`${item.finalbox.size}px`)
                .height(`${item.finalbox.size}px`)
                .position({
                  x: `${item.finalbox.x + item.finalbox.width - item.finalbox.size}px`,
                  y: `${item.finalbox.y}px`
                });
              Image($r('app.media.ic_left_below'))
                .width(`${item.finalbox.size}px`)
                .height(`${item.finalbox.size}px`)
                .position({
                  x: `${item.finalbox.x}px`,
                  y: `${item.finalbox.y + item.finalbox.height - item.finalbox.size}px`
                });
              Image($r('app.media.ic_right_below'))
                .width(`${item.finalbox.size}px`)
                .height(`${item.finalbox.size}px`)
                .position({
                  x: `${item.finalbox.x + item.finalbox.width - item.finalbox.size}px`,
                  y: `${item.finalbox.y + item.finalbox.height - item.finalbox.size}px`
                });
            }
            .width(`${this.pageW}px`)
            .height(`${this.pageH}px`)
            .zIndex(5);
          });

          Row() {
            // 多机位切换按钮SVG
            Column() {
              Row() {
                Image($rawfile('Multi_Camera_On.svg'))
                  .width('100lpx')
                  .height('100lpx')
                  .objectFit(ImageFit.Cover)
                  .clip(true);
              }
              .width('100lpx')
              .height('100lpx')
              .justifyContent(FlexAlign.Center)
              .alignItems(VerticalAlign.Center);

              Text('多机位切换')
                .fontColor('#dbffffff')
                .fontSize('24lpx')
                .lineHeight('35lpx')
                .margin({ top: '12lpx' })
                .padding({
                  left: '15lpx',
                  top: '5lpx',
                  right: '15lpx',
                  bottom: '5lpx'
                });

            }
            .margin({ bottom: '120lpx' })
            .onTouch((e) => {
              EventUtil.isTouchEvent(e);
              if (e.type == TouchType.Up) {
                this.openCamerasListDialog();
              }
            });
          }
          .zIndex(6)
          .width('100%')
          .height('100%')
          .alignItems(VerticalAlign.Bottom)
          .justifyContent(FlexAlign.Center);
        }
        .width('100%')
        .height('100%');
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#18181A');
    }
    .hideTitleBar(true)
    .focusable(true)
    .onWillDisappear(() => {
      if (this.timerId != null) {
        clearInterval(this.timerId);
      }
      this.cameraService.releaseCamera();
    })
    .onKeyEvent(e => {
      e.stopPropagation();
      if ((e.keyCode == KeyCode.KEYCODE_DPAD_CENTER || e.keyCode == KeyCode.KEYCODE_ENTER) && e.type == KeyType.Up) {
        this.camerasList = this.cameraService.getCamerasList();
        if (this.camerasList.length > 0) {
          this.openCamerasListDialog();
          focusControl.requestFocus('dialog');
        } else {
          promptAction.showToast({
            message: '无可用摄像头',
            duration: 2000
          });
        }
      }
    });
  }
}
