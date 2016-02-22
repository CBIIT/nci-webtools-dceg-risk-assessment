#Considering only the selected covarients, multiply by the (1-Attribute Risk).
#Aggregate proper gender/race for Rectal, Proximal, and Distal cancer and Competing Hazards.
#For each age from start to stop, multiply 

class CcratConstants:
  #Age Intervals:   [50:54,         55:59,        60:64,        65:69,        70:74,        75:79,        80:84,        85:89]
  CANCER_RATES = {
    "Male": {
      "White": {
        "rectal":   [0.00021124016, 0.0003578343, 0.0005356635, 0.0007856330, 0.0009257527, 0.0010657938, 0.0012010900, 0.0011884848],
        "proximal": [0.00015490945, 0.0002836243, 0.0005019932, 0.0008204589, 0.0012469950, 0.0017402817, 0.0022855145, 0.0026821212],
        "distal":   [0.00014485039, 0.0002785414, 0.0004693433, 0.0007129081, 0.0009062523, 0.0011049244, 0.0012323955, 0.0012173939]
      },
      "Black": {
        "rectal":   [0.00024599720, 0.0003492975, 0.0005642569, 0.0006438935, 0.0007777330, 0.0009580642, 0.0009500435, 0.0007192391],
        "proximal": [0.00029682310, 0.0004984047, 0.0008048450, 0.0010912740, 0.0014447670, 0.0019786960, 0.0023463200, 0.0027588720],
        "distal":   [0.00019313830, 0.0003120207, 0.0005140623, 0.0006522557, 0.0009764239, 0.0010714680, 0.0012307380, 0.0010520210]
      },
      "Hispanic": {
        "rectal":   [0.00018550970, 0.0002955000, 0.0004464836, 0.0006712931, 0.0006900790, 0.0008980813, 0.0011264120, 0.0009662390],
        "proximal": [0.00011958480, 0.0001751509, 0.0003261149, 0.0006041638, 0.0008705236, 0.0011794540, 0.0013164930, 0.0013680410],
        "distal":   [0.00011421880, 0.0001880455, 0.0003751022, 0.0005624348, 0.0006461870, 0.0007901573, 0.0007744079, 0.0007270710]
      },
      "Asian": {
        "rectal":   [0.00025916020, 0.0004029752, 0.0005275801, 0.0007305318, 0.0008763499, 0.0010291130, 0.0011711580, 0.0010754240],
        "proximal": [0.00010384470, 0.0001819494, 0.0002947375, 0.0005208262, 0.0008440420, 0.0011584550, 0.0013350230, 0.0015156980],
        "distal":   [0.00014899460, 0.0002991785, 0.0004701063, 0.0007545963, 0.0009490425, 0.0011050310, 0.0013253840, 0.0012991700]
      }
    },
    "Female": {
      "White": {
        "rectal":   [0.00013300000, 0.0002103312, 0.0003100585, 0.0004161709, 0.0005203058, 0.0006476476, 0.0007651407, 0.0008282269],
        "proximal": [0.00012300000, 0.0002344841, 0.0004279824, 0.0006915781, 0.0010539000, 0.0014967170, 0.0020116470, 0.0024187740],
        "distal":   [0.00011500000, 0.0001871847, 0.0003039590, 0.0004202510, 0.0005887940, 0.0006786356, 0.0007872120, 0.0008479989]
      },
      "Black": {
        "rectal":   [0.00017101960, 0.0002702230, 0.0003279893, 0.0003819875, 0.0004723062, 0.0005504391, 0.0006173157, 0.0006328520],
        "proximal": [0.00026469370, 0.0004093591, 0.0006643885, 0.0009222040, 0.0012949710, 0.0015761470, 0.0019989270, 0.0019720480],
        "distal":   [0.00017016030, 0.0002495251, 0.0003574242, 0.0005418148, 0.0006600673, 0.0007904985, 0.0008267621, 0.0008778269]
      },
      "Hispanic": {
        "rectal":   [0.00011109990, 0.0001633839, 0.0002047256, 0.0003613020, 0.0003827081, 0.0004922947, 0.0004942689, 0.0005834361],
        "proximal": [0.00009970502, 0.0001518509, 0.0002880441, 0.0004466489, 0.0006029458, 0.0008608713, 0.0011968660, 0.0014397700],
        "distal":   [0.00010255370, 0.0001451234, 0.0002094867, 0.0002830673, 0.0003664611, 0.0004304357, 0.0004779295, 0.0005787309]
      },
      "Asian": {
        "rectal":   [0.00015156480, 0.0002323163, 0.0002612616, 0.0003685268, 0.0004551240, 0.0005295132, 0.0006787809, 0.0006916783],
        "proximal": [0.00009969233, 0.0001828415, 0.0002430340, 0.0004698716, 0.0006277572, 0.0009030288, 0.0013241790, 0.0014422230],
        "distal":   [0.00017993250, 0.0002075789, 0.0003025774, 0.0004027471, 0.0005100527, 0.0006525536, 0.0008345666, 0.0008486549]
      }
    }
  }
  #Age Intervals: [50:54,           55:59,        60:64,        65:69,        70:74,        75:79,        80:84,        85:89       ]
  COMPETING_HAZARDS = {
    "Male": {
      "White":      [0.005925000,   0.009422000,  0.015259000,  0.024038000,  0.03674100,   0.05680100,   0.09078900,   0.17206000  ],
      "Black":      [0.012980990,   0.018749910,  0.026639260,  0.036625910,  0.05390114,   0.07254379,   0.10465670,   0.16184630  ],
      "Hispanic":   [0.005443669,   0.008031369,  0.012201550,  0.018639800,  0.02857283,   0.04344392,   0.06740426,   0.12528380  ],
      "Asian":      [0.001845804,   0.003296273,  0.005037185,  0.007990520,  0.01331962,   0.02067203,   0.03436599,   0.06001890  ]
    },
    "Female": {
      "White":      [0.003470000,   0.005648000,  0.009149000,  0.014204000,  0.022322000,  0.03557300,   0.05998600,   0.14030800  ],
      "Black":      [0.007032216,   0.010488400,  0.015447410,  0.022107450,  0.032484820,  0.04531423,   0.06828158,   0.12967860  ],
      "Hispanic":   [0.002782463,   0.004357588,  0.007048012,  0.011122880,  0.017397910,  0.02696323,   0.04522219,   0.10264220  ],
      "Asian":      [0.001103589,   0.002034818,  0.002446459,  0.005315876,  0.007556335,  0.01293654,   0.02051703,   0.04086728  ]
    }
  }

  ATTRIBUTE_RISKS = {
    "Male": {
      "rectal":       0.099728891869,
      "proximal":     0.136245677145,
      "distal":       0.275494599554
    },
    "Female": {
      "rectal":       0.0734559,
      "proximal":     0.1886108,
      "distal":       0.1779839,
      "distalOver65": 0.1480757
    }
  }
  #Relative Risk flags [negative screening,  no screening,         positive screening,  screening unknown,
  #                       Never smoked,        smoked 15-30 years,   smoked 35+ years,    cigarettes smoked daily,
  #                       No NSAID regimine,   Non-Aspirin (or No) Regimine,
  #                       Relative w/ cancer,  Number of relatives w/ Colorectal cancer,
  #                       average exercise/wk, exercise 5+ hrs/wk,  3-4 hours per week,   1-2 hrs/wk
  #                       Less than 5 servings a month,
  #                       BMI Trend,
  #                       No Hormone Use,
  #                       BMI*HormonesUsed]
  COVARIATES = {
    "Male": {
      "rectal":        [0.6760430335,        2.0252428101,         1.3283598064,        0,
                          0,                   0,                    0,                   0,
                          0,                   0.4202874746,
                          0.4006854532,        0,
                          0.1882660083,        0,                    0,                   0,
                          0,
                          0,
                          0,
                          0],
      "proximal":      [0,                   0.3511482106,         0.5707313462,        0.4541009837,
                          0.5101756750,        0.3843918169,         0.1129943060,        0.2656643161,
                          0.4343130874,        0,
                          0,                   0.5935996371,
                          0,                   0,                    0,                   0,
                          0.5536174113,
                          0.2327835021,
                          0,
                          0],
      "distal":        [0,                   1.0404879015,         0.2956944224,        0.9602749397,
                          0,                   0,                    0,                   0,
                          0.3413610714,        0,
                          0,                   0.5158856117,
                          0,                   0,                    0,                   0,
                          0,
                          0.3197633636,
                          0,
                          0]
    },
    "Female": {
      "rectal":        [1.0026582,           2.0981550,            2.1632906,           0,
                          0,                   0,                    0,                   0,
                          0.3561877,        0,
                          0.4277258,        0,
                          0,                   0.4620743,         0.0927766,        0.2250899,
                          0,
                          0.3388585,
                          0.3993965,
                          0],
      "proximal":      [0,                   0.5995456,         0.9630810,        0.6048391,
                          0,                   0,                    0,                   0,
                          0.4661512,        0,
                          0,                   0.4103523,
                          0.1458625,        0,                    0,                   0,
                          0.3270045,
                          0,
                          0.3823322,
                          0],
      "distal":        [0,                   1.2356447,         1.4698426,        1.1528665,
                          0,                   0,                    0,                   0,
                          0.3642435,                   0,
                          0,                   0.3693600,
                          0,                   0,                    0,                   0,
                          0,
                          0.0771453,
                          0.7421865,
                          0.9873503]
    }
  }