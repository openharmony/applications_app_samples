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

import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import lpx from '../../common/Lpx';
import { SettingBackground } from '../../default/layout/SettingBackground';
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { display, promptAction } from '@kit.ArkUI';
import { Duration } from '../../common/constants/Duration';
import { connection } from '@kit.NetworkKit';
import ethernet from '@ohos.net.ethernet';

const TAG = 'NetWorkSpeed';
const SPEED_1080P_VIDEO: number = 0.7;
const SPEED_2K_VIDEO: number = 2.5;
const PROGRESS_INCREASE_RATE: number = 5;
const PROGRESS_ONE_HUNDRED: number = 100;
const COEFFICIENT_FACTOR: number = 0.5;
const NETWORK_SPEED_REFERENCE: number = 12;
const HTTP_CONNECT_READ_TIMEOUT: number = 10500;
const MB_TO_KB_CONVERSION: number = 1024;
const CURRENT_SPEED_LINE_WIDTH: number = 4;
const SPEED_RECT_LEFT_MARGIN: number = 11;
const SPEED_RECT_RIGHT_MARGIN: number = 227;
const SPEED_LINE_RIGHT_MARGIN: number = 22;
const SPEED_ARROW_RIGHT_MARGIN: number = 253;
const HALF_SPEED_RECT_HEIGHT: number = 27.5;
const SPEED_TEXT_LEFT_MARGIN: number = 18;
const SPEED_TEXT_TOP_MARGIN_OFFSET: number = 13;
const PROGRESS_UPDATE_TIME_OUT: number = 1000;
const CURRENT_SPEED_TEXT_FONT: string = '32px sans-serif';
const CURRENT_SPEED_TEXT_FILL_STYLE: string = '#FFFFFF';
const CURRENT_SPEED_RECT_START_COLOR: string = '#1E93F6';
const CURRENT_SPEED_RECT_END_COLOR: string = '#24ECF7';
const CURRENT_SPEED_LINE_STOKE_STYLE: string = '#23DCF7';
const FILL_AREA_FILL_STYLE: string = '#4E4E4E';
const NETWORK_CONNECT_TIME_OUT: number = 5000;
const RESPONSE_CODE_OK: number = 200;
class Point {
  public x: number = 0
  public y: number = 0
}

@Entry
@Component
export struct NetSpeed {
  @State averageSpeed: string = '0';
  @State currentSpeed: string = '0';
  @State progress: number = 0;
  @State showRetestLayout: boolean = false;
  @State recommendVideoIcon: Resource | null = null;
  @State recommendVideoTitle: Resource | null = null;
  @State recommendVideoDescription: Resource | null = null;
  @State recommendSpeedText: string = '';
  @State isNetworkEnable: boolean = true;
  private updateInterval: number = 500 // 值越大曲线移动越慢
  private data: number[] = []; // 存储速度数据
  private maxDataPoints: number = 85; // 值越大曲线移动越慢
  private interpolationSteps: number = 3 // 2-5之间，值越大曲线越平滑
  private isPaused: boolean = false;
  private intervalId: number = 0;
  private densityPixels: number = 1.75;
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private testLinkUrl: string = '';
  private testLinkResourceUrl: string =
    getContext(this).resourceManager.getStringByNameSync('network_speed_test_resource');
  private speedLinePositionY: number = 0;
  private hasHandledError: boolean = false;
  private isEthernetTest: boolean = false;

