#import "@preview/diatypst:0.1.0": *

#show: slides.with(
  title: "Academic Presentation", // Required
  subtitle: "Introduction and Research Achievements",
  date: "10.14.2024",
  authors: ("plote1"),

  // Optional Styling
  ratio: 16/9,
  layout: "large",
  title-color: blue.darken(60%),
  footer: true,
  counter: true,
)

#outline()

= Educational Background

== Personal Introduction

#let info(label, content) = {
  grid(
    columns: (100pt, 1fr),
    gutter: 16pt,
    [#text(weight: "bold")[#label:]], content
  )
}

// #set page(
//   margin: (x: 0.7in, y: 0.7in),
// )

#grid(
  columns: (120pt, 1fr),
  gutter: 16pt,
  [
    // #image("jpg/people.jpg", width: 90%)
  ],
  [
    #text(15pt, weight: "bold")[Personal Information]

    #info("Name", "plote")
    #info("Institution", "bilibili University")
    #info("Major", "math/sofeware/ai/cs")
    #info("GPA", "0")


    #text(14pt, weight: "bold")[Key Courses]

    #grid(
      columns: (1fr, 1fr),
      gutter: 8pt,
      [Advanced Mathematics ], [Introduction to Programming ],
      [Linear Algebra ], [Probability and Statistics ],
      [Computer Organization Principles ], [Object-Oriented Programming ],
    )
    #text(14pt, weight: "bold")[Technical Skills]
    #align(left)[
      *Programming Languages*: Python, Rust, C/C++
    ]
  ]
)

= Projects and Competitions


== Design of a guide aid for the blind based on multi-modal perception and tactile feedback

#align(center)[
  #block(width: 90%, inset: 1em)[
    #text(weight: "bold", 1.5em)[比赛奖项]

    研究背景:针对现有导盲辅具视野狭窄、手部占用等问题。研发一种基于多模态感知与触觉反馈结合的便捷式盲人辅助设备，为视障用户提供导航、避障和物体识别等功能。

    #align(left)[

       研究内容:使用深度相机和麦克风阵列等传感器，利用卡尔曼滤波融合数据，减小误差
      
       使用Paddle训练PP-YOLOE模型进行目标检测，线上评测识别率0.997，FPS大于60.
       
       ROS环境下使用ORB-SLAM通过点云建图室内导航FOC控制无刷电机驱动动量轮提供触觉反馈

#grid(
  columns: (1fr, 1fr),
  gutter: 16pt,
  [ #v(.9em)
    #align(center)[
       #text(weight: "bold", 1.1em)[项目成果]
        #align(center)[
       
          2023年已评优结题并推荐参加年会
         
          无
          
          无 ]
        ]
      ],
  [
    #align(center)[
    

       #align(center)[
            #box(
              height: 88pt,
              image("jpg/man.png")
              )
            #box(
              height: 88pt,
              image("jpg/chair.png")
              )
            #box(
              height: 88pt,
              image("jpg/slam.png")
              )
          ]   
        ]
     ]
    )




     
    ]
  ]
]


== Liaoning Computer Chess Competition

#align(left)[
  #block(width: 90%, inset: 1em)[
    #text(weight: "bold", 1.1em)[水赛打着玩]

    #v(.9em)

    开发并优化六子棋游戏算法，引入$alpha-beta$剪枝技术改进传统极大极小值算法，显著提高计算机对弈效率和决策质量。

    #v(.9em)
    #align(left)[
       *Minimax Algorithm Optimization*: 设计并实现了基于极大极小过程的决策树，通过模拟棋手思考过程，为每种可能的走法进行评分和选择，确保在对手最佳反应下依然保持优势。通过构建深度搜索树，自底向上分析并确定最佳走法，确保稳定的棋力表现。
    
    #v(.9em)
       *Alpha-Beta Pruning Implementation*: 引入$alpha-beta$剪枝算法减少不必要的搜索路径，处理深度搜索过程中的组合爆炸问题，显著提高搜索效率。在深度优先搜索中动态调整节点生成，利用α剪枝和β剪枝规则剪除低效分支，从而在保持决策质量的同时大幅减少计算需求。
    ]
  ]
]

== Rust-Based OS Development (OS-Comp 2023)

#align(center)[
  #block(width: 90%, inset: 1em)[
    #text(weight: "bold", 1.1em)[Tsinghua University Open-Source Operating System]
