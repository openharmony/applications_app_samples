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

#ifndef NATIVE_TYPE_SAMPLE_SWIPERMAKER_H
#define NATIVE_TYPE_SAMPLE_SWIPERMAKER_H

#include "manager.h"

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
    static ArkUI_NodeHandle createSwiperPage();
};

#endif // NATIVE_TYPE_SAMPLE_SWIPERMAKER_H
