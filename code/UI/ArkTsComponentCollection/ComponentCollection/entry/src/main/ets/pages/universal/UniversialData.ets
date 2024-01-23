/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import { SecondLevelCategory, ThirdLevelCategory } from '../../model/CategoricalDataType';
import pointer from '@ohos.multimodalInput.pointer';

export interface ResourceObjectType {
  value: Resource
}

export interface PointerStyleName {
  key: string
  value: pointer.PointerStyle
}

const GRAPHIC_TRANSFORMATION: ThirdLevelCategory[] =
  [
    {
      image: $r('app.media.ic_prop_background'),
      title: $r('app.string.prop_foreground'),
      url: 'pages/universal/properties/foregroundSample/ForegroundSample'
    },
    {
      image: $r('app.media.ic_prop_background'),
      title: $r('app.string.prop_background'),
      url: 'pages/universal/properties/backgroundSample/BackgroundSample'
    },
    {
      image: $r('app.media.ic_prop_border'),
      title: $r('app.string.prop_border'),
      url: 'pages/universal/properties/borderSample/BorderSample'
    },
    {
      image: $r('app.media.ic_prop_border'),
      title: $r('app.string.prop_outline'),
      url: 'pages/universal/properties/outlineSample/OutlineSample'
    },
    {
      image: $r('app.media.ic_prop_font'),
      title: $r('app.string.prop_font'),
      url: 'pages/universal/properties/fontSample/FontSample'
    },
    {
      image: $r('app.media.ic_prop_size'),
      title: $r('app.string.prop_size'),
      url: 'pages/universal/properties/sizeSample/SizeSample'
    },
    {
      image: $r('app.media.ic_graphic_transformation'),
      title: $r('app.string.graphic_transformation'),
      childNodes: [
        {
          title: $r('app.string.graphic_transformation_rotate'),
          url: 'pages/universal/properties/rotateSample/RotateSample'
        },
        {
          title: $r('app.string.graphic_transformation_translate'),
          url: 'pages/universal/properties/translateSample/TranslateSample'
        },
        {
          title: $r('app.string.scale'),
          url: 'pages/universal/properties/scaleSample/ScaleSample'
        },
        {
          title: $r('app.string.transform'),
          url: 'pages/universal/properties/transformSample/TransformSample'
        }
      ]
    },
    {
      image: $r('app.media.ic_display'),
      title: $r('app.string.components_display'),
      url: "pages/universal/properties/displaySample/DisplaySample"
    },
    {
      image: $r('app.media.ic_interaction'),
      title: $r('app.string.components_interaction'),
      url: "pages/universal/properties/interactionSample/InteractionSample"
    },
    {
      image: $r('app.media.ic_image_effects'),
      title: $r('app.string.components_effects'),
      url: "pages/universal/properties/effectsSample/EffectsSample"
    },
    {
      image: $r('app.media.ic_properties_location'),
      title: $r('app.string.location_settings'),
      url: "pages/universal/properties/locationSample/LocationSample"
    },
    {
      image: $r('app.media.ic_properties_constraint'),
      title: $r('app.string.layout_constrain'),
      url: "pages/universal/properties/layoutConstraintSample/LayoutConstraintSample"
    },
    {
      image: $r('app.media.ic_properties_flex'),
      title: $r('app.string.flex'),
      url: "pages/universal/properties/flexSample/FlexSample"
    },
    {
      image: $r('app.media.ic_properties_border'),
      title: $r('app.string.picture_border'),
      url: "pages/universal/properties/pictureBorderSample/PictureBorderSample"
    },
    {
      image: $r('app.media.ic_shape_crop'),
      title: $r('app.string.shape_crop'),
      url: "pages/universal/properties/shapeCropSample/ShapeCropSample"
    },
    {
      image: $r('app.media.ic_grid_setting'),
      title: $r('app.string.grid_settings'),
      url: "pages/universal/properties/gridSettingsSample/GridSettingsSample"
    },
    {
      image: $r('app.media.ic_focus'),
      title: $r('app.string.focus_control'),
      url: "pages/universal/properties/focusControlSample/FocusControlSample"
    },
    {
      image: $r('app.media.ic_component_id'),
      title: $r('app.string.component_id'),
      url: "pages/universal/properties/componentIDSample/ComponentIDSample"
    },
    {
      image: $r('app.media.ic_component_blurr'),
      title: $r('app.string.component_blurred'),
      url: "pages/universal/properties/componentBlurredSample/ComponentBlurredSample"
    },
    {
      image: $r('app.media.ic_restore_id'),
      title: $r('app.string.restore_id'),
      url: "pages/universal/properties/restoreIdSample/RestoreIdSample"
    },
    {
      image: $r('app.media.ic_prop_background'),
      title: $r('app.string.safe_area'),
      url: 'pages/universal/properties/safeAreaSample/SafeAreaSample'
    },
    {
      image: $r('app.media.ic_screenshot_arbitrarygraphics'),
      title: $r('app.string.attribute_modifier'),
      url: 'pages/universal/properties/attributeModifierSample/AttributeModifierSample'
    }
  ];

