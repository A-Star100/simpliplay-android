## Compatibility
The app works on Android 5 (API 21) and above. It *also* works on Android Go devices, but it might be slower there. The only Android Go device I used to test had Play Services disabled... so it probably performed a lot better because of that. If you don't have Google Play Services installed (maybe you are using a custom ROM like LineageOS, or have rooted and degoogled your phone), the speech select feature will not work and will cause a runtime error/hang, but everything else should still work TOTALLY fine :D

microG Services may fix this, but I haven't tested with the full microG installed yet :/
_______

## Old compatibility page
It has been tested on the following devices with the following results:

| Device | Compatible? | Real Device/VM |
| -------- | ------- |  ------- |
| Android 16 (Samsung & Pixel)| Yes   |  Real Device & VM     |
| Android 15 (Samsung & Pixel)| Yes  |   Real Device & VM   |
| Android 14 (Samsung & Xiaomi)| Yes  |   Real Device   |
| Android 13 (Samsung - LineageOS)| Yes  |   Real Device   |
| Android 11 (Xiaomi) | Yes  |   Real Device  |
| Android 9 Go (AT&T)| Yes  |   Real Device   |
| Android 8 (Pixel)| Yes  |   VM   |
| Android 7 (Samsung - LineageOS)| Yes  |   Real Device   |
| Android 5 (Pixel)| Yes (not too well on VMs)  |   VM   |
| Android 4.4 | **No**  |   Real Device   |

*Android 5 VMs have encoding issues that don't occur on real Android 5 devices. Real devices should play media properly*.


**The app *CANNOT* be installed on Android 4.4 and below due to an installation minimum of Android 5+. Just for test's sake, I removed the limit, and the app freezed every single time I attempted to launch it, so it is not compatible. It relies on ExoPlayer 2 at launch (initializes in the background for faster media loading), and since that always fails on Android 4.4 and below, the app does not work. And even if ExoPlayer 2 was intialized in a separate screen, it would still fail when navigating to said screen.**
