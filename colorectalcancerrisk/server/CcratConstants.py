#Considering only the selected covarients, multiply by the (1-Attribute Risk).
#Aggregate proper gender/race for Rectal, Proximal, and Distal cancer and Competing Hazards.
#For each age from start to stop, multiply

class CcratConstants:
  #Age Intervals:   [45:49          50:54,         55:59,        60:64,        65:69,        70:74,        75:79,        80:84,        85:89]
  CANCER_RATES = {
    "Male": {
      "White": {
        "rectal":   [0.00015404,    0.000279069,   0.000311145,  0.000388472,  0.000475544,  0.000536782,  0.000626264, 0.000673191,   0.000685024],
        "proximal": [0.000094396,   0.000165414,   0.000228887,  0.000343665,  0.000543806,  0.000822461,  0.001096504, 0.001453321,   0.001621485],
        "distal":   [0.000096446,   0.000190759,   0.000210349,  0.000289598,  0.000388529,  0.00047729,   0.0005568,   0.00063606,    0.000652245]
      },
      "Black": {
        "rectal":   [0.000147764,   0.00031165,    0.000387965,  0.000499556,  0.000557388,  0.000618423,  0.000599039, 0.000824465,   0.000632715],
        "proximal": [0.000147764,   0.000272013,   0.000427224,  0.000564453,  0.000923829,  0.001105514,  0.001283655, 0.00170782,    0.001431651],
        "distal":   [0.000120181,   0.000230889,   0.000290974,  0.00045277,   0.000560699,  0.000674946,  0.000790329, 0.000744542,   0.000691696]
      },
      "Hispanic": {
        "rectal":   [0.000114764,   0.0002375,     0.000311163,  0.000400663,  0.000523825,  0.00057289,   0.000599579,  0.000725084,  0.000661517],
        "proximal": [0.000063079,   0.000134852,   0.000198053,  0.000317448,  0.000481992,  0.000707204,  0.000855138,  0.001075836,  0.001271582],
        "distal":   [0.00007336,    0.000156656,   0.000205095,  0.000286011,  0.000428336,  0.00047284,   0.000593682,  0.000621922,  0.000558614]
      },
      "Asian": {
        "rectal":   [0.00013998,    0.000303994,   0.000346034,  0.00044832,   0.000535561,  0.000548544,  0.000607099,  0.000720916,  0.000669886],
        "proximal": [0.000067319,   0.000103039,   0.000149862,  0.000234278,  0.000378658,  0.000463702,  0.00059058,   0.000792386,  0.000964496],
        "distal":   [0.000089224,   0.000199816,   0.000229617,  0.000376713,  0.00049895,   0.000533916,  0.000660788,  0.000699164,  0.000747046]
      }
    },
    "Female": {
      "White": {
        "rectal":   [0.000120561,   0.000201265,   0.000190476,  0.000223127,  0.000270298,  0.000301295,  0.000365468,  0.000407899,  0.000439046],
        "proximal": [0.000084588,   0.000140409,   0.000189659,  0.000300741,  0.000473394,  0.000732341,  0.00106824,   0.001412928,  0.001533784],
        "distal":   [0.000094684,   0.000143584,   0.000145466,  0.000163728,  0.000224999,  0.000291184,  0.000355425,  0.000442591,  0.000430304]
      },
      "Black": {
        "rectal":   [0.000108651,   0.000255288,   0.000241062,  0.000246203,  0.000349144,  0.000333772,  0.000377542,  0.000454859,  0.00039187],
        "proximal": [0.000151052,   0.000251306,   0.000324584,  0.000525027,  0.000704279,  0.000977218,  0.001168896,  0.001277825,  0.001348032],
        "distal":   [0.000109976,   0.000189807,   0.000216556,  0.000256666,  0.000346577,  0.00039161,   0.00050284,   0.000468927,  0.000503832]
      },
      "Hispanic": {
        "rectal":   [0.000082482,   0.000164631,   0.00019936,   0.000223059,  0.000275521,  0.000255463,  0.000311729,  0.000375954,  0.000388896],
        "proximal": [0.000066388,   0.00012389,    0.000176053,  0.000268004,  0.000423231,  0.000554567,  0.000741255,  0.001078394,  0.001048329],
        "distal":   [0.000069836,   0.000147266,   0.000153994,  0.000196425,  0.000221948,  0.000254398,  0.00030311,   0.000330444,  0.000367761]
      },
      "Asian": {
        "rectal":   [0.000103437,   0.000193699,   0.000188894,  0.000224919,  0.000296103,  0.00029365,   0.000340634,  0.000437537,  0.000408177],
        "proximal": [0.000053616,   0.000100086,   0.000124659,  0.000187112,  0.000319276,  0.000435739,  0.000562046,  0.000842051,  0.00099709],
        "distal":   [0.00008683,    0.000172785,   0.000157321,  0.000205054,  0.000276363,  0.000341013,  0.000379342,  0.000456111,  0.000503622]
      }
    }
  }
  #Age Intervals: [45:49        50:54,           55:59,        60:64,        65:69,        70:74,        75:79,        80:84,        85:89       ]
  COMPETING_HAZARDS = {
    "Male": {
      "White":      [0.003880489,   0.005977758,    0.008746618,    0.012207925,    0.017445394,     0.026850993,     0.042880578,     0.07182451,  0.15326379],
      "Black":      [0.005374977,   0.008527183,    0.01348236,     0.019635905,    0.026224221,     0.037208311,     0.053555824,     0.079356856, 0.136105911],
      "Hispanic":   [0.002755742,   0.00441541,     0.006694739,    0.009789987,    0.013955647,     0.021310691,     0.033762895,     0.05510037,  0.106585778],
      "Asian":      [0.001627231,   0.002519184,    0.003990335,    0.006037592,    0.008857362,     0.014030781,     0.023964808,     0.042910879, 0.097537978]
    },
    "Female": {
      "White":      [0.002455866,   0.003675325,    0.005172382,    0.007422948,    0.01151871,     0.018519935,      0.030772108,      0.052985389,    0.133512135],
      "Black":      [0.003658655,   0.005618185,    0.008157399,    0.011336293,    0.015888539,    0.023582038,      0.035579973,      0.056318842,    0.120125854],
      "Hispanic":   [0.001489034,   0.002339127,    0.003524357,    0.005507226,    0.008407629,    0.013350759,      0.022836228,      0.040383996,    0.096770185],
      "Asian":      [0.000960654,   0.001474481,    0.002227591,    0.003456956,    0.00543539,     0.00913529,       0.016641935,      0.031301192,    0.081374093]
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