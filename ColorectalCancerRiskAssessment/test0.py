from CcratRunFunction import AbsRisk

def runTest():
  with open("comparison.txt","w") as out:
    with open("input0.txt") as f:
      factors = ["Race","screening","smoking","cigarettesPerDay","noNSAID","noIbu","#rel","exercise","Veggies","BMI","Age1","Age2","distal","rectal","proximal","AbsRisk"]
      for line in f:
        input = line[:-1].split(" ")
        if input[0] == "W":
          race = "White"
        else:
          race = input[0]
        for i in range(1,len(input)-1):
          input[i] = int(input[i])
        input[12] = float(input[12])
        result = round(AbsRisk("Male",race,input[10],input[11],input[1],input[2],input[3],input[4],input[5],input[6],input[7],input[8],input[9],0),4)
        if result != input[12]:
          print result
