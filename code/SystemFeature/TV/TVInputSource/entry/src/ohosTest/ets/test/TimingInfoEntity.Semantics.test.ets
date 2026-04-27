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
import { TimingInfoEntity } from '../../../main/ets/entity/TimingInfoEntity';

/**
 * Validates constructor defaults, setter/getter consistency, width/height
 * independence, frame-rate and interlace field semantics, and boundary
 * conditions for TimingInfoEntity.
 *
 * Business context: TimingInfoEntity encapsulates the physical video timing
 * parameters reported by the TV display subsystem via displaySetting. These
 * values drive the signal-quality indicator, HDMI mode badge, and video-info
 * overlay shown to the user. Key fields:
 *   _width      鈥?horizontal pixel count (e.g. 1920 for FHD)
 *   _height     鈥?vertical pixel count (e.g. 1080 for FHD)
 *   _frameRate  鈥?refresh rate in Hz (e.g. 60 for NTSC, 50 for PAL)
 *   _isInterlace 鈥?true for interlaced signals (1080i) vs progressive (1080p)
 *
 * Design rationale: Each field represents an independent physical dimension.
 * Changing width must not silently alter height or frameRate. The entity
 * intentionally lacks @Observed (unlike SourcePlugStateEntity) because it is
 * used as a snapshot value-object rather than a live UI-bound state carrier.
 */
