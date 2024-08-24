CC = kos32-gcc
LD = kos32-ld
OBJCOPY = kos32-objcopy

SDK_DIR = ../../..
LDFLAGS = -nostdlib -static --image-base 0 -T $(SDK_DIR)/sources/newlib/app.lds --subsystem native
CFLAGS = -c -fno-ident -O2 -fomit-frame-pointer -U__WIN32__ -U_Win32 -U_WIN32 -U__MINGW32__ -UWIN32 -D_KOLIBRI
CFLAGS += -DMUSIC_WAV -DMUSIC_OGG -DMUSIC_MP3_MINIMP3 -DMUSIC_FLAC_DRFLAC -DMUSIC_MID_TIMIDITY
LIBS = -lSDL2_mixer -lSDL2 -ltimidity -lvorbis -logg -lgcc -lc.dll -lc -lsound

INCLUDES = -I $(SDK_DIR)/sources/newlib/libc/include -I../include/ -I../../SDL-2.30.3/include/
LIBPATH = -L $(SDK_DIR)/lib -L /home/autobuild/tools/win32/mingw32/lib

default: examples

examples: $(OBJECTS) Makefile
	$(CC) $(CFLAGS) $(INCLUDES) -o playmus.o playmus.c
	$(CC) $(CFLAGS) $(INCLUDES) -o playwave.o playwave.c
	$(LD) $(LDFLAGS) $(LIBPATH) --subsystem native -o playmus playmus.o $(LIBS)
	$(LD) $(LDFLAGS) $(LIBPATH) --subsystem native -o playwave playwave.o $(LIBS)
	kos32-strip -s playmus -o playmus
	kos32-strip -s playwave -o playwave
	kos32-objcopy playmus -O binary
	kos32-objcopy playwave -O binary
	rm playmus.o
	rm playwave.o

clean:
	rm playmus
	rm playwave
