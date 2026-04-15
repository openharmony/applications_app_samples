/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, beforeEach, it, expect } from '@ohos/hypium';
import DateTimeUtil from '../../../../main/ets/model/DateTimeUtil';

export default function DateTimeUtilTest() {
  describe('DateTimeUtilTest', () => {
    let util: DateTimeUtil;

    beforeEach(() => {
      // 业务背景：DateTimeUtil 是媒体文件命名和录制计时的基础依赖。
      // 每条用例都重新创建实例，可以把失败范围锁定到单个方法，而不是共享状态。
      util = new DateTimeUtil();
    });

    it('DateTimeUtil_Fill_PadsSingleDigit_001', 0, () => {
      // 业务背景：文件名和录制计时都要求固定宽度，否则排序和展示都会错位。
      // 这条测试守住了前导零规则，避免生成 1 位数字导致字符串比较失真。
      expect(util.fill(5)).assertEqual('05');
    });

    it('DateTimeUtil_Fill_LeavesDoubleDigitUntouched_002', 0, () => {
      // 业务背景：双位数不应再次补零，否则会直接破坏文件名格式。
      // 这里验证上界分支，是为了防止今后把比较条件误写成大于等于。
      expect(util.fill(12)).assertEqual('12');
    });

    it('DateTimeUtil_ConcatDate_BuildsCompactDate_003', 0, () => {
      // 业务背景：媒体文件名使用无分隔符日期，便于跨平台存储和排序。
      // 单独验证 concatDate，能保证上层命名逻辑即使换实现也不丢格式契约。
      expect(util.concatDate(2026, 4, 11)).assertEqual('20260411');
    });

    it('DateTimeUtil_ConcatTime_BuildsCompactTime_004', 0, () => {
      // 业务背景：相机输出命名依赖 HHMMSS 形式，任何分隔符变化都会影响兼容性。
      // 守住紧凑时间格式，可以保证 createAndGetUri 一类调用持续稳定。
      expect(util.concatTime(9, 8, 7)).assertEqual('090807');
    });

    it('DateTimeUtil_GetVideoTime_FormatsMinuteAndSecond_005', 0, () => {
      // 业务背景：录制面板展示的是分钟和秒，错一位就会直接误导用户判断时长。
      // 选择 61 秒作为样本，可以同时命中分钟进位和秒补零两个规则。
      expect(util.getVideoTime(61000)).assertEqual('01 : 01');
    });

    it('DateTimeUtil_GetVideoTime_HandlesZeroDuration_006', 0, () => {
      // 业务背景：录制刚启动时会先闪出 00:00，零值格式错误会造成首帧抖动。
      // 这条用例确保初始态和正常计时共用同一套格式规则。
      expect(util.getVideoTime(0)).assertEqual('00 : 00');
    });

    it('DateTimeUtil_GetVideoTimes_FormatsHourMinuteSecond_007', 0, () => {
      // 业务背景：长视频录制依赖时分秒计数，小时位缺失会导致直播或监控场景显示错误。
      // 使用 1 小时 1 分 1 秒覆盖三段式格式，比单一零值更能防回归。
      expect(util.getVideoTimes(3661000)).assertEqual('01:01:01');
    });

    it('DateTimeUtil_GetVideoTimes_KeepsShortDurationAligned_008', 0, () => {
      // 业务背景：短视频是高频主链路，因此秒级展示必须与长视频保持一致宽度。
      // 保持 00:00:59 这种格式，才能让录制按钮附近的文本不发生横跳。
      expect(util.getVideoTimes(59000)).assertEqual('00:00:59');
    });

    it('DateTimeUtil_GetDate_ReturnsEightDigits_009', 0, () => {
      // 业务背景：真实日期由系统时间生成，测试不应绑定某一天，否则会天然脆弱。
      // 因此这里只验证格式契约，确保输出可直接拼进媒体文件名。
      let dateValue: string = util.getDate();
      expect(new RegExp('^\\d{8}$').test(dateValue)).assertTrue();
    });

    it('DateTimeUtil_GetTime_ReturnsSixDigits_010', 0, () => {
      // 业务背景：时间部分必须稳定输出六位，否则会破坏 IMG_YYYYMMDD_HHMMSS 命名约定。
      // 这里同样只检查结构，不把测试耦合到运行时系统时间。
      let timeValue: string = util.getTime();
      expect(new RegExp('^\\d{6}$').test(timeValue)).assertTrue();
    });

    it('DateTimeUtil_ConcatMethods_ComposeStableFileStamp_011', 0, () => {
      // 业务背景：日期和时间方法经常被上层串联使用，单测需要覆盖组合效果而不只是单个片段。
      // 拼接后验证长度和内容，能更贴近真实的媒体文件命名路径。
      let stamp = `${util.concatDate(2026, 12, 31)}_${util.concatTime(23, 59, 58)}`;
      expect(stamp).assertEqual('20261231_235958');
    });
  });
}
