LWLibavVideoSource("NCOP_waifu2x_noise.mp4")
ConvertToYV12()
#Sharpen(1)
#Undot()

SetMemoryMax(2000)
global threads=6
#SetMemoryMax和global threads不同电脑SVP生成的不同，可能需要修改（global threads和CPU线程无关）

SetFilterMTMode("DEFAULT_MT_MODE",2)
SetFilterMTMode("SVSuper",1)
SetFilterMTMode("SVAnalyse",1)
ConvertToYV12()
#参数
global crop_string1  = ""
global resize_string = ""
global trim_string = "Trim(0,1000-1)"
global super_params     = "{scale:{up:0},gpu:1}"
#gpu后数值对应“渲染设备”选项，CPU对应0，GPU对应1。但是SVP好像即使在把渲染设备改为显卡的情况下仍然占用更多的CPU资源，如果用GPU的话差不多是用20%的GPU占用换取CPU节省30%的占用这种比例（不同设备差异会很大），因此仍然不能很好的调用显卡
global analyse_params   = "{block:{overlap:0},main:{search:{coarse:{distance:-8,bad:{sad:2000,range:24}},type:2}}}"
global smoothfps_params1 = "{cubic:1,gpuid:11,rate:{num:72000,den:1001,abs:true},algo:23,mask:{area:25,cover:80},scene:{blend:true,mode:1}}"
#目标帧率=视频帧率*num/den；algo对应“SVP着色器选项”，数值就是选项前的数值（参考文章附的图片）
#scene:{blend}对应“场景变换处理”选项，帧混合对应blend:true，帧重复则不需要写此项（如scene:{limits:{m1:0,m2:0}}。此功能相对Pr的光流法之类补帧好处是镜头切换处没有坏帧，检测灵敏度可以调节，请参考官网）
#scene中limits的位置可以用mode代替，对应“帧插补模式“选项，恒定帧间隔（最流畅）对应mode:0，  1m普通模式对应mode:1，  2m（伪影最少）对应mode:2，例如：  scene:{blend:true,mode:0}（“场景变换处理”为“帧混合”，“插补模式”为“最流畅”）。1.5m（少量伪影）对应limits:{m1:0,m2:0}。少伪影和流畅之间不能兼顾，官网上有limits的详细说明。个人偏向1.5m模式，也就是样例里写着的这个样子，但是相对流畅感不强。

global smoothfps_params2 = "{cubic:1,gpuid:11,rate:{num:72000,den:1001,abs:true},algo:23,mask:{area:25,cover:80},scene:{blend:true,mode:2}}"
global smoothfps_params0 = "{cubic:1,gpuid:11,rate:{num:72000,den:1001,abs:true},algo:23,mask:{area:25,cover:90},scene:{blend:true,mode:0}}"
global demo_mode=0
global stereo_type=0

function interpolate(clip src,string smoothfps_params)
{
    input = src
	#MT-MODE-1  #do not remove this line!

	super=SVSuper(input, super_params)
	vectors=SVAnalyse(super, analyse_params, src=input)
	smooth=SVSmoothFps(input, super, vectors, smoothfps_params, mt=threads, src=src)

	#MT-MODE-2  #do not remove this line!

	#return demo_mode==0 ? smooth : demo(input,smooth)
    return smooth
}

