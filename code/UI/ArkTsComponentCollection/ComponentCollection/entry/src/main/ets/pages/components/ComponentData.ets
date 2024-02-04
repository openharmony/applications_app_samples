/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { ThirdLevelCategory } from '../../model/CategoricalDataType'

const AUXILIARY: ThirdLevelCategory =
  {
    image: $r('app.media.ic_auxiliary'),
    title: $r('app.string.auxiliary'),
    childNodes: [
      {
        title: $r('app.string.auxiliary_badge'),
        url: 'pages/components/auxiliary/badgeSample/BadgeSample'
      },
      {
        title: $r('app.string.scroll_bar'),
        url: 'pages/components/auxiliary/scrollbarSample/ScrollBarSample'
      },
      {
        title: $r('app.string.auxiliary_refresh'),
        url: 'pages/components/auxiliary/refreshSample/RefreshSample'
      },
      {
        title: $r('app.string.auxiliary_panel'),
        url: 'pages/components/auxiliary/panelSample/PanelSample'
      },
      {
        title: $r('app.string.auxiliary_alphabetIndexer'),
        url: 'pages/components/auxiliary/alphabetIndexerSample/AlphabetIndexerSample'
      }
    ]
  }

const CANVAS: ThirdLevelCategory =
  {
    image: $r('app.media.ic_pen'),
    title: $r('app.string.canvas_components'),
    childNodes: [
      {
        title: $r('app.string.canvas_component_attributes'),
        url: 'pages/components/canvas/attributesSample/AttributesSample'
      },
      {
        title: $r('app.string.canvas_component_method'),
        url: 'pages/components/canvas/methodsSample/MethodsSample',
      },
      {
        title: $r('app.string.canvas_component_shadow'),
        url: 'pages/components/canvas/shadowsSample/ShadowsSample',
      },
      {
        title: $r('app.string.canvas_component_transform'),
        url: 'pages/components/canvas/transformSample/TransformSample',
      },
      {
        title: $r('app.string.canvas_component_gradient'),
        url: 'pages/components/canvas/gradientSample/GradientSample',
      },
      {
        title: $r('app.string.canvas_component_path_2d'),
        url: 'pages/components/canvas/path2dSample/Path2dSample',
      },
      {
        title: $r('app.string.canvas_component_image_bitmap'),
        url: 'pages/components/canvas/imageBitmapSample/ImageBitmapSample',
      }
    ]
  }

const BUTTON_AND_SELECTION: ThirdLevelCategory =
  {
    image: $r('app.media.ic_button_and_selection'),
    title: $r('app.string.button_and_selection'),
    childNodes: [
      {
        title: $r('app.string.button_title'),
        url: 'pages/components/buttonAndSelection/buttonSample/ButtonSample'
      },
      {
        title: $r('app.string.date_picker_title'),
        url: 'pages/components/buttonAndSelection/datePickerSample/DatePickerSample'
      },
      {
        title: $r('app.string.radio_title'),
        url: 'pages/components/buttonAndSelection/radioSample/RadioSample'
      },
      {
        title: $r('app.string.select_title'),
        url: 'pages/components/buttonAndSelection/selectSample/SelectSample'
      },
      {
        title: $r('app.string.slider_title'),
        url: 'pages/components/buttonAndSelection/sliderSample/SliderSample'
      },
      {
        title: $r('app.string.toggle_title'),
        url: 'pages/components/buttonAndSelection/toggleSample/ToggleSample'
      },
      {
        title: $r('app.string.checkbox_checkboxgroup'),
        url: 'pages/components/buttonAndSelection/checkboxSample/CheckboxSample'
      },
      {
        title: $r('app.string.text_picker'),
        url: 'pages/components/buttonAndSelection/textPickerSample/TextPickerSample'
      },
      {
        title: $r('app.string.time_picker'),
        url: 'pages/components/buttonAndSelection/timePickerSample/TimePickerSample'
      },
      {
        title: $r('app.string.counter_name'),
        url: 'pages/components/buttonAndSelection/counterSample/CounterSample'
      },
      {
        title: $r('app.string.rating_name'),
        url: 'pages/components/buttonAndSelection/ratingSample/RatingSample'
      }
    ]
  }

const BLANK_AND_DIVIDER: ThirdLevelCategory =
  {
    image: $r('app.media.ic_blank_and_divider'),
    title: $r('app.string.blank_and_divider'),
    childNodes: [
      {
        title: $r('app.string.divider_title'),
        url: 'pages/components/blankAndDivider/dividerSample/DividerSample'
      }
    ]
  }

