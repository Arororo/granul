# granular-assignment

Task: Using mock endpoint, the app should fetch the data, store it in an on-device database, then display it in a list. For each entry, it should display the image referenced (one for example) on the left-hand side and display the name on the right-hand side, in the order that it is listed in the json response. The UI should support the various iPhone sizes, but you do not need to worry about iPad support.

Notes: 
* In case of network call failure, the app should retreive data from the local database and notify user about this.
* If a data request to the local database fails, the alert message should be presented.
* For a sake of simplicity the interaction with local database is done in the main thread. In real life app if there is significant aamount of data, thus interactions should be done in a background thread.
* To improve performance and reduce the memory footprint, the pagination had been implemented for the list of items.
* MVVM, Singleton and Faced architectures had been used.
* A view model had been covered with unit tests to demonstrate the advantages of MVVM and Dependency Injection patterns
