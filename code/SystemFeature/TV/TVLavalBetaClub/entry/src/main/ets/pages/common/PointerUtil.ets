import { pointer } from '@kit.InputKit';
import { image } from '@kit.ImageKit';
import { JSON } from '@kit.ArkTS';

/**
 * 指针相关工具类
 */
export class PointerUtil {
  static pixelMap: image.PixelMap | null = null

  /**
   * 替换鼠标样式
   * @param isClick 是否是单击
   */
  static changePointStyle(isClick: boolean): void {
    getContext()
      .resourceManager
      .getMediaContent(isClick ? $r("app.media.mouse_click") : $r("app.media.mouse_show"))
      .then((svgFileData) => {
        const svgBuffer: ArrayBuffer = svgFileData.buffer.slice(0);
        let svgImageSource: image.ImageSource = image.createImageSource(svgBuffer);
        let svgDecodingOptions: image.DecodingOptions = { desiredSize: { width: 50, height: 50 } };
        svgImageSource.createPixelMap(svgDecodingOptions).then((pixelMap) => {
          try {
            pointer.setCustomCursorSync(AppStorage.get("windowId"), pixelMap, 25, 25);
            console.log(`setCustomCursorSync success`);
          } catch (error) {
            console.log(`setCustomCursorSync failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
          }
        });
      });
  }
}