#分块
input =last
input1 = input.Trim(0,118-1)
input2 = input.Trim(118,272-1)
input3 = input.Trim(272,443-1)
input4 = input.Trim(443,505-1)
input5 = input.Trim(505,519-1)
input6 = input.Trim(519,583-1)
input7 = input.Trim(583,595-1)
input8 = input.Trim(595,658-1)
input9 = input.Trim(658,686-1)
input10 = input.Trim(686,717-1)
input11 = input.Trim(717,751-1)
input12 = input.Trim(751,830-1)
input13 = input.Trim(830,924-1)
input14 = input.Trim(924,937-1)
input15 = input.Trim(937,956-1)
input16 = input.Trim(956,1107-1)
input17 = input.Trim(1107,1186-1)
input18 = input.Trim(1186,1202-1)
input19 = input.Trim(1202,1226-1)
input20 = input.Trim(1226,1266-1)
input21 = input.Trim(1266,1282-1)
input22 = input.Trim(1282,1307-1)
input23 = input.Trim(1307,1326-1)
input24 = input.Trim(1326,1348-1)
input25 = input.Trim(1348,1440-1)
input26 = input.Trim(1440,1575-1)
input27 = input.Trim(1575,1587-1)
input28 = input.Trim(1587,1618-1)
input29 = input.Trim(1618,1626-1)
input30 = input.Trim(1626,1666-1)
input31 = input.Trim(1666,1741-1)
input32 = input.Trim(1741,1822-1)
input33 = input.Trim(1822,1832-1)
input34 = input.Trim(1832,1892-1)
input35 = input.Trim(1892,1901-1)
input36 = input.Trim(1901,1931-1)
input37 = input.Trim(1931,1947-1)
input38 = input.Trim(1947,1969-1)
input39 = input.Trim(1969,1986-1)
input40 = input.Trim(1986,2002-1)
input41 = input.Trim(2002,2018-1)
input42 = input.Trim(2018,2045-1)
input43 = input.Trim(2045,2061-1)
input44 = input.Trim(2061,2144-1)
input45 = input.Trim(2144,2302-1)
input46 = input.Trim(2302,2342-1)
input47 = input.Trim(2342,2362-1)
input48 = input.Trim(2362,2381-1)
input49 = input.Trim(2381,2447-1)
#补帧设定
smooth1 = input1.interpolate(smoothfps_params2)
smooth2 = input2.interpolate(smoothfps_params0)
smooth3 = input3.interpolate(smoothfps_params2)
smooth4 = input4.interpolate(smoothfps_params1)
smooth5 = input5.interpolate(smoothfps_params2)
smooth6 = input6.ChangeFPS(72000.0/1001.0)
smooth7 = input7.interpolate(smoothfps_params0)
smooth8 = input8.interpolate(smoothfps_params2)
smooth9 = input9.interpolate(smoothfps_params2)
smooth10 = input10.interpolate(smoothfps_params1)
smooth11 = input11.interpolate(smoothfps_params2)
smooth12 = input12.interpolate(smoothfps_params1)
smooth13 = input13.interpolate(smoothfps_params1)
smooth14 = input14.interpolate(smoothfps_params0)
smooth15 = input15.interpolate(smoothfps_params0)
smooth16 = input16.interpolate(smoothfps_params2)
smooth17 = input17.interpolate(smoothfps_params0)
smooth18 = input18.interpolate(smoothfps_params1)
smooth19 = input19.interpolate(smoothfps_params0)
smooth20 = input20.interpolate(smoothfps_params1)
smooth21 = input21.interpolate(smoothfps_params0)
smooth22 = input22.interpolate(smoothfps_params1)
smooth23 = input23.interpolate(smoothfps_params2)
smooth24 = input24.interpolate(smoothfps_params1)
smooth25 = input25.interpolate(smoothfps_params2)
smooth26 = input26.interpolate(smoothfps_params1)
smooth27 = input27.interpolate(smoothfps_params0)
smooth28 = input28.interpolate(smoothfps_params1)
smooth29 = input29.interpolate(smoothfps_params1)
smooth30 = input30.interpolate(smoothfps_params1)
smooth31 = input31.interpolate(smoothfps_params2)
smooth32 = input32.interpolate(smoothfps_params1)
smooth33 = input33.interpolate(smoothfps_params0)
smooth34 = input34.interpolate(smoothfps_params1)
smooth35 = input35.interpolate(smoothfps_params0)
smooth36 = input36.interpolate(smoothfps_params2)
smooth37 = input37.interpolate(smoothfps_params1)
smooth38 = input38.interpolate(smoothfps_params2)
smooth39 = input39.interpolate(smoothfps_params1)
smooth40 = input40.interpolate(smoothfps_params2)
smooth41 = input41.interpolate(smoothfps_params1)
smooth42 = input42.interpolate(smoothfps_params2)
smooth43 = input43.interpolate(smoothfps_params1)
smooth44 = input44.interpolate(smoothfps_params0)
smooth45 = input45.interpolate(smoothfps_params2)
smooth46 = input46.interpolate(smoothfps_params2)
smooth47 = input47.interpolate(smoothfps_params1)
smooth48 = input48.interpolate(smoothfps_params1)
smooth49 = input49.interpolate(smoothfps_params0)

global fps = smooth1.framerate

