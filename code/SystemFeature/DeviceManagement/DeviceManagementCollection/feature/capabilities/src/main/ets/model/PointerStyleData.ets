/*
 * Copyright (c) 2023 Fujian Newland Auto-ID Tech.Co.,Ltd.
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
import pointer from '@ohos.multimodalInput.pointer'
import { getString } from '@ohos/common/src/main/ets/util/ResourceUtil';
/**
 * 鼠标指针样式
 */
export class PointerStyleData {
  icon: Resource | string = '';
  name: string = '';
  style: pointer.PointerStyle = pointer.PointerStyle.DEFAULT
}

export let pointerStyleArr: PointerStyleData[] = [
  {
    icon: $r('app.media.icon_mouse_default'),
    name: getString($r('app.string.mouse_style_default')),
    style: pointer.PointerStyle.DEFAULT
  },
  {
    icon: $r('app.media.icon_mouse_east'),
    name: getString($r('app.string.mouse_style_east')),
    style: pointer.PointerStyle.EAST
  },
  {
    icon: $r('app.media.icon_mouse_west'),
    name: getString($r('app.string.mouse_style_west')),
    style: pointer.PointerStyle.WEST
  },
  {
    icon: $r('app.media.icon_mouse_south'),
    name: getString($r('app.string.mouse_style_south')),
    style: pointer.PointerStyle.SOUTH
  },
  {
    icon: $r('app.media.icon_mouse_north'),
    name: getString($r('app.string.mouse_style_north')),
    style: pointer.PointerStyle.NORTH
  },
  {
    icon: $r('app.media.icon_mouse_west_east'),
    name: getString($r('app.string.mouse_style_west_east')),
    style: pointer.PointerStyle.WEST_EAST
  },
  {
    icon: $r('app.media.icon_mouse_north_south'),
    name: getString($r('app.string.mouse_style_north_south')),
    style: pointer.PointerStyle.NORTH_SOUTH
  },
  {
    icon: $r('app.media.icon_mouse_north_east'),
    name: getString($r('app.string.mouse_style_north_east')),
    style: pointer.PointerStyle.NORTH_EAST
  },
  {
    icon: $r('app.media.icon_mouse_north_west'),
    name: getString($r('app.string.mouse_style_north_west')),
    style: pointer.PointerStyle.NORTH_WEST
  },
  {
    icon: $r('app.media.icon_mouse_south_east'),
    name: getString($r('app.string.mouse_style_south_east')),
    style: pointer.PointerStyle.SOUTH_EAST
  },
  {
    icon: $r('app.media.icon_mouse_south_west'),
    name: getString($r('app.string.mouse_style_south_west')),
    style: pointer.PointerStyle.SOUTH_WEST
  },
  {
    icon: $r('app.media.icon_mouse_north_east_south_west'),
    name: getString($r('app.string.mouse_style_north_east_south_west')),
    style: pointer.PointerStyle.NORTH_EAST_SOUTH_WEST
  },
  {
    icon: $r('app.media.icon_mouse_north_west_south_east'),
    name: getString($r('app.string.mouse_style_north_west_south_east')),
    style: pointer.PointerStyle.NORTH_WEST_SOUTH_EAST
  },
  {
    icon: $r('app.media.icon_mouse_cross'),
    name: getString($r('app.string.mouse_style_cross')),
    style: pointer.PointerStyle.CROSS
  },
  {
    icon: $r('app.media.icon_mouse_copy'),
    name: getString($r('app.string.mouse_style_copy')),
    style: pointer.PointerStyle.CURSOR_COPY
  },
  {
    icon: $r('app.media.icon_mouse_forbid'),
    name: getString($r('app.string.mouse_style_forbid')),
    style: pointer.PointerStyle.CURSOR_FORBID
  },
  {
    icon: $r('app.media.icon_mouse_color_sucker'),
    name: getString($r('app.string.mouse_style_color_sucker')),
    style: pointer.PointerStyle.COLOR_SUCKER
  },
  {
    icon: $r('app.media.icon_mouse_hand_grabbing'),
    name: getString($r('app.string.mouse_style_hand_grabbing')),
    style: pointer.PointerStyle.HAND_GRABBING
  },
  {
    icon: $r('app.media.icon_mouse_hand_open'),
    name: getString($r('app.string.mouse_style_hand_open')),
    style: pointer.PointerStyle.HAND_OPEN
  },
  {
    icon: $r('app.media.icon_mouse_hand_pointing'),
    name: getString($r('app.string.mouse_style_hand_pointing')),
    style: pointer.PointerStyle.HAND_POINTING
  },
  {
    icon: $r('app.media.icon_mouse_help'),
    name: getString($r('app.string.mouse_style_help')),
    style: pointer.PointerStyle.HELP
  },
  {
    icon: $r('app.media.icon_mouse_move'),
    name: getString($r('app.string.mouse_style_move')),
    style: pointer.PointerStyle.MOVE
  },
  {
    icon: $r('app.media.icon_mouse_resize_left_right'),
    name: getString($r('app.string.mouse_style_resize_left_right')),
    style: pointer.PointerStyle.RESIZE_LEFT_RIGHT
  },
  {
    icon: $r('app.media.icon_mouse_resize_up_down'),
    name: getString($r('app.string.mouse_style_resize_up_down')),
    style: pointer.PointerStyle.RESIZE_UP_DOWN
  },
  {
    icon: $r("app.media.icon_mouse_screenshot_choose"),
    name: getString($r('app.string.mouse_style_screenshot_choose')),
    style: pointer.PointerStyle.SCREENSHOT_CHOOSE
  },
  {
    icon: $r('app.media.icon_mouse_screenshot_cursor'),
    name: getString($r('app.string.mouse_style_screenshot_cursor')),
    style: pointer.PointerStyle.SCREENSHOT_CURSOR
  },
  {
    icon: $r('app.media.icon_mouse_text_cursor'),
    name: getString($r('app.string.mouse_style_text_cursor')),
    style: pointer.PointerStyle.TEXT_CURSOR
  },
  {
    icon: $r('app.media.icon_mouse_zoom_in'),
    name: getString($r('app.string.mouse_style_zoom_in')),
    style: pointer.PointerStyle.ZOOM_IN
  },
  {
    icon: $r('app.media.icon_mouse_zoom_out'),
    name: getString($r('app.string.mouse_style_zoom_out')),
    style: pointer.PointerStyle.ZOOM_OUT
  },
  {
    icon: $r('app.media.icon_mouse_mid_btn_east'),
    name: getString($r('app.string.mouse_style_mid_btn_east')),
    style: pointer.PointerStyle.MIDDLE_BTN_EAST
  },
  {
    icon: $r('app.media.icon_mouse_mid_btn_west'),
    name: getString($r('app.string.mouse_style_mid_btn_west')),
    style: pointer.PointerStyle.MIDDLE_BTN_WEST
  },
  {
    icon: $r('app.media.icon_mouse_mid_btn_south'),
    name: getString($r('app.string.mouse_style_mid_btn_south')),
    style: pointer.PointerStyle.MIDDLE_BTN_SOUTH
  },
  {
    icon: $r('app.media.icon_mouse_mid_btn_north'),
    name: getString($r('app.string.mouse_style_mid_btn_north')),
    style: pointer.PointerStyle.MIDDLE_BTN_NORTH
  },
  {
    icon: $r('app.media.icon_mouse_mid_btn_north_south'),
    name: getString($r('app.string.mouse_style_mid_btn_north_south')),
    style: pointer.PointerStyle.MIDDLE_BTN_NORTH_SOUTH
  },
  {
    icon: $r('app.media.icon_mouse_mid_btn_north_east'),
    name: getString($r('app.string.mouse_style_mid_btn_north_east')),
    style: pointer.PointerStyle.MIDDLE_BTN_NORTH_EAST
  },
  {
    icon: $r('app.media.icon_mouse_mid_btn_north_west'),
    name: getString($r('app.string.mouse_style_mid_btn_north_west')),
    style: pointer.PointerStyle.MIDDLE_BTN_NORTH_WEST
  },
  {
    icon: $r('app.media.icon_mouse_mid_btn_south_east'),
    name: getString($r('app.string.mouse_style_mid_btn_south_east')),
    style: pointer.PointerStyle.MIDDLE_BTN_SOUTH_EAST
  },
  {
    icon: $r('app.media.icon_mouse_mid_btn_south_west'),
    name: getString($r('app.string.mouse_style_mid_btn_south_west')),
    style: pointer.PointerStyle.MIDDLE_BTN_SOUTH_WEST
  },
  {
    icon: $r('app.media.icon_mouse_mid_btn_north_south_west_east'),
    name: getString($r('app.string.mouse_style_mid_btn_north_south_west_east')),
    style: pointer.PointerStyle.MIDDLE_BTN_NORTH_SOUTH_WEST_EAST
  },
]