#v(.8em)
    #align(left)[
       *System Architecture and Debugging*:  通过`make debug`命令使用`GDB`调试`Qemu`，掌握代码结构和执行流程。实现了基于`RISC-V`特权级的简单批处理系统，使得应用程序和用户态支持库能在最低特权级U模式下运行。
      #v(.5em)
       *Basic Output and Control*: 通过实现`println!`宏和`console_putchar`函数，使得格式化输出在自己的库级操作系统中可用。这包括完整的`Stdout`结构体和`Write trait`的实现，提供基本的输出功能。
      #v(.5em) 
       *Task and Privilege Management*: 设计和实现了从操作系统的S模式到应用程序的U模式的上下文切换。这包括应用程序的内存布局、系统调用的处理，以及在发生`Trap`时`CPU`特权级的管理和切换。
      #v(.5em) 
       *SBI-Based Output and Shutdown*: 实现了基于`SBI（Supervisor Binary Interface）`的输出和关机功能，增强了系统的基本输入输出和控制能力。
       
       *Multi-Tasking*: 实现了包括`yield`系统调用和时间片轮转调度的多任务处理能力，支持多个任务并发执行并合理分配CPU资源。
    ]
  ]
]

== C Language Compiler

#align(center)[
  #block(width: 90%, inset: 1em)[
    #text(weight: "bold", 1.1em)[Compiler and Compiler Principles]
    #v(.4em)

    #block()[
    / *为了做这个项目,学习了编译原理并且阅读了以下书籍* :  
        #v(.3em)
        *Compilers: Principles, Techniques, and Tools* 
        #v(.3em)
        *Advanced Compiler Design and Implementation*
        #v(.3em)
        *Modern Compiler Implementation in C*.
    ]
    #align(left)[
       *Lexical Analysis*: 实现了基于有限自动机的词法分析器。为了高效处理输入流，我采用了二重指针和缓冲区管理策略来代替`lex`工具使用，从而实现了快速的文本扫描和词法单元识别。
      
       *Syntax Analysis and AST*: 使用`Yacc`工具进行语法分析，自动构建抽象语法树（AST）。这一步是将词法单元按照语言的语法规则结构化，为后续的语义分析和代码生成打下基础。
      
       *AST Visualization*: 利用Python开发了一个遍历并可视化AST的工具，通过生成图形化的树结构，使代码逻辑结构一目了然，便于调试和分析。
      
      
    ]
  ]
]

== Web Scraping and Data Analysis - Patent Publishing

#align(center)[
  #block(width: 90%, inset: 1em)[
    #text(weight: "bold", 1.1em)[实习生]

    #v(2em)

    #align(left)[
       *Data Acquisition*: 利用 Python 的 `Requests` 和 `Scrapy` 库结合 `XPath` 定位技术，合理合法爬取国家专利统计局开放数据。通过爬虫任务，处理和抓取网页数据。
     #v(.9em)
       *Skill Enhancement*:  在实习期间，学习数据预处理、清洗与转换技术，应用 Pandas 库进行数据处理，使用 NumPy 进行数值分析。
     #v(.9em) 
       *Patent Analysis*:  针对数据，运用 `Beautiful Soup` 解析 HTML 文件，抽取关键信息，并利用` Matplotlib`和 `Seaborn` 等可视化工具制作图表，展示专利数据的趋势和模式，为管理决策提供了数据支持。
    ]
  ]
]
== Book reading and paper reproduction

#align(center)[
  #block(width: 90%, inset: 1em)[
    #text(weight: "bold", 1.3em)[*学习过的领域*: 深度学习模型、cv目标检测、生成式模型、扩散模型]


#grid(
  columns: (1fr, 1fr),
  gutter: 16pt,
  [ #v(.9em)
    #align(center)[
       #text(weight: "bold", 1.5em)[Book reading]
      
       _动手学深度学习_ - 李沐
      
       _统计学习方法_ - 李航
      
       机器学习花书 (_The Elements of Statistical Learning_)
      
       _PRML_ (Pattern Recognition and Machine Learning)
      
       _Pattern Classification_
        
        ]
      ],
  [
    #align(center)[
      #v(.9em)
      #text(weight: "bold", 1.5em)[paper reproduction]
      
       YOLO 系列
      
       VAE 与 GAN
      
       Diffusion 模型
      
       Stable Diffusion
      
       DDPM (Denoising Diffusion Probabilistic Models)
      
       RDDM (Refinement-based Diffusion Models)
        ]
     ]
    )
  ]
]

== National Intelligent Vehicle Competition - Full Model Group
  #text(weight: "bold", 1.2em)[ 深度学习在线赛全国第28名]