export default function TimingInfoEntitySemanticsTest(): void {
  describe('TimingInfoEntity_constructor_defaults', () => {
    it('should_initialize_all_fields_to_zero', 0, () => {
      const timing = new TimingInfoEntity();
      expect(timing.getWidth()).assertEqual(0);
      expect(timing.getHeight()).assertEqual(0);
      expect(timing.getFrameRate()).assertEqual(0);
      expect(timing.getIsInterlace()).assertEqual(false);
    });

    it('should_allow_default_construction_without_parameters', 0, () => {
      const timing = new TimingInfoEntity();
      expect(timing instanceof TimingInfoEntity).assertEqual(true);
    });
  });

  describe('TimingInfoEntity_width_height_independence', () => {
    it('should_update_width_without_affecting_height', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setWidth(1920);
      expect(timing.getWidth()).assertEqual(1920);
      expect(timing.getHeight()).assertEqual(0);
      expect(timing.getFrameRate()).assertEqual(0);
      expect(timing.getIsInterlace()).assertEqual(false);
    });

    it('should_update_height_without_affecting_width', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setHeight(1080);
      expect(timing.getHeight()).assertEqual(1080);
      expect(timing.getWidth()).assertEqual(0);
      expect(timing.getFrameRate()).assertEqual(0);
      expect(timing.getIsInterlace()).assertEqual(false);
    });

    it('should_allow_setting_width_and_height_together', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setWidth(1280);
      timing.setHeight(720);
      expect(timing.getWidth()).assertEqual(1280);
      expect(timing.getHeight()).assertEqual(720);
    });

    it('should_toggle_resolution_without_impact_on_interlace_flag', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setIsInterlace(true);
      timing.setWidth(1920);
      timing.setHeight(1080);
      expect(timing.getIsInterlace()).assertEqual(true);
    });
  });

  describe('TimingInfoEntity_framerate_independence', () => {
    it('should_update_framerate_without_affecting_dimensions', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setWidth(1920);
      timing.setHeight(1080);
      timing.setFrameRate(60);
      expect(timing.getFrameRate()).assertEqual(60);
      expect(timing.getWidth()).assertEqual(1920);
      expect(timing.getHeight()).assertEqual(1080);
    });

    it('should_toggle_interlace_without_affecting_framerate', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setFrameRate(50);
      timing.setIsInterlace(true);
      expect(timing.getIsInterlace()).assertEqual(true);
      expect(timing.getFrameRate()).assertEqual(50);
    });
  });

  describe('TimingInfoEntity_standard_video_timings', () => {
    it('should_support_sd_ntsc_720x480', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setWidth(720);
      timing.setHeight(480);
      timing.setFrameRate(30);
      expect(timing.getWidth()).assertEqual(720);
      expect(timing.getHeight()).assertEqual(480);
      expect(timing.getFrameRate()).assertEqual(30);
    });

    it('should_support_sd_pal_720x576', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setWidth(720);
      timing.setHeight(576);
      timing.setFrameRate(25);
      expect(timing.getWidth()).assertEqual(720);
      expect(timing.getHeight()).assertEqual(576);
      expect(timing.getFrameRate()).assertEqual(25);
    });

    it('should_support_hd_720p_1280x720', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setWidth(1280);
      timing.setHeight(720);
      timing.setFrameRate(60);
      expect(timing.getWidth()).assertEqual(1280);
      expect(timing.getHeight()).assertEqual(720);
      expect(timing.getFrameRate()).assertEqual(60);
    });

    it('should_support_fhd_1080p_1920x1080_progressive', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setWidth(1920);
      timing.setHeight(1080);
      timing.setFrameRate(60);
      timing.setIsInterlace(false);
      expect(timing.getWidth()).assertEqual(1920);
      expect(timing.getHeight()).assertEqual(1080);
      expect(timing.getFrameRate()).assertEqual(60);
      expect(timing.getIsInterlace()).assertEqual(false);
    });

    it('should_support_fhd_1080i_1920x1080_interlaced', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setWidth(1920);
      timing.setHeight(1080);
      timing.setFrameRate(30);
      timing.setIsInterlace(true);
      expect(timing.getWidth()).assertEqual(1920);
      expect(timing.getHeight()).assertEqual(1080);
      expect(timing.getFrameRate()).assertEqual(30);
      expect(timing.getIsInterlace()).assertEqual(true);
    });

    it('should_support_uhd_4k_3840x2160', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setWidth(3840);
      timing.setHeight(2160);
      timing.setFrameRate(60);
      timing.setIsInterlace(false);
      expect(timing.getWidth()).assertEqual(3840);
      expect(timing.getHeight()).assertEqual(2160);
      expect(timing.getFrameRate()).assertEqual(60);
      expect(timing.getIsInterlace()).assertEqual(false);
    });

    it('should_support_cinema_24fps', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setWidth(1920);
      timing.setHeight(1080);
      timing.setFrameRate(24);
      timing.setIsInterlace(false);
      expect(timing.getFrameRate()).assertEqual(24);
    });

    it('should_support_pal_50hz', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setWidth(1920);
      timing.setHeight(1080);
      timing.setFrameRate(50);
      expect(timing.getFrameRate()).assertEqual(50);
    });

    it('should_support_high_refresh_120hz', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setWidth(1920);
      timing.setHeight(1080);
      timing.setFrameRate(120);
      timing.setIsInterlace(false);
      expect(timing.getFrameRate()).assertEqual(120);
    });
  });

  describe('TimingInfoEntity_setter_getter_roundtrip', () => {
    it('should_roundtrip_width', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setWidth(1366);
      expect(timing.getWidth()).assertEqual(1366);
    });

    it('should_roundtrip_height', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setHeight(768);
      expect(timing.getHeight()).assertEqual(768);
    });

    it('should_roundtrip_framerate', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setFrameRate(144);
      expect(timing.getFrameRate()).assertEqual(144);
    });

    it('should_roundtrip_isInterlace_true', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setIsInterlace(true);
      expect(timing.getIsInterlace()).assertEqual(true);
    });

    it('should_roundtrip_isInterlace_false', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setIsInterlace(false);
      expect(timing.getIsInterlace()).assertEqual(false);
    });

    it('should_update_all_fields_sequentially_without_interference', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setWidth(2560);
      timing.setHeight(1440);
      timing.setFrameRate(144);
      timing.setIsInterlace(false);
      expect(timing.getWidth()).assertEqual(2560);
      expect(timing.getHeight()).assertEqual(1440);
      expect(timing.getFrameRate()).assertEqual(144);
      expect(timing.getIsInterlace()).assertEqual(false);
    });
  });

  describe('TimingInfoEntity_boundary_conditions', () => {
    it('should_handle_zero_width', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setWidth(0);
      expect(timing.getWidth()).assertEqual(0);
    });

    it('should_handle_zero_height', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setHeight(0);
      expect(timing.getHeight()).assertEqual(0);
    });

    it('should_handle_zero_framerate', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setFrameRate(0);
      expect(timing.getFrameRate()).assertEqual(0);
    });

    it('should_handle_negative_dimensions_if_reported', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setWidth(-1);
      timing.setHeight(-1);
      expect(timing.getWidth()).assertEqual(-1);
      expect(timing.getHeight()).assertEqual(-1);
    });

    it('should_handle_negative_framerate_if_reported', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setFrameRate(-1);
      expect(timing.getFrameRate()).assertEqual(-1);
    });

    it('should_support_max_safe_integer_dimensions', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setWidth(2147483647);
      timing.setHeight(2147483647);
      expect(timing.getWidth()).assertEqual(2147483647);
      expect(timing.getHeight()).assertEqual(2147483647);
    });

    it('should_support_large_framerate', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setFrameRate(1000);
      expect(timing.getFrameRate()).assertEqual(1000);
    });
  });

  describe('TimingInfoEntity_interlace_semantics', () => {
    it('should_distinguish_interlaced_from_progressive_same_resolution', 0, () => {
      const interlaced = new TimingInfoEntity();
      interlaced.setWidth(1920);
      interlaced.setHeight(1080);
      interlaced.setFrameRate(30);
      interlaced.setIsInterlace(true);

      const progressive = new TimingInfoEntity();
      progressive.setWidth(1920);
      progressive.setHeight(1080);
      progressive.setFrameRate(60);
      progressive.setIsInterlace(false);

      expect(interlaced.getWidth()).assertEqual(progressive.getWidth());
      expect(interlaced.getHeight()).assertEqual(progressive.getHeight());
      expect(((interlaced.getIsInterlace()) === (progressive.getIsInterlace()))).assertFalse();
      expect(((interlaced.getFrameRate()) === (progressive.getFrameRate()))).assertFalse();
    });

    it('should_allow_toggling_interlace_flag_multiple_times', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setIsInterlace(false);
      expect(timing.getIsInterlace()).assertEqual(false);
      timing.setIsInterlace(true);
      expect(timing.getIsInterlace()).assertEqual(true);
      timing.setIsInterlace(false);
      expect(timing.getIsInterlace()).assertEqual(false);
    });
  });

  describe('TimingInfoEntity_instance_isolation', () => {
    it('should_isolate_multiple_instances_completely', 0, () => {
      const ntsc = new TimingInfoEntity();
      ntsc.setWidth(720);
      ntsc.setHeight(480);
      ntsc.setFrameRate(30);
      ntsc.setIsInterlace(false);

      const pal = new TimingInfoEntity();
      pal.setWidth(720);
      pal.setHeight(576);
      pal.setFrameRate(25);
      pal.setIsInterlace(false);

      const uhd = new TimingInfoEntity();
      uhd.setWidth(3840);
      uhd.setHeight(2160);
      uhd.setFrameRate(60);
      uhd.setIsInterlace(false);

      expect(ntsc.getWidth()).assertEqual(720);
      expect(ntsc.getHeight()).assertEqual(480);
      expect(ntsc.getFrameRate()).assertEqual(30);

      expect(pal.getWidth()).assertEqual(720);
      expect(pal.getHeight()).assertEqual(576);
      expect(pal.getFrameRate()).assertEqual(25);

      expect(uhd.getWidth()).assertEqual(3840);
      expect(uhd.getHeight()).assertEqual(2160);
      expect(uhd.getFrameRate()).assertEqual(60);

      ntsc.setWidth(1920);
      ntsc.setHeight(1080);
      ntsc.setFrameRate(1080);

      expect(ntsc.getWidth()).assertEqual(1920);
      expect(pal.getWidth()).assertEqual(720);
      expect(uhd.getWidth()).assertEqual(3840);
    });

    it('should_maintain_independent_state_after_cross_updates', 0, () => {
      const a = new TimingInfoEntity();
      a.setWidth(1280);
      a.setHeight(720);
      a.setFrameRate(60);

      const b = new TimingInfoEntity();
      b.setWidth(1920);
      b.setHeight(1080);
      b.setFrameRate(30);

      const aOriginalRate = a.getFrameRate();
      const bOriginalRate = b.getFrameRate();
      a.setFrameRate(bOriginalRate);
      b.setFrameRate(aOriginalRate);

      expect(a.getFrameRate()).assertEqual(30);
      expect(b.getFrameRate()).assertEqual(60);
    });
  });

  describe('TimingInfoEntity_semantic_contracts', () => {
    it('should_treat_interlace_flag_as_orthogonal_to_resolution', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setWidth(1920);
      timing.setHeight(1080);
      timing.setIsInterlace(true);
      expect(timing.getWidth()).assertEqual(1920);
      expect(timing.getHeight()).assertEqual(1080);
    });

    it('should_allow_unknown_resolution_without_violating_invariants', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setWidth(1366);
      timing.setHeight(768);
      expect(timing.getWidth() > 0 && timing.getHeight() > 0).assertEqual(true);
    });

    it('should_support_zero_dimensions_for_error_state', 0, () => {
      const timing = new TimingInfoEntity();
      timing.setWidth(0);
      timing.setHeight(0);
      timing.setFrameRate(0);
      expect(timing.getWidth()).assertEqual(0);
      expect(timing.getHeight()).assertEqual(0);
    });
  });
}