const COMMON_EVENTS: ThirdLevelCategory[] =
  [
    {
      image: $r('app.media.ic_click_event'),
      title: $r('app.string.click_event'),
      url: 'pages/universal/events/clickEventSample/ClickEventSample'
    },
    {
      image: $r('app.media.ic_event_touch'),
      title: $r('app.string.touch_event'),
      url: 'pages/universal/events/touchEventSample/TouchEventSample'
    },
    {
      image: $r('app.media.ic_event_drag'),
      title: $r('app.string.drag_drop_event'),
      url: 'pages/universal/events/dragEventSample/DragEventSample'
    },
    {
      image: $r('app.media.ic_event_area_change'),
      title: $r('app.string.component_area_change_event'),
      url: 'pages/universal/events/areaChangeEventSample/AreaChangeEventSample'
    },
    {
      image: $r('app.media.ic_mount_event'),
      title: $r('app.string.general_mount'),
      url: 'pages/universal/events/mountUnmountEventSample/MountUnmountEventSample'
    },
    {
      image: $r('app.media.ic_focus_event'),
      title: $r('app.string.focus_event'),
      url: 'pages/universal/events/focusEventSample/FocusEventSample'
    },
    {
      image: $r('app.media.ic_key_press'),
      title: $r('app.string.keyPress_event'),
      url: 'pages/universal/events/keyPressEventSample/KeyPressEventSample'
    },
    {
      image: $r('app.media.ic_mouse_event'),
      title: $r('app.string.mouse_event'),
      url: 'pages/universal/events/mouseEventSample/MouseEventSample'
    },
    {
      image: $r('app.media.ic_scroll_event'),
      title: $r('app.string.scroll_event'),
      url: 'pages/universal/events/scrollEventSample/ScrollEventSample'
    },
    {
      image: $r('app.media.ic_gallery_free'),
      title: $r('app.string.custom_event'),
      url: 'pages/universal/events/customEventSample/CustomEventHome'
    }
  ];

const GESTURE: ThirdLevelCategory[] =
  [
    {
      image: $r('app.media.ic_click_event'),
      title: $r('app.string.bind_gesture_methods'),
      url: 'pages/universal/gesture/bindGestureSample/BindGestureSample'
    },
    {
      image: $r('app.media.ic_basic_gestures'),
      title: $r('app.string.basic_gestures'),
      childNodes: [
        {
          title: $r('app.string.tap_gesture'),
          url: 'pages/universal/gesture/tapGestureSample/TapGestureSample'
        },
        {
          title: $r('app.string.long_press_gesture'),
          url: 'pages/universal/gesture/longPressSample/LongPressSample'
        },
        {
          title: $r('app.string.pan_gesture'),
          url: 'pages/universal/gesture/panSample/PanSample'
        },
        {
          title: $r('app.string.pinch_gesture'),
          url: 'pages/universal/gesture/pinchSample/PinchSample'
        },
        {
          title: $r('app.string.rotation_gesture'),
          url: 'pages/universal/gesture/rotationSample/RotationSample'
        },
        {
          title: $r('app.string.swipe_gesture'),
          url: 'pages/universal/gesture/swipeSample/SwipeSample'
        }
      ]
    },
    {
      image: $r('app.media.ic_combined_gestures'),
      title: $r('app.string.combined_gestures'),
      url: 'pages/universal/gesture/combinedSample/CombinedSample'
    },
    {
      image: $r('app.media.ic_customGesture'),
      title: $r('app.string.custom_gesture'),
      url: 'pages/universal/gesture/customGesture/CustomGestureJudge'
    }
  ];