#smooth1 + (smooth1.Trim(smooth1.FrameCount-1,length=1)+smooth2.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth2 + (smooth2.Trim(smooth2.FrameCount-1,length=1)+smooth3.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth3 + (smooth3.Trim(smooth3.FrameCount-1,length=1)+smooth4.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth4 + (smooth4.Trim(smooth4.FrameCount-1,length=1)+smooth5.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth5 + (smooth5.Trim(smooth5.FrameCount-1,length=1)+smooth6.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth6 + (smooth6.Trim(smooth6.FrameCount-1,length=1)+smooth7.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth7 + (smooth7.Trim(smooth7.FrameCount-1,length=1)+smooth8.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth8 + (smooth8.Trim(smooth8.FrameCount-1,length=1)+smooth9.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth9 + (smooth9.Trim(smooth9.FrameCount-1,length=1)+smooth10.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth10 + (smooth10.Trim(smooth10.FrameCount-1,length=1)+smooth11.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth11 + (smooth11.Trim(smooth11.FrameCount-1,length=1)+smooth12.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps)

#smooth12 + (smooth12.Trim(smooth12.FrameCount-1,length=1)+smooth13.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth13 + (smooth13.Trim(smooth13.FrameCount-1,length=1)+smooth14.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth14 + (smooth14.Trim(smooth14.FrameCount-1,length=1)+smooth15.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth15 + (smooth15.Trim(smooth15.FrameCount-1,length=1)+smooth16.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth16 + (smooth16.Trim(smooth16.FrameCount-1,length=1)+smooth17.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth17 + (smooth17.Trim(smooth17.FrameCount-1,length=1)+smooth18.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth18 + (smooth18.Trim(smooth18.FrameCount-1,length=1)+smooth19.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth19 + (smooth19.Trim(smooth19.FrameCount-1,length=1)+smooth20.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth20 + (smooth20.Trim(smooth20.FrameCount-1,length=1)+smooth21.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth21 + (smooth21.Trim(smooth21.FrameCount-1,length=1)+smooth22.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps)

#smooth22 + (smooth22.Trim(smooth22.FrameCount-1,length=1)+smooth23.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth23 + (smooth23.Trim(smooth23.FrameCount-1,length=1)+smooth24.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth24 + (smooth24.Trim(smooth24.FrameCount-1,length=1)+smooth25.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth25 + (smooth25.Trim(smooth25.FrameCount-1,length=1)+smooth26.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth26 + (smooth26.Trim(smooth26.FrameCount-1,length=1)+smooth27.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth27 + (smooth27.Trim(smooth27.FrameCount-1,length=1)+smooth28.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth28 + (smooth28.Trim(smooth28.FrameCount-1,length=1)+smooth29.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth29 + (smooth29.Trim(smooth29.FrameCount-1,length=1)+smooth30.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth30 + (smooth30.Trim(smooth30.FrameCount-1,length=1)+smooth31.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth31 + (smooth31.Trim(smooth31.FrameCount-1,length=1)+smooth32.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps)

#smooth32 + (smooth32.Trim(smooth32.FrameCount-1,length=1)+smooth33.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth33 + (smooth33.Trim(smooth33.FrameCount-1,length=1)+smooth34.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth34 + (smooth34.Trim(smooth34.FrameCount-1,length=1)+smooth35.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth35 + (smooth35.Trim(smooth35.FrameCount-1,length=1)+smooth36.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth36 + (smooth36.Trim(smooth36.FrameCount-1,length=1)+smooth37.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth37 + (smooth37.Trim(smooth37.FrameCount-1,length=1)+smooth38.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth38 + (smooth38.Trim(smooth38.FrameCount-1,length=1)+smooth39.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth39 + (smooth39.Trim(smooth39.FrameCount-1,length=1)+smooth40.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth40 + (smooth40.Trim(smooth40.FrameCount-1,length=1)+smooth41.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth41 + (smooth41.Trim(smooth41.FrameCount-1,length=1)+smooth42.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps)

#smooth42 + (smooth42.Trim(smooth42.FrameCount-1,length=1)+smooth43.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth43 + (smooth43.Trim(smooth43.FrameCount-1,length=1)+smooth44.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth44 + (smooth44.Trim(smooth44.FrameCount-1,length=1)+smooth45.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth45 + (smooth45.Trim(smooth45.FrameCount-1,length=1)+smooth46.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth46 + (smooth46.Trim(smooth46.FrameCount-1,length=1)+smooth47.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth47 + (smooth47.Trim(smooth47.FrameCount-1,length=1)+smooth48.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth48 + (smooth48.Trim(smooth48.FrameCount-1,length=1)+smooth49.Trim(0,length=1)).AssumeFPS(fps*2/3).ChangeFPS(fps) + smooth49

