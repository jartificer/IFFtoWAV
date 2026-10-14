# IFFtoWAV

IFFtoWAV is a quick and dirty solution for converting the Amiga Soundtracker soundpack collection (ST-XX) into WAV files that can then be used in modern DAWs or other sound editing applications.

You'll need a few things to get going: 
1. A Windows machine,
2. A recent version of [Sound eXchange (SoX)](http://sox.sourceforge.net/) installed locally and added to your PATH as an environment variable
3. And, of course, the original sample packs themselves. 

Please copy the original LHA files to a folder not containing any other files or folders. You should then extract the original audio samples in the LHA packs to individual subdirectories inside the parent folder.

The Internet Archive appears to have several versions of the full collection - some converted incorrectly and [one in the correct original format](https://archive.org/details/AmigaSTXX). The latter version, once extracted, should match the folder structure required by the batch script. One way to tell the original audio files from conversions is that they have no file extension (some of the file names may contain a dot, but it does not serve to indicate a file extension). 

```
ST-XX
  |______ST-01
  |        |_____Sample1
  |        |_____Sample2
  |        |_____Sample3
  |        |_____...
  |______ST-02
  |        |_____Sample1
  |        |_____...
  |______...
```

Pass the parent folder path (ST-XX in the above example) as an argument to the batch file, and the program will write a WAV version of every sample to a separate output folder that mirrors the source folder structure. The original files are only read - they are never renamed, modified or deleted. By default the output goes to a folder next to the source folder with a `-WAV` suffix (e.g. `ST-XX-WAV`); you can choose a different location with the optional second argument. 
The script is fairly quick, and it can go through the full collection in a matter of minutes. Also, it differentiates between 8svx and raw files so all the output audio files should be correctly converted and pitched as long as they match any of the two formats used in the ST-XX collection.

```
Usage: ifftowav [stxxpath] [outputpath]
```
