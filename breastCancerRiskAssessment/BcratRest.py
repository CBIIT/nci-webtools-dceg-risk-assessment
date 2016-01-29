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
    retval = 0.0
    riskMod = 0.0
    ti = currentAge
    ts = projectionAge
    bet = [None]*8
    for i in range(0,8):
      bet[i] = BcratConstants.bet2[i][irace - 1]
    if (irace == 2):
      if (menarcheAge == 2):
        menarcheAge = 1
        firstLiveBirthAge = 0
    ni = 0
    for i in range(1, 15+1):
      if (ti < BcratConstants.t[i - 1]):
        ni = i - 1
        break
    ns = 0
    for i in range(1, 15+1):
      if (ts <= BcratConstants.t[i - 1]):
        ns = i - 1
        break
    incr = 0
    if (riskindex == 2 and irace < 7):
      incr = 3
    cindx = 0
    cindx = incr + irace - 1
    rmu = [None]*14
    rlan = [None]*14
    for i in range(0,14):
      rmu[i] = BcratConstants.rmu2[i][cindx]
      rlan[i] = BcratConstants.rlan2[i][cindx]
    rf = [None]*2
    rf[0] = BcratConstants.rf2[0][incr + irace - 1]
    rf[1] = BcratConstants.rf2[1][incr + irace - 1]
    if (riskindex == 2 and irace >= 7):
      rf[0] = BcratConstants.rf2[0][12]
      rf[1] = BcratConstants.rf2[1][12]
    if (riskindex >= 2):
      menarcheAge = 0
      numberOfBiopsy = 0
      firstLiveBirthAge = 0
      firstDegRelatives = 0
      rhyp = 1.0
    ilev = (1 if currentAge >= 50 else 0) * 108 + menarcheAge * 36 + numberOfBiopsy * 12 + firstLiveBirthAge * 3 + firstDegRelatives + 1
    r8iTox2 = [None]*216
    for k in range(0,216):
      r8iTox2[k] = [None]*9
      r8iTox2[k][0] = 1.0
    for k in range(0,108):
      r8iTox2[k][1] = 0.0
      r8iTox2[108 + k][1] = 1.0
    for j in range(1, 2+1):
      for k in range(1, 36+1):
        r8iTox2[(j - 1) * 108 + k - 1][2] = 0.0
        r8iTox2[(j - 1) * 108 + 36 + k - 1][2] = 1.0
        r8iTox2[(j - 1) * 108 + 72 + k - 1][2] = 2.0
    for j in range(1, 6+1):
      for k in range(1, 12+1):
        r8iTox2[(j - 1) * 36 + k - 1][3] = 0.0
        r8iTox2[(j - 1) * 36 + 12 + k - 1][3] = 1.0
        r8iTox2[(j - 1) * 36 + 24 + k - 1][3] = 2.0
    for j in range(1, 18+1):
      for k in range(1, 3+1):
        r8iTox2[(j - 1) * 12 + k - 1][4] = 0.0
        r8iTox2[(j - 1) * 12 + 3 + k - 1][4] = 1.0
        r8iTox2[(j - 1) * 12 + 6 + k - 1][4] = 2.0
        r8iTox2[(j - 1) * 12 + 9 + k - 1][4] = 3.0
    for j in range(1, 72+1):
      r8iTox2[(j - 1) * 3 + 1 - 1][5] = 0.0
      r8iTox2[(j - 1) * 3 + 2 - 1][5] = 1.0
      r8iTox2[(j - 1) * 3 + 3 - 1][5] = 2.0
    for i in range(0, 216):
      r8iTox2[i][6] = r8iTox2[i][1] * r8iTox2[i][3]
      r8iTox2[i][7] = r8iTox2[i][4] * r8iTox2[i][5]
    sumbb = [None]*216
    for i in range(0, 216):
      sumbb[i] = sum([x*y for x,y in zip(bet[2:],r8iTox2[i][2:])])
    rlanrf = [None]*14
    for j in range(1, 6+1):
      rlanrf[j - 1] = rlan[j - 1]*rf[0]
    for j in range(7, 14+1):
      rlanrf[j - 1] = rlan[j - 1]*rf[1]
    i = ilev
    sumbb[i - 1] += math.log(rhyp);
    if (i <= 108):
      sumbb[i + 107] += math.log(rhyp);
    absRisk = 0
    if (ts <= BcratConstants.t[ni]):
      absRisk = 1.0 - math.exp(-(rlanrf[ni - 1] * math.exp(sumbb[i - 1]) + rmu[ni - 1]) * (ts - ti))
      absRisk = absRisk * rlanrf[ni - 1] * math.exp(sumbb[i - 1]) / (rlanrf[ni - 1] * math.exp(sumbb[i - 1]) + rmu[ni - 1])
    else:
      absRisk = 1.0 - math.exp(-(rlanrf[ni - 1] * math.exp(sumbb[i - 1]) + rmu[ni - 1]) * (BcratConstants.t[ni] - ti));
      absRisk = absRisk * rlanrf[ni - 1] * math.exp(sumbb[i - 1]) / (rlanrf[ni - 1] * math.exp(sumbb[i - 1]) + rmu[ni - 1])
      if (ns - ni > 0):
        if (projectionAge > 50.0 and currentAge < 50.0):
          riskMod = 1.0 - math.exp(-(rlanrf[ns - 1] * math.exp(sumbb[i + 107]) + rmu[ns - 1]) * (ts - BcratConstants.t[ns - 1]))
          riskMod = riskMod * rlanrf[ns - 1] * math.exp(sumbb[i + 107]) / (rlanrf[ns - 1] * math.exp(sumbb[i + 107]) + rmu[ns - 1])
          riskMod *= math.exp(-(rlanrf[ni - 1] * math.exp(sumbb[i - 1]) + rmu[ni - 1]) * (BcratConstants.t[ni] - ti))
          if (ns - ni > 1):
            menarcheAge = ns - 1
            for j in range(ni + 1, menarcheAge + 1):
              if (BcratConstants.t[j - 1] >= 50.0):
                riskMod *= math.exp(-(rlanrf[j - 1] * math.exp(sumbb[i + 107]) + rmu[j - 1]) * (BcratConstants.t[j] - BcratConstants.t[j - 1]))
              else:
                riskMod *= math.exp(-(rlanrf[j - 1] * math.exp(sumbb[i - 1]) + rmu[j - 1]) * (BcratConstants.t[j] - BcratConstants.t[j - 1]))
          absRisk += riskMod
        else:
          riskMod = 1.0 - math.exp(-(rlanrf[ns - 1] * math.exp(sumbb[i - 1]) + rmu[ns - 1]) * (ts - BcratConstants.t[ns - 1]))
          riskMod = riskMod * rlanrf[ns - 1] * math.exp(sumbb[i - 1]) / (rlanrf[ns - 1] * math.exp(sumbb[i - 1]) + rmu[ns - 1])
          riskMod *= math.exp(-(rlanrf[ni - 1] * math.exp(sumbb[i - 1]) + rmu[ni - 1]) * (BcratConstants.t[ni] - ti))
          if (ns - ni > 1):
            menarcheAge = ns - 1
            for j in range(ni + 1, menarcheAge + 1):
              riskMod *= math.exp(-(rlanrf[j - 1] * math.exp(sumbb[i - 1]) + rmu[j - 1]) * (BcratConstants.t[j] - BcratConstants.t[j - 1]))
          absRisk += riskMod
      if (ns - ni > 1):
        if (projectionAge > 50.0 and currentAge < 50.0):
          menarcheAge = ns - 1
          for k in range(ni + 1, menarcheAge + 1):
            if (BcratConstants.t[k - 1] >= 50.0):
              riskMod = 1.0 - math.exp(-(rlanrf[k - 1] * math.exp(sumbb[i + 107]) + rmu[k - 1]) * (BcratConstants.t[k] - BcratConstants.t[k - 1]))
              riskMod = riskMod * rlanrf[k - 1] * math.exp(sumbb[i + 107]) / (rlanrf[k - 1] * math.exp(sumbb[i + 107]) + rmu[k - 1])
            else:
              riskMod = 1.0 - math.exp(-(rlanrf[k - 1] * math.exp(sumbb[i - 1]) + rmu[k - 1]) * (BcratConstants.t[k] - BcratConstants.t[k - 1]))
              riskMod = riskMod * rlanrf[k - 1] * math.exp(sumbb[i - 1]) / (rlanrf[k - 1] * math.exp(sumbb[i - 1]) + rmu[k - 1])
            riskMod *= math.exp(-(rlanrf[ni - 1] * math.exp(sumbb[i - 1]) + rmu[ni - 1]) * (BcratConstants.t[ni] - ti))
            numberOfBiopsy = k - 1
            for j in range(ni + 1, numberOfBiopsy + 1):
              if (BcratConstants.t[j - 1] >= 50.0):
                riskMod *= math.exp(-(rlanrf[j - 1] * math.exp(sumbb[i + 107]) + rmu[j - 1]) * (BcratConstants.t[j] - BcratConstants.t[j - 1]))
              else:
                riskMod *= math.exp(-(rlanrf[j - 1] * math.exp(sumbb[i - 1]) + rmu[j - 1]) * (BcratConstants.t[j] - BcratConstants.t[j - 1]))
            absRisk += riskMod
        else:
          menarcheAge = ns - 1
          for k in range(ni + 1, menarcheAge + 1):
            riskMod = 1.0 - math.exp(-(rlanrf[k - 1] * math.exp(sumbb[i - 1]) + rmu[k - 1]) * (BcratConstants.t[k] - BcratConstants.t[k - 1]))
            riskMod = riskMod * rlanrf[k - 1] * math.exp(sumbb[i - 1]) / (rlanrf[k - 1] * math.exp(sumbb[i - 1]) + rmu[k - 1])
            riskMod *= math.exp(-(rlanrf[ni - 1] * math.exp(sumbb[i - 1]) + rmu[ni - 1]) * (BcratConstants.t[ni] - ti))
            numberOfBiopsy = k - 1
            for j in range(ni + 1, numberOfBiopsy + 1):
              riskMod *= math.exp(-(rlanrf[j - 1] * math.exp(sumbb[i - 1]) + rmu[j - 1]) * (BcratConstants.t[j] - BcratConstants.t[j - 1]))
            absRisk += riskMod
    retval = absRisk
    return retval
