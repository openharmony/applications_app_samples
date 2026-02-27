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
import { getScreenSize, drawImageSize } from '../utils/utils';
import { initInfo } from '../utils/log';
import { CRect2f, _ratio_enum, _scale_enum, bbox_pred, nms_cpu } from '../utils/caffe';
import { image } from '@kit.ImageKit';
import { mindSporeLite } from '@kit.MindSporeLiteKit';
import { LengthMetricsUnit, promptAction } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { taskpool } from '@kit.ArkTS';
import { AcInfo, AnchorCfg, FaceObject, finalboxModel, ImagePosition } from '../Types/ParamsType';

let log: (tag?: string | number, log?: string | number | undefined) => void = initInfo('index.ets');

@Builder
export function ImagePreviewBuilder() {
  ImagePreview();
}

@Concurrent
async function argb2BgrTaskPoolFunc(rgba: Uint8ClampedArray, size: number): Promise<ArrayBuffer> {
  let bgr: Float32Array = new Float32Array(size * 3);
  for (let i = 0; i < size; i++) {
    bgr[i * 3 + 0] = rgba[i * 4 + 2];
    bgr[i * 3 + 1] = rgba[i * 4 + 1];
    bgr[i * 3 + 2] = rgba[i * 4 + 0];
  }
  const imgBuffer: ArrayBuffer = bgr.buffer as ArrayBuffer;
  return imgBuffer;
}

async function mainTaskPoolFunc(rgba: Uint8ClampedArray, size: number): Promise<ArrayBuffer> {
  // 创建任务并执行
  let argb2BgrTask: taskpool.Task = new taskpool.Task(argb2BgrTaskPoolFunc, rgba, size);
  let argb2BgrTaskResult: ArrayBuffer = await taskpool.execute(argb2BgrTask) as ArrayBuffer;
  return argb2BgrTaskResult;
}

@Component
struct ImagePreview {
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  private canvasContext: CanvasRenderingContext2D =
    new CanvasRenderingContext2D(new RenderingContextSettings(true), LengthMetricsUnit.PX);
  private canvasContext2: CanvasRenderingContext2D =
    new CanvasRenderingContext2D(new RenderingContextSettings(true), LengthMetricsUnit.PX);
  @State canvasW: number = 720;
  @State canvasH: number = 480;
  @State canvasW2: number = 720;
  @State canvasH2: number = 480;
  // canvas比率
  canvasRatioW: number = 1;
  // canvas比率
  canvasRatioH: number = 1;
  imgBuffer: ArrayBuffer | null = null;
  @StorageLink('imageFd') imageFd: number | string = 0;
  @StorageLink('shouldScan') shouldScan: boolean = false;
  @State isScanning: boolean = false;
  @State focusId: string | number = 1;
  @State screenW: number = 1920;
  @State screenH: number = 1080;
  @State pageW: number = 1920;
  @State pageH: number = 1080;
  image: image.PixelMap | null = null;
  @State faces: Array<FaceObject> = [];
  @State offsetX: number = 0;
  @State offsetY: number = 0;
  @Consume('NavPathStack') pageStack: NavPathStack;

