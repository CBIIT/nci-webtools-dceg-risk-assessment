from CcratRunFunction import AbsRisk
import math

def runTest():
  with open("FemaleInput.txt") as file:
    for line in file:
      input = line[:-1].split(" ")
      age = int(input[0])
      if input[1] == "W":
        race = "White"
      elif input[1] == "B":
        race = "Black"
      elif input[1] == "H":
        race = "Hispanic"
      elif input[1] == "A":
        race = "Asian"
      else:
        race = input[1]
      for i in range(2,9):
        input[i] = int(input[i])
      for i in range(9,13):
        input[i] = float(input[i])
      absRisk = AbsRisk("Female",race,age,age+5,input[2],0,0,input[3],0,input[4],input[5],input[6],input[7],input[8])
      if math.floor(absRisk*1000000)/1000000 != input[9] and math.ceil(absRisk*1000000)/1000000 != input[9]:
        print str(age)+","+str(age+5)+","+str(round(absRisk,6))+" vs. "+str(input[9])
      absRisk = AbsRisk("Female",race,age,min(age+10,90),input[2],0,0,input[3],0,input[4],input[5],input[6],input[7],input[8])
      if math.floor(absRisk*1000000)/1000000 != input[10] and math.ceil(absRisk*1000000)/1000000 != input[10]:
        print str(age)+","+str(min(age+10,90))+","+str(round(absRisk,6))+" vs. "+str(input[10])
      absRisk = AbsRisk("Female",race,age,min(age+20,90),input[2],0,0,input[3],0,input[4],input[5],input[6],input[7],input[8])
      if math.floor(absRisk*1000000)/1000000 != input[11] and math.ceil(absRisk*1000000)/1000000 != input[11]:
        print str(age)+","+str(min(age+20,90))+","+str(round(absRisk,6))+" vs. "+str(input[11])
      absRisk = AbsRisk("Female",race,age,90,input[2],0,0,input[3],0,input[4],input[5],input[6],input[7],input[8])
      if math.floor(absRisk*1000000)/1000000 != input[12] and math.ceil(absRisk*1000000)/1000000 != input[12]:
        print str(age)+",90,"+str(round(absRisk,6))+" vs. "+str(input[12])