#smooth1 + (smooth1.Trim(smooth1.FrameCount-1,length=1)+smooth2.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth2 + (smooth2.Trim(smooth2.FrameCount-1,length=1)+smooth3.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth3 + (smooth3.Trim(smooth3.FrameCount-1,length=1)+smooth4.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth4 + (smooth4.Trim(smooth4.FrameCount-1,length=1)+smooth5.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth5 + (smooth5.Trim(smooth5.FrameCount-1,length=1)+smooth6.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth6 + (smooth6.Trim(smooth6.FrameCount-1,length=1)+smooth7.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth7 + (smooth7.Trim(smooth7.FrameCount-1,length=1)+smooth8.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth8 + (smooth8.Trim(smooth8.FrameCount-1,length=1)+smooth9.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth9 + (smooth9.Trim(smooth9.FrameCount-1,length=1)+smooth10.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth10 + (smooth10.Trim(smooth10.FrameCount-1,length=1)+smooth11.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth11 + (smooth11.Trim(smooth11.FrameCount-1,length=1)+smooth12.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps)
#smooth12 + (smooth12.Trim(smooth12.FrameCount-1,length=1)+smooth13.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth13 + (smooth13.Trim(smooth13.FrameCount-1,length=1)+smooth14.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth14 + (smooth14.Trim(smooth14.FrameCount-1,length=1)+smooth15.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth15 + (smooth15.Trim(smooth15.FrameCount-1,length=1)+smooth16.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth16 + (smooth16.Trim(smooth16.FrameCount-1,length=1)+smooth17.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth17 + (smooth17.Trim(smooth17.FrameCount-1,length=1)+smooth18.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth18 + (smooth18.Trim(smooth18.FrameCount-1,length=1)+smooth19.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth19 + (smooth19.Trim(smooth19.FrameCount-1,length=1)+smooth20.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth20 + (smooth20.Trim(smooth20.FrameCount-1,length=1)+smooth21.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth21 + (smooth21.Trim(smooth21.FrameCount-1,length=1)+smooth22.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps)
#smooth22 + (smooth22.Trim(smooth22.FrameCount-1,length=1)+smooth23.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth23 + (smooth23.Trim(smooth23.FrameCount-1,length=1)+smooth24.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth24 + (smooth24.Trim(smooth24.FrameCount-1,length=1)+smooth25.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth25 + (smooth25.Trim(smooth25.FrameCount-1,length=1)+smooth26.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth26 + (smooth26.Trim(smooth26.FrameCount-1,length=1)+smooth27.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth27 + (smooth27.Trim(smooth27.FrameCount-1,length=1)+smooth28.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth28 + (smooth28.Trim(smooth28.FrameCount-1,length=1)+smooth29.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth29 + (smooth29.Trim(smooth29.FrameCount-1,length=1)+smooth30.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth30 + (smooth30.Trim(smooth30.FrameCount-1,length=1)+smooth31.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth31 + (smooth31.Trim(smooth31.FrameCount-1,length=1)+smooth32.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps)
#smooth32 + (smooth32.Trim(smooth32.FrameCount-1,length=1)+smooth33.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth33 + (smooth33.Trim(smooth33.FrameCount-1,length=1)+smooth34.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth34 + (smooth34.Trim(smooth34.FrameCount-1,length=1)+smooth35.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth35 + (smooth35.Trim(smooth35.FrameCount-1,length=1)+smooth36.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth36 + (smooth36.Trim(smooth36.FrameCount-1,length=1)+smooth37.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth37 + (smooth37.Trim(smooth37.FrameCount-1,length=1)+smooth38.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth38 + (smooth38.Trim(smooth38.FrameCount-1,length=1)+smooth39.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth39 + (smooth39.Trim(smooth39.FrameCount-1,length=1)+smooth40.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth40 + (smooth40.Trim(smooth40.FrameCount-1,length=1)+smooth41.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth41 + (smooth41.Trim(smooth41.FrameCount-1,length=1)+smooth42.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps)
#smooth42 + (smooth42.Trim(smooth42.FrameCount-1,length=1)+smooth43.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth43 + (smooth43.Trim(smooth43.FrameCount-1,length=1)+smooth44.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth44 + (smooth44.Trim(smooth44.FrameCount-1,length=1)+smooth45.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth45 + (smooth45.Trim(smooth45.FrameCount-1,length=1)+smooth46.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth46 + (smooth46.Trim(smooth46.FrameCount-1,length=1)+smooth47.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth47 + (smooth47.Trim(smooth47.FrameCount-1,length=1)+smooth48.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth48 + (smooth48.Trim(smooth48.FrameCount-1,length=1)+smooth49.Trim(0,length=1)).AssumeFPS(fps*2.5/3).ChangeFPS(fps) + smooth49

