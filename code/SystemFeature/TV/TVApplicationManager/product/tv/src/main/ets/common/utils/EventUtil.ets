import { JSON } from '@kit.ArkTS';
import { image } from '@kit.ImageKit';
import { window } from '@kit.ArkUI';
import { inputDevice, pointer } from '@kit.InputKit';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * 事件相关公共类
 */
export class EventUtil {
  public static pixelMap: image.PixelMap | null = null

  private constructor() {
  }

  /**
   * 判断是否触发触摸事件,修改鼠标样式
   * @returns 判断结果
   */
  static isTouchEvent(event: TouchEvent): boolean {

    //SourceTool.Pen 值为undefined,使用硬编码
    if (event.sourceTool == SourceTool.Pen || event.sourceTool == 2) {
      EventUtil.changePointStyle(event.type == TouchType.Down)
    }

    if (event.type == TouchType.Down) {
      return false;
    }

    return event.source == SourceType.Mouse || event.source == SourceType.TouchScreen
  }

  /**
   * 修改鼠标样式
   * @param isClick 是否点击
   */
  static changePointStyle(isClick: boolean): void {
    getContext()
      .resourceManager
      .getMediaContent(isClick ? $r('app.media.mouse_click') : $r('app.media.mouse_show'))
      .then((svgFileData) => {
        const svgBuffer: ArrayBuffer = svgFileData.buffer.slice(0);
        let svgImageSource: image.ImageSource = image.createImageSource(svgBuffer);
        let svgDecodingOptions: image.DecodingOptions = { desiredSize: { width: 50, height: 50 } };
        svgImageSource.createPixelMap(svgDecodingOptions).then((pixelMap) => {
          window.getLastWindow(getContext(), (_error: BusinessError, win: window.Window) => {
            try {
              let windowId = win?.getWindowProperties()?.id;
              pointer.setCustomCursorSync(windowId, pixelMap, 25, 25);
              console.log(`setCustomCursorSync success`);
            } catch (error) {
              console.log(`setCustomCursorSync failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
            }
          });
        });
      });
  }

  /**
   * 设置鼠标样式为默认样式
   */
  static changePointDefaultStyle(): void {
    window.getLastWindow(getContext(), (_error: BusinessError, win: window.Window) => {
      try {
        let windowId = win.getWindowProperties().id;
        pointer.setPointerStyle(windowId, pointer.PointerStyle.DEFAULT)
        console.log(`setCustomCursorSync success`);
      } catch (error) {
        console.log(`setCustomCursorSync failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
      }
    });
  }
}