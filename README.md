# **Ship Dashboard App** 🚢

This is a **`Shiny`** app that allows you to visualize the sailed distance between two consecutive observations of a ship on a map. The app also allows the user to select the vessel type and vessel name to display the most recent distance sailed.

## **Installation**

To run this app, you will need to have **`R`** installed. Once installed, you can install the necessary packages by running:

```r
install.packages(c("shiny", "shinyWidgets", "shiny.semantic", "htmltools", "leaflet", "dplyr", "magrittr", "geosphere"))
```

After installing the required packages, download the **`ships.rds`** dataset and store it in your working directory.

## **How to use**

To use the app, open **`R`** and navigate to the folder containing the **`ui.R`** and **`server.R`** files. Run the **`shinyApp()`** function to launch the app.

```r
library(shiny)

# Run the app
shiny::runApp("path/to/folder")
```

Once launched, the app will display a title and a map with a legend. The user can select a vessel type and a vessel name to display the most recent sailed distance on the map.

### **User Interface**

The user interface is composed of the following components:

### Title

The title displays the name of the app.

### Map

The map displays the location of the ship and the distance it has sailed between two consecutive observations.

### User Controls

The user controls consist of two dropdown menus:

- Vessel Type: allows the user to select the type of vessel to display.
- Vessel Name: allows the user to select the name of the vessel to display.

## **How it works**

The app is built using **`Shiny`** and **`leaflet`**. The **`ships.rds`** dataset is imported into the app and used to display the most recent sailed distance between two consecutive observations of a ship.

The app uses the **`geosphere`** package to calculate the distance between two consecutive locations. The **`dplyr`** and **`magrittr`** packages are used to manipulate and filter the dataset to obtain the most recent observation with the longest sailed distance.

## **Credits**

This app was developed by Hamza. The app uses the following packages:

- **`shiny`**: provides the framework for the app.
- **`shinyWidgets`**: provides the dropdown menus for user selection.
- **`shiny.semantic`**: provides the grid template for the layout.
- **`htmltools`**: provides the HTML formatting for the app.
- **`leaflet`**: provides the mapping functionality.
- **`dplyr`**: provides the data manipulation functionality.
- **`magrittr`**: provides the pipe operator functionality.
- **`geosphere`**: provides the distance calculation functionality.
