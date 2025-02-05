# contrib

## How to contribute
   - First, create a new fork of the *contrib* branch of the repo. (Uncheck the box that says *Copy the main branch only*). Feel free to delete the main branch in your fork as long as       you only pull request to this branch. Any pull requests made to the main branch will be closed.
   
   - Second, create a new folder in your repo (don't delete existing folders as this can affect others' contributions). Then name the folder something like *[your-username]*. Inside         there should be a folder covering a major version of a series of your modification(s). For example, the first version should be a subfolder. Inside there will be folders for            patches (like one folder for 1.x and inside that a folder for 1.x.x). And avoid replacing older versions of your code unless you really need to (e.g, a critical bug), as it             keeps the history of your modifications inaccessible and less people can learn from what you did.
     
   - Third, add your modified source code to that folder (refer to the *main* branch for the original source code to modify).
   
   - Fourth, submit a pull request to the repository in the *contrib* branch. You might have to wait awhile until it gets approved and your fork gets merged with the branch.
   
   - Five, that's pretty much it! Enjoy your day!

     **If you're still confused, refer to [this example fork](https://github.com/anirudhsevugan/simpliplay-android-example-fork/tree/contrib), it's [pull request](https://github.com/A-Star100/simpliplay-android/pull/2), and take a look at how it's structured**.

## About this branch
This branch is for contributions to the source code. The source code should be read from the *main* branch. Any contributions, or modified versions of the same software will be here,
with different folders for different authors. **You should NOT make pull requests for contributions in the main branch, you should make it in this branch after you've created a fork with your modifications**. 

There should be **one fork** for each contributor, or a team of contributors. This fork should be modified with all the modifications you made. **You should not make a new fork for each modification**. **Continue using the old one**.

If your contribution pleases reviewers enough, it will eventually be added to the *main* branch and be included with **all** releases of the app from then.

## Rules
1. No malicious content/code should be included in your contribution. This includes any type of malware, spyware, adware, PUPs, etc.

2. Contributions should only contain the source code not build files/SDK files (e.g, folders like *android/* or *build/*). For example, if you're editing the Flutter release, only submit the content in the *lib/* folder, where all text-based source code for the app is stored, to save on space and reduce clutter. If you really need to change these files, talk about it in your pull request.

3. Contributions should *not* contain any errors. To test any errors in your source code, try compiling your app. In the AI2 version, any errors would be either runtime errors, bugs that cause the app to freeze or unexpectedly stop, or duplicate event blocks. In the Flutter version, any errors would either be syntax errors, bugs that cause the app to freeze or unexpectedly stop, or runtime errors.

4. Keep code organized. Make separate folders if possible. (for example, *the first version should be a subfolder. Inside there will be folders for patches (like one folder for 1.x...*)