#grid(
  columns: (1fr, 1fr),
  gutter: 16pt,
  [
    #align(left)[
     
      1. *Data preprocessing and enhancement*
         - 数据格式转换：VOC 至 COCO 格式的系统性转换
         - 自主开发图像增强算法：实现图像翻转、随机裁剪等技术，提高模型输入多样性
         - 数据集均衡化：优化 JSON 文件中数据分布，提升数据质量
      #v(0.3em)
      2. *Data quality control*
         - 实施严格的数据清洗流程，确保标签准确性和图像质量
         - 利用 PaddleLabel 进行实地数据采集和自动预标注，扩充数据集
      #v(0.3em)
      3. *Model optimization and selection*
         - 应用 Grid 搜索算法，优化模型结构和参数组合
         - 实施数据蒸馏技术，提炼核心特征，加速学习过程
         - 综合评估多种框架，选定 PP-YOLOE 结合 ResNet 作为主要检测框架
    ]
  ],
  [#v(3em)
    #align(left)[
      4. *Model performance improvement strategies*
         - 实施模型剪枝技术，优化网络结构，提高计算效率
         - 采用 Adam 优化器，精细调整学习率等超参数，确保模型快速收敛
         - 应用先进剪枝策略，有效降低计算资源消耗，提升预测速度

      #v(2em)

      5. *Research results*
         - 模型性能：F1 得分达到 0.99704
         - 实时性能：帧率提升至 42.85 FPS
         - 显著超越前期版本，实现性能质的飞跃
    ]
  ]
)

== Room Layout Generation Model - Pix2Pix Based

#align(center)[ 
  #block(width: 90%, inset: 1em)[ 
    #text(weight: "bold", 1.1em)[Internship at Chinese Academy of Sciences, Institute of Automation]
    
    #grid(
      columns: (5fr, 6fr),
      gutter: 9pt,
    
    column-gutter: 1fr,[
      #align(left)[
        #text(11pt)[
          *Conditional Generative Adversarial Network (CGAN)*: Based on Pix2Pix framework with U-Net generator structure, leveraging down-sampling and up-sampling with skip connections to retain image details.

          *Generator*: Built a U-Net model, consisting of convolution, batch normalization, Leaky ReLU, and dropout layers to strengthen feature extraction and image generation.

          *Discriminator*: Used PatchGAN to evaluate image authenticity at patch level, assisting the generator in optimizing local features.
        ]
      ]
    ],

    [
      #text()[
      
      #image("jpg/work.png", width:120%, height: 90%)
      ]
    ]
  )
  ] 
]

= Internship Expectations
== Personal understanding of the project

#v(.5em)

我自己对生成学习的了解

/ * Diffusion中的核心公式是: * :
  / *正向扩散 Forward Diffusion Process* :
  $
    q ( x _ ( 1 ),..., x _ ( T ) | x _ ( 0 ) ) = product _ (  t = 1 ) ^ ( T ) q ( x _ ( t ) | x _ ( t - 1 ) )
  $
 / * 反向生成 Reverse Generation Formula* : 
 #v(.1em)
  $
    p _ ( theta ) ( x _ ( t - 1 ) | x _ ( t ) ) = cal( N ) ( x _ ( t - 1 ) ; mu _ ( theta ) ( x _ ( t ), t ), Sigma _ ( theta ) ( x _ ( t ), t ) )
  $

   / * 正向和反向扩散的平衡控制* : 
  $ bold( upright( x ) ) _ ( t - 1 ) = sqrt( alpha _ ( t ) ) bold( upright( x ) ) _ ( 0 ) + sqrt( 1 - alpha _ ( t ) ) epsilon.alt
  $
