/*
 * Copyright (c) 2023-2025 Huawei Device Co., Ltd.
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

export default class Constants {
  /**
   * FontWeight.borderRadius 700
   */
  public static readonly FONT_WEIGHT_LG: number = 700;

  /**
   * FontWeight.borderRadius 600
   */
  public static readonly FONT_WEIGHT_MD: number = 600;

  /**
   * FontWeight.borderRadius 500
   */
  public static readonly FONT_WEIGHT: number = 500;

  /**
   * FontWeight.borderRadius 50
   */
  public static readonly FONT_WEIGHT_SM: number = 50;

  /**
   * Click on the list of tips/history to go to the animation duration of the example page.
   */
  public static readonly TO_EXAMPLE_PAGE_DURATION: number = 20;

  /**
   * Device size
   */
  public static readonly DEFAULT_DEVICE_SIZE: number = 600;

  /**
   * BorderRadius
   */
  public static readonly BORDER_RADIUS: number = 24;

  /**
   * Detail height
   */
  public static readonly DETAIL_HEIGHT: number = 72;

  /**
   * List space.
   */
  public static readonly LIST_SPACE: number = 72;

  /**
   * Half opacity
   */
  public static readonly HALF_OPACITY: number = 0.5;

  /**
   * Maximum number of input characters
   */
  public static readonly PHONE_NUMBER_LENGTH = 11;

  /**
   * The animation duration is 300 ms
   */
  public static readonly EFFECT_DURATION = 300;

  /**
   * The animation duration is 400 ms
   */
  public static readonly EFFECT_DURATION_FOUR = 400;

  /**
   * Spacing of child elementsconst 10
   */
  public static readonly SPACE_TEN = 10;

  /**
   * Spacing of child elementsconst 15
   */
  public static readonly SPACE_FIFTEEN = 15;

  /**
   * Spacing of child elementsconst 30
   */
  public static readonly SPACE_THIRTY = 30;

  /**
   * Spacing of child elements
   */
  public static readonly SPACE_TWENTY = 20;

  /**
   * FontWeight.seventy
   */
  public static readonly FONT_WEIGHT_SEVENTY = 70;

  /**
   * FontWeight.twenty
   */
  public static readonly FONT_WEIGHT_NORMAL = 20;

  /**
   * Default status height
   */
  public static readonly DEFAULT_STATUS_HEIGHT: number = 32;

  /**
   * Default text max line
   */
  public static readonly DEFAULT_TEXT_LINE: number = 2;

  /**
   * Default row height * 2
   */
  public static readonly DEFAULT_ROW_HEIGHT: number = 168;

  /**
   * Default row spacing of waterfall flow
   */
  public static readonly DEFAULT_ROW_SPACING_WATERFALL: number = 8;

  /**
   * Default number 0
   */
  public static readonly DEFAULT_ZERO: number = 0;

  /**
   * Default number 1
   */
  public static readonly DEFAULT_ONE: number = 1;

  /**
   * Default number -1
   */
  public static readonly DEFAULT_NEGATIVE_ONE: number = -1;

  /**
   * None of the opacity
   */
  public static readonly NONE_OPACITY: number = 0;

  /**
   * Click to search for the duration of the animation
   */
  public static readonly CLICK_SEARCH_ANIMATION_DURATION: number = 100;

  /**
   * Transition animation duration
   */
  public static readonly TRANSITION_ANIMATION_DURATION: number = 200;

  /**
   * Search history content animation duration
   */
  public static readonly SEARCH_HISTORY_ANIMATION_DURATION: number = 350;

  /**
   * Animation delay 150
   */
  public static readonly ANIMATION_DELAY: number = 150;

  /**
   * Animation delay 100
   */
  public static readonly ANIMATION_DELAY_ONE: number = 100;

  /**
   * Parameter velocity for generating the animation curve from 0 to 1
   */
  public static readonly ANIMATION_CURVE_VELOCITY: number = 0;

  /**
   * Parameter mass for generating the animation curve from 0 to 1
   */
  public static readonly ANIMATION_CURVE_MASS: number = 1;

  /**
   * Parameter stiffness for generating the animation curve from 0 to 1
   */
  public static readonly ANIMATION_CURVE_STIFFNESS: number = 342;

  /**
   * Parameter damping for generating the animation curve from 0 to 1
   */
  public static readonly ANIMATION_CURVE_DAMPING: number = 38;

  /**
   * Constructs a third-order Bezier curve X1
   */
  public static readonly ANIMATION_CURVE_X1: number = 0.33;

  /**
   * Constructs a third-order Bezier curve Y1
   */
  public static readonly ANIMATION_CURVE_Y1: number = 0;

  /**
   * Constructs a third-order Bezier curve X2
   */
  public static readonly ANIMATION_CURVE_X2: number = 0.67;

  /**
   * Constructs a third-order Bezier curve Y2
   */
  public static readonly ANIMATION_CURVE_Y2: number = 1;

  /**
   * Creates a translate transition effect.
   */
  public static readonly TRANSITION_EFFECT_Y: number = 30;

  /**
   * Creates an opacity transition effect with alpha value
   */
  public static readonly TRANSITION_OPACITY: number = 0;

  /**
   * Width of the top search box
   */
  public static readonly TOP_SEARCH_WIDTH: number = 24;

  /**
   * Width of the search
   */
  public static readonly SEARCH_WIDTH: number = 80;

  /**
   * 0.9 of the opacity
   */
  public static readonly ZERO_NINE_OPACITY: number = 0.9;

  /**
   * Font family HeiTi
   */
  public static readonly HARMONY_HEI_TI_FONT_FAMILY = 'HarmonyHeiTi';

  /**
   * Font family Medium
   */
  public static readonly HARMONY_HEITI_MEDIUM_FONT_FAMILY = 'HarmonyHeiTi-Medium';

  /**
   * Font family Bold
   */
  public static readonly HARMONY_HEITI_BOLD_FONT_FAMILY = 'HarmonyHeiTi-Bold';

  /**
   * Columns template 1fr 1fr
   */
  public static readonly COLUMNS_TEMPLATE = '1fr 1fr';

  /**
   * Columns template 1fr
   */
  public static readonly COLUMNS_TEMPLATE_ONE = '1fr';

  /**
   * Full percent.
   */
  public static readonly FULL_PERCENT: string = '100%';

  /**
   * Eighty percent.
   */
  public static readonly EIGHTY_PERCENT: string = '80%';

  /**
   * Ten percent.
   */
  public static readonly TEN_PERCENT: string = '10%';

  /**
   * Ninety Four percent.
   */
  public static readonly NINETY_FOUR_PERCENT: string = '94%';

  /**
   * Animation Duration.
   */
  public static readonly ANIMATE_DURATION: number = 200;

  /**
   * Minimum Animation Duration.
   */
  public static readonly ANIMATE_DURATION_MIN: number = 100;

  /**
   * Card Minimum Animation Duration.
   */
  public static readonly CARD_ANIMATE_DURATION_MIN: number = 5;

  /**
   * zIndex Large.
   */
  public static readonly Z_INDEX_LARGE: number = 2;

  /**
   * zIndex Medium.
   */
  public static readonly Z_INDEX_MEDIUM: number = 1;

  /**
   * zIndex Small.
   */
  public static readonly Z_INDEX_SMALL: number = 0;

  /**
   * Vertical spacing between elements in a vertical layout.
   */
  public static readonly CARD_LIST_SPACE: number = 2;

  /**
   * border radius 6
   */
  public static readonly BORDER_RADIUS_NORMAL: number = 6;

  /**
   * border radius 12
   */
  public static readonly BORDER_RADIUS_NORMAL_DOUBLE: number = 12;

  /**
   * border radius 30
   */
  public static readonly BORDER_RADIUS_NORMAL_MD: number = 30;

  /**
   * Circle width height
   */
  public static readonly CIRCLE_WIDTH_NORMAL: number = 6;

  /**
   * Circle width width
   */
  public static readonly CIRCLE_HEIGHT_NORMAL: number = 6;

  /**
   * averageCalories 26
   */
  public static readonly AVERAGE_CALORIES_ONE: number = 26;

  /**
   * averageCalories 60
   */
  public static readonly AVERAGE_CALORIES_TWO: number = 60;

  /**
   * averageCalories 606
   */
  public static readonly AVERAGE_CALORIES_THREE: number = 606;

  /**
   * averageCalories 56
   */
  public static readonly AVERAGE_CALORIES_FOUR: number = 56;

  /**
   * averageCalories 365
   */
  public static readonly AVERAGE_CALORIES_FIVE: number = 365;

  /**
   * strokeWidth
   */
  public static readonly STROKE_WIDTH: number = 24;
}