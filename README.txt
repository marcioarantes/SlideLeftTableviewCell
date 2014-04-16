SlideLeftTableviewCell is an easy-to-use UITableViewCell subclass that implements a swipe to reveal action on each cell. When you swipe left it exposes utility buttons that you can use to call an action (like the Mail app). I have used similar tools in the past and thought all of them were a bit overkill for what most people need, with SlideLeftTableviewCell there is only one delegate method and you can create as many buttons as you wish with custom titles, width and background color independently of each other.

Functionality:
1- In your header file import the SlideLeftTableviewCell.h
2- Make sure your class conforms to the SlideLeftTableviewCellDelegate protocol
3- In your implementation file, create your SlideLeftTableviewCell. To make it easier I’ve created a convenience initializer. Note: make sure you set the cell’s delegate
4- Each button is a dictionary stored in an array, you will need a title for each button and optionally you may also specify the background color and width independently. Unlike most tools, SlideTableviewCell allows you to change the size of your buttons to fit your needs. (see sample code)
5- Finally use the slideLeftDidPushButtonAtIndex delegate method to implement your actions.

Contact:
Marcio Arantes
marcioarantes220@gmail.com
