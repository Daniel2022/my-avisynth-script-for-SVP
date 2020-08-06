#合并视频

v1 = LWLibavVideoSource("NCOP_SVP_mixmode_test1.mp4")
v2 = LWLibavVideoSource("NCOP_SVP_mixmode_test2.mp4")
v3 = LWLibavVideoSource("NCOP_SVP_mixmode_test3.mp4")
v4 = LWLibavVideoSource("NCOP_SVP_mixmode_test4.mp4")
v5 = LWLibavVideoSource("NCOP_SVP_mixmode_test5.mp4")
#ConvertToYV12()

v1+v2+v3+v4+v5

#rate1 = 48000.0/1001.0
#v1.Trim(0,23).AssumeFPS(rate1).ChangeFPS(60000.0/1001.0)