  aboutToAppear() {
    getScreenSize().then((data) => {
      AppStorage.setOrCreate<number>('screen_px_w', data.pageW);
      AppStorage.setOrCreate<number>('screen_px_h', data.pageH);
      AppStorage.setOrCreate<number>('screen_lpx_w', data.width);
      AppStorage.setOrCreate<number>('screen_lpx_h', data.height);
      AppStorage.setOrCreate<number>('screen_dpi', data.dpi);
      AppStorage.setOrCreate<number>('screen_lpi', data.lpi);
      this.screenW = data.width;
      this.screenH = data.height;
      this.pageW = data.pageW;
      this.pageH = data.pageH;
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
    if (this.shouldScan) {
      this.faces = [];
      this.shouldScan = false;
      this.image = null;
      this.loadImg();
    }
  }

  // 选在图片后加载
  async loadImg() {
    this.canvasContext.clearRect(0, 0, this.canvasW, this.canvasH);
    let imageSourceApi: image.ImageSource;
    if (typeof this.imageFd === 'number') {
      imageSourceApi = image.createImageSource(this.imageFd);
    } else {
      const value = await this.context.resourceManager.getRawFd(this.imageFd);
      imageSourceApi = image.createImageSource(value);

    }

    imageSourceApi.createPixelMap(async (err, data) => {
      if (data) {
        this.image = data;
        data.getImageInfo().then((image) => {
          let width: number = image.size.width;
          let height: number = image.size.height;
          let imgSize: ImagePosition = drawImageSize(width, height, this.canvasW, this.canvasH);
          this.canvasContext.drawImage(data, imgSize.x, imgSize.y, imgSize.width, imgSize.height);
          // canvas2
          let imgSize2: ImagePosition = drawImageSize(width, height, this.canvasW2, this.canvasH2);
          this.canvasContext2.drawImage(data, imgSize2.x, imgSize2.y, imgSize2.width, imgSize2.height);

          this.isScanning = true;
          setTimeout(async () => {
            let rgba: Uint8ClampedArray = this.canvasContext.getImageData(0, 0, this.canvasW, this.canvasH).data;
            let size: number = this.canvasW * this.canvasH;
            this.imgBuffer = await mainTaskPoolFunc(rgba, size);
            this.imageScan();
          }, 500);
        });
      } else {
        this.isScanning = false;
        promptAction.showToast({
          message: $r('app.string.image_fail_load'),
          duration: 3000,
          bottom: `${px2vp(this.pageH + 100) / 2}`
        });
      }
    });
  }

  // 绘制人脸
  drawFace(data: FaceObject[]) {
    if (data.length < 1) {
      promptAction.showToast({
        message: $r('app.string.no_face_detected'),
        duration: 3000,
        bottom: `${px2vp(this.pageH + 100) / 2}`
      });
    } else {
      let faces: FaceObject[] = [];
      data.forEach((item: FaceObject) => {
        let finalbox: finalboxModel = item.finalbox;
        let x: number = finalbox.x + this.offsetX;
        let y: number = finalbox.y + this.offsetY;

        let w: number = finalbox.w - finalbox.x;
        let h: number = finalbox.h - finalbox.y;

        let size1: number = Math.floor(w / 5);
        let size2: number = Math.floor(h / 5);
        let size: number = size1 > size2 ? size2 : size1;
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
    this.isScanning = false;
  }

  // 数据后处理
  acFilterAnchor(acArray: AcInfo[]) {
    let anchorNum: number = 2;
    let stride: number[] = [32, 16, 8];
    let anchorCfg: AnchorCfg[] = [
      { SCALES: [32, 16], RATIOS: [1], BASE_SIZE: 16 },
      { SCALES: [8, 4], RATIOS: [1], BASE_SIZE: 16 },
      { SCALES: [2, 1], RATIOS: [1], BASE_SIZE: 16 }
    ];

    let confidenceThreshold: number = 0.5;
    let nmsThreshold: number = 0.4;

    let ratiow: number = 1.0;
    let ratioh: number = 1.0;

    let proposals: FaceObject[] = [];

    acArray.forEach((ac: AcInfo, index: number) => {
      let clsData: Float32Array = new Float32Array(ac.cls!.getData());
      let regData: Float32Array = new Float32Array(ac.reg!.getData());
      let ptsLength: number = 0;
      let w: number = ac.cls!.shape[3];
      let h: number = ac.cls!.shape[2];
      let step: number = h * w;

      let anchorStride: number = stride[index];
      let cfg: AnchorCfg = anchorCfg[index];

      let baseAnchor: CRect2f = new CRect2f(0, 0, cfg.BASE_SIZE - 1, cfg.BASE_SIZE - 1);
      let ratioAnchors: number[][] = _ratio_enum(baseAnchor.val, cfg.RATIOS);
      let presetAnchors: number[][] = _scale_enum(ratioAnchors, cfg.SCALES);

      for (let i = 0; i < w; i++) {
        for (let j = 0; j < h; j++) {
          let id: number = j * w + i;
          for (let a = 0; a < anchorNum; a++) {
            let clsScore: number = clsData[(anchorNum + a) * step + id];
            if (clsScore > confidenceThreshold) {
              let boxObj: CRect2f = new CRect2f(i * anchorStride + presetAnchors[a][0],
                j * anchorStride + presetAnchors[a][1],
                i * anchorStride + presetAnchors[a][2],
                j * anchorStride + presetAnchors[a][3]);
              let box: number[] = boxObj.val;

              let deltaObj: CRect2f = new CRect2f(regData[(a * 4 + 0) * step+id], regData[(a * 4 + 1) * step+id],
                regData[(a * 4 + 2) * step+id], regData[(a * 4 + 3) * step+id]);
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
              res.score = clsScore;
              proposals.push(res);
            }
          }
        }
      }
    });

    let data: FaceObject[] = nms_cpu(proposals, nmsThreshold);
    this.drawFace(data);
  }

  // AI接口推理图片
  async imageScan() {
    let modelName: string = 'mnet_caffemodel_480_720.ms';
    let option: mindSporeLite.Context = {
      target: ['cpu']
    };

    this.context.resourceManager.getRawFileContent(modelName)
      .then(async (modelData) => {
        try {
          // 模型文件数据 ArrayBufferLike
          let modelBuffer: ArrayBuffer = modelData.buffer as ArrayBuffer;
          // 加载模型
          let msliteModel: mindSporeLite.Model = await mindSporeLite.loadModelFromBuffer(modelBuffer, option);
          log(`loadModel`);
          // 获取模型输入 返回数组类型
          let modelInputs: mindSporeLite.MSTensor[] = msliteModel.getInputs();
          log(`getInputs`);
          if (modelInputs) {
            log(`modelInputs length:` + modelInputs.length);
          } else {
            log(`modelInputs:` + JSON.stringify(modelInputs));
          }

          modelInputs.forEach((item, index) => {
            // 将图片输入
            item.setData(this.imgBuffer);
          });
          // 执行推理
          let modelOutputs: mindSporeLite.MSTensor[] = await msliteModel.predict(modelInputs);
          log(`predict`);
          // 32, 16, 8
          let acArray: AcInfo[] = [{}, {}, {}];
          modelOutputs.forEach((item, index) => {
            let name: string = item.name;
            let key: string = '';
            if (name.includes('face_rpn_cls_prob_reshape_stride')) {
              key = 'cls';
            } else if (name.includes('face_rpn_bbox_pred_stride')) {
              key = 'reg';
            }
            if (name.includes('32')) {
              Object(acArray[0])[key] = item;
            } else if (name.includes('16')) {
              Object(acArray[1])[key] = item;
            } else if (name.includes('8')) {
              Object(acArray[2])[key] = item;
            }
          });
          this.acFilterAnchor(acArray);
        } catch (e) {
          this.isScanning = false;
        }
      })
      .catch((e: Error) => {
        this.isScanning = false;
        promptAction.showToast({
          message: $r('app.string.AI_fail_load'),
          duration: 3000,
          bottom: `${px2vp(this.pageH + 100) / 2}`
        });
      });

  }

  openImageSelect() {
    this.pageStack.pushPath({ name: 'ImageSelect', param: 1 }, { launchMode: LaunchMode.POP_TO_SINGLETON });
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Center }) {
        // 图片加载
        Canvas(this.canvasContext)
          .width(`${this.canvasW}px`)
          .height(`${this.canvasH}px`)
          .backgroundColor('#00000000')
          .zIndex(2);

        Canvas(this.canvasContext2)
          .width(`${this.canvasW2}px`)
          .height(`${this.canvasH2}px`)
          .backgroundColor('#00000000')
          .zIndex(2);

        // 人脸绘制
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

        // 扫描中
        Row() {
          LoadingProgress().color('#ffffff').width('120lpx');
        }
        .backgroundColor('#73000000')
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width(`${this.screenW}lpx`)
        .height(`${this.screenH}lpx`)
        .zIndex(10)
        .visibility(this.isScanning ? Visibility.Visible : Visibility.Hidden);

        Row() {
          Column() {
            Row() {
              Image('')
                .width('100lpx')
                .height('100lpx')
                .clip(true)
                .focusable(true)
                .focusOnTouch(true)
                .defaultFocus(true)
                .onKeyEvent((event: KeyEvent) => {
                  event.stopPropagation();
                  if (event.keyCode === KeyCode.KEYCODE_ENTER && event.type === KeyType.Up) {
                    if (!this.isScanning) {
                      this.openImageSelect();
                    }
                  }
                });
            }
            .width('100lpx')
            .height('100lpx')
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.Center);


            Text('')
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
            if (e.type === TouchType.Up && !this.isScanning) {
              this.openImageSelect();
            }
          });
        }
        .zIndex(5)
        .width('100%')
        .height('100%')
        .alignItems(VerticalAlign.Bottom)
        .justifyContent(FlexAlign.Center);
      };
    }
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
    .backgroundColor('#18181A');
  }
}
