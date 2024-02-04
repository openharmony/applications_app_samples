/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import router from '@ohos.router';
import image from '@ohos.multimedia.image';
import effectKit from '@ohos.effectKit';
import { logger } from '../util/Logger';
import { copyPixelMap } from '../util/CopyObj';
import { adjustDatas, cropTaskDatas, markDatas } from '../model/AdjustModels';
import { CropTasks, TaskData, Tasks } from '../model/AdjustData';
import { ScalePhotoPage } from '../pages/ScalePhotoPage';
import MaterialEdit from './MaterialEdit';
import InputTextDialog from './InputTextDialog';
import LoadingDialog from './LoadingDialog';
import PixelMapQueue from '../feature/PixelMapQueue';
import { readImage } from '../util/MediaUtil';
import { FontColorData, MaterialData } from '../model/MaterialData';
import { fontColors, stickers } from '../model/MaterialModels';
import { getContainSize, Size } from '../util/ImageUtil';
import { savePixelMap } from '../util/FileUtil';
import { BusinessError } from '@ohos.base';
import { ColorSpacePage } from './ColorSpacePage';

const TAG: string = '[Sample_EditImage]';

@Component
export struct EditImage {
  @State mediaUris: string = (router.getParams() as Record<string, Object>)['mediaUris'] as string;
  @State pixelMap: PixelMap | undefined | null = undefined;
  @State adjustMarkJudg: boolean = false;
  @State currentTask: number = Tasks.ADJUST;
  @State currentCropTask: number = CropTasks.NONE;
  @State tempPixelMap: image.PixelMap | undefined | null = undefined;
  @State cancelOkText: Resource | null = null;
  @State brightnessValue: number = 0;
  @State outSetValueOne: number = 0;
  @State cropFlag: boolean = false;
  @State originBM: PixelMap | null = null;
  @State cropIndex: number = 0;
  @State canClick: boolean = true;
  @State loading: boolean = false;
  @State isCancelQuit: boolean = false;
  // 选择资源素材index
  @State resourceIndex: number = 0;
  @State isTextMaterial: boolean = true;
  selectedResource: Resource | undefined = $r('app.color.material_font_color_one');
  scroller: Scroller = new Scroller();
  brightnessOriginBM: PixelMap | null | undefined = null;
  @State resolution: string = '';
  @State inputValue: string = '';
  // 分辨率的坐标
  @State dpiX: number = 0;
  @State dpiY: number = 0;
  // 分辨率
  @State dpi: string = '';
  // 图片父容器大小
  containerArea: Area | null = null;
  private pixelMapQueue: PixelMapQueue = new PixelMapQueue();

  onOpen(): void {
    if (this.loading) {
      return;
    }
    this.loading = true;
    this.loadingController.open();
  }

  onClose(): void {
    this.loading = false;
    this.loadingController.close();
  }


  /**
   * 输入文字素材弹窗
   */
  dialogController: CustomDialogController | undefined = new CustomDialogController({
    builder: InputTextDialog({
      cancel: (): void => this.onCancel(),
      confirm: (): void => this.onAccept(),
      inputValue: $inputValue
    }),
    cancel: (): void => this.existApp(),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  });

  /**
   * 加载弹窗
   */
  loadingController: CustomDialogController = new CustomDialogController({ builder: LoadingDialog() });

  onCancel(): void {
    console.info('Callback when the first button is clicked');
  }

  onAccept(): void {
    if (this.inputValue !== null && this.inputValue.length > 0) {
      this.currentTask = Tasks.TEXT;
    }
    this.onSelectItem(markDatas[0], true);
  }

  async onEditCancel(): Promise<void> {
    if (this.currentTask === Tasks.CROP || this.currentTask === Tasks.SCALE ||
    this.currentTask === Tasks.ROTATE || this.currentTask === Tasks.TONING || this.currentTask === Tasks.COLORSPACE) {
      this.currentTask = Tasks.ADJUST;
      this.cropIndex = 0;
    }
    if (this.currentTask === Tasks.TEXT || this.currentTask === Tasks.STICKER) {
      this.currentTask = Tasks.MARK;
      this.cropIndex = 0;
    }
    if (this.currentTask === Tasks.CROP) {
      this.cropIndex = 0;
    }
    this.isCancelQuit = true;
    this.outSetValueOne = 0;
    if (this.originBM !== null && this.originBM !== undefined) {
      this.pixelMap = await copyPixelMap(this.originBM); // 拷贝
    }
    // 移出一个缓存
    const pm: image.PixelMap | undefined = this.pixelMapQueue.pop();
    this.releasePm(pm);
  }

