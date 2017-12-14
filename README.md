# SubredditCodable

Students will build an app that will allow to search posts by subreddit. After creating a search you should see a list of the most recent posts in that subreddit. This app will allow you to practice asynchronous network requests, working with JSON data, using the Codable protocol, closures, and intermediate table views.

Students who complete this project independently are able to:

* use URLSession to make asynchronous network calls
* parse JSON data and generate model objects from the data using Codable
* use closures to execute code when an asynchronous task is complete
* build custom table views

### Implement Model

Before creating your model you'll want to inspect a sample of the JSON data that will come back from a search. Go to the [Reddit API Documentation](https://www.reddit.com/dev/api/) and see what url you will need to get the desired information. After browsing through and seeing what possibilities there are, go ahead and view the hint below.
<details> 
<summary><code>Hint:</code></summary>

> Go to https://www.reddit.com/r/funny (If you add `.json` to the end of this it will return this page in JSON.)
</details>

1. Create a `Post.swift` file that will hold the information of a `Post`.

You will need to pay close attention to the sample JSON in order to structure your `Post.swift` file properly. When using the Codable protocol you need to make your model object `codable`. For this project we only need to adopt the `Decodable` protocol. You will see how by making an object where each of it's properties themselves are `codable` you can `decode` your JSON into `posts` without any further work. You will notice that the data we are interested in (Each post's information) in the JSON is quite nested. We will use the sample JSON as our guide to creating a structure matching the JSON.

2. Create a struct called `JSONDictionary` with the following property:
* `let data: DataDictionary`
3. Inside of the `JSONDictionary` create a struct called `DataDictionary` with the following property: 
    * `let children: [PostDictionary]`
4. Inside of the `DataDictionary` create a struct called `PostDictionary` with the following:
    *  `let post = Post`
    * You'll also need a `CodingKeys` enum to use `data` as the key instead of `post`. *Reference the [documentation](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types) if you need a refresher on how this is to be done.
5. Outside of these structs, create a new struct called `Post` with the following properties:

```
let title: String
let thumbnailEndpoint: String
let numberOfUpvotes: Int
let numberOfComments: Int
```
* Use the sample JSON to create your `CodingKeys` to get each of these values.

### Post Controller

##### Create a `PostController` class. 

This class will use `URLSession` to fetch data from the API. It will then decode that data into `Post` objects. It will need a function that will fetch Post objects and another that will fetch the image of each post. These functions will be called in the view controller who will be notified when they are finished through a completion closure. This is especially useful when performing asyncronous network requests.

1. Create a static constant `shared` instance of this class.
2. Create a static constant that represents the `baseURL` of the API.
3. Create a variable called `posts` that will be an array of the posts we get back from the web.
4. Add a function `fetchPosts(by searchTerm: ...)` that allows the developer to pass in the search parameter from the user. Also provide a completion closure to run 'some code' when the function has completed it's work.
5. Create a constant `url` that will hold the `baseURL` with the component `searchTerm` appended to it. Remember, you'll also need to append `".json"`
6. Create a `URLSession` dataTask. Choose the option that takes in a `URL`, and has a completion closure. This is used to get `Data` back from the API. Pass it the `url` as an argument. **Don't forget to call resume() on the dataTask or it will not work** 

    _If the dataTask was successful at retrieving data, `data` will have value, and `error` will not. The opposite is also true. If unsuccessful, `data` will be nil and `error` will have value._ 
* In the completion closure of your dataTask, first check if error has value. If it does, print the error, call `completion()` and `return`. 
* Next, use a guard statement to unwrap data. If the guard statement fails, print an error message to the console, call `completion()`, and `return`.
* Create an instance of `JSONDecoder`
* Call `decode(from:)` on your instance of the JSONDecoder. You will need to assign the return of this function to a constant named `jsonDictionary`. This function takes in two arguments: a type `JSONDictionary.self`, and your unwrapped `data`. This will decode the data into a `JSONDictionary` that we created in the `Post.swift` file.
    * NOTE: You will notice that this function `throws`. That means that if you call this function and it doesn't work the way it should, it will _`throw`_ an error. Functions that throw need to be marked with `try` in front of the function call. You will also need to put this call inside of a **do-catch block** and `catch` the error that might be thrown. If there is an error caught, you will want to print the error, call `completion()` and `return`. _Review the documentation if you need to learn about do catch blocks._
