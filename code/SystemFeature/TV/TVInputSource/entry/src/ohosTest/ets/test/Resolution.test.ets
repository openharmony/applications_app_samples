/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, beforeEach, afterEach, it, expect } from '@ohos/hypium';
import { display } from '@kit.ArkUI';
import { getScreenSize, getVideoSize } from '../../../main/ets/utils/Utils';
import { restoreAll } from './Batch1TestHelper';

interface DefaultDisplayLike {
  densityDPI: number;
}

/**
 * Replaces `display.getDefaultDisplay` for one test case.
 *
 * @param replacement Replacement async display reader.
 * @returns () => void Restore callback for the original API.
 */
function patchGetDefaultDisplay(replacement: () => Promise<DefaultDisplayLike>): () => void {
  const original = display.getDefaultDisplay;
  display.getDefaultDisplay = async (): Promise<display.Display> => {
    return (await replacement()) as Object as display.Display;
  };
  return (): void => {
    display.getDefaultDisplay = original;
  };
}

/**
 * Registers business-facing tests for multi-resolution sizing and aspect-ratio policy.
 *
 * @returns void.
 */
export default function ResolutionTest(): void {
  describe('Resolution_real', () => {
    let restores: Array<() => void> = [];

    beforeEach(() => {
      restores = [];
      AppStorage.setOrCreate<number>('screen_px_w', 1920);
      AppStorage.setOrCreate<number>('screen_px_h', 1080);
    });

    afterEach(() => {
      restoreAll(restores);
    });

    it('should_letterbox_width_for_four_three_content_on_widescreen_pages', 0, () => {
      const videoSize = getVideoSize(1920, 1080, 3840, 2160, '4:3');

      // TV 杈撳叆婧愰〉闇€瑕佷繚鎸佽妭鐩師濮嬬敾骞咃紝鍚﹀垯 4:3 鐩存挱鍐呭浼氳妯悜鎷変几銆?      // 閿佸畾瀹藉害瑁佸壀绛栫暐鍚庯紝鍚庣画鍒囨崲涓嶅悓鍒嗚鲸鐜囬〉闈㈡椂浠嶈兘淇濇寔鑰佺數瑙嗗唴瀹规瘮渚嬫纭€?      expect(videoSize.width).assertEqual(1440);
      expect(videoSize.height).assertEqual(1080);
    });

    it('should_letterbox_height_for_four_three_content_on_portrait_pages', 0, () => {
      const videoSize = getVideoSize(1080, 1920, 720, 576, '4:3');

      // 鏃嬭浆鍦烘櫙涓嬮〉闈㈡瘮鍐呭鏇粹€滅槮鈥濓紝绯荤粺搴斾繚鐣欓〉闈㈠搴﹀苟鍘嬬缉楂樺害銆?      // 璇ユ柇瑷€鑳介槻姝㈢珫灞忛€傞厤鏃堕敊璇部鐢ㄦí灞忓垎鏀紝瀵艰嚧鍐呭瓒呭嚭鍙鍖恒€?      expect(videoSize.width).assertEqual(1080);
      expect(videoSize.height).assertEqual(810);
    });

    it('should_letterbox_height_for_sixteen_nine_content_on_four_three_pages', 0, () => {
      const videoSize = getVideoSize(1440, 1080, 1920, 1080, '16:9');

      // 16:9 鑺傜洰杩涘叆杈冪獎瀹瑰櫒鏃讹紝浼樺厛鍑忓皯楂樺害鑰屼笉鏄埅鏂搴︺€?      // 杩欑洿鎺ュ奖鍝?HDMI 涓?DTV 椤甸潰鍦ㄦ棫鍒嗚鲸鐜囩數瑙嗕笂鐨勯甯ф樉绀烘槸鍚﹀畬鏁淬€?      expect(videoSize.width).assertEqual(1440);
      expect(videoSize.height).assertEqual(810);
    });

    it('should_letterbox_width_for_sixteen_nine_content_on_ultrawide_pages', 0, () => {
      const videoSize = getVideoSize(2560, 1080, 1920, 1080, '16:9');

      // 瓒呭灞忕幆澧冨緢瀹规槗鎶婅棰戝尯鍩熼敊璇摵婊★紝閫犳垚宸﹀彸鍐呭琚繃搴︽媺浼搞€?      // 杩欓噷鍥哄畾涓衡€滀繚楂樼缉瀹解€濓紝纭繚妗岄潰娓叉煋鎴栧鎺ュ睆鍦烘櫙浠嶉伒寰爣鍑嗙數瑙嗙敾骞呫€?      expect(videoSize.width).assertEqual(1920);
      expect(videoSize.height).assertEqual(1080);
    });

    it('should_keep_full_page_size_when_page_ratio_already_matches_target_ratio', 0, () => {
      const videoSize = getVideoSize(1920, 1080, 1280, 720, '16:9');

      // 褰撳鍣ㄦ瘮渚嬪拰鐩爣姣斾緥瀹屽叏涓€鑷存椂锛屼笉搴斿紩鍏ラ澶栭粦杈广€?      // 璇ョ敤渚嬬敤浜庨槻姝㈠悗缁噸鏋勬妸鈥滅瓑浜庘€濊鍒よ繘缂╂斁鍒嗘敮锛屽奖鍝嶆弧灞忔挱鏀句綋楠屻€?      expect(videoSize.width).assertEqual(1920);
      expect(videoSize.height).assertEqual(1080);
    });

    it('should_keep_original_page_size_when_ratio_type_is_not_supported', 0, () => {
      const videoSize = getVideoSize(1920, 1080, 1920, 1080, 'original');

      // 鏈瘑鍒敾骞呯被鍨嬫椂閫夋嫨淇濇寔鐜扮姸锛屾瘮鎿呰嚜濂楃敤鏌愪釜姣斾緥鏇村畨鍏ㄣ€?      // 杩欒兘淇濇姢鏈潵鎵╁睍鐨勬柊姣斾緥鍦ㄥ皻鏈帴鍏ュ墠锛屼笉浼氱牬鍧忓綋鍓嶉〉闈㈠竷灞€銆?      expect(videoSize.width).assertEqual(1920);
      expect(videoSize.height).assertEqual(1080);
    });

    it('should_round_portrait_sixteen_nine_height_for_rotation_scenarios', 0, () => {
      const videoSize = getVideoSize(1080, 1920, 1920, 1080, '16:9');

      // 鏃嬭浆鍚?16:9 鍐呭閫氬父鍙兘鏄剧ず涓鸿緝娴呯殑妯悜甯︾姸鍖哄煙銆?      // 杩欓噷閿佸畾鍥涜垗浜斿叆缁撴灉锛岄伩鍏嶄笉鍚屾瀯寤虹幆澧冧笅鍑虹幇 607/608 鐨勫竷灞€鎶栧姩銆?      expect(videoSize.width).assertEqual(1080);
      expect(videoSize.height).assertEqual(608);
    });

    it('should_build_screen_metrics_from_explicit_4k_window_values', 0, async () => {
      AppStorage.setOrCreate<number>('screen_px_w', 3840);
      AppStorage.setOrCreate<number>('screen_px_h', 2160);
      restores.push(
        patchGetDefaultDisplay(async (): Promise<DefaultDisplayLike> => {
          return { densityDPI: 320 };
        })
      );

      // Verify cached 4K metrics map to layout size consistently.
      const screenSize = await getScreenSize();

      expect(screenSize.width).assertEqual(1280);
      expect(screenSize.height).assertEqual(720);
      expect(screenSize.pageW).assertEqual(3840);
      expect(screenSize.pageH).assertEqual(2160);
      expect(screenSize.dpi).assertEqual(2);
      expect(screenSize.lpi).assertEqual(3);
    });

    it('should_fallback_to_default_window_metrics_when_cached_values_are_zero', 0, async () => {
      AppStorage.setOrCreate<number>('screen_px_w', 0);
      AppStorage.setOrCreate<number>('screen_px_h', 0);
      restores.push(
        patchGetDefaultDisplay(async (): Promise<DefaultDisplayLike> => {
          return { densityDPI: 240 };
        })
      );

      // Verify zeroed cache falls back to safe default metrics.
      const screenSize = await getScreenSize();

      expect(screenSize.width).assertEqual(1280);
      expect(screenSize.height).assertEqual(720);
      expect(screenSize.pageW).assertEqual(1920);
      expect(screenSize.pageH).assertEqual(1080);
      expect(screenSize.dpi).assertEqual(1.5);
      expect(screenSize.lpi).assertEqual(1.5);
    });

    it('should_preserve_portrait_window_metrics_for_rotated_pages', 0, async () => {
      AppStorage.setOrCreate<number>('screen_px_w', 1080);
      AppStorage.setOrCreate<number>('screen_px_h', 1920);
      restores.push(
        patchGetDefaultDisplay(async (): Promise<DefaultDisplayLike> => {
          return { densityDPI: 160 };
        })
      );

      // Verify portrait metrics stay stable for rotated layouts.
      const screenSize = await getScreenSize();

      expect(screenSize.width).assertEqual(1280);
      expect(screenSize.height).assertEqual(2275);
      expect(screenSize.pageW).assertEqual(1080);
      expect(screenSize.pageH).assertEqual(1920);
      expect(screenSize.dpi).assertEqual(1);
      expect(screenSize.lpi).assertEqual(0.844);
    });

    it('should_round_fractional_layout_scale_to_three_decimals_for_non_standard_panels', 0, async () => {
      AppStorage.setOrCreate<number>('screen_px_w', 1366);
      AppStorage.setOrCreate<number>('screen_px_h', 768);
      restores.push(
        patchGetDefaultDisplay(async (): Promise<DefaultDisplayLike> => {
          return { densityDPI: 213 };
        })
      );

      // Verify fractional scales are rounded predictably.
      const screenSize = await getScreenSize();

      expect(screenSize.width).assertEqual(1280);
      expect(screenSize.height).assertEqual(719);
      expect(screenSize.pageW).assertEqual(1366);
      expect(screenSize.pageH).assertEqual(768);
      expect(screenSize.dpi).assertEqual(1.331);
      expect(screenSize.lpi).assertEqual(1.067);
    });
  });
}
