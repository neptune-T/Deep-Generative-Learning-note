
# 目标
主成分分析:只是保留一个轴的时候，信息保留的最多

![[1404.1100v1.pdf]]
# 结果
找到数据分布最分散的方向（即方差最大），作为主成分（坐标轴）
![[Pasted image 20240701165043.png]]
# 操作

去中心化，将坐标原点放置在数据中心位置
找坐标系：找到方差最大的


![[J-05-00021-v2.pdf]]

一般来说，如果数据过于密集均匀，我们这里采用的是拉伸加旋转
$$
D \to SD \to RSD \to D` = RSD
$$  
$$
S = \begin{bmatrix}
   a && 0 \\ 0 && b
\end{bmatrix}
\quad

R = \begin{bmatrix}
\cos(\theta) && -\sin(\theta) \\ \sin(\theta) &&\cos(\theta)
\end{bmatrix}
$$

这里可以很清晰的看见我们要求的关键因素在R上，我们因该怎么求R呢？

**协方差矩阵的特征向量就是R**

### 什么是协方差？

$$
\operatorname{cov}(x,y)= \frac{\sum_{i=1}^n \left(x_i-\bar{x}\right)\left(y_i-\bar{y}\right)}{n-1}
$$
表示：两个变量在变化过程之中是同方向变化还是反方向变化，同向或者反向的程度如何？
$$x \uparrow \quad \to y \uparrow \quad \to \quad \operatorname{cov}(x,y) > 0
$$

协方差矩阵：

$$
C = \begin{bmatrix}\operatorname{cov}(x,x) && \operatorname{cov}(x,y) \\
\operatorname{cov}(x,y) && \operatorname{cov}(y,y)
\end{bmatrix}
$$
又因为:
$$
\operatorname{cov}(x,y)=\frac{\sum_{i=1}^nx_iy_i}{n-1}
\quad
\operatorname{cov}(x,x)=\frac{\sum_{i=1}^nx_1^2}{n-1}
$$

代入:

$$ 
C=\begin{bmatrix}
\frac{\sum_{i=1}^nx_1^2}{n-1} &&
\frac{\sum_{i=1}^nx_iy_i}{n-1} \\
\frac{\sum_{i=1}^nx_iy_i}{n-1} &&
\frac{\sum_{i=1}^ny_1^2}{n-1}
\end{bmatrix}
$$
展开可得：
$$
\mathbf{C} = \frac{1}{n-1}\begin{bmatrix}
x_1 &&x_2 &&x_3 &&x_4 \\
y_1 &&y_2 &&y_3 &&y_4 
\end{bmatrix}
\begin{bmatrix}
x_1 && y_1 \\
x_2 && y_2 \\
x_3 && y_3 \\
x_4 && y_4
\end{bmatrix}
=\frac{1}{n-1}\mathbf{D}\mathbf{D}^\top
$$

## pca求解

数据 ---> 去中心化  ---> 协方差矩阵 ---> 特征向量  ---> 坐标轴方向（R）
                                --->特征值  --->  坐标轴方向的方差