* Create a constant called `postsWithoutImages` that will be set equal to the posts that are inside of our `jsonDictionary`. Pull them out using flatmap.
<details>
<summary>Solution:</summary>

> let postsWithoutImages = jsonDictionary.data.children.flatMap( {$0.post} )
</details>

* Assign this array of posts to `self.posts` and call `completion()`.

At this point you should be able to pull data for a specific subreddit and decode a list of posts. Feel free to test this in your App Delegate by trying to print the results for a subreddit to the console.

### Search Posts Table View Controller

Build a view that allows a user to search posts by subreddit.

1. Add a `UITableViewController` as your root view controller in Main.storyboard and embed it in a `UINavigationController`
2. Create a `SearchPostsTableViewController` file as a subclass of `UITableViewController` and set the class of your root view controller scene
3. Implement the `UITableViewDataSource` functions using the `posts` array in the `PostController`.
4. Add a search bar above the prototype cell.
5. Set up a custom cell to the display the properties of each post: thumbnail, title, number of upvotes, and number of comments.
6. Create a `PostTableViewCell` file as a subclass of `UITableViewCell` and set the cell to this type in the storyboard.
7. Look at the documentation for `UISearchBarDelegate` and find a method to use that will get called when the user taps the search button when typing in the search bar. Adopt this protocol in `SearchPostsTableViewController`, set this controller to be the delegate of the searchbar, and add the delegate method to the class.
8. This method should be implemented to:
* Get the searchTerm out of the searchBar.
* Call the `fetchPosts(by searchTerm: ...)` passing in the unwrapped and lowercased searchTerm.
* When the network request is completed, you will reload the UITableView to display the results. ***Make sure this is done on the main thread.***
> Consider adding some polishing details to this process. Some ideas are to: Show the user a network activity indicator while the network is fetching data, dismiss the keyboard after tapping search, clear the text out of the search bar after they tap search, set the nav bar's title to whatever the subreddit is they searched for, etc...

The app is now at a point where it should fetch posts and display them in the tableview but they won't have their thumbnails yet. Run it, check for bugs, and fix any that you might find up to this point.

### Fetching Images

Notice that the JSON data includes the url to the thumbnail for a post (if it has one) but not the actual image data. You'll need to perform another network request to fetch the image data at it's url.

1. In the `PostController`, create a `fetchImage(at urlString: String, completion: @escaping(UIImage?) -> Void)` function. _(You will need to import UIKit instead of Foundation for it to accept this.)_ Implement this function to:
* Create a constant called url by using the failable initializer on `URL` which takes in a string as an argument. Pass it the `urlString`. (You'll need to unwrap it)
* Create a `URLSession` dataTask and pass it the url. Just like in the `fetchPosts` function we wrote before, you'll need to check for an error and handle it if present.
* Check for and unwrap the data. Create a constant `image` by passing in the unwrapped `data` to the initializer on `UIImage` that takes data as an argument. (This initializer is also failable).
* Call completion whether or not you get an image. Choose whether you'll need to call `completion(image)` or `completion(nil)` in each part of your code where you will return out of this function.

### Black Diamonds

* If no posts were "found" for that search term, notify the user that the search failed.
* Make it so that when a cell is tapped you can go to the url of the post in a web view.

## Contributions

Please refer to CONTRIBUTING.md.

## Copyright

© DevMountain LLC, 2015. Unauthorized use and/or duplication of this material without express and written permission from DevMountain, LLC is strictly prohibited. Excerpts and links may be used, provided that full and clear credit is given to DevMountain with appropriate and specific direction to the original content.