// Generic categorical data, second menu data
export const UNIVERSAL_CATEGORIES: SecondLevelCategory[] =
  [
    { title: $r('app.string.common_events'), childNodes: COMMON_EVENTS },
    { title: $r('app.string.common_properties'), childNodes: GRAPHIC_TRANSFORMATION },
    { title: $r('app.string.gesture_process'), childNodes: GESTURE }
  ];

// univesal/properties/DisplaySample
export let locationTypes: ResourceObjectType[] =
  [
    { value: $r('app.string.components_display_center') },
    { value: $r('app.string.components_display_topstart') },
    { value: $r('app.string.components_display_topend') },
    { value: $r('app.string.components_display_top') },
    { value: $r('app.string.components_display_start') },
    { value: $r('app.string.components_display_end') },
    { value: $r('app.string.components_display_bottomstart') },
    { value: $r('app.string.components_display_bottom') },
    { value: $r('app.string.components_display_bottomend') }
  ];

export let visibileTypes: ResourceObjectType[] =
  [
    { value: $r('app.string.components_display_visible') },
    { value: $r('app.string.components_display_hidden') },
    { value: $r('app.string.components_display_none') },
  ];

// univesal/properties/InteractionSample
export let placementsNameData = ['TopLeft', 'Top', 'TopRight', 'RightTop', 'Right', 'RightBottom', 'LeftTop', 'Left', 'LeftBottom', 'BottomLeft', 'Bottom', 'BottomRight'];

export let hitTestModeNameData = ['Default', 'Block', 'Transparent', 'None'];

export let hoverEffectNameData = ['None', 'Highlight', 'Auto', 'Scale'];