const INFORMATION_PRESENTATION_AND_DYNAMIC_EFFECTS: ThirdLevelCategory =
  {
    image: $r('app.media.ic_information_presentation_and_dynamic_effects'),
    title: $r('app.string.information_presentation_and_dynamic_effects'),
    childNodes: [
      {
        title: $r('app.string.qrcode_title'),
        url: 'pages/components/informationPresentationAndDynamicEffects/qrCodeSample/QRCodeSample'
      }, 
      {
        title: $r('app.string.loading_progress'),
        url: 'pages/components/informationPresentationAndDynamicEffects/loadingProgressSample/LoadingProgressSample'
      },
      {
        title: $r('app.string.marquee_name'),
        url: 'pages/components/informationPresentationAndDynamicEffects/marqueeSample/MarqueeSample'
      },
      {
        title: $r('app.string.text_timer'),
        url: 'pages/components/informationPresentationAndDynamicEffects/textTimerSample/TextTimerSample'
      },
      {
        title: $r('app.string.text_clock'),
        url: 'pages/components/informationPresentationAndDynamicEffects/textclockSample/TextClockSample'
      },
      {
        title: $r('app.string.progress_name'),
        url: 'pages/components/informationPresentationAndDynamicEffects/progressSample/ProgressSample'
      },
      {
        title: $r('app.string.gauge_name'),
        url: 'pages/components/informationPresentationAndDynamicEffects/gaugeSample/GaugeSample'
      },
      {
        title: $r('app.string.data_panel'),
        url: 'pages/components/informationPresentationAndDynamicEffects/dataPanelSample/DataPanelSample'
      },
      {
        title: $r('app.string.scroll_To_effect'),
        url: "pages/components/informationPresentationAndDynamicEffects/scrollToSample/ScrollToSample"
      },
      {
        title: $r('app.string.tabs_switch_effect'),
        url: "pages/components/informationPresentationAndDynamicEffects/tapsSwitchSample/TapsSwitchSample"
      },
      {
        title: $r('app.string.image_fit_Full_effect'),
        url: "pages/components/informationPresentationAndDynamicEffects/imageFitFullSample/ImageFitFullSample"
      },
      {
        title: $r('app.string.particle_effect'),
        url: "pages/components/informationPresentationAndDynamicEffects/particleSample/ParticleSample"
      },
      {
        title: $r('app.string.list'),
        url: 'pages/components/informationPresentationAndDynamicEffects/listSample/ListSample'
      }
    ]
  }

const TEXT_AND_INPUT: ThirdLevelCategory =
  {
    image: $r('app.media.ic_text_and_input'),
    title: $r('app.string.text_and_input'),
    childNodes: [
      {
        title: $r('app.string.image_span_title'),
        url: 'pages/components/textAndInput/imageSpanSample/ImageSpanSample'
      },
      {
        title: $r('app.string.span_title'),
        url: 'pages/components/textAndInput/spanSample/SpanSample'
      },
      {
        title: $r('app.string.text_input_title'),
        url: 'pages/components/textAndInput/textInputSample/TextInputSample',
      },
      {
        title: $r('app.string.text_title'),
        url: 'pages/components/textAndInput/textSample/TextSample'
      },
      {
        title: $r('app.string.rich_text'),
        url: 'pages/components/textAndInput/richTextSample/RichTextSample'
      },{
        title: $r('app.string.rich_editor'),
        url: 'pages/components/textAndInput/richEditorSample/RichEditorSample'
      }, {
        title: $r('app.string.textarea_title'),
        url: 'pages/components/textAndInput/textAreaSample/TextAreaSample'
    },{
        title: $r('app.string.patternlock_title'),
        url: 'pages/components/textAndInput/patternLockSample/PattternLockSample'
    },{
        title: $r('app.string.search_title'),
        url: 'pages/components/textAndInput/searchSample/SearchSample'
    }
    ]
  }

const SCOLL_SWIPE: ThirdLevelCategory =
  {
    image: $r('app.media.ic_blank_and_divider'),
    title: $r('app.string.scroll_swiper'),
    childNodes: [
      {
        title: $r('app.string.scroll_name'),
        url: 'pages/components/scrollAndSwipe/scrollSample/ScrollSample'
      },
      {
        title: $r('app.string.swiper_name'),
        url: 'pages/components/scrollAndSwipe/swiperSample/SwiperSample'
      }
    ]
  }