  private async isNetworkOkForTest(): Promise<boolean> {
    try {
      const netHandle = await connection.getDefaultNet();
      if (netHandle.netId === 0) {
        return false;
      }
      const netCapabilities = await connection.getNetCapabilities(netHandle);
      if (!netCapabilities) {
        return false;
      }
      this.isEthernetTest = netCapabilities.bearerTypes.includes(connection.NetBearType.BEARER_ETHERNET);
      if (this.isEthernetTest) {
        const ifaces = await ethernet.getAllActiveIfaces();
        if (ifaces.length === 0) {
          return false;
        }
      }
      return true;
    } catch (error) {
      console.error(TAG, `isNetworkOkForTest error: ${error.message}`);
      return false;
    }
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  aboutToAppear(): void {
    this.densityPixels = display.getDefaultDisplaySync().densityPixels;
    console.debug(TAG, 'aboutToAppear, densityPixels =' + this.densityPixels);
    this.handleSpeedTest();
  }

  aboutToDisappear(): void {
    this.handlePause();
  }

  handleSpeedTest() {
    clearInterval(this.intervalId);
    console.log(TAG, 'handleSpeedTest start.');
    this.progress = 0;
    this.averageSpeed = '0';
    this.currentSpeed = '0';
    this.data = [];
    this.showRetestLayout = false;
    this.isNetworkEnable = true;
    this.isPaused = false;
    this.hasHandledError = false;
    this.isEthernetTest = false;

    this.getTestLinkUrl()
      .then((): Promise<void> => {
        return this.downloadLargeFile(this.testLinkUrl);
      })
      .catch((error: BusinessError) => {
        console.error(TAG, `handleSpeedTest error, message:${error.message}`);
        this.handleNetworkError();
      })

    setTimeout(() => {
      if (this.isNetworkEnable && !this.hasHandledError) {
        this.progress += PROGRESS_INCREASE_RATE;
      }
      this.intervalId = setInterval(async () => {
        if (this.hasHandledError) {
          clearInterval(this.intervalId);
          return;
        }
        const isNetworkOk = await this.isNetworkOkForTest();
        if (!isNetworkOk) {
          this.handleNetworkError();
          return;
        }
        if (this.progress <= PROGRESS_ONE_HUNDRED - PROGRESS_INCREASE_RATE) {
          this.progress += PROGRESS_INCREASE_RATE;
        } else {
          clearInterval(this.intervalId);
          this.getRecommendVideoQuality();
          this.showRetestLayout = true;
          focusControl.requestFocus('retryButton')
        }
      }, this.updateInterval);
    }, PROGRESS_UPDATE_TIME_OUT);
  }

  // 先获取测速的url
  async getTestLinkUrl() {
    console.debug(TAG, 'getTestLinkUrl start.');
    if (this.testLinkUrl) {
      return;
    }
    try {
      let httpRequest = http.createHttp();
      let options: http.HttpRequestOptions = {
        connectTimeout: NETWORK_CONNECT_TIME_OUT,
        readTimeout: NETWORK_CONNECT_TIME_OUT,
        usingCache: false
      };
      let response = await httpRequest.request(this.testLinkResourceUrl, options);
      if (response && response.responseCode === RESPONSE_CODE_OK) {
        let resultData = JSON.parse(response.result.toString()) as object
        let resultList = resultData['data']['playlist'] as object[];
        let urlList = resultList[0]['urls'] as string[]
        this.testLinkUrl = urlList[0];
        console.debug(TAG, 'getTestLinkUrl result =' + this.testLinkUrl);
      } else {
        throw new Error('NetWorkSpeed getTestLinkUrl error.');
      }
    } catch (error) {
      throw new Error(`NetWorkSpeed getTestLinkUrl error, message:${error.message}`);
    }
  }

  build() {
    Stack() {
      SettingBackground()
        .position({ x: 0, y: 0 })
        .height(ConfigData.WH_100_100)
        .width(ConfigData.WH_100_100)

      Column() {
        Text($r('app.string.network_speed_title'))
          .height(lpx(85))
          .fontColor(Color.White)
          .fontSize(lpx(60))
          .textAlign(TextAlign.Start)
          .margin({
            left: lpx(107),
            top: lpx(64)
          })

        Row() {
          Column() {
            Text(this.progress + '%')
              .height(lpx(85))
              .fontColor('rgb(255, 145, 90)')
              .fontSize(lpx(60))
              .textAlign(TextAlign.Start)

            Text($r('app.string.network_speed_progress'))
              .height(lpx(46))
              .fontColor(Color.White)
              .fontSize(lpx(32))
              .textAlign(TextAlign.Start)
              .margin({ top: lpx(5) })
          }.height(ConfigData.WH_100_100).alignItems(HorizontalAlign.Start)

          Column() {
            Row() {
              Text(this.currentSpeed)
                .height(lpx(85))
                .fontColor('rgb(117, 215, 255)')
                .fontSize(lpx(60))
                .textAlign(TextAlign.Start)

              Text($r('app.string.network_speed_unit'))
                .height(lpx(47))
                .fontColor('rgb(117, 215, 255)')
                .fontSize(lpx(33)).margin({ bottom: lpx(7) })
            }.alignItems(VerticalAlign.Bottom)

            Text($r('app.string.current_speed'))
              .height(lpx(46))
              .fontColor(Color.White)
              .fontSize(lpx(32))
              .textAlign(TextAlign.Start)
              .margin({ top: lpx(5) })
          }
          .height(ConfigData.WH_100_100)
          .align(Alignment.Center)
          .margin({ left: lpx(430) })
          .alignItems(HorizontalAlign.Start)

          Column() {
            Row() {
              Text(this.averageSpeed)
                .height(lpx(85))
                .fontColor('rgb(117, 215, 255)')
                .fontSize(lpx(60))
                .textAlign(TextAlign.Start)

              Text($r('app.string.network_speed_unit'))
                .height(lpx(47))
                .fontColor('rgb(117, 215, 255)')
                .fontSize(lpx(33)).margin({ bottom: lpx(7) })
            }.alignItems(VerticalAlign.Bottom)

            Text($r('app.string.average_speed'))
              .height(lpx(46))
              .fontColor(Color.White)
              .fontSize(lpx(32))
              .textAlign(TextAlign.Start)
              .margin({ top: lpx(5) })
          }
          .height(ConfigData.WH_100_100)
          .align(Alignment.Center)
          .margin({ left: lpx(350) })
          .alignItems(HorizontalAlign.Start)
        }
        .width(ConfigData.WH_100_100)
        .height(lpx(136))
        .margin({
          left: lpx(286), top: lpx(83), bottom: lpx(50)
        })

        Stack() {
          Canvas(this.context)
            .width(ConfigData.WH_100_100)
            .height(ConfigData.WH_100_100)
            .backgroundColor('rgb(40, 40, 40)')

          Column() {
            Row() {
              Divider()
                .width(lpx(1268))
                .height(lpx(1))
                .color('rgb(151, 151, 151)')
                .margin({ top: lpx(183) })

              Text($r('app.string.network_speed_fast'))
                .height(lpx(60))
                .fontColor(Color.White)
                .fontSize(lpx(32))
                .width(ConfigData.WH_100_100)
                .margin({ top: lpx(158) })
                .align(Alignment.Bottom)
            }
            .width(ConfigData.WH_100_100)
            .height(lpx(184))

            Row() {
              Divider()
                .width(lpx(1268))
                .height(lpx(1))
                .color('rgb(151, 151, 151)')
                .margin({ top: lpx(151) })

              Text($r('app.string.network_speed_slow'))
                .height(lpx(60))
                .fontColor(Color.White)
                .fontSize(lpx(32))
                .width(ConfigData.WH_100_100)
                .margin({ top: lpx(110) })
                .align(Alignment.Bottom)
            }
            .width(ConfigData.WH_100_100)
            .height(lpx(292))
            .alignItems(VerticalAlign.Top)
          }
          .width(ConfigData.WH_100_100)
          .height(ConfigData.WH_100_100)
        }
        .width(lpx(1321))
        .height(lpx(476))
        .margin({ left: lpx(286) })
      }
      .width(ConfigData.WH_100_100)
      .height(ConfigData.WH_100_100)
      .alignItems(HorizontalAlign.Start)
      .visibility(!this.showRetestLayout && this.isNetworkEnable && !this.hasHandledError
        ? Visibility.Visible : Visibility.None)

      Column() {
        Text($r('app.string.network_speed_title'))
          .height(lpx(85))
          .fontColor(Color.White)
          .fontSize(lpx(60))
          .textAlign(TextAlign.Start)
          .margin({ left: lpx(107), top: lpx(64) })
          .alignSelf(ItemAlign.Start)

        Image((this.isNetworkEnable && !this.hasHandledError)
          ? this.recommendVideoIcon : $r('app.media.network_not_connected'))
          .width((this.isNetworkEnable && !this.hasHandledError) ? lpx(169) : lpx(242))
          .height((this.isNetworkEnable && !this.hasHandledError) ? lpx(169) : lpx(195))
          .margin({ top: (this.isNetworkEnable && !this.hasHandledError) ? lpx(109) : lpx(202) })

        Text(this.recommendVideoTitle)
          .height(lpx(70))
          .fontSize(lpx(50))
          .fontColor(Number(this.averageSpeed) > SPEED_2K_VIDEO ? 'rgb(255, 226, 193)' : 'rgb(96, 208, 255)')
          .margin({ top: lpx(11) })
          .visibility((this.isNetworkEnable && !this.hasHandledError) ? Visibility.Visible : Visibility.None)

        Text($r('app.string.network_speed_average', this.averageSpeed))
          .height(lpx(47))
          .fontSize(lpx(33))
          .fontColor(Color.White)
          .visibility((this.isNetworkEnable && !this.hasHandledError) ? Visibility.Visible : Visibility.None)

        Text((this.isNetworkEnable && !this.hasHandledError)
          ? this.recommendVideoDescription : $r('app.string.network_speed_no_network'))
          .height(lpx(59))
          .fontSize(lpx(42))
          .fontColor(Color.White)
          .margin({ top: (this.isNetworkEnable && !this.hasHandledError) ? lpx(34) : lpx(42), bottom: lpx(43) })

        Text($r('app.string.speed_description'))
          .height(lpx(49))
          .fontSize(lpx(35))
          .fontColor('rgb(198, 198, 198)')
          .margin({ bottom: lpx(80) })

        Column() {
          Button($r('app.string.retest_speed'))
            .id('retryButton')
            .backgroundColor('rgba(216, 216, 216, 1)')
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Medium)
            .height(lpx(96))
            .fontSize(lpx(40))
            .focusable(true)
            .padding({
              left: lpx(83),
              right: lpx(83),
              top: lpx(28),
              bottom: lpx(28)
            })
            .onClick(() => {
              console.log(TAG, 'Click retry button.');
              this.context.clearRect(0, 0, this.context.width, this.context.height);
              this.handleSpeedTest();
            })
            .stateStyles({
              focused: {
                .border({
                  color: Color.Transparent,
                  radius:lpx(54)
                })
              }
            })
        }
        .borderRadius(lpx(54))
        .padding(lpx(6))
        .border({
          width: lpx(2),
          color: Color.White,
          style: BorderStyle.Solid
        })
      }
      .focusable(true)
      .width(ConfigData.WH_100_100)
      .height(ConfigData.WH_100_100)
      .alignItems(HorizontalAlign.Center)
      .visibility(this.showRetestLayout || !this.isNetworkEnable || this.hasHandledError
        ? Visibility.Visible : Visibility.None)
      .focusable(true)
    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
    .focusable(true)
  }

  private getRecommendVideoQuality() {
    let speed = Number(this.averageSpeed);
    try {
      if (speed >= 0 && speed < SPEED_1080P_VIDEO) {
        this.recommendVideoIcon = $r('app.media.video_quality_1080p');
        this.recommendVideoTitle = $r('app.string.network_speed_1080P');
        this.recommendVideoDescription = $r('app.string.speed_description_1080p')
      } else if (speed >= SPEED_1080P_VIDEO && speed <= SPEED_2K_VIDEO) {
        this.recommendVideoIcon = $r('app.media.video_quality_2k');
        this.recommendVideoTitle = $r('app.string.network_speed_ultra');
        this.recommendVideoDescription = $r('app.string.speed_description_2k')
      } else {
        this.recommendVideoIcon = $r('app.media.video_quality_4k');
        this.recommendVideoTitle = $r('app.string.network_speed_ultra');
        this.recommendVideoDescription = $r('app.string.speed_description_4k')
      }
    } catch (error) {
      console.error(TAG, `getRecommendVideoQuality error, message:${error.message}`);
    }
  }

  private getRecommendSpeedText() {
    let speed = Number(this.averageSpeed);
    try {
      if (speed >= 0 && speed < SPEED_1080P_VIDEO) {
        this.recommendSpeedText = getContext()
          .resourceManager
          .getStringSync($r('app.string.recommend_speed_text_1080p'),
            Math.round(Number(this.currentSpeed) * MB_TO_KB_CONVERSION).toString())
      } else if (speed >= SPEED_1080P_VIDEO && speed <= SPEED_2K_VIDEO) {
        this.recommendSpeedText = getContext()
          .resourceManager
          .getStringSync($r('app.string.recommend_speed_text_2k'),
            Math.round(Number(this.currentSpeed) * MB_TO_KB_CONVERSION).toString())
      } else {
        this.recommendSpeedText = getContext()
          .resourceManager
          .getStringSync($r('app.string.recommend_speed_text_4k'),
            Math.round(Number(this.currentSpeed) * MB_TO_KB_CONVERSION).toString())
      }
    } catch (error) {
      console.error(TAG, `getRecommendSpeedText error, message:${error.message}`);
    }
  }

  // 新增三次样条插值方法
  private cubicInterpolate(p0: number, p1: number, t: number): number {
    return p0 * (1 - t)**3 +
      p1 * t**3 +
      3 * p0 * t * (1 - t)**2 +
      3 * p1 * t**2 * (1 - t)
  }

  // 新增安全获取坐标点方法
  private getPoint(index: number, width: number, height: number, maxValue: number): Point {
    const point = new Point()
    const safeIndex = Math.max(0, Math.min(index, this.data.length - 1))
    point.x = (safeIndex / (this.maxDataPoints - 1)) * width
    point.y = height - (this.data[safeIndex] / maxValue) * height
    return point
  }

  // 新增填充区域绘制方法
  private drawFillArea(canvas: CanvasRenderingContext2D, width: number, height: number, maxValue: number) {
    canvas.beginPath()
    canvas.fillStyle = FILL_AREA_FILL_STYLE
    canvas.moveTo(0, height)

    for (let i = 0; i < this.data.length; i++) {
      const p = this.getPoint(i, width, height, maxValue)
      if (i === 0) {
        canvas.lineTo(p.x, p.y)
      } else {
        const pPrev = this.getPoint(i - 1, width, height, maxValue)
        const cp1x = pPrev.x + (p.x - pPrev.x) * COEFFICIENT_FACTOR
        const cp1y = pPrev.y + (p.y - pPrev.y) * COEFFICIENT_FACTOR
        canvas.bezierCurveTo(cp1x, cp1y, cp1x, cp1y, p.x, p.y)
      }
    }
    this.drawCurrentSpeedRect(width, height, maxValue, canvas);
  }

  // 新增实时速度标线和文本的绘制
  private drawCurrentSpeedRect(width: number, height: number, maxValue: number, canvas: CanvasRenderingContext2D) {
    this.getRecommendSpeedText();
    const lastPoint = this.getPoint(this.data.length - 1, width, height, maxValue);
    canvas.lineTo(lastPoint.x, height);
    canvas.lineTo(0, height);
    canvas.fill();

    if (lastPoint.y < HALF_SPEED_RECT_HEIGHT / this.densityPixels) {
      this.speedLinePositionY = HALF_SPEED_RECT_HEIGHT / this.densityPixels;
    } else if (lastPoint.y > (height - HALF_SPEED_RECT_HEIGHT / this.densityPixels)) {
      this.speedLinePositionY = height - HALF_SPEED_RECT_HEIGHT / this.densityPixels;
    } else {
      this.speedLinePositionY = lastPoint.y;
    }

    canvas.beginPath();
    canvas.lineWidth = CURRENT_SPEED_LINE_WIDTH / this.densityPixels;
    canvas.moveTo(SPEED_RECT_LEFT_MARGIN / this.densityPixels, this.speedLinePositionY);
    canvas.lineTo(width - SPEED_LINE_RIGHT_MARGIN / this.densityPixels, this.speedLinePositionY);
    canvas.strokeStyle = CURRENT_SPEED_LINE_STOKE_STYLE;
    canvas.stroke();

    let grad =
      this.context.createLinearGradient(SPEED_RECT_LEFT_MARGIN / this.densityPixels, lastPoint.y,
        SPEED_ARROW_RIGHT_MARGIN / this.densityPixels, lastPoint.y);
    grad.addColorStop(0, CURRENT_SPEED_RECT_START_COLOR);
    grad.addColorStop(1, CURRENT_SPEED_RECT_END_COLOR);
    this.context.fillStyle = grad;
    canvas.beginPath();
    canvas.moveTo(SPEED_RECT_LEFT_MARGIN / this.densityPixels,
      this.speedLinePositionY - HALF_SPEED_RECT_HEIGHT / this.densityPixels);
    canvas.lineTo(SPEED_RECT_RIGHT_MARGIN / this.densityPixels,
      this.speedLinePositionY - HALF_SPEED_RECT_HEIGHT / this.densityPixels);
    canvas.lineTo(SPEED_ARROW_RIGHT_MARGIN / this.densityPixels,
      this.speedLinePositionY);
    canvas.lineTo(SPEED_RECT_RIGHT_MARGIN / this.densityPixels,
      this.speedLinePositionY + HALF_SPEED_RECT_HEIGHT / this.densityPixels);
    canvas.lineTo(SPEED_RECT_LEFT_MARGIN / this.densityPixels,
      this.speedLinePositionY + HALF_SPEED_RECT_HEIGHT / this.densityPixels);
    canvas.closePath();
    canvas.fill();

    this.context.fillStyle = CURRENT_SPEED_TEXT_FILL_STYLE;
    this.context.font = CURRENT_SPEED_TEXT_FONT;
    this.context.fillText(this.recommendSpeedText, SPEED_TEXT_LEFT_MARGIN / this.densityPixels,
      this.speedLinePositionY + SPEED_TEXT_TOP_MARGIN_OFFSET / this.densityPixels);
  }

  // 修改后的数据更新方法
  updateData(newValue: number) {
    // 如果已经处理了错误或暂停，停止更新数据
    if (this.isPaused || this.hasHandledError || !this.isNetworkEnable) {
      return;
    }

    // 当数据达到最大容量时暂停
    if (this.data.length >= this.maxDataPoints) {
      this.handlePause();
      return;
    }

    // 插值处理（增加长度检查）
    if (this.data.length >= 1) {
      const lastValue = this.data[this.data.length - 1];
      for (let i = 1; i <= this.interpolationSteps; i++) {
        if (this.data.length >= this.maxDataPoints) {
          this.handlePause();
          break;
        }
        const t = i / (this.interpolationSteps + 1);
        const interpolated = this.cubicInterpolate(lastValue, newValue, t);
        this.data.push(interpolated);
      }
    }

    // 最终数据点检查
    if (this.data.length >= this.maxDataPoints) {
      this.handlePause();
      return;
    }

    this.data.push(newValue);
    this.drawChartBezier(this.context);
  }

  // 新增暂停处理方法
  private handlePause() {
    this.isPaused = true;
    clearInterval(this.intervalId);
    this.forceFullRender(); // 确保绘制到最右侧
  }

  // 强制完成最终渲染
  private forceFullRender() {
    if (this.data.length > this.maxDataPoints) {
      this.data = this.data.slice(0, this.maxDataPoints);
    }
    this.drawChartBezier(this.context);
  }

  // 修改后的绘制方法
  private drawChartBezier(canvas: CanvasRenderingContext2D) {
    const width = canvas.width;
    const height = canvas.height;
    const maxValue = Math.max(...this.data, NETWORK_SPEED_REFERENCE);
    canvas.clearRect(0, 0, width, height);

    // 即使暂停也绘制最后完整2帧
    if (this.data.length < 2) {
      return;
    }

    // 绘制逻辑保持不变...
    this.drawFillArea(canvas, width, height, maxValue);
  }

  // 处理网络错误
  private handleNetworkError() {
    // 防止重复处理错误
    if (this.hasHandledError) {
      return;
    }
    
    // 设置错误标志
    this.hasHandledError = true;
    this.isNetworkEnable = false;

    // 立即停止进度条定时器
    if (this.intervalId !== 0) {
      clearInterval(this.intervalId);
      this.intervalId = 0;
    }

    // 暂停数据更新
    this.isPaused = true;
    
    // 立即显示错误界面并聚焦到重试按钮
    this.showRetestLayout = true;
    setTimeout(() => {
      focusControl.requestFocus('retryButton');
    }, this.updateInterval);
  }

  async downloadLargeFile(url: string) {
    console.log(TAG, 'downloadLargeFile START.');
    if (!url) {
      console.error(TAG, 'downloadLargeFile url error.');
      return;
    }
    const httpRequest = http.createHttp();

    // 速度统计变量
    let totalBytes = 0;
    const startTime = new Date().getTime();
    let lastCheckTime = startTime;
    let lastCheckBytes = 0;

    // 配置HTTP请求
    const options: http.HttpRequestOptions = {
      method: http.RequestMethod.GET,
      connectTimeout: HTTP_CONNECT_READ_TIMEOUT,
      readTimeout: HTTP_CONNECT_READ_TIMEOUT,
      expectDataType: http.HttpDataType.ARRAY_BUFFER, //期望返回的数据类型
    };


      // 注册数据接收监听器
      httpRequest.on('dataReceive', (receivedData: ArrayBuffer) => {
        if (this.hasHandledError || !this.isNetworkEnable) {
          return;
        }
        const currentTime = new Date().getTime();
        totalBytes += receivedData.byteLength;

        // 每隔500ms计算一次速度
        if (currentTime - lastCheckTime >= this.updateInterval) {
          if (this.isPaused || this.hasHandledError) {
            return;
          }
          const totalElapsed = (currentTime - startTime) / 1000;
          const recentElapsed = (currentTime - lastCheckTime) / 1000;

          // 格式化并输出
          const formatSpeed = (speed: number) => (speed / (MB_TO_KB_CONVERSION * MB_TO_KB_CONVERSION)).toFixed(2);
          const formatData = (bytes: number) => (bytes / (MB_TO_KB_CONVERSION * MB_TO_KB_CONVERSION)).toFixed(2);

          this.averageSpeed = formatSpeed(totalBytes / totalElapsed);
          this.currentSpeed = formatSpeed((totalBytes - lastCheckBytes) / recentElapsed);

          console.debug(TAG, `downloadLargeFile received ：${formatData(totalBytes)}MB `);

          lastCheckTime = currentTime;
          lastCheckBytes = totalBytes;

          this.updateData(parseFloat(this.currentSpeed));
        }
      });

    // 发送请求并处理响应
    httpRequest.requestInStream(url, options, (err: BusinessError<void>, data: number) => {
      // 如果已经处理过错误，不再重复处理
      if (this.hasHandledError) {
        httpRequest.destroy();
        return;
      }
      if (err) {
        console.error(TAG, `requestInStream callback error, message:${JSON.stringify(err)}`);
        if (err.code != 2300028 && err.code != 2300056) {
          this.handleNetworkError();
        }
      } else {
        this.isNetworkEnable = true;
        console.debug(TAG, 'requestInStream success, number = ' + data);
      }
      httpRequest.destroy()
    });
  }
}
