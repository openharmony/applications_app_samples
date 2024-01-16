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
#ifndef MY_X_COMPONENT_MATRIX4X4_H
#define MY_X_COMPONENT_MATRIX4X4_H

#include "Quaternion.h"
#include "Vector3.h"
#include "util/types.h"
class Matrix4x4 {
public:
    Matrix4x4() {}
    static Matrix4x4 Identity()
    {
        Matrix4x4 mat;
        for (int i = 0; i < matrixComponentCount; i++) {
            mat.values[i] = identityValues[i];
        }
        return mat;
    }
    void Set(float dataIn[], int offset)
    {
        for (int i = 0; i < matrixComponentCount; i++) {
            values[i] = dataIn[offset + i];
        }
    }
    static void Multiply(Matrix4x4 lhs, Matrix4x4 rhs, Matrix4x4 &product)
    {
        float outArray[16] = {0};
        for (int row = 0; row < kFour; ++row) {
            int index = 0;
            for (int column = 0; column < kFour; ++column) {
                for (int column2 = 0; column2 < kFour; ++column2) {
                    outArray[index] += lhs.values[column2 + row * kFour] * rhs.values[row + column * kFour];
                    ++index;
                }
            }
        }
        product.Set(outArray, 0);
    }

    float *GetValues() { return values; }

    void MakeTranslation(Vector3 translation)
    {
        Identity();
        values[12] = translation.GetDataX(); // M12
        values[13] = translation.GetDataY(); // M13
        values[14] = translation.GetDataZ(); // M14
    }

    void MakeScale(Vector3 scale)
    {
        Identity();
        values[0] = scale.GetDataX();
        values[kFive] = scale.GetDataY();
        values[kTen] = scale.GetDataZ();
    }

    void MakeRoate(float angle, Vector3 axis)
    {
        Identity();
        Quaternion rotation = Quaternion::AngleAxis(angle, axis);
        Quaternion rotationNorm = rotation.GetNormalized();
        float yy = rotationNorm.GetDataY() * rotationNorm.GetDataY();
        float zz = rotationNorm.GetDataZ() * rotationNorm.GetDataZ();
        this->values[0] = 1.0F - 2.0F * (yy + zz);
        float xy = rotationNorm.GetDataX() * rotationNorm.GetDataY();
        float zw = rotationNorm.GetDataZ() * rotationNorm.GetDataW();
        this->values[kFour] = 2.0F * (xy - zw);
        float xz = rotationNorm.GetDataX() * rotationNorm.GetDataZ();
        float yw = rotationNorm.GetDataY() * rotationNorm.GetDataW();
        this->values[kEight] = 2.0F * (xz + yw);
        this->values[1] = 2.0F * (xy + zw);
        float xx = rotationNorm.GetDataX() * rotationNorm.GetDataX();
        this->values[kFive] = 1.0F - 2.0F * (xx + zz);
        float yz = rotationNorm.GetDataY() * rotationNorm.GetDataZ();
        float xw = rotationNorm.GetDataX() * rotationNorm.GetDataW();
        this->values[kNine] = 2.0F * (yz - xw);
        this->values[kTwo] = 2.0F * (xz - yw);
        this->values[kSix] = 2.0F * (yz + xw);
        this->values[kTen] = 1.0F - 2.0F * (xx + yy);
    }

    void SetValue(int index, float value) { values[index] = value; }

    float GetValue(int index) { return values[index]; }

private:
    float values[16] = {0};
    static constexpr int matrixComponentCount = 16;
    static constexpr float identityValues[16] = {1.0F, 0.0F, 0.0F, 0.0F, 0.0F, 1.0F, 0.0F, 0.0F,
                                                 0.0F, 0.0F, 1.0F, 0.0F, 0.0F, 0.0F, 0.0F, 1.0F};
};

#endif // MY_X_COMPONENT_MATRIX4X4_H
