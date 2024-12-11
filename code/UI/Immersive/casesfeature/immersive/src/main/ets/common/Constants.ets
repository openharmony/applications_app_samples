/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

export class Constants {
  static readonly NUMBER_1: number = 1;
  static readonly NUMBER_2: number = 1;
  static readonly NUMBER_6: number = 6;
  static readonly NUMBER_10: number = 10;
  static readonly NUMBER_20: number = 20;
  static readonly NUMBER_16: number = 16;
  static readonly NUMBER_17: number = 17;
  static readonly NUMBER_700: number = 700;
  /** 告警toast弹窗持续时长 */
  public static readonly WARN_TOAST_DURATION: number = 800;
  /** 测试用评论数量 */
  public static readonly TEST_COMMENTS_COUNT: number = 10;
  /** 测试用评论列表预加载数量 */
  public static readonly COMMENTS_LIST_CACHE: number = 5;
  /** 测试评论的默认用户名 */
  public static readonly COMMENTS_DEFAULT_USERNAME: string = '买家';
  /** 评论条目之间的间距 */
  public static readonly COMMENT_SPACE: number = 10;
  /** 评论条目具体头像和内容之间的间距 */
  public static readonly COMMENT_ITEM_SPACE: number = 8;
  /** 评论内容之间的间距 */
  public static readonly COMMENT_CONTENT_SPACE: number = 5;
  /** 评论弹窗高度占屏幕的比例 */
  public static readonly COMMENT_DIALOG_SCALE: number = 0.67;
  /** 关闭评论弹窗回调的动画时长 */
  public static readonly COMMENT_DIALOG_CLOSE_DURATION: number = 300;
  /** 评论弹窗的转场动画时长 */
  public static readonly COMMENT_DIALOG_TRANS_DURATION: number = 300;
  /** 评论弹窗的最小高度（触发关闭弹窗,vp） */
  public static readonly COMMENT_DIALOG_MIN_HEIGHT: number = 250;
  /** 评论弹窗恢复高度的动画时长 */
  public static readonly COMMENT_DIALOG_RECOVERY_TIME: number = 400;
  /** 滑动手势最小识别距离 */
  public static readonly COMMENT_PAN_GESTURE_DISTANCE: number = 20;
  /** 底部栏缺失的高度 */
  public static readonly BOTTOM_STATUS_HEIGHT: number = 25;
}