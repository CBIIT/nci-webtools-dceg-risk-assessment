from BcratConstants import BcratConstants
import math

class BcratRest:
  def AbsoluteRisk(self, race, currentage, projectionAge, menarcheAge, numberOfBiopsy, firstLiveBirthAge, firstDegRelatives, rhyp):
    return self.CalculateRisk(1, race, currentage, projectionAge, numberOfBiopsy, menarcheAge, firstLiveBirthAge, firstDegRelatives, rhyp)

  def AverageRisk(self, race, currentAge, projectionAge):
    return self.CalculateRisk(2, race, currentAge, projectionAge, 0, 0, 0, 0, 1.0)

  # rhyp    yes = 1.82
  #          no = 0.93
  #       other = 1.00
  def CalculateRisk(self, riskindex, race, currentAge, projectionAge, menarcheAge, numberOfBiopsy, firstLiveBirthAge, firstDegRelatives, rhyp):
    riskType = None
    if riskindex == 1:
      riskType = "Absolute"
    elif riskindex == 2:
      riskType = "Average"
    else:
      raise RuntimeError("riskindex contained an invalid value")
    if projectionAge <= currentAge:
      raise RuntimeError("projectionAge must be greater than the current age")
    if race == "White":
      irace = 1
    elif race == "Black":
      irace = 2
    elif race == "Hispanic":
      irace = 3
    elif race == "Chinese":
      irace = 7
    elif race == "Japanese":
      irace = 8
    elif race == "Filipino":
      irace = 9
    elif race == "Hawaiian":
      irace = 10
    elif race == "Islander":
      irace = 11
    elif race == "Asian":
      irace = 12
    else:
      raise RuntimeError("race contained an invalid value")
    raceCovariants = BcratConstants.COVARIANTS[irace - 1]
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
    if (irace == 2 and menarcheAge == 2):
      menarcheAge = 1
      firstLiveBirthAge = 0
    currentAgeInterval = int(math.floor(currentAge/5.0))-3
    projectionAgeInterval = int(math.ceil(projectionAge/5.0))-4
    cindx = irace - 1
    if (riskindex == 2 and irace < 7):
      cindx += 3
    rmu = BcratConstants.rmu2[riskType][race]
    rlan = BcratConstants.rlan2[cindx]
    rf = [None]*2
    rf[0] = BcratConstants.rf2[0][cindx]
    rf[1] = BcratConstants.rf2[1][cindx]
    if (riskindex == 2 and irace >= 7): #average asians
      rf[0] = BcratConstants.rf2[0][12]
      rf[1] = BcratConstants.rf2[1][12]
    covariateSummary = sum([x*y for x,y in zip(raceCovariants,covariateBreakdown)]) + math.log(rhyp)
    over50CovariateSummary = sum([x*y for x,y in zip(raceCovariants,covariateBreakdown[:4]+[numberOfBiopsy]+covariateBreakdown[5:])]) + math.log(rhyp)
    rlanrf = [None]*14
    for j in range(1, 6+1):
      rlanrf[j - 1] = rlan[j - 1]*rf[0]
    for j in range(7, 14+1):
      rlanrf[j - 1] = rlan[j - 1]*rf[1]
    absRisk = 1.0
    if (projectionAge <= BcratConstants.t[currentAgeInterval]):
      absRisk -= math.exp(-(rlanrf[currentAgeInterval - 1] * math.exp(covariateSummary) + rmu[currentAgeInterval - 1]) * (projectionAge - currentAge))
      absRisk *= rlanrf[currentAgeInterval - 1] * math.exp(covariateSummary) / (rlanrf[currentAgeInterval - 1] * math.exp(covariateSummary) + rmu[currentAgeInterval - 1])
    else:
      absRisk -= math.exp(-(rlanrf[currentAgeInterval - 1] * math.exp(covariateSummary) + rmu[currentAgeInterval - 1]) * (BcratConstants.t[currentAgeInterval] - currentAge))
      absRisk *= rlanrf[currentAgeInterval - 1] * math.exp(covariateSummary) / (rlanrf[currentAgeInterval - 1] * math.exp(covariateSummary) + rmu[currentAgeInterval - 1])
      if (projectionAgeInterval - currentAgeInterval > 0):
        riskMod = 1.0
        if (projectionAge > 50.0 and currentAge < 50.0):
          riskMod -= math.exp(-(rlanrf[projectionAgeInterval - 1] * math.exp(over50CovariateSummary) + rmu[projectionAgeInterval - 1]) * (projectionAge - BcratConstants.t[projectionAgeInterval - 1]))
          riskMod *= rlanrf[projectionAgeInterval - 1] * math.exp(over50CovariateSummary) / (rlanrf[projectionAgeInterval - 1] * math.exp(over50CovariateSummary) + rmu[projectionAgeInterval - 1])
          riskMod *= math.exp(-(rlanrf[currentAgeInterval - 1] * math.exp(covariateSummary) + rmu[currentAgeInterval - 1]) * (BcratConstants.t[currentAgeInterval] - currentAge))
          for j in range(currentAgeInterval, projectionAgeInterval - 1):
            riskMod *= math.exp(-(rlanrf[j] * math.exp(over50CovariateSummary if BcratConstants.t[j] >= 50.0 else covariateSummary) + rmu[j]) * 5)
        else:
          riskMod -= math.exp(-(rlanrf[projectionAgeInterval - 1] * math.exp(covariateSummary) + rmu[projectionAgeInterval - 1]) * (projectionAge - BcratConstants.t[projectionAgeInterval - 1]))
          riskMod *= rlanrf[projectionAgeInterval - 1] * math.exp(covariateSummary) / (rlanrf[projectionAgeInterval - 1] * math.exp(covariateSummary) + rmu[projectionAgeInterval - 1])
          riskMod *= math.exp(-(rlanrf[currentAgeInterval - 1] * math.exp(covariateSummary) + rmu[currentAgeInterval - 1]) * (BcratConstants.t[currentAgeInterval] - currentAge))
          for j in range(currentAgeInterval, projectionAgeInterval-1):
            riskMod *= math.exp(-(rlanrf[j] * math.exp(covariateSummary) + rmu[j]) * 5)
        absRisk += riskMod
      if (projectionAgeInterval - currentAgeInterval > 1):
        if (projectionAge > 50.0 and currentAge < 50.0):
          for k in range(currentAgeInterval, projectionAgeInterval - 1):
            riskMod = 1.0
            if (BcratConstants.t[k] >= 50.0):
              riskMod -= math.exp(-(rlanrf[k] * math.exp(over50CovariateSummary) + rmu[k]) * 5)
              riskMod *= rlanrf[k] * math.exp(over50CovariateSummary) / (rlanrf[k] * math.exp(over50CovariateSummary) + rmu[k])
            else:
              riskMod -= math.exp(-(rlanrf[k] * math.exp(covariateSummary) + rmu[k]) * 5)
              riskMod *= rlanrf[k] * math.exp(covariateSummary) / (rlanrf[k] * math.exp(covariateSummary) + rmu[k])
            riskMod *= math.exp(-(rlanrf[currentAgeInterval - 1] * math.exp(covariateSummary) + rmu[currentAgeInterval - 1]) * (BcratConstants.t[currentAgeInterval] - currentAge))
            for j in range(currentAgeInterval, k):
              if (BcratConstants.t[j] >= 50.0):
                riskMod *= math.exp(-(rlanrf[j] * math.exp(over50CovariateSummary) + rmu[j]) * 5)
              else:
                riskMod *= math.exp(-(rlanrf[j] * math.exp(covariateSummary) + rmu[j]) * 5)
            absRisk += riskMod
        else:
          for k in range(currentAgeInterval, projectionAgeInterval - 1):
            riskMod = 1.0
            riskMod -= math.exp(-(rlanrf[k] * math.exp(covariateSummary) + rmu[k]) * (BcratConstants.t[k + 1] - BcratConstants.t[k]))
            riskMod *= rlanrf[k] * math.exp(covariateSummary) / (rlanrf[k] * math.exp(covariateSummary) + rmu[k])
            riskMod *= math.exp(-(rlanrf[currentAgeInterval - 1] * math.exp(covariateSummary) + rmu[currentAgeInterval - 1]) * (BcratConstants.t[currentAgeInterval] - currentAge))
            for j in range(currentAgeInterval, k):
              riskMod *= math.exp(-(rlanrf[j] * math.exp(covariateSummary) + rmu[j]) * 5)
            absRisk += riskMod
    return absRisk
