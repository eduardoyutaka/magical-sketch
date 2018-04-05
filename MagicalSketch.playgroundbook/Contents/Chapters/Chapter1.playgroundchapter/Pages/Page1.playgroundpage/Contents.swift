/*:
 # Getting Started
 - - -
 1. Set to full-screen mode
 2. Tap Run My Code
 # How to Play
 - - -
 ### Roll to Go
 Create amazing single-line pictures by rolling the dials at the bottom.
 
 ![Dial Image](dial.png)
 
 ### Shake it to Erase it
 If you want to erase the line, the only way is to erase the whole drawing!
 Shake it until you make it.
 
 ### Customize
 Once you get the hang of it, feel free to customize your Playground with the settings below.
*/

import UIKit

Consts.View.backgroundColor = /*#-editable-code*/.darkRed/*#-end-editable-code*/
Consts.Cursor.color = /*#-editable-code*/.green/*#-end-editable-code*/
Consts.Context.lineWidth = /*#-editable-code*/5.0/*#-end-editable-code*/
Consts.Context.strokeColor = /*#-editable-code*/.gray/*#-end-editable-code*/

//#-hidden-code
import PlaygroundSupport
let page = PlaygroundPage.current
page.liveView = SketchViewController()
//#-end-hidden-code
