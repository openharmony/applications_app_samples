//
// Created on 2023/12/25.
//
// Node APIs are not fully supported. To solve the compilation error of the interface cannot be found,
// please include "napi/native_api.h".

#include "Vector3.h"
#include <cmath>
#include "cmath"
Vector3 Vector3::Add(Vector3 lhs, Vector3 rhs)
{
    return Vector3(lhs.dataX + rhs.dataX, lhs.dataY + rhs.dataY, lhs.dataZ + rhs.dataZ);
}

Vector3 Vector3::Subtract(Vector3 lhs, Vector3 rhs)
{
    return Vector3(lhs.dataX - rhs.dataX, lhs.dataY - rhs.dataY, lhs.dataZ - rhs.dataZ);
}

Vector3 Vector3::Multiply(Vector3 lhs, float rhs) { return Vector3(lhs.dataX * rhs, lhs.dataY * rhs, lhs.dataZ * rhs); }
float Vector3::GetDataX() { return this->dataX; }
void Vector3::SetDataX(float xData) { this->dataX = xData; }
float Vector3::GetDataY() { return this->dataY; }
void Vector3::SetDataY(float yData) { this->dataY = yData; }
float Vector3::GetDataZ() { return this->dataZ; }
void Vector3::SetDataZ(float zData) { this->dataZ = zData; }

float Vector3::Length(Vector3 lhs)
{
    return (float)std::sqrt(lhs.dataX * lhs.dataX + lhs.dataY * lhs.dataY + lhs.dataZ * lhs.dataZ);
}

Vector3 Vector3::Normalize(Vector3 lhs)
{
    float oneOverLen = 1.0F / Length(lhs);
    return isfinite(oneOverLen) ? Vector3(lhs.dataX * oneOverLen, lhs.dataY * oneOverLen, lhs.dataZ * oneOverLen)
                                : Vector3(0, 0, 0);
}

Vector3 Vector3::Cross(Vector3 lhs, Vector3 rhs)
{
    float newX = lhs.dataY * rhs.dataZ - lhs.dataZ * rhs.dataY;
    float newY = lhs.dataZ * rhs.dataX - lhs.dataX * rhs.dataZ;
    float newZ = lhs.dataX * rhs.dataY - lhs.dataY * rhs.dataX;
    return Vector3(newX, newY, newZ);
}

float Vector3::Dot(Vector3 lhs, Vector3 rhs)
{
    return lhs.dataX * rhs.dataX + lhs.dataY * rhs.dataY + lhs.dataZ * rhs.dataZ;
}