  existApp(): void {
    console.info('Click the callback in the blank area')
  }

  async aboutToAppear(): Promise<void> {
    this.pixelMap = await readImage(this.mediaUris);
    if (this.pixelMap !== null) {
      this.originBM = await copyPixelMap(this.pixelMap);
    }
  }

  aboutToDisappear(): void {
    this.dialogController = undefined
  }

  /**
   * 选择子菜单
   * @param item
   * @param hasInputText
   */
  async onSelectItem(item: TaskData, hasInputText: boolean = false): Promise<void> {
    if (hasInputText || item.task !== Tasks.TEXT) {
      // 只有hasInputText，才是图片素材模式，其他都是贴纸
      this.isTextMaterial = hasInputText;
      this.resourceIndex = 0;
      this.isCancelQuit = false;
      if (item.task !== undefined) {
        this.currentTask = item.task;
      }

      if (item.text !== undefined) {
        this.cancelOkText = item.text;
      }

      if (this.pixelMap) {
        this.originBM = await copyPixelMap(this.pixelMap);
      }
      // 保存到队列
      if (this.originBM !== null && this.originBM !== undefined) {
        this.pixelMapQueue.push(this.originBM);
      }
    } else if (item.task === Tasks.TEXT) {
      this.dialogController?.open();
    }
  }

  /**
   * 撤销功能
   */
  async repeal(): Promise<void> {
    const pm: image.PixelMap | undefined = this.pixelMapQueue.pop();
    if (pm !== null && pm !== undefined) {
      this.pixelMap = await copyPixelMap(pm);
    }
  }

  /**
   * 刷新图层显示
   */
  flushPage(): void {
    this.tempPixelMap = this.pixelMap;
    this.pixelMap = null;
    this.pixelMap = this.tempPixelMap;
  }

  /**
   * 亮度调节
   */
  async brightChange(): Promise<void> {
    let headFilter: effectKit.Filter = effectKit.createEffect(this.brightnessOriginBM);
    if (headFilter !== null) {
      headFilter.brightness(this.brightnessValue);
      this.pixelMap = headFilter.getPixelMap();
      this.flushPage();
    }
  }

  /**
   * 图片裁剪
   * @param proportion
   */
  async cropImage(proportion: number): Promise<void> {
    if (!this.pixelMap) {
      return;
    }
    let imageInfo: image.ImageInfo = await this.pixelMap.getImageInfo();
    if (!imageInfo) {
      return;
    }
    let imageHeight: number = imageInfo.size.height;
    let imageWith: number = imageInfo.size.width;
    logger.info(TAG, `imageInfo = ${JSON.stringify(imageInfo)}`);
    if (proportion === 1) {
      if (imageHeight > imageWith) {
        imageHeight = imageWith;
      } else {
        imageWith = imageHeight;
      }
      logger.info(TAG, `imageHeight = ${JSON.stringify(imageHeight)},imageWith = ${JSON.stringify(imageWith)}`);
    }
    try {
      await this.pixelMap.crop({
        size: { height: imageHeight / proportion, width: imageWith },
        x: 0,
        y: 0
      });
    } catch (error) {
      logger.info(TAG, `crop error = ${JSON.stringify(error)}`);
    }
    this.flushPage();
  }

