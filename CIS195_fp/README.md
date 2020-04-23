#  CIS195 Final Project - Map Quest
By : Ajay Vasisht

Features
- NLP Search on Apple Maps
- Add Pins based on Geolocation to represent places you've been too
- On clicking on the Pin's detail view, can access a table view of memories at that location
- Can add memories (including )
- all supported by Firebase Database and Storage (for images)

Specs
- Firebase
- MapKit
- Segues
- Delegates
- Different Controllers (View, Navigation, TableView)
- Firebase Databse and Storage for Images (Network calls)

App Run Through
- Open App to map - automatically centered on Penn's campus
- Use search bar button to look up any address, name, or location
- NLP Search will then move map region to that location and display search term, lat, and long coordinates
- Click the add button and input pin id, name, lat, long to save this a memory
- Need to manually need to input all,, since search is independent
- After pin is set, can click on the pin and click on the annotation to open a TableView with memories at that pin
- Can add memory to this, including memory title, id, blurb, and an image (all required)
- Network call takes a bit, but will appear in tableview
- Can click on tableview to see the memory at that pin and not at another pin