#smooth1 + (smooth1.Trim(smooth1.FrameCount-1,length=1)+smooth2.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth2 + (smooth2.Trim(smooth2.FrameCount-1,length=1)+smooth3.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth3 + (smooth3.Trim(smooth3.FrameCount-1,length=1)+smooth4.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth4 + (smooth4.Trim(smooth4.FrameCount-1,length=1)+smooth5.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth5 + (smooth5.Trim(smooth5.FrameCount-1,length=1)+smooth6.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth6 + (smooth6.Trim(smooth6.FrameCount-1,length=1)+smooth7.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth7 + (smooth7.Trim(smooth7.FrameCount-1,length=1)+smooth8.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth8 + (smooth8.Trim(smooth8.FrameCount-1,length=1)+smooth9.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth9 + (smooth9.Trim(smooth9.FrameCount-1,length=1)+smooth10.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth10 + (smooth10.Trim(smooth10.FrameCount-1,length=1)+smooth11.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth11 + (smooth11.Trim(smooth11.FrameCount-1,length=1)+smooth12.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth12 + (smooth12.Trim(smooth12.FrameCount-1,length=1)+smooth13.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth13 + (smooth13.Trim(smooth13.FrameCount-1,length=1)+smooth14.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth14 + (smooth14.Trim(smooth14.FrameCount-1,length=1)+smooth15.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth15 + (smooth15.Trim(smooth15.FrameCount-1,length=1)+smooth16.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth16 + (smooth16.Trim(smooth16.FrameCount-1,length=1)+smooth17.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth17 + (smooth17.Trim(smooth17.FrameCount-1,length=1)+smooth18.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth18 + (smooth18.Trim(smooth18.FrameCount-1,length=1)+smooth19.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth19 + (smooth19.Trim(smooth19.FrameCount-1,length=1)+smooth20.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth20 + (smooth20.Trim(smooth20.FrameCount-1,length=1)+smooth21.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth21 + (smooth21.Trim(smooth21.FrameCount-1,length=1)+smooth22.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth22 + (smooth22.Trim(smooth22.FrameCount-1,length=1)+smooth23.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth23 + (smooth23.Trim(smooth23.FrameCount-1,length=1)+smooth24.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth24 + (smooth24.Trim(smooth24.FrameCount-1,length=1)+smooth25.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth25 + (smooth25.Trim(smooth25.FrameCount-1,length=1)+smooth26.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth26 + (smooth26.Trim(smooth26.FrameCount-1,length=1)+smooth27.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth27 + (smooth27.Trim(smooth27.FrameCount-1,length=1)+smooth28.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth28 + (smooth28.Trim(smooth28.FrameCount-1,length=1)+smooth29.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth29 + (smooth29.Trim(smooth29.FrameCount-1,length=1)+smooth30.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth30 + (smooth30.Trim(smooth30.FrameCount-1,length=1)+smooth31.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth31 + (smooth31.Trim(smooth31.FrameCount-1,length=1)+smooth32.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth32 + (smooth32.Trim(smooth32.FrameCount-1,length=1)+smooth33.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth33 + (smooth33.Trim(smooth33.FrameCount-1,length=1)+smooth34.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth34 + (smooth34.Trim(smooth34.FrameCount-1,length=1)+smooth35.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth35 + (smooth35.Trim(smooth35.FrameCount-1,length=1)+smooth36.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth36 + (smooth36.Trim(smooth36.FrameCount-1,length=1)+smooth37.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth37 + (smooth37.Trim(smooth37.FrameCount-1,length=1)+smooth38.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth38 + (smooth38.Trim(smooth38.FrameCount-1,length=1)+smooth39.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth39 + (smooth39.Trim(smooth39.FrameCount-1,length=1)+smooth40.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth40 + (smooth40.Trim(smooth40.FrameCount-1,length=1)+smooth41.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth41 + (smooth41.Trim(smooth41.FrameCount-1,length=1)+smooth42.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth42 + (smooth42.Trim(smooth42.FrameCount-1,length=1)+smooth43.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth43 + (smooth43.Trim(smooth43.FrameCount-1,length=1)+smooth44.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth44 + (smooth44.Trim(smooth44.FrameCount-1,length=1)+smooth45.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth45 + (smooth45.Trim(smooth45.FrameCount-1,length=1)+smooth46.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth46 + (smooth46.Trim(smooth46.FrameCount-1,length=1)+smooth47.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth47 + (smooth47.Trim(smooth47.FrameCount-1,length=1)+smooth48.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth48 + (smooth48.Trim(smooth48.FrameCount-1,length=1)+smooth49.Trim(0,length=1)).AssumeFPS(fps*2.0/3.0).ChangeFPS(fps) + smooth49

