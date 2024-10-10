# ecommerce_test

Architecture:
  Overview
     This application is designed based on feature first design approach, due to it's relative
  simplicity and how the features depend on each other in a compact manner.

  It mainly has three features:
   1/ Products: which is responsible of fetching, displaying, caching and CRUD operations
      on the products and it's respective Database.
   2/ Cart: which has a almost the same functionality as the product feature with a few simple
      differences. mainly it checks the internet connection status to perform it's operations either
      on a remote Database or a local one.
   3/ Order: Display, organise and edit the cart after the user proceeds to checkout.


  State Management:
    For state management, the app uses Riverpod because of its scalability and simplicity compared to 
    alternatives. Riverpod allows us to efficiently manage global states without depending on the
    widget tree, making the app more maintainable as it grows.

Steps to run the app:
 copy the url and import from version control directly, then run get dependencies and the app will be 
ready


Packages Used
Below are the main packages used in the application along with the reasoning behind their choice:

intl (v0.19.0)
Used for formatting dates, times, and numbers. Provides locale-specific formatting that ensures the 
app is ready for international users.

go_router (v14.1.1)
A declarative routing package used for navigating between screens. It allows us to manage navigation
in a scalable way, supporting deep linking and nested navigation.

flutter_riverpod (v2.5.1)
Our state management solution. It decouples state from the widget tree, making the app's logic 
cleaner and easier to test. It’s especially useful in complex apps where multiple states need to be
managed globally.

riverpod_annotation (v2.3.5)
Provides annotations to generate boilerplate code for Riverpod, speeding up the development process 
and ensuring consistency.

flutter_layout_grid (v2.0.2)
Used to create complex layouts with a grid system, similar to CSS grid. This package is helpful for 
building responsive UIs, especially when working with items like product grids.

flutter_launcher_icons (v0.9.2)
Automates the generation of launcher icons for both iOS and Android, saving time and ensuring the 
icons are optimized for all screen sizes.

sqflite (v2.0.0+4)
Provides local storage with SQLite, allowing for offline access to data such as the shopping cart. 
The app can store data locally and sync it with the server once the device is back online.

path (v1.8.0)
This package helps manage file paths across different platforms, which is critical for file 
management and storage access across Android and iOS.

path_provider (v2.1.3)
Used to find commonly used directories like the documents and cache directories. It’s helpful for
managing file storage, particularly when saving files locally.

dio (v5.0.0)
Our HTTP client for handling network requests. dio supports advanced features such as interceptors,
request/response transformation, and error handling, which makes it ideal for managing API calls 
efficiently.

connectivity_plus (v2.3.0)
This package is used to check the device’s network connectivity status. It’s vital for determining 
when the app should switch between local and remote data sources.

Note:
   Only 70% of the requirements were implemented due to the time conflict with my current job.
 I couldn't work more than Eight hours total, Nevertheless all the UI was implemented and the Product
 and Order features were completed. The Cart Feature is missing the final bit of it's implementation
 regarding the Remote cart service, alas most of the project skeleton was done.

// The remaining features to implement are remote cart, cart Sync, widget test and UI tests.
   