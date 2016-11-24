

![Mou icon](https://raw.githubusercontent.com/qingluanchou/RRChartView/master/RRChartView/RRChartView/test5.gif)

## RRChart 集成RRChart可以快速地完成各种的复杂曲线的绘制，喜欢的同学，记得给小星星哦。

#### RRGridChart

所有图表对象的基类，对图标可以进行X，Y，Z，轴的绘制，经纬，刻度的绘制，图片上下，左右，偏移的设置，同时可以捕获触摸点的位置，返回对应位置的数据

#### RRLineChart
此类基于**RRGridChart**的基础上可以绘制各种折线

#### RRStickChart
是在**RRGridChart**上绘制柱状数据的图表、如果需要支持显示均线，**RRStickChartData**保存柱条表示用的高低值的实体对象

#### RRStickChart
此类是基于**RRStickChart**的，可以**RRStickChart**基础上
显示移动平均等各种分析指标数据，显示每日均线，组成混合视图。

 **RRTitledLine**保存折线表示用的多个折线的集合对象，以及线的标题，颜色
 
**RRTitledLine**保存线图表示用单个线的对象，位置的值和日期