const ROWS_AND_COLUMNS: ThirdLevelCategory =
  {
    image: $r('app.media.ic_rows_and_columns'),
    title: $r('app.string.rows_and_columns'),
    childNodes: [
      {
        title: $r('app.string.row_title'),
        url: 'pages/components/rowsAndColumns/rowSample/RowSample'
      },
      {
        title: $r('app.string.rowsplit_title'),
        url: 'pages/components/rowsAndColumns/rowSplitSample/RowSplitSample'
      },
      {
        title: $r('app.string.column_title'),
        url: 'pages/components/rowsAndColumns/columnSample/ColumnSample'
      },
      {
        title: $r('app.string.columnsplit_title'),
        url: 'pages/components/rowsAndColumns/columnSplitSample/ColumnSplitSample'
      },
      {
        title: $r('app.string.sidebarcontainer_title'),
        url: 'pages/components/rowsAndColumns/sideBarContainerSample/SideBarContainerSample'
      }
    ]
  }

const STACK_FLEX_AND_GRID: ThirdLevelCategory =
  {
    image: $r('app.media.ic_stack_flex_and_grid'),
    title: $r('app.string.stack_flex_and_grid'),
    childNodes: [
      {
        title: $r('app.string.stack_title'),
        url: 'pages/components/stackFlexAndGrid/stackSample/StackSample'
      },
      {
        title: $r('app.string.flex_title'),
        url: 'pages/components/stackFlexAndGrid/flexSample/FlexSample'
      },
      {
        title: $r('app.string.gridcontainer_title'),
        url:'pages/components/stackFlexAndGrid/gridContainerSample/GridContainerSample'
      }
    ]
  }

const LIST_AND_GRID: ThirdLevelCategory =
  {
    image: $r('app.media.ic_list_and_grid'),
    title: $r('app.string.list_and_grid'),
    childNodes: [
      {
        title : $r('app.string.list_title'),
        url : 'pages/components/listAndGrid/listSample/ListSample'
      },
      {
        title: $r('app.string.list_item_title'),
        url: 'pages/components/listAndGrid/listItemSample/ListItemSample'
      },
      {
        title: $r('app.string.grid_title'),
        url : 'pages/components/listAndGrid/gridSample/GridSample'
      },
      {
        title: $r('app.string.grid_item_title'),
        url: 'pages/components/listAndGrid/gridItemSample/GridItemSample'
      },
      {
        title: $r('app.string.water_flow_title'),
        url: 'pages/components/listAndGrid/waterFlowSample/WaterFlowSample'
      }
    ]
  }

const NAVIGATION: ThirdLevelCategory =
  {
    image: $r('app.media.ic_navigation'),
    title: $r('app.string.navigation'),
    childNodes : [
      {
        title: $r('app.string.navigation_title'),
        url: 'pages/components/navigation/navigationSample/NavigationSample'
      },
      {
        title: $r('app.string.navigator_title'),
        url: 'pages/components/navigation/navigatorSample/NavigatorSample'
      },
      {
        title: $r('app.string.tabs_title'),
        url : "pages/components/navigation/tabSample/TabSample"
      },
      {
        title: $r('app.string.tab_content_title'),
        url: 'pages/components/navigation/tabContentSample/TabContentSample'
      },
      {
        title: $r('app.string.stepper_title'),
        url: "pages/components/navigation/stepperAndStepperItemSample/StepperAndStepperItemSample"
      },
      {
        title: $r('app.string.navRouter_title'),
        url: 'pages/components/navigation/navRouterSample/NavRouterSample'
      }
    ]
  }

const CANVAS_AND_GRAPHIC_DRAWING: ThirdLevelCategory =
  {
    image: $r('app.media.ic_canvas_and_graphic_drawing'),
    title: $r('app.string.canvas_and_graphic_drawing'),
    childNodes : [
      {
        title:$r('app.string.canvas_title'),
        url:'pages/components/canvasAndGraphicDrawing/canvasSample/CanvasSample'
      },
      {
        title:$r('app.string.circle_title'),
        url:'pages/components/canvasAndGraphicDrawing/circleSample/CircleSample'
      },
      {
        title:$r('app.string.ellipse_title'),
        url:'pages/components/canvasAndGraphicDrawing/ellipseSample/EllipseSample'
      },
      {
        title:$r('app.string.line_title'),
        url:'pages/components/canvasAndGraphicDrawing/lineSample/LineSample'
      },
      {
        title:$r('app.string.path_title'),
        url:'pages/components/canvasAndGraphicDrawing/pathSample/PathSample'
      },
      {
        title:$r('app.string.polygon_title'),
        url:'pages/components/canvasAndGraphicDrawing/polygonSample/PolygonSample'
      },
      {
        title:$r('app.string.polyline_title'),
        url:'pages/components/canvasAndGraphicDrawing/polylineSample/PolylineSample'
      },
      {
        title:$r('app.string.rect_title'),
        url:'pages/components/canvasAndGraphicDrawing/rectSample/RectSample'
      },
      {
        title:$r('app.string.shape_title'),
        url:'pages/components/canvasAndGraphicDrawing/shapeSample/ShapeSample'
      }
    ]
  }

