import { pointer } from '@kit.InputKit';
import { image } from '@kit.ImageKit';
import { JSON } from '@kit.ArkTS';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * 指针相关工具类
 */
export class PointerUtil {
  static pixelMap: image.PixelMap | null = null

  /**
   * 修改鼠标样式
   * @param isClick 是否点击
   */
  static changePointStyle(isClick: boolean): void {
    try {
      getContext()
        .resourceManager
        .getMediaContent(isClick ? $r("app.media.mouse_click") : $r("app.media.mouse_show"))
        .then((svgFileData) => {
          const svgBuffer: ArrayBuffer = svgFileData.buffer.slice(0);
          let svgImageSource: image.ImageSource = image.createImageSource(svgBuffer);
          let svgDecodingOptions: image.DecodingOptions = { desiredSize: { width: 50, height: 50 } };
          svgImageSource.createPixelMap(svgDecodingOptions).then((pixelMap) => {
            window.getLastWindow(getContext(), (_error: BusinessError, win: window.Window) => {
              if (win && win.getWindowProperties()) {
                let windowId = win.getWindowProperties().id;
                try {
                  pointer.setCustomCursorSync(windowId, pixelMap, 25, 25);
                  console.log(`setCustomCursorSync success`);
                } catch (error) {
                  console.log(`setCustomCursorSync failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
                }
              }
            });
          });
        });
    } catch (error) {
      console.log(`setCustomCursorSync failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
    }
  }
}

