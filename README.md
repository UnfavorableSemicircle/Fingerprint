A quick sketch written in [Processing](https://processing.org/) to analyze the distribution of dots in each frame of a video. This works for the style of videos with single colored frames with differently colored pixels on them - this will analyze how common each position of pixel is. So far this hasn't produced any interesting results.

You will need Processing and the "Video" library to run this. When you start the program it will ask for a video file. Once you select one it will take a few seconds to load, then it will begin plotting the frequency of each position as a brightness value - dots closer to white are more common. The program is playing the video in the background and analyzing it as it plays, so the dots will change over time.

Some constants at the top of the file affect the program's behavior:
- `EXACT` controls whether it will try to read every single frame. If EXACT is false the video will always be played at the same speed no matter what - if this speed is too fast to analyze each frame then some frames will be skipped. This defaults to false; true makes it *much* slower.
- `SPEED` is the speed to play the video at if EXACT is false. Faster speeds mean less frames that are actually analyzed.
- `PIXELS` is the resolution of the video in pixels. The video is assumed to be square.
