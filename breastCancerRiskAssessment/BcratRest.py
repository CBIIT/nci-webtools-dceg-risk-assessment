from BcratConstants import BcratConstants
import math

def AverageRisk(race, currentAge, projectionAge):
  return AbsRisk(race, currentAge, projectionAge, 0, 0, 0, 0, 1.0)

# rhyp    yes = 1.82
#          no = 0.93
#       other = 1.00
def AbsRisk(race, currentAge, projectionAge, numberOfBiopsy, menarcheAge, firstLiveBirthAge, firstDegRelatives, rhyp):
  if projectionAge <= currentAge:
    raise RuntimeError("projectionAge must be greater than the current age")
  raceAttribute  = BcratConstants.ATTRIBUTE_RISK   ["Absolute"][race]
  raceHazards    = BcratConstants.COMPETING_HAZARDS["Absolute"][race]
  raceIncidence  = BcratConstants.INCIDENCE        ["Absolute"][race]
  raceCovariants = BcratConstants.COVARIANTS       [race]
  currentAgeInterval    = int(math.floor(currentAge   /5))-4
  projectionAgeInterval = int(math.floor(projectionAge/5))-4
  #age ge 50 ind  0=[20, 50)
  #               1=[50, 85)
  if (race == "Black" and menarcheAge == 2):
    menarcheAge = 1;        # recode agemen=2 (age<12) to agmen=1 [12,13]
    firstLiveBirthAge = 0;  # set age 1st live birth to 0
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
  covariateSummary = math.exp(sum([x*y for x,y in zip(covariateBreakdown,raceCovariants)]) + math.log(rhyp))
  projectedCovariateSummary = math.exp(sum([x*y for x,y in zip([menarcheAge, numberOfBiopsy, firstLiveBirthAge, firstDegRelatives, numberOfBiopsy, firstLiveBirthAge * firstDegRelatives],raceCovariants)]) + math.log(rhyp))
            if (ts <= t[ni])
            {
                abs[i - 1] = 1.0 - Math.Exp(-(rlan[ni - 1] * Math.Exp(sumbb[i - 1]) + rmu[ni - 1]) * (ts - ti))
                abs[i - 1] = abs[i - 1] * rlan[ni - 1] * Math.Exp(sumbb[i - 1]) / (rlan[ni - 1] * Math.Exp(sumbb[i - 1]) + rmu[ni - 1])
            }
            else
            {
                abs[i - 1] = 1.0 - Math.Exp(-(rlan[ni - 1] * Math.Exp(sumbb[i - 1]) + rmu[ni - 1]) * (t[ni] - ti))
                abs[i - 1] = abs[i - 1] * rlan[ni - 1] * Math.Exp(sumbb[i - 1]) / (rlan[ni - 1] * Math.Exp(sumbb[i - 1]) + rmu[ni - 1])
                if (ns - ni > 0)
                {
                    if (projectionAge > 50.0 && currentAge < 50.0)
                    {
                        r = 1.0 - Math.Exp(-(rlan[ns - 1] * Math.Exp(sumbb[i + 107]) + rmu[ns - 1]) * (ts - t[ns - 1]))
                        r = r * rlan[ns - 1] * Math.Exp(sumbb[i + 107]) / (rlan[ns - 1] * Math.Exp(sumbb[i + 107]) + rmu[ns - 1])
                        r *= Math.Exp(-(rlan[ni - 1] * Math.Exp(sumbb[i - 1]) + rmu[ni - 1]) * (t[ni] - ti))
                        if (ns - ni > 1)
                        {
                            for (j = ni + 1; j <= ns - 1; ++j)
                            {
                                if (t[j - 1] >= 50.0)
                                {
                                    r *= Math.Exp(-(rlan[j - 1] * Math.Exp(sumbb[i + 107]) + rmu[j - 1]) * (t[j] - t[j - 1]))
                                }
                                else
                                {
                                    r *= Math.Exp(-(rlan[j - 1] * Math.Exp(sumbb[i - 1]) + rmu[j - 1]) * (t[j] - t[j - 1]))
                                }
                            }
                        }
                        abs[i - 1] += r
                    }
                    else
                    {
                        r = 1.0 - Math.Exp(-(rlan[ns - 1] * Math.Exp(sumbb[i - 1]) + rmu[ns - 1]) * (ts - t[ns - 1]))
                        r = r * rlan[ns - 1] * Math.Exp(sumbb[i - 1]) / (rlan[ns - 1] * Math.Exp(sumbb[i - 1]) + rmu[ns - 1])
                        r *= Math.Exp(-(rlan[ni - 1] * Math.Exp(sumbb[i - 1]) + rmu[ni - 1]) * (t[ni] - ti))
                        if (ns - ni > 1)
                        {
                            for (j = ni + 1; j <= ns - 1; ++j)
                            {
                                r *= Math.Exp(-(rlan[j - 1] * Math.Exp(sumbb[i - 1]) + rmu[j - 1]) * (t[j] - t[j - 1]));
                            }
                        }
                        abs[i - 1] += r
                    }
                }
                if (ns - ni > 1)
                {
                    if (projectionAge > 50.0 && currentAge < 50.0)
                    {
                        for (k = ni + 1; k <= ns - 1; ++k)
                        {
                            if (t[k - 1] >= 50.0)
                            {
                                r = 1.0 - Math.Exp(-(rlan[k - 1] * Math.Exp(sumbb[i + 107]) + rmu[k - 1]) * (t[k] - t[k - 1]))
                                r = r * rlan[k - 1] * Math.Exp(sumbb[i + 107]) / (rlan[k - 1] * Math.Exp(sumbb[i + 107]) + rmu[k - 1])
                            }
                            else
                            {
                                r = 1.0 - Math.Exp(-(rlan[k - 1] * Math.Exp(sumbb[i - 1]) + rmu[k - 1]) * (t[k] - t[k - 1]))
                                r = r * rlan[k - 1] * Math.Exp(sumbb[i - 1]) / (rlan[k - 1] * Math.Exp(sumbb[i - 1]) + rmu[k - 1])
                            }
                            r *= Math.Exp(-(rlan[ni - 1] * Math.Exp(sumbb[i - 1]) + rmu[ni - 1]) * (t[ni] - ti))
                            for (j = ni + 1; j <= k - 1; ++j)
                            {
                                if (t[j - 1] >= 50.0)
                                {
                                    r *= Math.Exp(-(rlan[j - 1] * Math.Exp(sumbb[i + 107]) + rmu[j - 1]) * (t[j] - t[j - 1]))
                                }
                                else
                                {
                                    r *= Math.Exp(-(rlan[j - 1] * Math.Exp(sumbb[i - 1]) + rmu[j - 1]) * (t[j] - t[j - 1]))
                                }
                            }
                            abs[i - 1] += r
                        }
                    }
                    else
                    {
                        for (k = ni + 1; k <= ns - 1; ++k)
                        {
                            r = 1.0 - Math.Exp(-(rlan[k - 1] * Math.Exp(sumbb[i - 1]) + rmu[k - 1]) * (t[k] - t[k - 1]))
                            r = r * rlan[k - 1] * Math.Exp(sumbb[i - 1]) / (rlan[k - 1] * Math.Exp(sumbb[i - 1]) + rmu[k - 1])
                            r *= Math.Exp(-(rlan[ni - 1] * Math.Exp(sumbb[i - 1]) + rmu[ni - 1]) * (t[ni] - ti))
                            for (j = ni + 1; j <= k - 1; ++j)
                            {
                                r *= Math.Exp(-(rlan[j - 1] * Math.Exp(sumbb[i - 1]) + rmu[j - 1]) * (t[j] - t[j - 1]))
                            }
                            abs[i - 1] += r
                        }
                    }
                }
            }
  return absRisk
