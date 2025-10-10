/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import ImageNapi from 'libentry.so';
import { NodeContent } from '@kit.ArkUI';

enum ArkUIImageSize {
  ARKUI_IMAGE_SIZE_AUTO = 0,
  ARKUI_IMAGE_SIZE_COVER = 1,
  ARKUI_IMAGE_SIZE_CONTAIN = 2,
}

enum ArkUIImageInterpolation {
  ARKUI_IMAGE_INTERPOLATION_NONE = 0,
  ARKUI_IMAGE_INTERPOLATION_LOW,
  ARKUI_IMAGE_INTERPOLATION_MEDIUM,
  ARKUI_IMAGE_INTERPOLATION_HIGH,
}

enum ArkUIImageRenderMode {
  ARKUI_IMAGE_RENDER_MODE_ORIGINAL = 0,
  ARKUI_IMAGE_RENDER_MODE_TEMPLATE,
}

enum ArkUIImageRepeat {
  ARKUI_IMAGE_REPEAT_NONE = 0,
  ARKUI_IMAGE_REPEAT_X,
  ARKUI_IMAGE_REPEAT_Y,
  ARKUI_IMAGE_REPEAT_XY,
}

enum ArkUIObjectFit {
  /** The image is scaled with its aspect ratio retained for the content to be completely displayed within the
   *  display boundaries. */
  ARKUI_OBJECT_FIT_CONTAIN = 0,
  /** The image is scaled with its aspect ratio retained for both sides to be greater than or equal to the
   *  display boundaries. */
  ARKUI_OBJECT_FIT_COVER,
  /** The image is scaled automatically to fit the display area. */
  ARKUI_OBJECT_FIT_AUTO,
  /** The image is scaled to fill the display area, and its aspect ratio is not retained. */
  ARKUI_OBJECT_FIT_FILL,
  /** The image content is displayed with its aspect ratio retained. The size is smaller than or equal to the
   *  original size. */
  ARKUI_OBJECT_FIT_SCALE_DOWN,
  /** The original size is retained. */
  ARKUI_OBJECT_FIT_NONE,
  /** Not resized, the image is aligned with the start edge of the top of the container. */
  ARKUI_OBJECT_FIT_NONE_AND_ALIGN_TOP_START,
  /** Not resized, the image is horizontally centered at the top of the container. */
  ARKUI_OBJECT_FIT_NONE_AND_ALIGN_TOP,
  /** Not resized, the image is aligned with the end edge at the top of the container. */
  ARKUI_OBJECT_FIT_NONE_AND_ALIGN_TOP_END,
  /** Not resized, the image is vertically centered on the start edge of the container. */
  ARKUI_OBJECT_FIT_NONE_AND_ALIGN_START,
  /** Not resized, the image is horizontally and vertically centered in the container. */
  ARKUI_OBJECT_FIT_NONE_AND_ALIGN_CENTER,
  /** Not resized, the image is vertically centered on the end edge of the container. */
  ARKUI_OBJECT_FIT_NONE_AND_ALIGN_END,
  /** Not resized, the image is aligned with the start edge at the bottom of the container. */
  ARKUI_OBJECT_FIT_NONE_AND_ALIGN_BOTTOM_START,
  /** Not resized, the image is horizontally centered at the bottom of the container. */
  ARKUI_OBJECT_FIT_NONE_AND_ALIGN_BOTTOM,
  /** Not resized, the image is aligned with the end edge at the bottom of the container. */
  ARKUI_OBJECT_FIT_NONE_AND_ALIGN_BOTTOM_END,
}
@Entry
@Component
struct ImageSize {
  @State imageSize : number = ArkUIImageSize.ARKUI_IMAGE_SIZE_AUTO;
  @State objectFit : number = ArkUIObjectFit.ARKUI_OBJECT_FIT_CONTAIN;
  @State imageInterpolation : number = ArkUIImageInterpolation.ARKUI_IMAGE_INTERPOLATION_NONE;
  @State imageRenderMode : number = ArkUIImageRenderMode.ARKUI_IMAGE_RENDER_MODE_ORIGINAL;
  @State imageRepeat : number = ArkUIImageRepeat.ARKUI_IMAGE_REPEAT_NONE;
  private nodeContent: Content = new NodeContent();
  @Builder
  SubMenuImageSize() {
    Menu() {
      MenuItem({ content: 'ARKUI_IMAGE_SIZE_AUTO'})
        .width('50%')
        .onChange(()=> {
          this.imageSize = ArkUIImageSize.ARKUI_IMAGE_SIZE_AUTO;
          ImageNapi.createImageSize( this.objectFit, this.imageSize);
        })
      MenuItem({ content: 'ARKUI_IMAGE_SIZE_COVER'})
        .width('50%')
        .onChange(()=> {
          this.imageSize = ArkUIImageSize.ARKUI_IMAGE_SIZE_COVER;
          ImageNapi.createImageSize( this.objectFit, this.imageSize);
        })
      MenuItem({ content: 'ARKUI_IMAGE_SIZE_CONTAIN'})
        .width('50%')
        .onChange(()=> {
          this.imageSize = ArkUIImageSize.ARKUI_IMAGE_SIZE_CONTAIN;
          ImageNapi.createImageSize(this.objectFit, this.imageSize);
        })
    }
  }
  @Builder
  SubMenuImageRepeat() {
    Menu() {
      MenuItem({ content: 'ARKUI_IMAGE_REPEAT_NONE'})
        .width('50%')
        .onChange(()=> {
          this.imageRepeat = ArkUIImageRepeat.ARKUI_IMAGE_REPEAT_NONE;
          ImageNapi.setImageProperties(this.imageRepeat, this.imageInterpolation, this.imageRenderMode);
        })
      MenuItem({ content: 'ARKUI_IMAGE_REPEAT_X'})
        .width('50%')
        .onChange(()=> {
          this.imageRepeat = ArkUIImageRepeat.ARKUI_IMAGE_REPEAT_X;
          ImageNapi.setImageProperties(this.imageRepeat, this.imageInterpolation, this.imageRenderMode);
        })
      MenuItem({ content: 'ARKUI_IMAGE_REPEAT_Y'})
        .width('50%')
        .onChange(()=> {
          this.imageRepeat = ArkUIImageRepeat.ARKUI_IMAGE_REPEAT_Y;
          ImageNapi.setImageProperties(this.imageRepeat, this.imageInterpolation, this.imageRenderMode);
        })
      MenuItem({ content: 'ARKUI_IMAGE_REPEAT_XY'})
        .width('50%')
        .onChange(()=> {
          this.imageRepeat = ArkUIImageRepeat.ARKUI_IMAGE_REPEAT_XY;
          ImageNapi.setImageProperties(this.imageRepeat, this.imageInterpolation, this.imageRenderMode);
        })
      }
  }
  @Builder
  SubMenuImageInterpolation() {
    Menu() {
      MenuItem({ content: 'ARKUI_IMAGE_INTERPOLATION_NONE'})
        .width('50%')
        .onChange(()=> {
          this.imageInterpolation = ArkUIImageInterpolation.ARKUI_IMAGE_INTERPOLATION_NONE;
          ImageNapi.setImageProperties(this.imageRepeat, this.imageInterpolation, this.imageRenderMode);
        })
      MenuItem({ content: 'ARKUI_IMAGE_INTERPOLATION_LOW'})
        .width('50%')
        .onChange(()=> {
          this.imageInterpolation = ArkUIImageInterpolation.ARKUI_IMAGE_INTERPOLATION_LOW;
          ImageNapi.setImageProperties(this.imageRepeat, this.imageInterpolation, this.imageRenderMode);
        })
      MenuItem({ content: 'ARKUI_IMAGE_INTERPOLATION_MEDIUM'})
        .width('50%')
        .onChange(()=> {
          this.imageInterpolation = ArkUIImageInterpolation.ARKUI_IMAGE_INTERPOLATION_MEDIUM;
          ImageNapi.setImageProperties(this.imageRepeat, this.imageInterpolation, this.imageRenderMode);
        })
      MenuItem({ content: 'ARKUI_IMAGE_INTERPOLATION_HIGH'})
        .width('50%')
        .onChange(()=> {
          this.imageInterpolation = ArkUIImageInterpolation.ARKUI_IMAGE_INTERPOLATION_HIGH;
          ImageNapi.setImageProperties(this.imageRepeat, this.imageInterpolation, this.imageRenderMode);
        })
    }
  }
  @Builder
  SubMenuMode() {
    Menu() {
      MenuItem({ content: 'ARKUI_IMAGE_RENDER_MODE_ORIGINAL'})
        .width('50%')
        .onChange(()=> {
          this.imageRenderMode = ArkUIImageRenderMode.ARKUI_IMAGE_RENDER_MODE_ORIGINAL;
          ImageNapi.setImageProperties(this.imageRepeat, this.imageInterpolation, this.imageRenderMode);
        })
      MenuItem({ content: 'ARKUI_IMAGE_RENDER_MODE_TEMPLATE'})
        .width('50%')
        .onChange(()=> {
          this.imageRenderMode = ArkUIImageRenderMode.ARKUI_IMAGE_RENDER_MODE_TEMPLATE;
          ImageNapi.setImageProperties(this.imageRepeat, this.imageInterpolation, this.imageRenderMode);
        })
    }
  }
  @Builder
  SubMenuObjectFit() {
    Menu() {
      MenuItem({ content: 'ARKUI_OBJECT_FIT_CONTAIN'})
        .width('50%')
        .onChange(()=> {
          this.objectFit = ArkUIObjectFit.ARKUI_OBJECT_FIT_CONTAIN;
          ImageNapi.createImageSize(this.objectFit, this.imageSize);
        })
      MenuItem({ content: 'ARKUI_OBJECT_FIT_COVER'})
        .width('50%')
        .onChange(()=> {
          this.objectFit = ArkUIObjectFit.ARKUI_OBJECT_FIT_COVER;
          ImageNapi.createImageSize(this.objectFit, this.imageSize);
        })
      MenuItem({ content: 'ARKUI_OBJECT_FIT_AUTO'})
        .width('50%')
        .onChange(()=> {
          this.objectFit = ArkUIObjectFit.ARKUI_OBJECT_FIT_AUTO;
          ImageNapi.createImageSize(this.objectFit, this.imageSize);
        })
      MenuItem({ content: 'ARKUI_OBJECT_FIT_FILL'})
        .width('50%')
        .onChange(()=> {
          this.objectFit = ArkUIObjectFit.ARKUI_OBJECT_FIT_FILL;
          ImageNapi.createImageSize(this.objectFit, this.imageSize);
        })
      MenuItem({ content: 'ARKUI_OBJECT_FIT_SCALE_DOWN'})
        .width('50%')
        .onChange(()=> {
          this.objectFit = ArkUIObjectFit.ARKUI_OBJECT_FIT_SCALE_DOWN;
          ImageNapi.createImageSize(this.objectFit, this.imageSize);
        })
      MenuItem({ content: 'ARKUI_OBJECT_FIT_NONE'})
        .width('50%')
        .onChange(()=> {
          this.objectFit = ArkUIObjectFit.ARKUI_OBJECT_FIT_NONE;
          ImageNapi.createImageSize(this.objectFit, this.imageSize);
        })
      MenuItem({ content: 'ARKUI_OBJECT_FIT_NONE_AND_ALIGN_TOP_START'})
        .width('50%')
        .onChange(()=> {
          this.objectFit = ArkUIObjectFit.ARKUI_OBJECT_FIT_NONE_AND_ALIGN_TOP_START;
          ImageNapi.createImageSize(this.objectFit, this.imageSize);
        })
      MenuItem({ content: 'ARKUI_OBJECT_FIT_NONE_AND_ALIGN_TOP'})
        .width('50%')
        .onChange(()=> {
          this.objectFit = ArkUIObjectFit.ARKUI_OBJECT_FIT_NONE_AND_ALIGN_TOP;
          ImageNapi.createImageSize(this.objectFit, this.imageSize);
        })
      MenuItem({ content: 'ARKUI_OBJECT_FIT_NONE_AND_ALIGN_TOP_END'})
        .width('50%')
        .onChange(()=> {
          this.objectFit = ArkUIObjectFit.ARKUI_OBJECT_FIT_NONE_AND_ALIGN_TOP_END;
          ImageNapi.createImageSize(this.objectFit, this.imageSize);
        })
      MenuItem({ content: 'ARKUI_OBJECT_FIT_NONE_AND_ALIGN_START'})
        .width('50%')
        .onChange(()=> {
          this.objectFit = ArkUIObjectFit.ARKUI_OBJECT_FIT_NONE_AND_ALIGN_START;
          ImageNapi.createImageSize(this.objectFit, this.imageSize);
        })
      MenuItem({ content: 'ARKUI_OBJECT_FIT_NONE_AND_ALIGN_CENTER'})
        .width('50%')
        .onChange(()=> {
          this.objectFit = ArkUIObjectFit.ARKUI_OBJECT_FIT_NONE_AND_ALIGN_CENTER;
          ImageNapi.createImageSize(this.objectFit, this.imageSize);
        })
      MenuItem({ content: 'ARKUI_OBJECT_FIT_NONE_AND_ALIGN_END'})
        .width('50%')
        .onChange(()=> {
          this.objectFit = ArkUIObjectFit.ARKUI_OBJECT_FIT_NONE_AND_ALIGN_END;
          ImageNapi.createImageSize(this.objectFit, this.imageSize);
        })
      MenuItem({ content: 'ARKUI_OBJECT_FIT_NONE_AND_ALIGN_BOTTOM_START'})
        .width('50%')
        .onChange(()=> {
          this.objectFit = ArkUIObjectFit.ARKUI_OBJECT_FIT_NONE_AND_ALIGN_BOTTOM_START;
          ImageNapi.createImageSize(this.objectFit, this.imageSize);
        })
      MenuItem({ content: 'ARKUI_OBJECT_FIT_NONE_AND_ALIGN_BOTTOM'})
        .width('50%')
        .onChange(()=> {
          this.objectFit = ArkUIObjectFit.ARKUI_OBJECT_FIT_NONE_AND_ALIGN_BOTTOM;
          ImageNapi.createImageSize(this.objectFit, this.imageSize);
        })
      MenuItem({ content: 'ARKUI_OBJECT_FIT_NONE_AND_ALIGN_BOTTOM_END'})
        .width('50%')
        .onChange(()=> {
          this.objectFit = ArkUIObjectFit.ARKUI_OBJECT_FIT_NONE_AND_ALIGN_BOTTOM_END;
          ImageNapi.createImageSize(this.objectFit, this.imageSize);
        })
    }
  }
  build() {
    Row() {
      Column() {
        Row() {
          Button($r('app.string.Select_image_coverage_mode'))
            .height(50)
            .width('50%')
            .onClick(() => {
              this.objectFit = ArkUIObjectFit.ARKUI_OBJECT_FIT_NONE;
            })
            .bindMenu(this.SubMenuImageSize)

          Button($r('app.string.Select_image_adaptation_mode'))
            .height(50)
            .width('50%')
            .bindMenu(this.SubMenuObjectFit)
        }
        .padding({bottom: 10})
        Row() {
          Button($r('app.string.Select_image_interpolation_mode'))
            .height(50)
            .width('50%')
            .onClick(() => {
              ImageNapi.createImageSize(ArkUIObjectFit.ARKUI_OBJECT_FIT_CONTAIN, ArkUIImageSize.ARKUI_IMAGE_SIZE_AUTO);
              this.imageRenderMode = ArkUIImageRenderMode.ARKUI_IMAGE_RENDER_MODE_ORIGINAL;
              this.imageRepeat = ArkUIImageRepeat.ARKUI_IMAGE_REPEAT_NONE;
            })
            .bindMenu(this.SubMenuImageInterpolation)
          Button($r('app.string.Select_image_rendering_mode'))
            .height(50)
            .width('50%')
            .bindMenu(this.SubMenuMode)
        }
        .padding({bottom: 10})
        Row() {
          Button($r('app.string.Select_background_overlay_mode'))
            .height(50)
            .onClick(() => {
              ImageNapi.createImageSize(ArkUIObjectFit.ARKUI_OBJECT_FIT_NONE, ArkUIImageSize.ARKUI_IMAGE_SIZE_AUTO);
            })
            .bindMenu(this.SubMenuImageRepeat)
        }
        .padding({bottom: 10})
        Column() {
          ContentSlot(this.nodeContent)
        }
        .width('100%')
      }
    }
    .height('100%')
  }
  async aboutToAppear() {
    ImageNapi.setContentHandle(this.nodeContent);
  }
  async aboutToDisappear() {
    ImageNapi.clearNodes();
  }
}
