from CcratRunFunction import AbsRisk

def runTest():
  factors = ["Race","T1","T2","screening","smoking","perDay","nsaids","aspirinOnly","#rel","exercise","veggies","bmi","AbsRisk"]
  with open("input1.txt") as f:
    for line in f:
      input = line[:-1].split(" ")
      if input[0] == "W":
        race = "White"
      elif input[0] == "B":
        race = "Black"
      elif input[0] == "H":
        race = "Hispanic"
      elif input[0] == "A":
        race = "Asian"
      else:
        race = input[0]
      input = [int(x) for x in input[1:12]]+[float(input[12])]
      result = AbsRisk("Male",race,input[0],input[1],input[2],input[3],input[4],input[5],input[6],input[7],input[8],input[9],input[10],0)
      result = int(result*10000)/100.0
      input[11] = int(input[11]*100)/100.0
      if result != input[11]:
        print [lineNumber,race,result,input[11]]