const IMAGE_VIDEO_AND_MEDIA: ThirdLevelCategory =
  {
    image: $r('app.media.ic_image_video_media'),
    title: $r('app.string.image_video_and_media'),
    childNodes:[
      {
        title: $r('app.string.image_title'),
        url: 'pages/components/imageVideoAndMedia/imageSample/ImageSample'
      },
      {
        title: $r('app.string.image_animator_title'),
        url: 'pages/components/imageVideoAndMedia/imageAnimatorSample/ImageAnimatorSample'
      },
      {
        title: $r('app.string.video_title'),
        url: 'pages/components/imageVideoAndMedia/videoSample/VideoSample'
      },
      {
        title: $r('app.string.xcomponent_title'),
        url: 'pages/components/imageVideoAndMedia/xcomponentSample/XComponentSample'
      }
      ,{
        title: $r('app.string.plugin_component_title'),
        url: 'pages/components/imageVideoAndMedia/pluginComponentSample/PluginComponentSample'
      }
    ]
}
const WEB:ThirdLevelCategory =
  {
    image:$r('app.media.ic_web'),
    title:$r('app.string.web'),
    childNodes:[
      {
        title:$r('app.string.web_title'),
        url:'pages/components/web/webSample/WebSample'
      }
    ]
  }

export const COMPONENT_CATEGORIES: ThirdLevelCategory[] =
  [
    BLANK_AND_DIVIDER,
    BUTTON_AND_SELECTION,
    SCOLL_SWIPE,
    INFORMATION_PRESENTATION_AND_DYNAMIC_EFFECTS,
    TEXT_AND_INPUT,
    AUXILIARY,
    CANVAS,
    ROWS_AND_COLUMNS,
    STACK_FLEX_AND_GRID,
    LIST_AND_GRID,
    NAVIGATION,
    CANVAS_AND_GRAPHIC_DRAWING,
    IMAGE_VIDEO_AND_MEDIA,
    WEB
  ]
// 辅助/AlphabetIndexerSampleData
export let alphabetIndexerDataB: Resource[] = [$r('app.string.alphabetindexer_bu'), $r('app.string.alphabetindexer_bai'), $r('app.string.alphabetindexer_bao'), $r('app.string.alphabetindexer_bi'), $r('app.string.alphabetindexer_bing')]

export let alphabetIndexerDataC: Resource[] = [$r('app.string.alphabetindexer_cao'), $r('app.string.alphabetindexer_cheng'), $r('app.string.alphabetindexer_chen'), $r('app.string.alphabetindexer_cui')]

export let alphabetIndexerDataL: Resource[] = [$r('app.string.alphabetindexer_liu'), $r('app.string.alphabetindexer_li'), $r('app.string.alphabetindexer_lou'), $r('app.string.alphabetindexer_liang'), $r('app.string.alphabetindexer_lei'), $r('app.string.alphabetindexer_lv'), $r('app.string.alphabetindexer_liu3'), $r('app.string.alphabetindexer_lu')]

export let letterValue: string[] = ['#', 'A', 'B', 'C', 'D', 'E', 'F', 'G',
  'H', 'I', 'J', 'K', 'L', 'M', 'N',
  'O', 'P', 'Q', 'R', 'S', 'T', 'U',
  'V', 'W', 'X', 'Y', 'Z']
// 辅助&按钮与选择/panel&textPickerArrayData
export let fruitArray: Resource[] = [$r('app.string.checkbox_apple'), $r('app.string.checkbox_banbana'), $r('app.string.checkbox_cherries'), $r('app.string.checkbox_durian')]

