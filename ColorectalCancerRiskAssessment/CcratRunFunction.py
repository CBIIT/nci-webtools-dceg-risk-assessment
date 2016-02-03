from CcratConstants import CcratConstants
import math

def AbsRisk(gender, race, startAge, upperBoundAge, screening, yearsSmoking, cigarettesPerDay, nsaidRegimine, aspirinOnly, familyHistory, averageExercise, servingsPerMonth, bmiTrend, hormoneUsage):
  genderRaceRisk       = CcratConstants.CANCER_RATES     [gender][race]
  genderRaceHazards    = CcratConstants.COMPETING_HAZARDS[gender][race]
  genderAttributeRisks = CcratConstants.ATTRIBUTE_RISKS  [gender]
  genderCovariates     = CcratConstants.COVARIATES       [gender]
  #screening risk
  covariate_breakdown = [
    #screening:        [0] Sigmoidoscopy or Colonoscopy with no sign of polyps
    1 if screening==0 else 0,
    #                  [1] No Screening done
    1 if screening==1 else 0,
    #                  [2] Sigmoidoscopy or Colonoscopy with polps found
    1 if screening==2 else 0,
    #                  [3] Don't know if a Sigmoidoscopy or Colonoscopy was done
    1 if screening==3 else 0,
    #yearsSmoking:     [0] Never smoked
    1 if yearsSmoking==0 else 0,
    #                  [1]  1-14 (Ignored)
    #                  [2] 15-34
    1 if yearsSmoking==2 else 0,
    #                  [3]    35+
    1 if yearsSmoking==3 else 0,
    #cigarettesPerDay: [0]     0 per day
    #                  [1]  1-10
    #                  [2] 11-20
    #                  [3]    21+
    cigarettesPerDay,
    #nsaidRegimine:    [0] Yes, on a regimine
    #                  [1] No
    nsaidRegimine,
    #aspirinOnly:      [0] Non-Aspirin medications are part of the NSAID regimine
    #                  [1] Aspirin-only Regimine or there is no NSAID regimine
    aspirinOnly,
    #familyHistory:    [0] No relatives with Colorectal Cancer
    1 if familyHistory>0 else 0,
    #                  [1] 1 relative
    #                  [2] 2 or more relatives
    2 if familyHistory>2 else familyHistory,
    #averageExercise:  [0]   5+ hours
    #                  [1] 3-4
    #                  [2] 1-2
    #                  [3]   0
    averageExercise,
    1 if averageExercise==3 else 0,
    1 if averageExercise==2 else 0,
    1 if averageExercise==1 else 0,
    #servingsPerMonth: [0]   5+ servings
    #                  [1] 0-4
    servingsPerMonth,
    #bmiTrend:         [0] men: N/A              women: < 30
    #                  [1] men: < 24.9           women: >=30
    #                  [2] men: >=24.9 & < 29.9  women: N/A
    #                  [3] men: >=29.9           women: N/A
    bmiTrend,
    #hormoneUsage:     [0] No hormones used in the last 2 years
    #                  [1] Hormones used
    hormoneUsage
  ];
  #rectal_covariates   = sum([math.exp(x*y) for x,y in zip(covariate_breakdown,genderCovariates["rectal"  ])])*genderAttributeRisks["rectal"  ]
  rectal_covariates   = math.exp(sum([x*y for x,y in zip(covariate_breakdown,genderCovariates["rectal"  ])]))*genderAttributeRisks["rectal"  ]
  #proximal_covariates = sum([math.exp(x*y) for x,y in zip(covariate_breakdown,genderCovariates["proximal"])])*genderAttributeRisks["proximal"]
  proximal_covariates = math.exp(sum([x*y for x,y in zip(covariate_breakdown,genderCovariates["proximal"])]))*genderAttributeRisks["proximal"]
  #distal_covariates   = sum([math.exp(x*y) for x,y in zip(covariate_breakdown,genderCovariates["distal"  ])])
  distal_covariates   = math.exp(sum([x*y for x,y in zip(covariate_breakdown,genderCovariates["distal"  ])]))
  #relational risk factors become less relavent for distal cancer as the age goes up
  if gender == "Female" and age >= 65:
    distal_covariates *= genderAttributeRisks["distalOver65"]
  else:
    distal_covariates *= genderAttributeRisks["distal"      ]
  absRisk = 0
  survivalRate = 1
  for currentAge in range(startAge,upperBoundAge):
    ageInterval = int(math.floor((currentAge-50)/5))
    yearlyHazards = rectal_covariates  *genderRaceRisk["rectal"]  [ageInterval] + \
                    proximal_covariates*genderRaceRisk["proximal"][ageInterval] + \
                    distal_covariates  *genderRaceRisk["distal"]  [ageInterval]
    #yearlySurvival = math.exp(-yearlyHazards-genderRaceHazards[ageInterval])
    yearlyDeathRatio = yearlyHazards+genderRaceHazards[ageInterval]
    yearlyDeathRate = math.exp(-yearlyDeathRatio)
    #absRisk += yearlyHazards/(yearlyHazards+genderRaceHazards[ageInterval])*(1-yearlySurvival)*survivalRate
    absRisk += yearlyHazards/yearlyDeathRatio*survivalRate*(1-yearlyDeathRate)
    survivalRate *= yearlyDeathRate

  return absRisk

