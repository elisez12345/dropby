# Description

DropBy is an app for college students and student groups that allows student groups to share events that they are hosting and students to find events they are interested in. Groups can post events for students and drop a pin on a map that allows students to see events near them. Groups hosting events can also promote their events through the app and popular events (based on the number of people that saved the event) will appear to users as “top events”. Groups can also gauge the interest of students by seeing the number of saves. Students can save events they are interested in, see who else is interested, and share events with their friends. Students will also be able to access a calendar populated with their saved events.
 
# Relevant iOS/API Technologies

- Apple Maps (Map Kit)
- Calendar (EventKitUI)
- Any technology allowing us to share a link to specific events within our app through a messaging service (we don’t know how to do this yet!)
- CoreLocation

# Sources of Complexity/Difficulty

- Allowing for groups to create events with locations
- Handling both students using the app to find events they’re interested in and groups posting their events 
- Creating an option for students to share the events they’re interested in, both with users that are already on the app as well as generating a link to send to those who are not on the app through a messaging service 
- Categorizing different pins, so that students can search for ones they’re interested in (i.e. Academic, Social, Personal Study Group)
- Allowing students to search for events with a search bar on the home page. 
- Auto-populating the calendar with events a student has saved and allowing them to remove the event from the calendar (un-saving the event)