#smooth1+ smooth2+smooth3
#interpolate(input1+input2+input3,smoothfps_params1)

#smooth1 + (smooth1.Trim(smooth1.FrameCount-1,length=1)+smooth2.Trim(0,length=1)) + smooth2 + (smooth2.Trim(smooth2.FrameCount-1,length=1)+smooth3.Trim(0,length=1)) + smooth3 + (smooth3.Trim(smooth3.FrameCount-1,length=1)+smooth4.Trim(0,length=1)) + smooth4 + (smooth4.Trim(smooth4.FrameCount-1,length=1)+smooth5.Trim(0,length=1)) + smooth5 + (smooth5.Trim(smooth5.FrameCount-1,length=1)+smooth6.Trim(0,length=1)) + smooth6 + (smooth6.Trim(smooth6.FrameCount-1,length=1)+smooth7.Trim(0,length=1)) + smooth7 + (smooth7.Trim(smooth7.FrameCount-1,length=1)+smooth8.Trim(0,length=1)) + smooth8 + (smooth8.Trim(smooth8.FrameCount-1,length=1)+smooth9.Trim(0,length=1)) + smooth9 + (smooth9.Trim(smooth9.FrameCount-1,length=1)+smooth10.Trim(0,length=1)) + smooth10 + (smooth10.Trim(smooth10.FrameCount-1,length=1)+smooth11.Trim(0,length=1)) + smooth11 + (smooth11.Trim(smooth11.FrameCount-1,length=1)+smooth12.Trim(0,length=1))  
#smooth12 + (smooth12.Trim(smooth12.FrameCount-1,length=1)+smooth13.Trim(0,length=1)) + smooth13 + (smooth13.Trim(smooth13.FrameCount-1,length=1)+smooth14.Trim(0,length=1)) + smooth14 + (smooth14.Trim(smooth14.FrameCount-1,length=1)+smooth15.Trim(0,length=1)) + smooth15 + (smooth15.Trim(smooth15.FrameCount-1,length=1)+smooth16.Trim(0,length=1)) + smooth16 + (smooth16.Trim(smooth16.FrameCount-1,length=1)+smooth17.Trim(0,length=1)) + smooth17 + (smooth17.Trim(smooth17.FrameCount-1,length=1)+smooth18.Trim(0,length=1)) + smooth18 + (smooth18.Trim(smooth18.FrameCount-1,length=1)+smooth19.Trim(0,length=1)) + smooth19 + (smooth19.Trim(smooth19.FrameCount-1,length=1)+smooth20.Trim(0,length=1)) + smooth20 + (smooth20.Trim(smooth20.FrameCount-1,length=1)+smooth21.Trim(0,length=1)) + smooth21 + (smooth21.Trim(smooth21.FrameCount-1,length=1)+smooth22.Trim(0,length=1))
#smooth22 + (smooth22.Trim(smooth22.FrameCount-1,length=1)+smooth23.Trim(0,length=1)) + smooth23 + (smooth23.Trim(smooth23.FrameCount-1,length=1)+smooth24.Trim(0,length=1)) + smooth24 + (smooth24.Trim(smooth24.FrameCount-1,length=1)+smooth25.Trim(0,length=1)) + smooth25 + (smooth25.Trim(smooth25.FrameCount-1,length=1)+smooth26.Trim(0,length=1)) + smooth26 + (smooth26.Trim(smooth26.FrameCount-1,length=1)+smooth27.Trim(0,length=1)) + smooth27 + (smooth27.Trim(smooth27.FrameCount-1,length=1)+smooth28.Trim(0,length=1)) + smooth28 + (smooth28.Trim(smooth28.FrameCount-1,length=1)+smooth29.Trim(0,length=1)) + smooth29 + (smooth29.Trim(smooth29.FrameCount-1,length=1)+smooth30.Trim(0,length=1)) + smooth30 + (smooth30.Trim(smooth30.FrameCount-1,length=1)+smooth31.Trim(0,length=1)) + smooth31 + (smooth31.Trim(smooth31.FrameCount-1,length=1)+smooth32.Trim(0,length=1))
#smooth32 + (smooth32.Trim(smooth32.FrameCount-1,length=1)+smooth33.Trim(0,length=1)) + smooth33 + (smooth33.Trim(smooth33.FrameCount-1,length=1)+smooth34.Trim(0,length=1)) + smooth34 + (smooth34.Trim(smooth34.FrameCount-1,length=1)+smooth35.Trim(0,length=1)) + smooth35 + (smooth35.Trim(smooth35.FrameCount-1,length=1)+smooth36.Trim(0,length=1)) + smooth36 + (smooth36.Trim(smooth36.FrameCount-1,length=1)+smooth37.Trim(0,length=1)) + smooth37 + (smooth37.Trim(smooth37.FrameCount-1,length=1)+smooth38.Trim(0,length=1)) + smooth38 + (smooth38.Trim(smooth38.FrameCount-1,length=1)+smooth39.Trim(0,length=1)) + smooth39 + (smooth39.Trim(smooth39.FrameCount-1,length=1)+smooth40.Trim(0,length=1)) + smooth40 + (smooth40.Trim(smooth40.FrameCount-1,length=1)+smooth41.Trim(0,length=1)) + smooth41 + (smooth41.Trim(smooth41.FrameCount-1,length=1)+smooth42.Trim(0,length=1))
smooth42 + (smooth42.Trim(smooth42.FrameCount-1,length=1)+smooth43.Trim(0,length=1)) + smooth43 + (smooth43.Trim(smooth43.FrameCount-1,length=1)+smooth44.Trim(0,length=1)) + smooth44 + (smooth44.Trim(smooth44.FrameCount-1,length=1)+smooth45.Trim(0,length=1)) + smooth45 + (smooth45.Trim(smooth45.FrameCount-1,length=1)+smooth46.Trim(0,length=1)) + smooth46 + (smooth46.Trim(smooth46.FrameCount-1,length=1)+smooth47.Trim(0,length=1)) + smooth47 + (smooth47.Trim(smooth47.FrameCount-1,length=1)+smooth48.Trim(0,length=1)) + smooth48 + (smooth48.Trim(smooth48.FrameCount-1,length=1)+smooth49.Trim(0,length=1)) + smooth49

