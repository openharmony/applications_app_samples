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

import { describe, it, expect } from '@ohos/hypium';
import { buildProgramInfoPresentation } from '../../../main/ets/pages/ProgramInfo';

/**
 * Registers business-facing tests for DTV program banner presentation rules.
 *
 * @returns void.
 */
export default function ProgramInfoTest(): void {
  describe('ProgramInfo_real', () => {
    it('should_keep_complete_program_info_when_all_fields_are_available', 0, () => {
      const presentation = buildProgramInfoPresentation(
        88,
        'CCTV-1',
        '新闻联播',
        '天气预报',
        '2026-04-16 20:00'
      );

      // 鑺傜洰鏉℃槸鐢ㄦ埛鍒囧彴鍚庣殑绗竴瑙嗚鍙嶉锛屽畬鏁存暟鎹満鏅繀椤诲師鏍蜂繚鐣欙紝涓嶈兘琚厹搴曟枃妗堣鐩栥€?      // 杩欓噷鍚屾椂鏍￠獙棰戦亾鍙枫€侀閬撳悕銆佸綋鍓嶈妭鐩拰涓嬩釜鑺傜洰锛岄槻姝㈠彧淇濅綇鏌愪竴鍒楄€屽叾浣欏瓧娈甸€€鍖栥€?      expect(presentation.channelNoText).assertEqual('88');
      expect(presentation.channelNameText).assertEqual('CCTV-1');
      expect(presentation.currentProgramText).assertEqual('新闻联播');
      expect(presentation.nextProgramText).assertEqual('天气预报');
      expect(presentation.dateTimeText).assertEqual('2026-04-16 20:00');
    });

    it('should_fallback_to_safe_labels_when_program_info_is_missing', 0, () => {
      const presentation = buildProgramInfoPresentation(0, '', '', '', '');

      // DTV 鑺傜洰鍗曞瓨鍦ㄥ姞杞藉欢杩熸垨绌鸿〃鍦烘櫙锛岀粍浠跺繀椤荤粰鍑哄彲鐞嗚В鐨勫崰浣嶆枃鏈紝鑰屼笉鏄┖鐧藉尯鍩熴€?      // 杩欑鍏滃簳灏ゅ叾褰卞搷鏃犱俊鍙枫€佸垰鎼滃彴瀹屾垚鍜?EPG 灏氭湭鍒拌揪鐨勮竟鐣岃矾寰勩€?      expect(presentation.channelNoText).assertEqual('--');
      expect(presentation.channelNameText).assertEqual('未知频道');
      expect(presentation.currentProgramText).assertEqual('暂无节目信息');
      expect(presentation.nextProgramText).assertEqual('暂无后续节目');
      expect(presentation.dateTimeText).assertEqual('');
    });
  });
}