// 信息展示与动效/dataPanelSample
export let panelData: number[] = [10, 10, 30, 10, 10, 20]
// 文本与输入/spanSelectData
export let selectData: Resource[] = [$r('app.string.span_decoration_none'), $r('app.string.span_decoration_linethrough'), $r('app.string.span_decoration_underline'), $r('app.string.span_decoration_overline')]
// 三级类别 Scroll 通用 left padding
export const LEFT_PADDING: number = 12
// 三级类别 Scroll 通用 right padding
export const RIGHT_PADDING: number = 12
// 行列与分栏/rowAlignItemsData
export const ROW_ALIGNITEMS_DATA: Resource[] = [$r('app.string.row_alignitems_top'), $r('app.string.row_alignitems_center'), $r('app.string.row_alignitems_bottom')]
// 行列与分栏/rowJustifyContentData
export const ROW_JUSTIFYCONTENT_DATA: Resource[] = [$r('app.string.row_justifycontent_start'), $r('app.string.row_justifycontent_center'), $r('app.string.row_justifycontent_end'),
$r('app.string.row_justifycontent_spacebetween'), $r('app.string.row_justifycontent_spacearound'), $r('app.string.row_justifycontent_spaceevenly')]
// 行列与分栏/columnAlignItemsData
export const COLUMN_ALIGNITEMS_DATA: Resource[] = [$r('app.string.column_alignitems_start'), $r('app.string.column_alignitems_center'), $r('app.string.column_alignitems_end')]
// 行列与分栏/columnJustifyContentData
export const COLUMN_JUSTIFYCONTENT_DATA: Resource[] = [$r('app.string.column_justifycontent_start'), $r('app.string.column_justifycontent_center'), $r('app.string.column_justifycontent_end'),
$r('app.string.column_justifycontent_spacebetween'), $r('app.string.column_justifycontent_spacearound'), $r('app.string.column_justifycontent_spaceevenly')]
// 行列与分栏/sidebarContainerTypeData
export const SBC_TYPE_DATA: Resource[] = [$r('app.string.sidebarcontainer_type_embed'), $r('app.string.sidebarcontainer_type_overlay')]
// 行列与分栏/sidebarContainerPositionData
export const SBC_POSITION_DATA: Resource[] = [$r('app.string.sidebarcontainer_sidebar_show_position_start'), $r('app.string.sidebarcontainer_sidebar_show_position_end')]
// 堆叠、Flex与栅格/stackArgsSelectData
export const STACK_ARGUMENTS_SELECT_DATA: Resource[] = [$r('app.string.stack_alignments_topstart'),$r('app.string.stack_alignments_top'),
$r('app.string.stack_alignments_topend'),$r('app.string.stack_alignments_start'),$r('app.string.stack_alignment_center'),$r('app.string.stack_alignment_end'),
$r('app.string.stack_alignments_bottomstart'),$r('app.string.stack_alignments_bottom'),$r('app.string.stack_alignments_bottomend')]
// 堆叠、Flex与栅格/stackZIndexSelectData
export const STACK_ZIND_SELECT_DATA: Resource[] = [$r('app.string.stack_zindex_four'),$r('app.string.stack_zindex_one')]
// 堆叠、Flex与栅格/flexDirectionSelectData
export const FLEX_DIRECTION_SELECT_DATA: Resource[] = [$r('app.string.flex_argument_direction_row'),$r('app.string.flex_argument_direction_row_reverse'),
$r('app.string.flex_argument_direction_column'),$r('app.string.flex_argument_direction_column_reverse')]
// 堆叠、Flex与栅格/flexWrapSelectData
export const FLEX_WRAP_SELECT_DATA : Resource[] = [$r('app.string.flex_argument_wrap_no_wrap'),$r('app.string.flex_argument_wrap_wrap'),$r('app.string.flex_argument_wrap_wrap_reverse')]
// 堆叠、Flex与栅格/flexJustifyContentSelectData
export const FLEX_JUSTIFY_CONTENT_SELECT_DATA : Resource[] = [$r('app.string.flex_argument_justifycontent_start'),$r('app.string.flex_argument_justifycontent_center'),$r('app.string.flex_argument_justifycontent_End'),
$r('app.string.flex_argument_justifycontent_space_between'),$r('app.string.flex_argument_justifycontent_space_around'),$r('app.string.flex_argument_justifycontent_speac_evenly')]
// 堆叠、Flex与栅格/flexAlignItemsSelectData
export const FLEX_ALIGN_ITEMS_SELECT_DATA : Resource[] = [$r('app.string.flex_argumen_alignItems_auto'),$r('app.string.flex_argumen_alignItems_start'),$r('app.string.flex_argumen_alignItems_center'),
$r('app.string.flex_argumen_alignItems_end'),$r('app.string.flex_argumen_alignItems_stretch'),$r('app.string.flex_argumen_alignItems_baseline')]
// 堆叠、Flex与栅格/gridContainerSizeTypeSelectData
export const GRIDCONTAIER_SIZE_TYPE_SELECT_DATA : Resource[] = [$r('app.string.gridcontainer_sizetype_xs'),$r('app.string.gridcontainer_sizetype_sm'),$r('app.string.gridcontainer_sizetype_md'),$r('app.string.gridcontainer_sizetype_lg'),$r('app.string.gridcontainer_sizetype_auto'),]
//图片、视频与媒体/imageSelectObjectFit
export const OBJECT_FIT_SELECT: Resource[] = [$r('app.string.object_fit_none'),$r('app.string.object_fit_cover'),$r('app.string.object_fit_contain'),$r('app.string.object_fit_fill'),$r('app.string.object_fit_scale_down'),$r('app.string.object_fit_auto')]
//图片、视频与媒体/imageSelectRenderMode
export const RENDER_MODE_SELECT: Resource[] = [$r('app.string.image_rendermode_original'),$r('app.string.image_rendermode_template')]
//图片、视频与媒体/imageSelectRepeat
export const REPEAT_SELECT: Resource[] = [$r('app.string.image_repeat_no'),$r('app.string.image_repeat_x'),$r('app.string.image_repeat_y'),$r('app.string.image_repeat_xy')]
// 图片、视频与媒体/videoSelectCurrentRate
export const CURRENT_RATE: string[] = ['0.75X','1X','1.25X','1.75X','2X']
// 列表与宫格/listDirectionSelectData
export const LIST_DIRECTION_SELECT_DATA : Resource[] = [$r('app.string.list_properties_direction_vertical'),$r('app.string.list_properties_direction_Horizontal')]
// 列表与宫格/listScrollBarSelectData
export const LIST_SCROLLBAR_SELECT_DATA : Resource[] = [$r('app.string.list_properties_scroll_bar_off'),$r('app.string.list_properties_scroll_bar_on'),$r('app.string.list_properties_scroll_bar_auto')]
// 列表与宫格/listEdgeEffectSelectData
export const LIST_EDGE_EFFECT_SELECT_DATA : Resource[] = [$r('app.string.list_properties_edge_effect_spring'),$r('app.string.list_properties_edge_effect_fade'),$r('app.string.list_properties_edge_effect_none')]
// 列表与宫格/listAlignListItemSelectData
export const LIST_ALIGN_LIST_ITEM_SELECT_DATA : Resource[] =[$r('app.string.list_properties_align_list_item_start'),$r('app.string.list_properties_align_list_item_Center'),$r('app.string.list_properties_align_list_item_End')]
// 列表与宫格/gridLayoutDirectionSelectData
export const GRID_LAYOUT_DIRECTION_SELECT : Resource[] =[$r('app.string.grid_properties_layout_direction_row'),$r('app.string.grid_properties_layout_direction_column')
  ,$r('app.string.grid_properties_layout_direction_row_reverse'),$r('app.string.grid_properties_layout_direction_column_reverse')]
