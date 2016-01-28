from BcratConstants import BcratConstants
import math

def AverageRisk(race, currentAge, projectionAge):
  return AbsRisk(race, currentAge, projectionAge, 0, 0, 0, 0, 1.0)

def AbsRisk(race, currentAge, projectionAge, numberOfBiopsy, menarcheAge, firstLiveBirthAge, firstDegRelatives, rhyp):
  if projectionAge <= currentAge:
    raise RuntimeError("projectionAge must be greater than the current age")
  raceAttribute  = BcratConstants.ATTRIBUTE_RISK   ["Absolute"][race]
  raceHazards    = BcratConstants.COMPETING_HAZARDS["Absolute"][race]
  raceIncidence  = BcratConstants.INCIDENCE        ["Absolute"][race]
  raceCovariants = BcratConstants.COVARIANTS       ["Absolute"][race]
  currentAgeInterval    = int(math.floor(currentAge   /5))-4
  projectionAgeInterval = int(math.floor(projectionAge/5))-4
  #age ge 50 ind  0=[20, 50)
  #               1=[50, 85)
  if (race == "Black" and menarcheAge == 2):
    menarcheAge = 1;        // recode agemen=2 (age<12) to agmen=1 [12,13]
    firstLiveBirthAge = 0;  // set age 1st live birth to 0
  covariateBreakdown = [
    # age of menarchy  0=[14, 39] U 99 (unknown)
    #                  1=[12, 14)
    #                  2=[ 7, 12)
    menarcheAge,
    # number of biopsies performed  0=0 or (99 and ever had biopsy=99)
    #                               1=1 or (99 and ever had biopsy=1)
    #                               2=[ 2, 30]
    numberOfBiopsy,
    # age of first live birth  0=<20, 99 (unknown)
    #                          1=[20, 25)
    #                          2=[25, 30) U 0
    #                          3=[30, 55]
    firstLiveBirthAge,
    # number of first degree relatives  0=0, 99 (unknown)
    #                                   1=1
    #                                   2=[2, 31]
    firstDegRelatives,
    # biopsies indicator * age >= 50
    (numberOfBiopsy if currentAge>=50 else 0),
    # first birth * number of relatives
    firstLiveBirthAge * firstDegRelatives
  ]
  covariateSummary = math.exp(sum([x*y for x,y in zip(covariateBreakdown,raceCovariants)]) + Math.Log(rhyp))
  cancerIncidence = raceIncidence[currentAgeInterval]*raceAttribute[currentAgeInterval]*covariateSummary
  deathRate = cancerIncidence+raceHazards[currentAgeInterval]
  absRisk = 1.0
  if (projectionAgeInterval == currentAgeInterval):
    absRisk -= math.exp(-deathRate*(projectionAge-currentAge))
    absRisk *= cancerIncidence/deathRate
  else:
    absRisk -= math.exp(-deathRate*(currentAgeInterval*5+25-currentAge))
    absRisk *= cancerIncidence/deathRate
    if projectionAgeInterval-currentAgeInterval > 0:
      riskMod = 1.0
      projectedAttributeIncidence = raceIncidence[projectionAgeInterval]*raceAttribute[projectionAgeInterval]
      if (projectionAge > 50 and currentAge < 50.0):
        projectedCovariateSummary = math.exp(sum([x*y for x,y in zip([menarcheAge, numberOfBiopsy, firstLiveBirthAge, firstDegRelatives, numberOfBiopsy, firstLiveBirthAge * firstDegRelatives],raceCovariants)]) + Math.Log(rhyp))
        projectedCancerIncidence = projectedAttributeIncidence*projectedCovariateSummary
        projectedDeathRate = projectedCancerIncidence+raceHazards[projectionAgeInterval]
        riskMod -= math.exp(-projectedDeathRate*(projectionAge-projectionAgeInterval*5-20))
        riskMod *= projectedCancerIncidence/projectedDeathRate
        riskMod *= math.exp(-deathRate*(currentAgeInterval*5+25-currentAge))
        for j in (currentAgeInterval,projectionAgeInterval):
          if (j >= 6):
            riskMod *= math.exp(-(raceIncidence[j]*raceAttribute[j] * projectedCovariateSummary + raceHazards[j]) * 5);
          else:
            riskMod *= math.exp(-(raceIncidence[j]*raceAttribute[j] * covariateSummary + raceHazards[j]) * 5);
      else:
        interstitialCancerIncidence = projectedAttributeIncidence*covariateSummary
        interstitialDeathRate = interstitialCancerIncidence+raceHazards[projectionAgeInterval]
        riskMod -= math.exp(-interstitialDeathRate*(projectionAge-projectionAgeInterval*5-20))
        riskMod *= interstitialCancerIncidence/interstitialDeathRate
        riskMod *= math.exp(-deathRate*(currentAgeInterval*5+25-currentAge))
        for j in range(currentAgeInterval,projectionAgeInterval)
          riskMod *= math.exp(-(raceIncidence[j]*raceAttribute[j] * covariateSummary + raceHazards[j]) * 5)
      absRisk += riskMod;
      if projectionAgeInterval-currentAgeInterval > 1:
        if projectionAge > 50.0 and currentAge < 50.0:
          for k in range(currentAgeInterval+2,projectionAgeInterval):
            riskMod = 1.0
            if k >= 7:
              riskMod -= math.exp(-(raceIncidence[k]*raceAttribute[k] * projectedCovariateSummary + raceHazards[k]) * 5)
              riskMod *= raceIncidence[k]*raceAttribute[k] * projectedCovariateSummary / (raceIncidence[k]*raceAttribute[k] * projectedCovariateSummary + raceHazards[k])
            else:
              riskMod -= math.exp(-(raceIncidence[k - 1]*raceAttribute[k - 1] * covariateSummary + raceHazards[k - 1]) * (t[k] - t[k - 1]))
              riskMod *= raceIncidence[k]*raceAttribute[k] * covariateSummary / (raceIncidence[k]*raceAttribute[k] * covariateSummary + raceHazards[k])
            riskMod *= math.exp(-deathRate*(currentAgeInterval*5+25-currentAge))
            for j in range(currentAgeInterval+1,k):
              if j >= 6:
                riskMod *= math.exp(-(raceIncidence[j]*raceAttribute[j]*projectedCovariateSummary+raceHazards[j])*5)
              else:
                riskMod *= math.exp(-(raceIncidence[j]*raceAttribute[j]*covariateSummary+raceHazards[j])*5)
            absRisk += riskMod
        else:
          for k in range(currentAgeInterval+1,projectionAgeInterval):
            riskMod = 1.0-math.exp(-(raceIncidence[k]*raceAttribute[k]*covariateSummary+raceHazards[k])*5)
            riskMod *= raceIncidence[k]*raceAttribute[k]*covariateSummary/(raceIncidence[k]*raceAttribute[k]*covariateSummary+raceHazards[k])
            riskMod *= math.exp(-deathRate*(currentAgeInterval*5+25-currentAge))
            for j in range(currentAgeInterval+1,k):
              riskMod *= math.exp(-(raceIncidence[j]*raceAttribute[j] * covariateSummary + raceHazards[j])*5)
            absRisk += riskMod
  return absRisk
