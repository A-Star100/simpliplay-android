# simpliplay-android
*(formerly known as ExoPlayer Creator)*

An Android app that allows you to play video using ExoPlayer, which supports many video formats, supports subtitles, and even includes support for playlists in the AI2 releases!
The **Flutter** version utilizes **Media3**, and the **App Inventor (AI2)** version utilizes **Media2**.

Looking for the **iOS** version? Check out [simpliplay-ios](https://github.com/A-Star100/simpliplay-ios)!

## App Inventor Ver.
The App Inventor version primarily uses the [ExoPlayer for App Inventor](https://github.com/zainulhassan815/exoplayer-appinventor) extension to create ExoPlayer initializations, and is a modified version of the 1.0.4 AIA version of the [ExoPlayer for App Inventor demo](https://github.com/zainulhassan815/exoplayer-appinventor/blob/v2.0/aia/exoplayer_v1.0.4.aia).

**Some extensions used in the App Inventor version are *not* open source, while others are**.

| Extensions | First Used |
| -------- | ------- |
| ExoPlayer for App Inventor  | v1 |
| RelativeView | v1    |
| ComponentTools | v1   |
| ~~UpdateMyApp~~ | v1.4.1 - v3.3 |
| UrsAI2SideBar | v2.0  |
| OriginalToast | v2.2  |
| Network | v2.4  |
| UrsAI2KeepAwake | v2.5  |
| ~~GetMetrics~~ | v2.5 - v4.4.3  |
| CustomSpotlight | v3.1  |
| ImageNotifier | v3.2.2 |
| CustomDownloader | v3.4 |
| AltNotifier | v3.4 |
| NotificationStyle | v3.4 |
| TaifunClipboard | v4.3.1 |
| GestureDetect | v4.6 |

It has been tested on the following devices with the following results:

| Device | Compatible? | Real Device/VM |
| -------- | ------- |  ------- |
| Android 15 (Pixel)| Yes   |  VM     |
| Android 14 (Samsung & Xiaomi)| Yes  |   Real Device   |
| Android 11 (Xiaomi) | Yes  |   Real Device  |
| Android 9 (Pixel)| Yes  |   VM   |
| Android 8 (Pixel)| Yes  |   VM   |
| Android 5 (Pixel)| **Partially**  |   VM   |

*Android 5 support may be broken on a real device, typically real devices have no issue like VMs, but you never know.*.

## Flutter Ver.
The Flutter version was built in Android Studio with the Flutter plugin, and primarily relies on the video_player and chewie plugins, uses the keep_screen_on plugin to keep screen active when playing a video, uses the file_picker plugin to pick a media file on your device to play, and unlike the App Inventor version, uses a newer UI standard, which is rendered with [Skia](https://skia.org/), Material UI 2, instead of the App Inventor version's OG Material Design and UI 1.

It uses **Media 3 ExoPlayer**, something the App Inventor version would've been dreaming of, but it has less controls, however, as a result, this version is *much* more user-friendly, and uses only ExoPlayer. It does not support a quality selector, or advanced audio settings, but it supports everything else the App Inventor version does in the ExoPlayer point of view (P.O.V).

## Media3 Demo (Very Early Demo)
> [!WARNING]
> This version doesn't support media URLs or files, and serves as a demo in its purest form. It's also **no longer supported**, and will not recieve updates on further notice.

The Media3 Demo was built in Android Studio using Kotlin, and uses the [Media3 Player](https://github.com/akhorasani/Media3Player) app by [@akhorasani](https://github.com/akhorasani) as a base for all Media3 support, and uses the traditional INTENT methods for URL redirects in Kotlin.

It, unlike the other 2 versions, is in a **very early** state right now and does not support video URLs (believe me, I tried, and failed), as of now. However, the placeholder video is the [Big Buck Bunny](https://peach.blender.org/) short film, stored in a GCP (Google Cloud Protocol) storage bucket.