#align(center)[ 
  #block(width: 90%, inset: 1em)[ 
    #text(weight: "bold", 1.3em)[论文的核心知识点]
    
    #grid(
      columns: (5fr, 6fr),
      gutter: 9pt,
    
    column-gutter: 1fr,[
       #text(weight: "bold", 1.3em)[Latent Diffusion Model] 
      #align(left)[
        #text(11pt)[ 

          核心思想：在潜在空间中进行扩散和去噪
  
          优势：降低计算成本，加速生成过程

          / *LDM损失函数： *:$
          L_(L D M) = E_(z,epsilon,t)[norm(epsilon - epsilon_theta(z_t, t, y))^2]  $
    
          #align(center)[
    
          因为潜在空间的维度通常比数据空间低。LDM 的这个损失函数与传统扩散模型的损失函数类似，但它在潜在空间中操作，使用的是压缩后的潜在表示 $z_t$ 进行计算，从而加速了生成过程。
        ]
        ]
      ]
    ],
    [
      #text(weight: "bold", 1.2em)[残差引导扩散模型(RDDM)]   
      
        #text(11pt)[
            引入残差学习（ResNet）改善模型性能
        ]   

        / *RDDM更新公式： *:$
          I _ ( t ) = & I _ ( t - 1 ) + alpha _ ( t ) I _ ( r e s ) + beta _ ( t ) epsilon.alt _ ( t - 1 ) \ = & I _ ( t - 2 ) + ( alpha _ ( t - 1 ) + alpha _ ( t ) ) I _ ( r e s ) + ( sqrt( beta _ ( t - 1 ) ^ ( 2 ) + beta _ ( t ) ^ ( 2 ) ) ) epsilon.alt _ ( t - 2 ) \ = &... \ = & I _ ( 0 ) + overline( alpha ) _ ( t ) I _ ( r e s ) + overline( beta ) epsilon.alt,    $  $I _ ( t - 1 ) = I _ ( t ) - ( overline( alpha ) _ ( t ) - overline( alpha ) _ ( t - 1 ) ) I _ ( r e s ) ^ ( theta ) -  overline( beta ) _ ( t ) - sqrt( (overline(beta)  _ ( t-1 ) ^ ( 2 ) - sigma _ ( t ) ^ ( 2 ) ) epsilon.alt _ ( theta ) )+ sigma _ ( t ) epsilon.alt _ ( t ), "where" epsilon.alt _ ( t ) tilde cal( N ) ( bold( upright( 0 ) ), bold( upright( I ) ) ).$

        ]
     )
  ] 
]


#align(center)[ 
  #block(width: 90%, inset: 1em)[ 
    #text(weight: "bold", 1.3em)[最近新学习的论文和自己的想法]
    
    #grid(
      columns: (5fr, 6fr),
      gutter: 9pt,
    
    column-gutter: 1fr,[
       #text(weight: "bold", 1.2em)[风格迁移中的自注意力机制] 
      #align(left)[
        #text(11pt)[ 
          
          自注意力和交叉注意力机制在风格迁移中起关键作用

          / *自注意力计算公式： *:$
          bold(A)(Q, K, V) = op("softmax")((Q K^T) / (sqrt(d_k)))V
          $
          #align(center)[
          *相关研究：*

          Style Injection in Diffusion: " A Training-free Approach for Adapting Large-scale Diffusion Models for Style Transfer" (CVPR 2024)
          ]
        ]
      ]
    ],

    [
      #text(weight: "bold", 1.2em)[感知损失函数(Perceptual Loss)]   

        #text(11pt)[
          传统均方误差损失（MSE）的改进

          结合感知损失和风格损失

          通常基于预训练的卷积神经网络（如VGG）
        ]   

        / *感知损失函数： *:$
          L_("perc")(x, hat(x)) = sum_l norm(phi_l(x) - phi_l(hat(x)))_2 
          $
            #align(center)[
          $phi_l$ 表示预训练网络的第 $l$ 层特征提取器
        ]
        #align(center)[
          *相关研究：*
          Image Style Transfer Using Convolutional Neural Networks 2016\
          Diffusion Model with Perceptual Loss 2023.12
          ]
        ]
     )
  ] 
]


== Personal idea 


#align(center)[ 
  #block(width: 90%, inset: 1em)[ 
    #text(weight: "bold", 1.3em)[]
    
    #grid(
      columns: (5fr, 6fr),
      gutter: 9pt,
    
    column-gutter: 1fr,[
       #text(weight: "bold", 1.2em)[现在的问题有] 
      #align(left)[
        #text(11pt)[ 

          1. 生成可控性不足

            - 当前的方法通常依赖推理阶段的优化，例如微调或文本反演，但这些方法的计算成本较高且控制的效果有限

          2. 噪声细节处理不充分

            - 扩散模型通过逐步去除噪声来生成图像，但噪声的逐步添加和去除过程中，某些低频信号可能没有被完全打破，会导致图像整体色调偏向中等值，破坏风格的清晰性和一致性

            - 生成的高频细节（如纹理和边缘）可能无法准确体现目标风格，导致生成的图像缺乏必要的细节丰富度。
        ]
      ]
    ],

    [
      #text(weight: "bold", 1.2em)[我的个人idea]     

        #align(center)[
        改进损失函数和模型结构来优化噪声处理。

        利用Attention机制增强控制性减少风格迁移中的不协调现象

        优化噪声分布与处理：
        通过改进噪声分布(自适应噪声处理)减少低频信息残留对生成图像的影响。
        ]
      #text()[

      #image("jpg/iccv.png", width:100%, height: 50%)
      ]
      ]
    )
  ] 
]