// 导航/tabsBarPositionSelectData
export const TABS_BAR_POSITION_SELECT : Resource[] = [$r('app.string.tabs_arguments_bar_position_start'),$r('app.string.tabs_arguments_bar_position_end')]
// 导航/tabsBarModeSelectData
export const TABS_BAR_MODE_SELECT : Resource[] = [$r('app.string.tabs_properties_bar_mode_fixed'),$r('app.string.tabs_properties_bar_scrollable')]
//画布与图形绘制/PathSelectCommands
export const PATH_SELECT_COMMANDS: Resource[] = [$r('app.string.path_line'),$r('app.string.path_triangle'),$r('app.string.path_square'),$r('app.string.path_polygon')
  ,$r('app.string.path_camber_first'),$r('app.string.path_camber_second'),$r('app.string.path_camber_third')]
// 列表与宫格/waterFlowScrollEdgeSelectData
export const WATER_FLOW_SCROLL_EDGE_SELECT_DATA : Resource[] = [$r('app.string.water_flow_controller_top'),$r('app.string.water_flow_controller_bottom')]
// 列表与宫格/waterFlowEdgeEffectSelectData
export const WATER_FLOW_EDGE_EFFECT_SELECT_DATA : Resource[] = [$r('app.string.water_flow_properties_edge_effect_spring'),$r('app.string.water_flow_properties_edge_effect_fade'),$r('app.string.water_flow_properties_edge_effect_none')]