  /**
   * 底部一级菜单
   */
  @Builder
  getFirstLvMenu() {
    Row() {
      Column() {
        Image($r('app.media.ic_adjust'))
          .width($r('app.float.size_30'))
          .height($r('app.float.size_30'))
        Text($r('app.string.edit_image_adjust'))
          .fontColor(Color.White)
          .fontSize($r('app.float.size_16'))
      }
      .justifyContent(FlexAlign.Center)
      .height('100%')
      .width('40%')
      .margin({ left: '10%' })
      .backgroundColor(this.adjustMarkJudg ? Color.Black : $r('app.color.edit_image_adjust_selected'))
      .onClick(async () => {
        this.adjustMarkJudg = false;
        this.currentTask = Tasks.ADJUST;
      })

      Column() {
        Image($r('app.media.ic_mark'))
          .width($r('app.float.size_30'))
          .height($r('app.float.size_30'))
        Text($r('app.string.edit_image_mark'))
          .fontColor(Color.White)
          .fontSize($r('app.float.size_16'))
      }
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        this.adjustMarkJudg = true;
        this.currentTask = Tasks.MARK;
      })
      .backgroundColor(this.adjustMarkJudg ? $r('app.color.edit_image_adjust_selected') : Color.Black)
      .height('100%')
      .width('40%')
      .margin({ right: '10%' })
    }
    .height('9%')
    .width('100%')
  }

  releasePm(pm: PixelMap | undefined): void {
    if (!pm) {
      return
    }

    pm.release().catch((err: BusinessError) => {
      logger.error('pm release异常:' + JSON.stringify(err));
    });
  }

  @Builder
  CancelOrOk(text: string | Resource) {
    Row() {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
        Image($r('app.media.ic_cancel'))
          .width($r('app.float.size_30'))
          .height($r('app.float.size_30'))
          .onClick(async () => {
            await this.onEditCancel();
          })
          .margin({ left: '10%' })
          .id('Cancel')

        Text(text)
          .fontColor(Color.White)
          .fontSize($r('app.float.size_18'))
          .width($r('app.float.size_40'))
          .height($r('app.float.size_30'))

        Image($r('app.media.ic_ok'))
          .width($r('app.float.size_30'))
          .height($r('app.float.size_30'))
          .margin({ right: '10%' })
          .onClick(() => {
            if (this.currentTask === Tasks.CROP || this.currentTask === Tasks.SCALE ||
            this.currentTask === Tasks.ROTATE || this.currentTask === Tasks.TONING || this.currentTask === Tasks.COLORSPACE) {
              this.currentTask = Tasks.ADJUST;
              this.cropIndex = 0;
            }
            if (this.currentTask === Tasks.TEXT || this.currentTask === Tasks.STICKER) {
              this.currentTask = Tasks.MARK;
              this.cropIndex = 0;
            }
            this.outSetValueOne = 0;
          })
          .id('Ok')
      }
    }
    .backgroundColor($r('app.color.edit_image_public_background'))
    .height('9%')
    .width('100%')
  }

  @Builder
  getMarkTool() {
    Row() {
      List() {
        ForEach(markDatas, (item: TaskData, index) => {
          ListItem() {
            Column() {
              Image(item.image)
                .width($r('app.float.size_30'))
                .height($r('app.float.size_30'))
              Text(item.text)
                .fontColor(Color.White)
                .fontSize($r('app.float.size_15'))
                .margin({ top: $r('app.float.size_5') })
            }
            .justifyContent(FlexAlign.Center)
            .height('100%')
            .width('40%')
            .margin(index === 0 ? { left: '10%' } : { right: '10%' })
            .onClick(async () => {
              this.onSelectItem(item);
            })
          }
        })
      }
      .listDirection(Axis.Horizontal) // 排列方向
      .width('100%')
      .height('14%')
    }
    .backgroundColor($r('app.color.edit_image_public_background'))
    .width('100%')
    .justifyContent(FlexAlign.SpaceAround)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  getCropTool() {
    Row() {
      List() {
        ForEach(cropTaskDatas, (item: TaskData, index: number) => {
          ListItem() {
            Column() {
              Image(item.image)
                .width($r('app.float.size_30'))
                .height($r('app.float.size_30'))
              Text(item.text)
                .fontColor(Color.White)
                .fontSize($r('app.float.size_14'))
                .margin({ top: $r('app.float.size_5') })
            }
            .backgroundColor(this.cropIndex === index ? $r('app.color.edit_image_public_background') : $r('app.color.edit_image_crop_select'))
            .justifyContent(FlexAlign.Center)
            .height('100%')
            .width('25%')
            .onClick(async () => {
              if (item.task !== undefined) {
                this.currentCropTask = item.task;
              }
              this.pixelMap = await copyPixelMap(this.originBM !); // 拷贝
              this.flushPage();
              this.cropIndex = index;
              if (this.currentCropTask === CropTasks.ORIGIN) { // 原图
                this.pixelMap = await readImage(this.mediaUris);
              } else if (this.currentCropTask === CropTasks.ONE_ONE) {
                await this.cropImage(1);
                console.log(TAG + 'CropTasks  this.cropImage(1)' + this.currentCropTask)
              } else if (this.currentCropTask === CropTasks.THREE_FOUR) {
                await this.cropImage(4 / 3);
                console.log(TAG + 'CropTasks  cropImage(4 / 3)==' + this.currentTask)
              } else if (this.currentCropTask === CropTasks.NINE_SIXTH) {
                await this.cropImage(16 / 9);
                console.log(TAG + 'CropTasks  (16 / 9)==' + this.currentTask);
              }
            })
          }
        })
      }
      .listDirection(Axis.Horizontal) // 排列方向
      .height('14%')
    }
    .width('100%')
  }

  @Builder
  getAdjustTool() {
    Row() {
      List() {
        ForEach(adjustDatas, (item: TaskData, index) => {
          ListItem() {
            Column() {
              Image(item.image)
                .width($r('app.float.size_30'))
                .height($r('app.float.size_30'))
              Text(item.text)
                .fontColor(Color.White)
                .fontSize($r('app.float.size_15'))
                .margin({ top: $r('app.float.size_5') })
            }
            .justifyContent(FlexAlign.Center)
            .height('100%')
            .width('25%')
            .onClick(async () => {
              if (item.task !== undefined) {
                this.currentTask = item.task;
              }
              if (this.currentTask === Tasks.SCALE) {
                this.computeDpiPosition();
              }
              if (item.task === Tasks.TONING) {
                this.brightnessOriginBM = this.pixelMap;
              }
              if (item.text !== undefined) {
                this.cancelOkText = item.text
              }
              this.originBM = await copyPixelMap(this.pixelMap !) // 拷贝
              if (item.task === Tasks.ROTATE) {
                this.pixelMap = await copyPixelMap(this.originBM);
              }
              // 保存到队列
              this.pixelMapQueue.push(this.originBM);
            })
          }
        })
      }
      .listDirection(Axis.Horizontal) // 排列方向
      .height('14%')
    }
    .backgroundColor($r('app.color.edit_image_public_background'))
    .width('100%')
    .justifyContent(FlexAlign.SpaceAround)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  getScaleTool() {
    ScalePhotoPage({ pixelMap: $pixelMap, dpi: $dpi })
      .backgroundColor($r('app.color.edit_image_public_background'))
      .height('14%')
      .width('100%')
      .padding({ top: $r('app.float.size_10') })
  }

  @Builder
  getColorSpaceTool() {
    ColorSpacePage({ pixelMap: $pixelMap, dpi: $dpi })
      .backgroundColor($r('app.color.edit_image_public_background'))
      .height('14%')
      .width('100%')
      .padding({ top: $r('app.float.size_10') })
  }

  @Builder
  getRotateTool() {
    Row() {
      Column() {
        Image($r('app.media.ic_rotateto90'))
          .width($r('app.float.size_30'))
          .height($r('app.float.size_30'))
        Text($r('app.string.edit_image_rotate_90'))
          .margin({ top: $r('app.float.size_5') })
          .fontSize($r('app.float.size_14'))
          .fontColor(Color.White)
      }
      .id('90')
      .onClick(async () => {
        if (this.canClick) {
          this.canClick = false;
          await this.pixelMap?.rotate(90);
          setTimeout(() => {
            this.canClick = true;
            this.flushPage();
          }, 300)
        }
      })

      Column() {
        Image($r('app.media.ic_rotate'))
          .width($r('app.float.size_30'))
          .height($r('app.float.size_30'))
        Text($r('app.string.edit_image_rotate_down_90'))
          .margin({ top: $r('app.float.size_5') })
          .fontColor(Color.White)
          .fontSize($r('app.float.size_14'))
      }
      .id('-90')
      .onClick(async () => {
        if (this.canClick) {
          this.canClick = false;
          await this.pixelMap?.rotate(-90);
          setTimeout(() => {
            this.canClick = true;
            this.flushPage();
          }, 300);
        }
      })
    }
    .justifyContent(FlexAlign.SpaceAround)
    .backgroundColor($r('app.color.edit_image_public_background'))
    .height('14%')
    .width('100%')
  }

  @Builder
  getToningTool() {
    Row() {
      Row() {
        Slider({
          value: this.outSetValueOne,
          min: 0,
          max: 30,
          style: SliderStyle.OutSet,
        })
          .id('Slider')
          .trackThickness($r('app.float.size_5'))
          .trackColor($r('app.color.edit_image_slider_trackColor'))
          .selectedColor($r('app.color.edit_image_slider_selected'))
          .onChange(async (value: number, mode: SliderChangeMode) => {
            this.outSetValueOne = value;
            this.brightnessValue = Number((value / 100).toFixed(2));
            await this.brightChange();
          })
      }
      .height('14%')
      .width('96%')
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .backgroundColor($r('app.color.edit_image_public_background'))
  }

  @Builder
  getMaterialTool(materials: MaterialData[]) {
    this.TextOrStickerScroll(materials)
  }

  async onSave(): Promise<void> {
    if (this.loading) {
      return;
    }
    this.loading = true;
    this.loadingController.open();

    if (this.pixelMap !== undefined && this.pixelMap !== null) {
      const uri: string = await savePixelMap(getContext(this), this.pixelMap);
      logger.debug('保存图片地址为:' + uri);
      router.pushUrl({
        url: 'pages/Index',
        params: { isShowCamera: true }
      });
    }

  }

  @Builder
  TextOrStickerScroll(materials: MaterialData[]) {
    Row() {
      Scroll() {
        List({ scroller: this.scroller }) {
          ForEach(materials, (item: MaterialData, index: number) => {
            ListItem() {
              Column() {
                if (item instanceof FontColorData) {
                  Text(item.getResource())
                    .visibility(Visibility.Hidden)
                    .width($r('app.float.size_40'))
                    .height($r('app.float.size_40'))
                } else {
                  Image(item.getResource())
                    .width($r('app.float.size_40'))
                    .height($r('app.float.size_40'))
                }
              }
              .justifyContent(FlexAlign.Center)
              .borderRadius($r('app.float.size_10'))
              .border(this.resourceIndex === index ?
                {
                  width: $r('app.float.size_3'),
                  color: $r('app.color.edit_image_mark_scroll_selected'),
                  radius: $r('app.float.size_10')
                } : { width: $r('app.float.size_0'), color: $r('app.color.edit_image_mark_scroll') })
              .backgroundColor(this.currentTask === Tasks.STICKER ? $r('app.color.edit_image_mark_scroll') : item.getResource())
              .width($r('app.float.size_45'))
              .height($r('app.float.size_45'))
              .onClick(() => {
                this.resourceIndex = index;
                this.selectedResource = item.getResource();
              })
            }
            .height('100%')
            .width('17%')
          })
        }
        .listDirection(Axis.Horizontal) // 排列方向
        .height('14%')
      }
      .padding({ left: $r('app.float.size_30'), right: $r('app.float.size_30') })
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Horizontal)
    }
    .alignItems(VerticalAlign.Center)
    .backgroundColor($r('app.color.edit_image_public_background'))
    .width('100%')
  }

  @Builder
  getTopBar() {
    Row() {
      Image($r("app.media.ic_public_back"))
        .fillColor(Color.White)
        .width($r('app.float.size_32'))
        .height($r('app.float.size_32'))
        .onClick(() => {
          router.back();
        })
      Blank()
      // 非编辑模式，展示撤回和保存功能
      if (this.currentTask === Tasks.ADJUST || this.currentTask === Tasks.MARK) {
        Row({ space: 24 }) {
          Image($r('app.media.ic_public_tosmall'))
            .height($r('app.float.size_32'))
            .width($r('app.float.size_32'))
            .id('Repeal')
            .onClick(async () => {
              this.repeal();
            })
          Image($r('app.media.ic_public_save'))
            .height($r('app.float.size_32'))
            .width($r('app.float.size_32'))
            .id('Save')
            .onClick(() => {
              this.onSave();
            })
        }.margin({ right: $r('app.float.size_10') })
      }
    }
    .width('100%')
    .padding({ left: $r('app.float.size_14') })
    .margin({ top: $r('app.float.size_20') });
  }

  async computeDpiPosition(): Promise<void> {
    if (this.containerArea === null || this.pixelMap === null || this.pixelMap === undefined) {
      return;
    }
    let imageInfo: image.ImageInfo = await this.pixelMap.getImageInfo()
    if (!imageInfo) {
      return;
    }
    const imageHeight: number = imageInfo.size.height;
    const imageWith: number = imageInfo.size.width;
    this.dpi = imageWith + "*" + imageHeight;
    // 计算容器宽高
    const containerHeight: number = Number(this.containerArea.height);
    const containerWidth: number = Number(this.containerArea.width);
    const size: Size = getContainSize(containerWidth * 0.9, containerHeight * 0.9, imageWith, imageHeight);
    // 计算左上角的坐标
    const x: number = containerWidth / 2 + size.width / 2;
    const y: number = containerHeight / 2 - size.height / 2;
    // 最终坐标还要除去控件宽高
    this.dpiX = x - 100;
    this.dpiY = y;
  }

  getResolutionText(): string {
    const tip: string = getContext(this).resourceManager.getStringSync($r('app.string.edit_image_resolution'));
    return tip + this.dpi;
  }

  build() {
    Column() {
      // 顶部功能区
      this.getTopBar()
      // 中间操作区
      if (this.currentTask === Tasks.TEXT || this.currentTask === Tasks.STICKER) {
        Stack() {
          MaterialEdit({
            pixelMap: $pixelMap,
            text: this.inputValue,
            isCancelQuit: this.isCancelQuit,
            selectedMaterialIndex: this.resourceIndex,
            isTextMaterial: this.isTextMaterial,
            onCancel: (): Promise<void> => this.onEditCancel(),
            onOpen: (): void => this.onOpen(),
            onClose: (): void => this.onClose()
          }).width('90%')
            .height('90%')
        }.layoutWeight(1)
      } else {
        Stack({ alignContent: Alignment.Center }) {
          Image(this.pixelMap)
            .objectFit(ImageFit.Contain)
            .width('90%')
            .height('90%')
            .backgroundColor($r('app.color.edit_image_stack_image'))
            .alignRules(
              {
                middle: { anchor: '__container__', align: HorizontalAlign.Center },
                center: { anchor: '__container__', align: VerticalAlign.Center }
              }
            )
            .id('image')

          if (this.currentTask === Tasks.SCALE) {
            Stack() {
              Text(this.getResolutionText())
                .fontSize($r('app.float.size_14'))
                .fontColor(Color.White)
            }
            .position({ x: this.dpiX, y: this.dpiY })
            .backgroundColor($r('app.color.edit_image_stack_resolution'))
            .id('dpi')
            .padding($r('app.float.size_10'))
            .width($r('app.float.size_100'))
            .height($r('app.float.size_80'))
            .border({ radius: $r('app.float.size_20') })
          }
        }.layoutWeight(1)
        .onAreaChange((oldValue: Area, newValue: Area) => {
          this.containerArea = newValue;
        })
      }
      // 底部菜单栏
      Column() {
        if (this.currentTask === Tasks.MARK) {
          this.getMarkTool();
        } else if (this.currentTask === Tasks.ADJUST) {
          this.getAdjustTool();
        } else if (this.currentTask === Tasks.CROP) {
          this.getCropTool();
        } else if (this.currentTask === Tasks.SCALE) {
          this.getScaleTool();
        } else if (this.currentTask === Tasks.ROTATE) {
          this.getRotateTool();
        } else if (this.currentTask === Tasks.TONING) {
          this.getToningTool();
        } else if (this.currentTask === Tasks.COLORSPACE) {
          this.getColorSpaceTool();
        } else if (this.currentTask === Tasks.TEXT) {
          this.getMaterialTool(fontColors);
        } else if (this.currentTask === Tasks.STICKER) {
          this.getMaterialTool(stickers);
        }
        if (this.currentTask === Tasks.MARK || this.currentTask === Tasks.ADJUST) {
          this.getFirstLvMenu();
        } else {
          this.CancelOrOk(this.cancelOkText !);
        }
      }
      .width('100%')
    }
    .backgroundColor(Color.Black)
    .width('100%')
    .height('100%')
  }
}