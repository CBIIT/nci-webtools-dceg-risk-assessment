from BcratRest import BcratRest

def runTest():
  b = BcratRest()
  f = open("comparison.txt","w")
  for a in range(35,86):
    f.write(str(a)+"\n")
    f.write(str(b.AverageRisk("White",a,a+5))+"\n")
    f.write(str(b.AverageRisk("White",a,90))+"\n########\n")
    for c in range(0,3):
      for d in range(0,3):
        for e in range(0,4):
          for g in range(0,3):
            for h in [0.93,1.00,1.82]:
              f.write(str(b.AbsoluteRisk("White",a,a+5,c,d,e,g,h))+"\n")
              f.write(str(b.AbsoluteRisk("White",a,90,c,d,e,g,h))+"\n\n")
    f.write("--------\n\n")
  f.close()
