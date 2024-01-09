/*
 * * Copyright (c) TD Tdch Communication Technologies Ltd.2023-2023.All rights reserved.
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
        for (int i = 0; i < MATRIX_COMPONENT_COUNT; i++) {
            mat.values[i] = IDENTITY_VALUES[i];
        }
        return mat;
    }
    void Set(float dataIn[], int offset)
    {
        for (int i = 0; i < MATRIX_COMPONENT_COUNT; i++) {
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
    static constexpr int MATRIX_ROW_COUNT = 4;
    static constexpr int MATRIX_COLUMN_COUNT = 4;
    static constexpr int MATRIX_COMPONENT_COUNT = 16;
    static constexpr int MATRIX_TRANSLATION_COMPONENT_X = 12;
    static constexpr int MATRIX_TRANSLATION_COMPONENT_Y = 13;
    static constexpr int MATRIX_TRANSLATION_COMPONENT_Z = 14;
    static constexpr int MATRIX_TRANSLATION_COMPONENT_W = 15;
    static constexpr int MATRIX_SCALE_COMPONENT_X = 0;
    static constexpr int MATRIX_SCALE_COMPONENT_Y = 5;
    static constexpr int MATRIX_SCALE_COMPONENT_Z = 10;
    static constexpr int M00 = 0;
    static constexpr int M10 = 1;
    static constexpr int M20 = 2;
    static constexpr int M30 = 3;
    static constexpr int M01 = 4;
    static constexpr int M11 = 5;
    static constexpr int M21 = 6;
    static constexpr int M31 = 7;
    static constexpr int M02 = 8;
    static constexpr int M12 = 9;
    static constexpr int M22 = 10;
    static constexpr int M32 = 11;
    static constexpr int M03 = 12;
    static constexpr int M13 = 13;
    static constexpr int M23 = 14;
    static constexpr int M33 = 15;
    static constexpr float QUAT_CONVERSION_MULTIPLIER = 2.0F;
    static constexpr float EPSILON = 1.0E-6F;
    static constexpr float IDENTITY_VALUES[16] = {1.0F, 0.0F, 0.0F, 0.0F, 0.0F, 1.0F, 0.0F, 0.0F,
                                                  0.0F, 0.0F, 1.0F, 0.0F, 0.0F, 0.0F, 0.0F, 1.0F};
};

#endif // MY_X_COMPONENT_MATRIX4X4_H
