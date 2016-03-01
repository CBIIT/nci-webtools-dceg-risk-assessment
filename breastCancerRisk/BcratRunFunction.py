from BcratConstants import BcratConstants
import math

# rhyp    yes = 1.82
#          no = 0.93
#       other = 1.00
def AbsRisk(self, riskType, race, currentAge, projectionAge, menarcheAge, numberOfBiopsy, firstLiveBirthAge, firstDegRelatives, rhyp):
  if projectionAge <= currentAge:
    raise RuntimeError("projectionAge must be greater than the current age")
  if (race == "Black" and menarcheAge == 2):
    menarcheAge = 1
    firstLiveBirthAge = 0
  covariateBreakdown = [
    # age of menarchy                   0=[14, 39] U 99 (unknown)
    #                                   1=[12, 14)
    #                                   2=[ 7, 12)
    menarcheAge,
    # number of biopsies performed      0=0 or (99 and ever had biopsy=99)
    #                                   1=1 or (99 and ever had biopsy=1)
    #                                   2=[ 2, 30]
    numberOfBiopsy,
    # age of first live birth           0=<20, 99 (unknown)
    #                                   1=[20, 25)
    #                                   2=[25, 30) U 0
    #                                   3=[30, 55]
    firstLiveBirthAge,
    # number of first degree relatives  0=0, 99 (unknown)
    #                                   1=1
    #                                   2=[2, 31]
    firstDegRelatives,
    # biopsies indicator * age >= 50
    (numberOfBiopsy if currentAge >= 50 else 0),
    # first birth * number of relatives
    firstLiveBirthAge * firstDegRelatives
  ]
  currentAgeInterval = int(math.floor(currentAge/5.0))-4
  projectionAgeInterval = int(math.ceil(projectionAge/5.0))-5
  raceCovariants = BcratConstants.COVARIANTS                 [race]
  raceHazards   =  BcratConstants.COMPETING_HAZARDS[riskType][race]
  raceIncidence =  BcratConstants.CANCER_INCIDENCE [riskType][race]
  raceAttribute =  BcratConstants.ATTRIBUTE_RISK   [riskType][race]
  covariateSummary       = math.exp(sum([x*y for x,y in zip(raceCovariants,covariateBreakdown)]) + math.log(rhyp))
  over50CovariateSummary = math.exp(sum([x*y for x,y in zip(raceCovariants,covariateBreakdown[:4]+[numberOfBiopsy]+covariateBreakdown[5:])]) + math.log(rhyp))
  absRisk = 1.0
  currentCancerRisk = raceIncidence[currentAgeInterval] * raceAttribute[currentAgeInterval] * covariateSummary
  currentDeathRisk = currentCancerRisk + raceHazards[currentAgeInterval]
  if (projectionAge <= currentAgeInterval*5+25):
    absRisk -= math.exp(-currentDeathRisk * (projectionAge - currentAge))
    absRisk *= currentCancerRisk / currentDeathRisk
  else:
    absRisk -= math.exp(-currentDeathRisk * (currentAgeInterval*5+25 - currentAge))
    absRisk *= currentCancerRisk / currentDeathRisk
    if (projectionAgeInterval - currentAgeInterval > 0):
      riskMod = 1.0
      if (projectionAge > 50.0 and currentAge < 50.0):
        projectedCancerRisk = raceIncidence[projectionAgeInterval] * raceAttribute[projectionAgeInterval] * over50CovariateSummary
        projectedDeathRisk = projectedCancerRisk + raceHazards[projectionAgeInterval]
        riskMod -= math.exp(-projectedDeathRisk * (projectionAge - projectionAgeInterval*5-20))
        riskMod *= projectedCancerRisk / projectedDeathRisk
        riskMod *= math.exp(-currentDeathRisk * (currentAgeInterval*5+25 - currentAge))
        for j in range(currentAgeInterval+1, projectionAgeInterval):
          riskMod *= math.exp(-(raceIncidence[j] * raceAttribute[j] * (over50CovariateSummary if j >= 6.0 else covariateSummary) + raceHazards[j]) * 5)
      else:
        interimCancerRisk = raceIncidence[projectionAgeInterval] * raceAttribute[projectionAgeInterval] * covariateSummary
        interimDeathRisk = interimCancerRisk + raceHazards[projectionAgeInterval]
        riskMod -= math.exp(-interimDeathRisk * (projectionAge - projectionAgeInterval*5-20))
        riskMod *= interimCancerRisk / interimDeathRisk
        riskMod *= math.exp(-currentDeathRisk * (currentAgeInterval*5+25 - currentAge))
        for j in range(currentAgeInterval+1, projectionAgeInterval):
          riskMod *= math.exp(-(raceIncidence[j] * raceAttribute[j] * covariateSummary + raceHazards[j]) * 5)
      absRisk += riskMod
    if (projectionAgeInterval - currentAgeInterval > 1):
      if (projectionAge > 50.0 and currentAge < 50.0):
        for k in range(currentAgeInterval+1, projectionAgeInterval):
          riskMod = 1.0
          kCancerRisk = raceIncidence[k] * raceAttribute[k]
          if (k >= 6.0):
            riskMod -= math.exp(-(kCancerRisk * over50CovariateSummary + raceHazards[k]) * 5)
            riskMod *= kCancerRisk * over50CovariateSummary / (kCancerRisk * over50CovariateSummary + raceHazards[k])
          else:
            riskMod -= math.exp(-(kCancerRisk * covariateSummary + raceHazards[k]) * 5)
            riskMod *= kCancerRisk * covariateSummary / (kCancerRisk * covariateSummary + raceHazards[k])
          riskMod *= math.exp(-currentDeathRisk * (currentAgeInterval*5+25 - currentAge))
          for j in range(currentAgeInterval+1, k):
            if j >= 6.0:
              riskMod *= math.exp(-(raceIncidence[j] * raceAttribute[j] * over50CovariateSummary + raceHazards[j]) * 5)
            else:
              riskMod *= math.exp(-(raceIncidence[j] * raceAttribute[j] * covariateSummary + raceHazards[j]) * 5)
          absRisk += riskMod
      else:
        for k in range(currentAgeInterval+1, projectionAgeInterval):
          kCancerRisk = raceIncidence[k] * raceAttribute[k]
          riskMod = 1.0 - math.exp(-(kCancerRisk * covariateSummary + raceHazards[k]) * 5)
          riskMod *= kCancerRisk * covariateSummary / (kCancerRisk * covariateSummary + raceHazards[k])
          riskMod *= math.exp(-currentDeathRisk * (currentAgeInterval*5+25-currentAge))
          for j in range(currentAgeInterval+1, k):
            riskMod *= math.exp(-(raceIncidence[j] * raceAttribute[j] * covariateSummary + raceHazards[j]) * 5)
          absRisk += riskMod
  return absRisk
