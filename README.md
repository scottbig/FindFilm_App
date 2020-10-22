# Find The Film

A test application for an iOS developer vacancy: using OMDb API for async parsing JSON and populate cells by received data.

[Press to watch video demonstration of the application.](https://www.youtube.com/watch?v=5Sb-JelJj6o)


![alt text](https://pp.userapi.com/c851432/v851432104/127c04/g7kyatumvtk.jpg)

For this case, the application observes the status of stage of the aplication. For example, loading or populated. 
Depending on status I changed tableView, i.e. show animated an activity indicator or show an error desription. Also, this one
observes when user scroll down until last cell, then the application update tableView by new information. If after a query, it doesn't get image data for example, then it set a default image.

When you go back to MainVC from a chosen film, the application shows the previous search result.

For cells in MainVC it uses .xib file to set up templet of the cell.

Parsing and setting execute asynchronously.

The application is using MVC and Enum patterns.
