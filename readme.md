# AJA Video Cards ❤️  Nix

This repo contains a Nix flake containing the open source AJA driver, utilities and
gstreamer plugin. This allows you to use Aja video IO cards on NixOS.


## Usage

- Add the flake to your system flake's inputs.
- Enable the module by adding the following to your system config:
  ```nix
  ntv2.enable = true;
  ```

## Gstreamer
Summon a quick network stream: `gst-launch-1.0 ajavideosrc input-channel=0 mode=29 ! videoconvert ! jpegenc quality=20 ! multipartmux  boundary="--videoboundary" ! tcpserversink host=0.0.0.0 port=6969`

NB: You must select the video mode to match what's on the input. Otherwise you will see
something like:
```
Setting pipeline to PAUSED ...
Pipeline is live and does not need PREROLL ...
Pipeline is PREROLLED ...
Setting pipeline to PLAYING ...
New clock: GstSystemClock
WARNING: from element /GstPipeline:pipeline0/GstAjaVideoSrc:ajavideosrc0: Signal lost
Additional debug info:
gstajavideosrc.cpp(1324): gst_aja_video_src_create (): /GstPipeline:pipeline0/GstAjaVideoSrc:ajavideosrc0:
No input source was detected - video frames invalid
```

You can find all the supported video modes with: `gst-inspect-1.0 ajavideosrc`.
