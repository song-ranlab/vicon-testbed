#data = "b'x=-1.904061e+02,'\nb'y=1.823281e+02,z'\nb'=2.875100e+01'"
#"b'x=-1.989775e+00,'\nb'y=0,z=1.002082e+'\nb'00'"
data="b'x=3.377991e-02,y'\nb'=-3.356934e-03,z'\nb'=-3.384666e-02,v'\nb'=7.071068e-01,ps'\nb'i=0'"
print(data)

data = data.replace('b','').replace('\n','').replace("'",'').split(',')
print(data)
x,y,z,v,psi = data[0].replace('x','').replace('=',''),data[1].replace('y','').replace('=',''),data[2].replace('z','').replace('=',''),data[3].replace('v','').replace('=',''),data[4].replace('psi','').replace('=','')
print(x,y,z,v,psi)

