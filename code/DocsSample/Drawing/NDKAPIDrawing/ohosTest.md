# NDKGraphicDraw测试用例归档

## 用例表

| 测试功能        | 预置条件                             | 输入                                                                                    | 预期输出                                           | 是否自动 | 测试结果 |
|-------------| ------------------------------------ |---------------------------------------------------------------------------------------| -------------------------------------------------- | -------- | -------- |
| 拉起应用        | 设备正常运行                         |                                                                                       | 成功拉起应用                                       | 是       | Pass     |
| drawing_brush    | 进入“drawing_brush”页面 | 依次点击Basic Brush、BlendMode、ColorFilter、ShaderEffect、MaskFilter这几个按钮                    | 在每个按钮点击后，绘制出对应的操作结果图案 | 是       | Pass     |
| drawing_pen | 进入“drawing_pen”界面         | 依次点击Basic Pen、Cap & Join、MiterLimit、ImageFilter、PathEffect、ShaderEffect、MaskFilter这几个按钮 | 在每个按钮点击后，绘制出对应的操作结果图案         | 是       | Pass     |
| drawing_rect    | 进入“drawing_rect”界面               | 依次点击Basic Rect、Intersect、Join、RoundRect这几个按钮                                          | 在每个按钮点击后，绘制出对应的操作结果图案                 | 是       | Pass     |
| drawing_path    | 进入“drawing_path”界面               | 依次点击PathBasic、PathAdd*、Path*To、PathStar、BuildFromSvgString这几个按钮                       | 在每个按钮点击后，绘制出对应的操作结果图案       | 是       | Pass     |
| drawing_matrix    | 进入“drawing_matrix”界面               | 依次点击MatrixBasic、Translation、PreTranslation、PostTranslation、Rotation等这几个按钮             | 在每个按钮点击后，绘制出对应的操作结果图案                | 是       | Pass     |
| drawing_canvas      | 进入“drawing_canvas”界面                   | 依次点击CreateCanvas、Clip、Save、SaveLayer、ConcatMatrix、DrawPixelMap、DrawRegion这几个按钮                  | 在每个按钮点击后，绘制出对应的操作结果图案 | 是       | Pass     |
| drawing_pixelmap      | 进入“drawing_pixelmap”界面                   | 依次点击LocalPixelMap、CustomPixelMap这几个按钮                    | 在每个按钮点击后，绘制出对应的操作结果图案 | 是       | Pass     |
| drawing_bitmap      | 进入“drawing_bitmap”界面                   |                    | 绘制出对应的图案    | 是       | Pass     |
| drawing_image      | 进入“drawing_image”界面                   |                     | 绘制出对应的图案    | 是       | Pass     |