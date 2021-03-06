# Youtube Searcher

This is an app that allows users to search Youtube's top 10 rated videos given a search term and then watch those videos.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them

* [Xcode](https://developer.apple.com/download/more/?&name=Xcode) - Xcode 9.3+
* [Cocoapods](https://guides.cocoapods.org/using/getting-started.html) - can be installed on a Mac by running `sudo gem install cocoapods` in terminal

### Installing

A step by step series of examples that tell you how to get a development env running

Open Terminal App 

```
Go to spotlight and start type Terminal, and select it. Or select Terminal from Dock if you have it there.
```

Clone Project

```
git clone https://github.com/leolopez13/ApplicasterYouTube.git
```

Open Project

```
When opening in Xcode, make sure to open, and use, YoutubeSearcher.xcworkspace and not YoutubeSearcher.xcodeproj due to cocoapods
```

Should be able to press build and run (Command+R) to load and install the app on the simulator and run

## Screenshots 

* [Ghoul States](https://raw.githubusercontent.com/leolopez13/ApplicasterYouTube/master/youtubeSearchGhoulStates.png) - Ghoul states when first loading the app
* [Content Loaded](https://raw.githubusercontent.com/leolopez13/ApplicasterYouTube/master/youtubeSearchWithVideos.png) - Search results populated
* [Video Playing](https://raw.githubusercontent.com/leolopez13/ApplicasterYouTube/master/youtubeSearchVideoPlaying.png) - Youtube player playing video

## Running the tests

The tests can be ran within the Xcode Workspace by pressing Command+U or navigating to the Project Menu -> Test

### Break down into end to end tests

YoutubeSearcherTests.swift tests creation of a model (YoutubeVideo) that is used to display information and used to load videos from a GTLRYouTube_Video object. We need to make sure it's getting instantiated correctly and when it is not, it returns that correct error.
```
testBadYouTubeVideoData() - tests the correct error is thrown with bad data
testBuildWithYouTubeVideo() - tests the object is instantiated correctly with an actual GTLRYouTube_Video
testISOFormattingWithHours() - tests the formatting of the string returned by the GTLRYouTube_Video which is in ISO8601 format
testISOFormattingWithMinutes() - tests the formatting of the string returned by the GTLRYouTube_Video which is in ISO8601 format
testISOFormattingWithSeconds() - tests the formatting of the string returned by the GTLRYouTube_Video which is in ISO8601 format
testSearching() - UI test - Want to test that we can query the Youtube API with a search term
testPlayVideo() - UI test - Want to test that we can still query the Youtube API with a search term and then play a video from that result in the youtube player
```

## Deployment

Project will need to be built manually for now via archiving and uploading a .ipa to the AppStore. Jenkins could be integrated to create automated builds.

## Built With

* [Xcode 9.4](https://developer.apple.com/download/more/?&name=Xcode) - The development IDE 
* [Cocoapods 1.5.3](https://guides.cocoapods.org/using/getting-started.html) - Library manager used to bring in third party frameworks and use them in the project

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Leonard Lopez** - *Initial work* - [YoutubeSearcher](https://github.com/leolopez13/ApplicasterYouTube)

## License

This project is licensed under the MIT and BSD Licenses - See the [MIT](https://opensource.org/licenses/MIT) and [BSD](https://en.wikipedia.org/wiki/BSD_licenses) sites for details

## Acknowledgments

* Applicaster for the inspiration behind the app

