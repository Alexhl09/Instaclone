# Project 4 - *Instagram*

**Instagram* is a photo sharing app using Parse as its backend.

Time spent: **20** hours spent in total http://g.recordit.co/85V7gVADp8.gif

## User Stories

The following **required** functionality is completed:

- [x] User can sign up to create a new account using Parse authentication
- [x] User can log in and log out of his or her account
- [x] The current signed in user is persisted across app restarts
- [x] User can take a photo, add a caption, and post it to "Instagram"
- [x] User can view the last 20 posts submitted to "Instagram"
- [x] User can pull to refresh the last 20 posts submitted to "Instagram"
- [x] User can tap a post to view post details, including timestamp and caption.

The following **optional** features are implemented:

- [x] Run your app on your phone and use the camera to take the photo
- [x] Style the login page to look like the real Instagram login page.
- [x] Style the feed to look like the real Instagram feed.
- [x] User can use a tab bar to switch between all "Instagram" posts and posts published only by the user. AKA, tabs for Home Feed and Profile
- [ ] User can load more posts once he or she reaches the bottom of the feed using infinite scrolling.
- [x] Show the username and creation time for each post
- [x] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse
- User Profiles:
  - [x] Allow the logged in user to add a profile photo
  - [x] Display the profile photo with each post
  - [x] Tapping on a post's username or profile photo goes to that user's profile page
- [ ] User can comment on a post and see all comments for each post in the post details screen.
- [x] User can like a post and see number of likes for each post in the post details screen.
- [x] Implement a custom camera view.

The following **additional** features are implemented:

- [x] Implemented filters with a cocoapod
- [x] Can change the profile's picture
Please list two areas of the assignment you'd like to discuss further with your peers during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

Protocols and delegate are so useful, I hadn't used them before, but I am so glad to know about them know
Structure of NoSQL Databases, I think that many people didnt undestand documents inside of a collection

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://g.recordit.co/85V7gVADp8.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [Parse]
- DateTools
- [YPImagePicker]
- [ActivityBar]

## Notes

Describe any challenges encountered while building the app.

I had a serious problem with github, I installed a cocoapod that later I didn't use, but I commit that version. when I was trying to push my commits, one of them was too big that github didn't let me to push my changes. I had to save my last version and remove all the previous commits.

## License

    Copyright [2019] [Alejandro Hernandez Lopez]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
