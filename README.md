# ShareGram

>ShareGram is a mobile-ready, cloud-based picture sharing application for the iOS (8.0 and above) written in Swift 2.

  - Login and sign-up page as the first view-controller 
  - Segue to a user list to select/de-select users to view/hide their feeds.
  - "Feed" button and a "Post" button on top navigation bar to control viewing pictures and posting new pictures respectively.
  - Magic!

>Some insights:

  - Frontend elements added through the main storyboard in XCode 7.3.1 
  - Backend is enirely handled through Parse Server deployed on Heroku

>Things I learned working on the app:

- Working with navigation controllers and advanced segues. 
- Managing user data in a table-view and enabling interactive gesture recognition by receiving user clicks. 
- Effectively handle image compression in swift, as the Xcode simulator does not allow images above 10 MB. 

>Further improvements:

- Facebook login integration by using the FBSDK. 
- Asking the user to upload an image as a profile picture in addition to general info and displaying that in the table view.