#smooth1 + (smooth1.Trim(smooth1.FrameCount-1,length=1)+smooth2.Trim(0,length=1)) + smooth2 + (smooth2.Trim(smooth2.FrameCount-1,length=1)+smooth3.Trim(0,length=1)) + smooth3 + (smooth3.Trim(smooth3.FrameCount-1,length=1)+smooth4.Trim(0,length=1)) + smooth4 + (smooth4.Trim(smooth4.FrameCount-1,length=1)+smooth5.Trim(0,length=1)) + smooth5 + (smooth5.Trim(smooth5.FrameCount-1,length=1)+smooth6.Trim(0,length=1)) + smooth6 + (smooth6.Trim(smooth6.FrameCount-1,length=1)+smooth7.Trim(0,length=1)) + smooth7 + (smooth7.Trim(smooth7.FrameCount-1,length=1)+smooth8.Trim(0,length=1)) + smooth8 + (smooth8.Trim(smooth8.FrameCount-1,length=1)+smooth9.Trim(0,length=1)) + smooth9 + (smooth9.Trim(smooth9.FrameCount-1,length=1)+smooth10.Trim(0,length=1)) + smooth10 + (smooth10.Trim(smooth10.FrameCount-1,length=1)+smooth11.Trim(0,length=1)) + smooth11 + (smooth11.Trim(smooth11.FrameCount-1,length=1)+smooth12.Trim(0,length=1)) + smooth12 + (smooth12.Trim(smooth12.FrameCount-1,length=1)+smooth13.Trim(0,length=1)) + smooth13 + (smooth13.Trim(smooth13.FrameCount-1,length=1)+smooth14.Trim(0,length=1)) + smooth14 + (smooth14.Trim(smooth14.FrameCount-1,length=1)+smooth15.Trim(0,length=1)) + smooth15 + (smooth15.Trim(smooth15.FrameCount-1,length=1)+smooth16.Trim(0,length=1)) + smooth16 + (smooth16.Trim(smooth16.FrameCount-1,length=1)+smooth17.Trim(0,length=1)) + smooth17 + (smooth17.Trim(smooth17.FrameCount-1,length=1)+smooth18.Trim(0,length=1)) + smooth18 + (smooth18.Trim(smooth18.FrameCount-1,length=1)+smooth19.Trim(0,length=1)) + smooth19 + (smooth19.Trim(smooth19.FrameCount-1,length=1)+smooth20.Trim(0,length=1)) + smooth20 + (smooth20.Trim(smooth20.FrameCount-1,length=1)+smooth21.Trim(0,length=1)) + smooth21 + (smooth21.Trim(smooth21.FrameCount-1,length=1)+smooth22.Trim(0,length=1)) + smooth22 + (smooth22.Trim(smooth22.FrameCount-1,length=1)+smooth23.Trim(0,length=1)) + smooth23 + (smooth23.Trim(smooth23.FrameCount-1,length=1)+smooth24.Trim(0,length=1)) + smooth24 + (smooth24.Trim(smooth24.FrameCount-1,length=1)+smooth25.Trim(0,length=1)) + smooth25 + (smooth25.Trim(smooth25.FrameCount-1,length=1)+smooth26.Trim(0,length=1)) + smooth26 + (smooth26.Trim(smooth26.FrameCount-1,length=1)+smooth27.Trim(0,length=1)) + smooth27 + (smooth27.Trim(smooth27.FrameCount-1,length=1)+smooth28.Trim(0,length=1)) + smooth28 + (smooth28.Trim(smooth28.FrameCount-1,length=1)+smooth29.Trim(0,length=1)) + smooth29 + (smooth29.Trim(smooth29.FrameCount-1,length=1)+smooth30.Trim(0,length=1)) + smooth30 + (smooth30.Trim(smooth30.FrameCount-1,length=1)+smooth31.Trim(0,length=1)) + smooth31 + (smooth31.Trim(smooth31.FrameCount-1,length=1)+smooth32.Trim(0,length=1)) + smooth32 + (smooth32.Trim(smooth32.FrameCount-1,length=1)+smooth33.Trim(0,length=1)) + smooth33 + (smooth33.Trim(smooth33.FrameCount-1,length=1)+smooth34.Trim(0,length=1)) + smooth34 + (smooth34.Trim(smooth34.FrameCount-1,length=1)+smooth35.Trim(0,length=1)) + smooth35 + (smooth35.Trim(smooth35.FrameCount-1,length=1)+smooth36.Trim(0,length=1)) + smooth36 + (smooth36.Trim(smooth36.FrameCount-1,length=1)+smooth37.Trim(0,length=1)) + smooth37 + (smooth37.Trim(smooth37.FrameCount-1,length=1)+smooth38.Trim(0,length=1)) + smooth38 + (smooth38.Trim(smooth38.FrameCount-1,length=1)+smooth39.Trim(0,length=1)) + smooth39 + (smooth39.Trim(smooth39.FrameCount-1,length=1)+smooth40.Trim(0,length=1)) + smooth40 + (smooth40.Trim(smooth40.FrameCount-1,length=1)+smooth41.Trim(0,length=1)) + smooth41 + (smooth41.Trim(smooth41.FrameCount-1,length=1)+smooth42.Trim(0,length=1)) + smooth42 + (smooth42.Trim(smooth42.FrameCount-1,length=1)+smooth43.Trim(0,length=1)) + smooth43 + (smooth43.Trim(smooth43.FrameCount-1,length=1)+smooth44.Trim(0,length=1)) + smooth44 + (smooth44.Trim(smooth44.FrameCount-1,length=1)+smooth45.Trim(0,length=1)) + smooth45 + (smooth45.Trim(smooth45.FrameCount-1,length=1)+smooth46.Trim(0,length=1)) + smooth46 + (smooth46.Trim(smooth46.FrameCount-1,length=1)+smooth47.Trim(0,length=1)) + smooth47 + (smooth47.Trim(smooth47.FrameCount-1,length=1)+smooth48.Trim(0,length=1)) + smooth48 + (smooth48.Trim(smooth48.FrameCount-1,length=1)+smooth49.Trim(0,length=1)) + smooth49

#input1.ChangeFPS(smooth2.framerate) + smooth2
#input.interpolate(smoothfps_params2)
Prefetch(threads)