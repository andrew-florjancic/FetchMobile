## Overview
This project is my implementation of this programming assignment from Fetch Rewards: https://d3jbb8n5wk0qxi.cloudfront.net/take-home-project.html

Your task is to build a recipe app that displays recipes from the provided API endpoint.

At a minimum, each recipe should show its name, photo, and cuisine type. You’re welcome to display additional details, add features, or sort the recipes in any way you see fit.

The app should allow users to refresh the list of recipes at any time, and you can decide how to implement this in the UI. You’re free to include any additional UI elements you think would enhance the experience. The app should consist of at least one screen displaying a list of recipes.

### Requirements

* Swift Concurrency: Use async/await for all asynchronous operations, including API calls and image loading.

* No External Dependencies: Your implementation should rely only on Apple's frameworks. Do not include third-party libraries for ui, networking, image caching, or testing.

* Efficient Network Usage: Load images only when needed in the UI to avoid unnecessary bandwidth consumption. Cache images to disk to minimize repeated network requests. Implement this fully yourself without relying on any third-party solutions, URLSession's HTTP default cache setup, or the URLCache implementation.

* Testing: Include unit tests to demonstrate your approach to testing. Use your judgement to determine what should be tested and the appropriate level of coverage. Focus on testing the core logic of your app (e.g., data fetching and caching). UI and integration tests are not required for this exercise.

* SwiftUI: The app's user interface must be built using SwiftUI. This is what we activly use for UI at Fetch. We expect engineers to stay up-to-date on the modern UI tooling available from Apple.

## Usage
This application is intended to be viewed ONLY. Under no circumstances is anyone authorized to download, install, copy, reproduce, distribute, or sell any ideas, source code, or compiled code from this project. Thanks :)

### Summary: Include screen shots or a video of your app highlighting its features
<img src="https://github.com/user-attachments/assets/0c653411-c5fd-46d7-b2a9-0985c3376fda" />
<div display="flex">
  <img src="https://github.com/user-attachments/assets/59706515-3cfe-4fcc-b805-72331e95a72b" width="32%" />
  <img src="https://github.com/user-attachments/assets/e0a958a1-675d-425e-baa8-a3c1fe817b1d" width="32%" />
  <img src="https://github.com/user-attachments/assets/0b59b89a-8b7c-4bd6-bc0d-b9afb352d96b" width="32%" />
</div> 
<div>
   <video src="https://github.com/user-attachments/assets/eeb9371b-0ac2-45fe-b31d-370d96899829" width="32%" />
</div>


### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
I chose to prioritize everything else except for the UI because judging by the lack of UI test requirements in the assignment this seems to be the most unimportant part of the assignment. The UI is also the easiest part to update without major modifications.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
A few hours every day for about a week with an additional day of about 8 hours to wrap everything up and add unit tests.
I started with a proof of concept MVP product in a throw away project to get the bare bones app built to see what kind of gotchas I would run into and if there were any areas I needed to review documentation or test out a few different ideas.
After completing the MVP I had better idea on how best to spend my time developing.
I knew I wanted to include some additional features such as filter and sorting of the recipes and a detail view. Since these really aren't required and are just nice to haves I saved them for last and focused on the developting the core application features first.

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
Sure, the UI is disgustingly basic because it was fast and easy to develop this way. I also chose to start with an MVP proof of concept project which added additional development time but arguably resulted in a better final product. There's always room for improvement and iterating on the current design so this is by no means perfect but it's a good start. One additional feature that could add value is to implement a search function to search for a recipe.

### Weakest Part of the Project: What do you think is the weakest part of your project?
The UI is most definitely the weakest part of the project. It's basic but functional.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
Producing professional quality code from scratch outside of a mature development environment without using any 3rd party libraries or in house solutions is a lot more work.
My poor 2017 MacBook pro that is hanging on by a thread crashed so many times during development, very frustrating. It sounds like a spaceship blasting off every time Xcode compiles. Please hire me so I can fling this piece of junk like a frisbee straight into the dumpster and buy a new laptop :) 
