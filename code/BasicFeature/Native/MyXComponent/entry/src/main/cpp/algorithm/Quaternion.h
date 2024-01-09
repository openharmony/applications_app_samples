/*
 * * Copyright (c) TD Tdch Communication Technologies Ltd.2023-2023.All rights reserved.
 */

#ifndef MY_X_COMPONENT_QUATERNION_H
#define MY_X_COMPONENT_QUATERNION_H

#include <cmath>
#include "algorithm/Vector3.h"
class Quaternion {
public:
    Quaternion(float xData, float yData, float zData, float wData)
        : dataX(xData), dataY(yData), dataZ(zData), dataW(wData)
    {
    }
    static Quaternion AngleAxis(float angleRadians, Vector3 axis)
    {
        double halfAngleRadians = static_cast<double>(angleRadians * 0.5);
        float sinValue = static_cast<float>(sin(halfAngleRadians));
        Vector3 axisMutiplied = Vector3::Multiply(axis, sinValue);
        return Quaternion(axisMutiplied.GetDataX(), axisMutiplied.GetDataY(), axisMutiplied.GetDataZ(),
                          (float)cos(halfAngleRadians));
    }
    static float Length(float xData, float yData, float zData, float wData)
    {
        return sqrt(xData * xData + yData * yData + zData * zData + wData * wData);
    }

    static Quaternion Identity() { return Quaternion(0.0F, 0.0F, 0.0F, 1.0F); }
    static Quaternion Normalize(float xData, float yData, float zData, float wData)
    {
        float oneOverLen = 1.0F / Length(xData, yData, zData, wData);
        return isfinite(oneOverLen)
                   ? Quaternion(xData * oneOverLen, yData * oneOverLen, zData * oneOverLen, wData * oneOverLen)
                   : Identity();
    }

    Quaternion GetNormalized() { return Normalize(this->dataX, this->dataY, this->dataZ, this->dataW); }

    float GetDataW();
    void SetDataW(float dataW);
    float GetDataZ();
    void SetDataZ(float dataZ);
    float GetDataY();
    void SetDataY(float dataY);
    float GetDataX();
    void SetDataX(float dataX);

private:
    float dataX;
    float dataY;
    float dataZ;
    float dataW;
};
#endif // MY_X_COMPONENT_QUATERNION_H
