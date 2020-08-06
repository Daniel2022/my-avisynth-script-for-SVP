#大量avs代码生成

def func(i,j):
    for i in range(i,j):
        #print("smooth%d = input%d.interpolate(smoothfps_params2)" % (i,i))
        print("smooth%d + (smooth%d.Trim(smooth%d.FrameCount-1,length=1)+smooth%d.Trim(0,length=1)) + " % (i,i,i,i+1),end="")
    #print()

func(1,12)
func(12,22)
func(22,32)
func(32,42)
func(42,50)