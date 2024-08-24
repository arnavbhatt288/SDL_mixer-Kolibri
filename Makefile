CC = kos32-gcc
AR = kos32-ar
LD = kos32-ld
STRIP = kos32-strip

LIBNAME=libSDL2_mixer
TIMIDITY=libtimidity

LIBS:= -lSDL2 -ltimidity -lvorbis -logg -lgcc -lc.dll -ldll -lsound
TLIBS:= -lSDL2 -lgcc -lc.dll -ldll -lsound

LDFLAGS+= -shared -s -T dll.lds --entry _DllStartup --image-base=0 --out-implib $(LIBNAME).dll.a
TLDFLAGS+= -shared -s -T dll.lds --entry _DllStartup --image-base=0 --out-implib $(TIMIDITY).dll.a
LDFLAGS+= -L/home/autobuild/tools/win32/mingw32/lib -L../../lib

OBJS =	src/utils.o \
		src/effect_position.o \
		src/effects_internal.o \
		src/effect_stereoreverse.o \
		src/mixer.o \
		src/music.o \
		src/codecs/load_aiff.o \
		src/codecs/load_voc.o \
		src/codecs/music_wav.o \
		src/codecs/music_ogg.o \
		src/codecs/music_ogg_stb.o \
		src/codecs/music_flac.o \
		src/codecs/music_drflac.o \
		src/codecs/music_wavpack.o \
		src/codecs/mp3utils.o \
    	src/codecs/music_mpg123.o \
     	src/codecs/music_minimp3.o \
      	src/codecs/music_xmp.o \
       	src/codecs/music_modplug.o \
        src/codecs/music_gme.o \
        src/codecs/music_fluidsynth.o \
        src/codecs/music_timidity.o

TOBJS = src/codecs/timidity/common.o \
		src/codecs/timidity/instrum.o \
		src/codecs/timidity/mix.o \
		src/codecs/timidity/output.o \
		src/codecs/timidity/playmidi.o \
		src/codecs/timidity/readmidi.o \
		src/codecs/timidity/resample.o \
		src/codecs/timidity/tables.o \
		src/codecs/timidity/timidity.o

CFLAGS = -c -O2 -mpreferred-stack-boundary=2 -fno-ident -fomit-frame-pointer -fno-stack-check \
-fno-stack-protector -mno-stack-arg-probe -fno-exceptions -fno-asynchronous-unwind-tables \
-ffast-math -mno-ms-bitfields -march=pentium-mmx \
-U_Win32 -UWIN32 -U_WIN32 -U__MINGW32__ -U__WIN32__ \
-I../newlib/libc/include/ -I../SDL-2.30.3/include/ -Iinclude/ -Isrc/ -Isrc/codecs \
-I -Isrc/codecs/dr_libs -Isrc/codecs/minimp3 -Isrc/codecs/timidity \
-I../libogg-1.3.5/include -I.. -I../libvorbis-1.3.7/include \
-DMUSIC_WAV -DMUSIC_OGG -DMUSIC_MP3_MINIMP3 -DMUSIC_FLAC_DRFLAC -DMUSIC_MID_TIMIDITY \

all:  $(TIMIDITY).a $(TIMIDITY).dll $(LIBNAME).a $(LIBNAME).dll

$(TIMIDITY).a: $(TOBJS)
	$(AR) -crs  ../../lib/$@ $^

$(TIMIDITY).dll: $(TOBJS)
	$(LD) $(LDFLAGS) -o $@ $^ $(TLIBS)
	$(STRIP) -S $@

$(LIBNAME).a: $(OBJS)
	$(AR) -crs  ../../lib/$@ $^

$(LIBNAME).dll: $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^ $(LIBS)
	$(STRIP) -S $@

%.o : %.c Makefile
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f $(OBJS) ../../lib/$(LIBNAME).a ../../lib/$(TIMIDITY).a $(LIBNAME).dll $(LIBNAME).dll.a $(TIMIDITY).dll $(TIMIDITY).dll.a
