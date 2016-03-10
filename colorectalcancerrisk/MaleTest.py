from CcratRunFunction import AbsRisk
import math

def perFile(file):
  for line in file:
    input = line[:-1].split(" ")
    age = int(input[1])
    for i in range(3,len(input)-5):
      input[i] = int(input[i])
    for i in range(len(input)-5,len(input)):
      input[i] = float(input[i])
    if input[2] == "W":
      race = "White"
    elif input[2] == "B":
      race = "Black"
    elif input[2] == "H":
      race = "Hispanic"
    elif input[2] == "A":
      race = "Asian"
    else:
      race = input[2]
    absRisk = AbsRisk("Male",race,age,min(age+5,90),input[3],input[4],input[5],input[6],input[7],input[8],input[9],input[10],input[11],0)*1000000
    if math.floor(absRisk)/1000000.0 != input[12] and math.ceil(absRisk)/1000000.0 != input[12]:
      print str(round(absRisk,6))+" vs. "+str(input[12])
      print input
    absRisk = AbsRisk("Male",race,age,min(age+10,90),input[3],input[4],input[5],input[6],input[7],input[8],input[9],input[10],input[11],0)*1000000
    if math.floor(absRisk)/1000000.0 != input[13] and math.ceil(absRisk)/1000000.0 != input[13]:
      print str(round(absRisk,6))+" vs. "+str(input[12])
      print input
    absRisk = AbsRisk("Male",race,age,min(age+20,90),input[3],input[4],input[5],input[6],input[7],input[8],input[9],input[10],input[11],0)*1000000
    if math.floor(absRisk)/1000000.0 != input[14] and math.ceil(absRisk)/1000000.0 != input[14]:
      print str(round(absRisk,6))+" vs. "+str(input[12])
      print input
    absRisk = AbsRisk("Male",race,age,90,input[3],input[4],input[5],input[6],input[7],input[8],input[9],input[10],input[11],0)*1000000
    if math.floor(absRisk)/1000000.0 != input[15] and math.ceil(absRisk)/1000000.0 != input[15]:
      print str(round(absRisk,6))+" vs. "+str(input[12])
      print input

def runTest():
  with open("MaleInput1.txt") as file:
    perFile(file)
  with open("MaleInput2.txt") as file:
    perFile(file)
