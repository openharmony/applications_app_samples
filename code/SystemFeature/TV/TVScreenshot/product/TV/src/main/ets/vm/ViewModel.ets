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
import Log from '../common/Log';
import { screenShotModel } from 'screenshot_tv';
import { window, display } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { sizeCalc } from '../common/SizeCalc';
import { photoAccessHelper } from '@kit.MediaLibraryKit';

const TAG = 'ScreenShot-ViewModel';

/**
 * ViewModel 类负责管理截屏流程的业务逻辑。
 * 它作为 UI 层与 Model 层（screenShotModel）之间的协调者，处理复杂的异步工作流。
 * 采用单例模式确保全局状态的一致性，方便在不同页面间共享逻辑。
 */
export class ViewModel {
  private static instance: ViewModel | undefined

  private constructor() {
    this.ViewModelInit();
  }

  /**
   * 获取 ViewModel 的单例实例。
   */
  static getInstance(): ViewModel {
    if (!ViewModel.instance) {
      ViewModel.instance = new ViewModel()
    }
    Log.showInfo(TAG, 'getInstance')
    return ViewModel.instance
  }

  ViewModelInit(): void {
    Log.showInfo(TAG, 'ViewModelInit');
  }

  /**
   * 弹出一个临时的保存提示窗口。
   * 业务背景：截屏完成后，需要通过一个轻量级的弹窗告知用户图片已成功保存。
   * 原理：创建一个 TYPE_FLOAT 类型的浮动窗口，加载指定的 UI 内容，并在设定时间后自动销毁。
   * 使用独立窗口而非页面内组件，是为了确保提示信息能跨页面展示，且不影响主业务逻辑的执行。
   */
  static popupSaveTip(name: string, pagePath: string, rectY: number, rectW: number, rectH: number, duration: number,
    callback?: () => void): void {

    let context = AppStorage.get('context') as common.UIAbilityContext;
    let config: window.Configuration = {
      name,
      windowType: window.WindowType.TYPE_FLOAT,
      ctx: context
    };
    
    // 异步创建窗口并配置其物理属性。
    window.createWindow(config, (err: BusinessError, windowClass: window.Window) => {
      if (err.code) {
        Log.showError(TAG, 'Failed to create the TipWindow: ' + JSON.stringify(err))
        return
      }
      Log.showInfo(TAG, 'Succeeded in creating the TipWindow.')
      const displayClass = display.getDefaultDisplaySync();
      
      // 将提示框水平居中显示，提供一致的视觉平衡感。
      windowClass.moveWindowTo((displayClass.width - rectW) / 2, rectY, (err: BusinessError) => {
        if (err.code) {
          Log.showError(TAG, 'Failed to move the window. Cause: ' + JSON.stringify(err))
          return
        }
        Log.showInfo(TAG, 'Succeeded in moving the window. Data:' + JSON.stringify(err))
      })
      
      windowClass.resize(rectW, rectH, (err: BusinessError, data) => {
        if (err.code) {
          Log.showError(TAG, 'Failed to resetSize. Cause: ' + JSON.stringify(err))
          return
        }
        Log.showInfo(TAG, 'Succeeded in resetting size. Data:' + JSON.stringify(data))
      })

      // 禁用获焦能力，防止提示框干扰用户的遥控器操作。
      windowClass.setWindowFocusable(false, (err: BusinessError, data) => {
        if (err.code) {
          Log.showError(TAG, 'Failed to setWindowFocusable. Cause: ' + JSON.stringify(err))
          return
        }
        Log.showInfo(TAG, 'Succeeded in setWindowFocusable. Data:' + JSON.stringify(data))
      })

      windowClass.setUIContent(pagePath, (err: BusinessError) => {
        if (err.code) {
          Log.showError(TAG, 'Failed to load screenRecorderDialog page. Cause: ' + JSON.stringify(err))
          return
        }
        Log.showInfo(TAG, 'Succeeded in loading screenRecorderDialog page.')

        windowClass.setWindowBackgroundColor('#00000000')

        // 使用显示方式，提升用户体验的平滑度。
        windowClass.showWindow((err: BusinessError) => {
          if (err.code) {
            Log.showError(TAG, 'Failed to show window. Case: ' + JSON.stringify(err))
            return
          }
          Log.showInfo(TAG, 'Succeeded showWindow.')

          // 核心业务：在提示显示期间触发真实的图片保存操作。
          setTimeout(async () => {
            const context = AppStorage.get('context') as common.UIAbilityContext;
            photoAccessHelper.getPhotoAccessHelper(context);
            await screenShotModel.saveImage();
            // 预留一小段等待时间，确保底层异步写入完成后再关闭提示，避免竞态条件。
            await new Promise<number>((resolve) => setTimeout(resolve, 200))
            windowClass.destroyWindow((err: BusinessError) => {
              if (err.code) {
                Log.showError(TAG, 'Failed to destroyWindow. Case: ' + JSON.stringify(err))
                return
              }
              Log.showInfo(TAG, 'Succeeded in destroyWindow.')
              // 动画彻底结束后回调，用于执行如终止服务等清理操作。
              setTimeout(() => {
                if (callback) {
                  callback()
                }
              }, 400)
            })
          }, duration)
        })
      })
    })
  }

  /**
   * 关闭截屏预览并结束整个流程。
   * 业务背景：用户点击返回或预览超时自动退出。
   * 原理：先通知 Model 层隐藏主预览窗，随后展示保存提示，最后安全终止 Ability。
   */
  CloseShotScreen(): void {
    // 设置提示框在屏幕上方的位置，避免遮挡可能存在的关键 UI。
    const rectY = sizeCalc(46);
    const rectW = sizeCalc(686);
    const rectH = sizeCalc(100);
    
    screenShotModel.dismiss();
    ViewModel.popupSaveTip('Tip', 'pages/TipPage', rectY, rectW, rectH, 2000, async () => {
      // 最终自杀逻辑：释放所有系统资源，返回到之前的应用场景。
      const context = AppStorage.get('context') as common.UIAbilityContext;
      if (context) {
        await context.terminateSelf();
      }
    })
  }
}

let viewModel = ViewModel.getInstance();

export default viewModel
