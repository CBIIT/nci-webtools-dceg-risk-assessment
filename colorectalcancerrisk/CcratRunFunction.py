from CcratConstants import CcratConstants
import math

def AbsRisk(gender, race, startAge, upperBoundAge, screening, yearsSmoking, cigarettesPerDay, nsaidRegimine, aspirinOnly, familyHistory, averageExercise, servingsPerDay, bmiTrend, hormoneUsage):
  genderRaceRisk       = CcratConstants.CANCER_RATES     [gender][race]
  genderRaceHazards    = CcratConstants.COMPETING_HAZARDS[gender][race]
  genderAttributeRisks = CcratConstants.ATTRIBUTE_RISKS  [gender]
  genderCovariates     = CcratConstants.COVARIATES       [gender]

  print("--- Inside AbsRisk")

  if gender == "Male" and yearsSmoking == 0 and cigarettesPerDay > 0:
    cigarettesPerDay = 0
    yearsSmoking = 0

  if gender == "Male" and yearsSmoking > 0 and cigarettesPerDay == 0:
    cigarettesPerDay = 0
    yearsSmoking = 0

  print( "Values for CigarettesPerDay/yearsSmoking might have been changed")
  print( "New Values cigarettesPerDay : " + str(cigarettesPerDay))
  print( "New Values yearsSmoking     : " + str(yearsSmoking))

  #screening risk
  covariate_breakdown = covariteBreakdown(gender, race, startAge, upperBoundAge, screening, yearsSmoking, cigarettesPerDay, nsaidRegimine, aspirinOnly, familyHistory, averageExercise, servingsPerDay, bmiTrend, hormoneUsage)
  rectal_covariates   = math.exp(sum([x*y for x,y in zip(covariate_breakdown,genderCovariates["rectal"  ])]))*genderAttributeRisks["rectal"  ]
  proximal_covariates = math.exp(sum([x*y for x,y in zip(covariate_breakdown,genderCovariates["proximal"])]))*genderAttributeRisks["proximal"]
  distal_covariates   = math.exp(sum([x*y for x,y in zip(covariate_breakdown,genderCovariates["distal"  ])]))
  #relational risk factors become less relavent for distal cancer as the age goes up
  absRisk = 0
  survivalRate = 1
  for currentAge in range(startAge,upperBoundAge):
    ageInterval = int(math.floor((currentAge-50)/5))
    yearlyHazards = rectal_covariates  *genderRaceRisk["rectal"]  [ageInterval] + \
                    proximal_covariates*genderRaceRisk["proximal"][ageInterval]
    if gender == "Female" and currentAge >= 65:
      yearlyHazards += distal_covariates *genderRaceRisk["distal"]  [ageInterval]*genderAttributeRisks["distalOver65"]
    else:
      yearlyHazards += distal_covariates *genderRaceRisk["distal"]  [ageInterval]*genderAttributeRisks["distal"      ]
    yearlyDeathRatio = yearlyHazards+genderRaceHazards[ageInterval]
    yearlyDeathRate = math.exp(-yearlyDeathRatio)
    absRisk += yearlyHazards/yearlyDeathRatio*survivalRate*(1-yearlyDeathRate)
    survivalRate *= yearlyDeathRate


  return absRisk

def AvgRisk(gender, race, startAge, upperBoundAge, screening, yearsSmoking, cigarettesPerDay, nsaidRegimine, aspirinOnly, familyHistory, averageExercise, servingsPerDay, bmiTrend, hormoneUsage):
  genderRaceRisk       = CcratConstants.CANCER_RATES     [gender][race]
  genderRaceHazards    = CcratConstants.COMPETING_HAZARDS[gender][race]
  genderAttributeRisks = CcratConstants.ATTRIBUTE_RISKS  [gender]

  print("--- Inside Average Risk")

  print("The gender Attribute Risks are : " + str(genderAttributeRisks))

  # set the variables genderAttributeRisks to One
  genderAttributeRisks = { x:1 for x in genderAttributeRisks }
  print("Fix : The gender covariates = " + str(genderAttributeRisks))

  print("Pass genderAttributeRisks")

  #screening risk
  covariate_breakdown = covariteBreakdown(gender, race, startAge, upperBoundAge, screening, yearsSmoking, cigarettesPerDay, nsaidRegimine, aspirinOnly, familyHistory, averageExercise, servingsPerDay, bmiTrend, hormoneUsage)

  print("Pass the covariate breakdown")

  # Set the variables rectal_covariates proximal_covariates and distal_covariates all equal to one
  rectal_covariates   = 1
  proximal_covariates = 1
  distal_covariates   = 1

  print("Rectal Covariates   --> " + str(rectal_covariates))
  print("Proximal Covariates --> " + str(proximal_covariates))
  print("Distal Covariates   --> " + str(distal_covariates))

  print("Pass the covariates")

  
  #relational risk factors become less relavent for distal cancer as the age goes up
  absRisk = 0
  survivalRate = 1
  for currentAge in range(startAge,upperBoundAge):
    ageInterval = int(math.floor((currentAge-50)/5))
    yearlyHazards = rectal_covariates  *genderRaceRisk["rectal"]  [ageInterval] + \
                    proximal_covariates*genderRaceRisk["proximal"][ageInterval]
    if gender == "Female" and currentAge >= 65:
      yearlyHazards += distal_covariates *genderRaceRisk["distal"]  [ageInterval]*genderAttributeRisks["distalOver65"]
    else:
      yearlyHazards += distal_covariates *genderRaceRisk["distal"]  [ageInterval]*genderAttributeRisks["distal"      ]
    yearlyDeathRatio = yearlyHazards+genderRaceHazards[ageInterval]
    yearlyDeathRate = math.exp(-yearlyDeathRatio)
    absRisk += yearlyHazards/yearlyDeathRatio*survivalRate*(1-yearlyDeathRate)
    survivalRate *= yearlyDeathRate

  print("Fix Making sure they did not change : The gender covariates = " + str(genderAttributeRisks))

  return absRisk

def covariteBreakdown(gender, race, startAge, upperBoundAge, screening, yearsSmoking, cigarettesPerDay, nsaidRegimine, aspirinOnly, familyHistory, averageExercise, servingsPerDay, bmiTrend, hormoneUsage):
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
    #servingsPerDay:   [0] >= 2.5 cups of veggies
    #                  [1]  < 2.5 cups
    servingsPerDay,
    #bmiTrend:         [0] men: < 24.9              women: < 30
    #                  [1] men: >=24.9 & < 29.9     women: >=30
    #                  [2] men: >=29.9              women: N/A
    bmiTrend,
    #hormoneUsage:     [0] Hormones used
    #                  [1] No hormones used in the last 2 years
    hormoneUsage,
    #bmi*hormoneUsage  [1] BMI >= 30 and no hormones used
    #                  [0] All other conditions
    bmiTrend*(1-hormoneUsage)
  ];

  return covariate_breakdown


