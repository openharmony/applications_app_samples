/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

#ifndef SWIPER_MAKER_H
#define SWIPER_MAKER_H

#include "manager.h"
#include <functional>


class SwiperMaker {
public:
    SwiperMaker(){};
    ~SwiperMaker(){};
    static void createSwiperNode(ArkUI_NodeHandle &swiper);
    static void SetSwiperArrowStyle(ArkUI_NodeHandle &swiper);
    static void GetSwiperArrowStyle(ArkUI_NodeHandle swiper);
    static void SetSwiperIndicatorTypeDot(ArkUI_NodeHandle &swiper);
    static void GetSwiperIndicatorTypeDot(ArkUI_NodeHandle swiper);
    static void SetSwiperIndicatorTypeDigit(ArkUI_NodeHandle &swiper);
    static void GetSwiperIndicatorTypeDigit(ArkUI_NodeHandle swiper);
    static void SetSwiperAttributeLoop(ArkUI_NodeHandle &swiper);
    static void SetSwiperAttributeAutoPlay(ArkUI_NodeHandle &swiper);
    static void SetSwiperAttributeShowIndicator(ArkUI_NodeHandle &swiper);
    static void SetSwiperAttributeInterval(ArkUI_NodeHandle &swiper);
    static void SetSwiperAttributeVertical(ArkUI_NodeHandle &swiper);
    static void SetSwiperAttributeDuration(ArkUI_NodeHandle &swiper);
    static void SetSwiperAttributeCurve(ArkUI_NodeHandle &swiper);
    static void SetSwiperAttributeItemSpace(ArkUI_NodeHandle &swiper);
    static void SetSwiperAttributeIndex(ArkUI_NodeHandle &swiper);
    static void SetSwiperAttributeDisplayCount(ArkUI_NodeHandle &swiper);
    static void SetSwiperAttributeDisableSwipe(ArkUI_NodeHandle &swiper);
    static void SetSwiperAttributeEdgeEffectMode(ArkUI_NodeHandle &swiper);
    static ArkUI_NodeAdapterHandle creatNodeAdapter();
    static void SetSwiperAttributeNodeAdapter(ArkUI_NodeHandle &swiper);
    static void SetSwiperAttributeCachedCount(ArkUI_NodeHandle &swiper);
    static void SetSwiperAttributePrevMargin(ArkUI_NodeHandle &swiper);
    static void SetSwiperAttributeNextMargin(ArkUI_NodeHandle &swiper);
    static void SetSwiperAttributeNestedScroll(ArkUI_NodeHandle &swiper);
    static void SetSwiperAttributeSwipeToIndex(ArkUI_NodeHandle &swiper);
    static void SetSwiperAttributeIndicatorInteractive(ArkUI_NodeHandle &swiper);
    static void SetSwiperAttributePageFlipMode(ArkUI_NodeHandle &swiper);
    static void SetSwiperAttributeAutoFill(ArkUI_NodeHandle &swiper);
    static void SetSwiperAttributeMaintainVisibleContentPosition(ArkUI_NodeHandle &swiper);
    static void SetSwiperAttribute(ArkUI_NodeHandle &swiper);
    static void EventOnChange(ArkUI_NodeEvent *event);
    static void EventOnAnimationStart(ArkUI_NodeEvent *event);
    static void EventOnAnimationEnd(ArkUI_NodeEvent *event);
    static void EventOnGestureSwipe(ArkUI_NodeEvent *event);
    static void EventOnContentDidScroll(ArkUI_NodeEvent *event);
    static void EventOnSelected(ArkUI_NodeEvent *event);
    static void EventOnUnselected(ArkUI_NodeEvent *event);
    static void EventOnContentWillScroll(ArkUI_NodeEvent *event);
    static void EventOnScrollStateChanged(ArkUI_NodeEvent *event);
    
    static void SetSwiperEvent(ArkUI_NodeHandle &swiper);
    
    static ArkUI_NodeHandle CreateNativeNode();

    struct UserCallback {
        std::function<void(void *event)> callback;
        UserCallback(){};
    };

    typedef enum {
        ON_CHANGE = 0,
        ON_ANIMATION_START = 1,
        ON_ANIMATION_END = 2,
        ON_GESTURE_SWIPE = 3,
        ON_CONTENT_DID_SCROLL = 4,
        ON_SELECTED = 5,
        ON_UNSELECTED = 6,
        ON_CONTENT_WILL_SCROLL = 7,
        ON_SCROLL_STATE_CHANGED = 8,
    } SwiperEventId;
};

#endif // NATIVE_TYPE_SAMPLE_SWIPERMAKER_H