export let pointerStyleNameData: PointerStyleName[] = [
  { key: 'DEFAULT', value: pointer.PointerStyle.DEFAULT },
  { key: 'EAST', value: pointer.PointerStyle.EAST },
  { key: 'WEST', value: pointer.PointerStyle.WEST },
  { key: 'SOUTH', value: pointer.PointerStyle.SOUTH },
  { key: 'NORTH', value: pointer.PointerStyle.NORTH },
  { key: 'WEST_EAST', value: pointer.PointerStyle.WEST_EAST },
  { key: 'NORTH_SOUTH', value: pointer.PointerStyle.NORTH_SOUTH },
  { key: 'NORTH_EAST', value: pointer.PointerStyle.NORTH_EAST },
  { key: 'NORTH_WEST', value: pointer.PointerStyle.NORTH_WEST },
  { key: 'SOUTH_EAST', value: pointer.PointerStyle.SOUTH_EAST },
  { key: 'SOUTH_WEST', value: pointer.PointerStyle.SOUTH_WEST },
  { key: 'NORTH_EAST_SOUTH_WEST', value: pointer.PointerStyle.NORTH_EAST_SOUTH_WEST },
  { key: 'NORTH_WEST_SOUTH_EAST', value: pointer.PointerStyle.NORTH_WEST_SOUTH_EAST },
  { key: 'CROSS', value: pointer.PointerStyle.CROSS },
  { key: 'CURSOR_COPY', value: pointer.PointerStyle.CURSOR_COPY },
  { key: 'CURSOR_FORBID', value: pointer.PointerStyle.CURSOR_FORBID },
  { key: 'COLOR_SUCKER', value: pointer.PointerStyle.COLOR_SUCKER },
  { key: 'HAND_GRABBING', value: pointer.PointerStyle.HAND_GRABBING },
  { key: 'HAND_OPEN', value: pointer.PointerStyle.HAND_OPEN },
  { key: 'HAND_POINTING', value: pointer.PointerStyle.HAND_POINTING },
  { key: 'HELP', value: pointer.PointerStyle.HELP },
  { key: 'MOVE', value: pointer.PointerStyle.MOVE },
  { key: 'RESIZE_LEFT_RIGHT', value: pointer.PointerStyle.RESIZE_LEFT_RIGHT },
  { key: 'RESIZE_UP_DOWN', value: pointer.PointerStyle.RESIZE_UP_DOWN },
  { key: 'SCREENSHOT_CHOOSE', value: pointer.PointerStyle.SCREENSHOT_CHOOSE },
  { key: 'SCREENSHOT_CURSOR', value: pointer.PointerStyle.SCREENSHOT_CURSOR },
  { key: 'TEXT_CURSOR', value: pointer.PointerStyle.TEXT_CURSOR },
  { key: 'ZOOM_IN', value: pointer.PointerStyle.ZOOM_IN },
  { key: 'ZOOM_OUT', value: pointer.PointerStyle.ZOOM_OUT },
  { key: 'MIDDLE_BTN_EAST', value: pointer.PointerStyle.MIDDLE_BTN_EAST },
  { key: 'MIDDLE_BTN_WEST', value: pointer.PointerStyle.MIDDLE_BTN_WEST },
  { key: 'MIDDLE_BTN_SOUTH', value: pointer.PointerStyle.MIDDLE_BTN_SOUTH },
  { key: 'MIDDLE_BTN_NORTH', value: pointer.PointerStyle.MIDDLE_BTN_NORTH },
  { key: 'MIDDLE_BTN_NORTH_SOUTH', value: pointer.PointerStyle.MIDDLE_BTN_NORTH_SOUTH },
  { key: 'MIDDLE_BTN_NORTH_EAST', value: pointer.PointerStyle.MIDDLE_BTN_NORTH_EAST },
  { key: 'MIDDLE_BTN_NORTH_WEST', value: pointer.PointerStyle.MIDDLE_BTN_NORTH_WEST },
  { key: 'MIDDLE_BTN_SOUTH_EAST', value: pointer.PointerStyle.MIDDLE_BTN_SOUTH_EAST },
  { key: 'MIDDLE_BTN_SOUTH_WEST', value: pointer.PointerStyle.MIDDLE_BTN_SOUTH_WEST },
  { key: 'MIDDLE_BTN_NORTH_SOUTH_WEST_EAST', value: pointer.PointerStyle.MIDDLE_BTN_NORTH_SOUTH_WEST_EAST }
];

export let selectImageSizeData: Resource[] = [$r('app.string.background_image_size_cover'), $r('app.string.background_image_size_contain')];

export let selectImageAlignmentData: Resource[] = [$r('app.string.background_image_position_top_start'), $r('app.string.background_image_position_top'), $r('app.string.background_image_position_top_end'), $r('app.string.background_image_position_start'), $r('app.string.background_image_position_center'), $r('app.string.background_image_position_end'), $r('app.string.background_image_position_bottom_start'), $r('app.string.background_image_position_bottom'), $r('app.string.background_image_position_bottom_end')];

export let selectBlurStyleColorModeData: Resource[] = [$r('app.string.blur_style_system'), $r('app.string.blur_style_light'), $r('app.string.blur_style_dark')];

export let selectBlurStyleAdaptiveColorData: Resource[] = [$r('app.string.blur_style_default'), $r('app.string.blur_style_average')];

export let selectShadowTypeData: Resource[] = [$r('app.string.shadow_type_color'), $r('app.string.shadow_type_blur')];
