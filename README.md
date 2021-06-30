# Heat_Distortion_Refraction
基于URP管线，热空气扭曲。支持半透明物体。


在Unity的Build-in渲染管线下可以在合适的时机使用GrabPass截图，但是在URP管线下没有GrabPass了，想要获取截图只有_CameraColorTexture和_CameraOpaqueTexture。

1. _CameraOpaqueTexture是在不透明通道渲染后截图，所以截不到半透明的物体。

2. _CameraColorTexture是在半透明通道渲染后和PostProcessing后截图。

所以在PostProcessing渲染通道渲染完成后会有一个_AfterPostProcessTexture的屏幕截图，这个就是正确的屏幕截图了，这时候使用这个截图就可以做出正确的扭曲效果。

测试效果：
https://user-images.githubusercontent.com/7518595/123969522-e3104100-d9ea-11eb-8941-f52efbba298f.mp4

