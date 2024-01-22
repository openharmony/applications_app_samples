/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

#include "Quaternion.h"
float Quaternion::GetDataW() { return this->dataW; }
void Quaternion::SetDataW(float wData) { this->dataW = wData; }
float Quaternion::GetDataZ() { return this->dataZ; }
void Quaternion::SetDataZ(float zData) { this->dataZ = zData; }
float Quaternion::GetDataY() { return this->dataY; }
void Quaternion::SetDataY(float yData) { this->dataY = yData; }
float Quaternion::GetDataX() { return this->dataX; }
void Quaternion::SetDataX(float xData) { this->dataX = xData; }
